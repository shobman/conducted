# Runs INSIDE a spawned conductor tab (launched by dispatch.ps1). Owns the tab's
# real console before and after claude, so it controls the lights:
#   - while claude runs: claude's own progress dots + bell (terminalProgressBarEnabled
#     + preferredNotifChannel: terminal_bell) do the talking
#   - when claude exits: red dot + retitle + silent bell badge = "needs your eyes"
# Also injects the bot token as GH_TOKEN so the session is bot-authed from launch
# (the BOT.md pattern, applied at the door instead of per-session).
param(
    [Parameter(Mandatory = $true)][string]$RepoPath,
    [Parameter(Mandatory = $true)][string]$Command,   # e.g. /conduct work/queue-viz
    [string]$Model = "opus"
)
Set-Location $RepoPath
if ($env:CONDUCTED_BOT) { $env:GH_TOKEN = $env:CONDUCTED_BOT }

# Identity law, commit-authorship half: gh auth covers API identity, but git merge
# and friends default to the owner's git config (the queue app's field report 2026-07-19).
# If this repo is ruled bot-mode, make EVERY git operation in this session
# bot-authored via environment, not per-command flags.
$botMd = Join-Path $RepoPath "docs/BOT.md"
if (Test-Path $botMd) {
    $md = Get-Content $botMd -Raw
    if ($md -match '(?m)^mode:\s*bot\b' -and $md -match '(?m)^bot-login:\s*(\S+)') {
        $login = $Matches[1]
        $env:GIT_AUTHOR_NAME = $login
        $env:GIT_AUTHOR_EMAIL = "$login@users.noreply.github.com"
        $env:GIT_COMMITTER_NAME = $login
        $env:GIT_COMMITTER_EMAIL = "$login@users.noreply.github.com"
    }
}

claude --model $Model $Command

# claude has exited - the console is ours again. Flip the lights.
# ASCII-only in titles: emoji/dashes mangle across the bash->pwsh->wt codepage
# boundary; the red dot (pure-ASCII escape) is the visual signal.
$esc = [char]27; $bel = [char]7
$node = ($Command -replace '^.*work/', '')
[Console]::Write("$esc]9;4;2;100$bel")            # red dot
[Console]::Write("$esc]0;DONE - $node$bel")       # retitle (ASCII)
[Console]::Write($bel)                             # silent bell badge
Write-Host ""
Write-Host "Session ended: $Command in $RepoPath"
Write-Host "This tab is now a record - review, then close me."
