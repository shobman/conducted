# Spawn a live conductor (or any claude command) in a new Windows Terminal tab,
# colored deterministically per repo, running immediately - no copy-paste.
# Usage:  .\dispatch.ps1 -RepoPath $HOME\repos\project -Command "/conduct work/queue-polish"
#         .\dispatch.ps1 -RepoPath $HOME\repos\project -Command "/principal" -Model opus
# Known limitation: wt has no background-tab flag, so each spawn focuses the new
# tab once. Batch your dispatches, then switch back.
param(
    [Parameter(Mandatory = $true)][string]$RepoPath,
    [Parameter(Mandatory = $true)][string]$Command,
    [string]$Model = "opus"
)
$ErrorActionPreference = "Stop"
$repoName = Split-Path $RepoPath -Leaf

# Deterministic per-repo color: hash the repo name onto a fixed palette.
$palette = @("#4A86E8", "#8E63CE", "#2A9C68", "#E07798", "#CF8933", "#2DA2BB", "#B65775", "#6D9EEB")
$hash = 0; foreach ($ch in $repoName.ToCharArray()) { $hash = ($hash * 31 + [int]$ch) % 2147483647 }
$color = $palette[$hash % $palette.Count]

$wrapper = Join-Path $PSScriptRoot "conduct-wrapper.ps1"
$node = ($Command -replace '^/(conduct|principal)\s*', '') ; if (-not $node) { $node = $Command }
$title = "$repoName - $node"   # ASCII only: fancy separators mangle across the codepage boundary

wt.exe -w 0 new-tab --title $title --tabColor $color `
    pwsh -NoExit -File $wrapper -RepoPath $RepoPath -Command $Command -Model $Model
Write-Host "dispatched: [$color] $title"
