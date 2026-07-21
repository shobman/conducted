# L2 setup (the author bot): idempotent GitHub settings for a CONSUMER repo of
# conducted (a project repo). This is the one scripted step of maturity level L2 -
# see docs/setup/L2-author-bot.md for the full level (account creation + PAT are
# human acts this script cannot do).
# Usage: .\setup-project-repo.ps1 -Repo owner/name -Bot your-machine-account
# Run with the OWNER's signed-in gh identity. Safe to re-run. Per-repo by design:
# one repo per run; adopting L2 on another repo is one more run with a new -Repo.
# -Bot is YOUR machine account (see docs/RUNBOOK.md "Solo mode vs bot mode") -
# there is deliberately no default: a bot identity belongs to a project's owner,
# and inviting anyone else's bot into your repo is never what you want.
#
# What this enforces (the merge-gate posture, mechanically):
#   - bot has write        -> agent PRs are authored by the bot, so the owner's approval COUNTS
#   - 1 required approval  -> nothing merges to main without a recorded owner approval
#   - squash-only, linear, no force-push/delete
# What it CANNOT do (printed as a checklist at the end):
#   - create/scope the bot's fine-grained PAT (that lives on the bot account)
#   - put the PAT where local conductor sessions can use it
param(
    [Parameter(Mandatory = $true)][string]$Repo,
    [Parameter(Mandatory = $true)][string]$Bot
)
$ErrorActionPreference = "Stop"

# Bot collaborator with write (push). Re-inviting an existing collaborator is a no-op.
gh api -X PUT "repos/$Repo/collaborators/$Bot" -f permission=push | Out-Null
Write-Host "ok: $Bot invited/confirmed as collaborator (write) on $Repo"

# Squash-only merges, tidy branches
gh repo edit $Repo --enable-squash-merge --enable-merge-commit=false --enable-rebase-merge=false --delete-branch-on-merge

# Protect main: PRs required with ONE approval (agent PRs come from the bot, so the owner's
# review counts and is mechanically required), linear history, no force pushes or deletion.
# enforce_admins false: the owner can still land docs/law directly; agents never run as owner
# once the bot is in use, so the bypass does not weaken the agent-side gate.
$protection = @'
{
  "required_status_checks": null,
  "enforce_admins": false,
  "required_pull_request_reviews": { "required_approving_review_count": 1 },
  "restrictions": null,
  "required_linear_history": true,
  "allow_force_pushes": false,
  "allow_deletions": false
}
'@
$protection | gh api -X PUT "repos/$Repo/branches/main/protection" --input -

# VERIFY, never assert: a silent failure here leaves the merge gate fictional while
# .protected reads true off any unrelated ruleset (the game project's false-REAL, 2026-07-19).
$check = gh api "repos/$Repo/branches/main/protection" | ConvertFrom-Json
$count = $check.required_pull_request_reviews.required_approving_review_count
if (-not $count -or $count -lt 1) {
    throw "VERIFICATION FAILED: $Repo main does not require an approval - the merge gate is NOT real. Fix before dispatching anything."
}
Write-Host "done AND VERIFIED: $Repo - $Bot writable, main requires $count approval(s), squash-only, protected."
Write-Host ""
Write-Host "MANUAL CHECKLIST (cannot be automated with the owner's token):"
Write-Host "  1. If the invite was new: accept it while signed in as $Bot."
Write-Host "  2. On $Bot, ensure its CLASSIC PAT carries scopes: repo, workflow, read:org."
Write-Host "     Classic, not fine-grained: fine-grained tokens cannot reach repos $Bot does"
Write-Host "     not own, and the bot is a collaborator by design. 'workflow' is required"
Write-Host "     because conducted lands gates.yml under .github/workflows/."
Write-Host "  3. Make the PAT reachable by local conductor sessions (env var at session launch;"
Write-Host "     never paste the token into an agent conversation - transcripts are not a"
Write-Host "     secrets store)."
