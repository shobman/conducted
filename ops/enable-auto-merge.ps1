# L2/L3 setup: turn ON the "allow auto-merge" repo setting across given repos.
# This is the switch that lets the author bot ARM a bookkeeping
# PR for auto-merge: GitHub then lands the PR by itself the moment its required
# approval and green checks are in place. Without this setting the arming call
# fails and every bookkeeping PR waits on a manual click - defeating the lane.
# Run with the OWNER's signed-in gh identity. Idempotent: re-running is a no-op on
# a repo that already has it on. Safe to re-run.
#
# Usage:
#   .\enable-auto-merge.ps1 -Repos owner/a,owner/b
#   .\enable-auto-merge.ps1 -ReposFile $HOME\repos.txt
#
# The other half of the L3 lane is the clerk's recorded approval (a machine USER,
# not an App - App approvals are not counted by rulesets, proven in the field). This
# script only flips the auto-merge SETTING; it grants no one the power to merge
# unreviewed. Required checks and the review rule still bind server-side.
#
# PER-REPO by design: one repo per list entry. To undo on a repo:
#   gh repo edit owner/name --enable-auto-merge=false
param(
    [string[]]$Repos,
    [string]$ReposFile
)
$ErrorActionPreference = "Stop"

$targets = New-Object System.Collections.Generic.List[string]
if ($Repos) { foreach ($r in $Repos) { if ($r.Trim()) { $targets.Add($r.Trim()) } } }
if ($ReposFile) {
    if (-not (Test-Path $ReposFile)) { throw "ReposFile not found: $ReposFile" }
    foreach ($line in Get-Content $ReposFile) {
        $t = $line.Trim()
        if ($t -and -not $t.StartsWith("#")) { $targets.Add($t) }
    }
}
if ($targets.Count -eq 0) { throw "No repos given. Pass -Repos owner/a,owner/b and/or -ReposFile <path>." }

foreach ($repo in $targets) {
    gh repo edit $repo --enable-auto-merge
    if ($LASTEXITCODE -ne 0) { throw "FAILED to enable auto-merge on $repo (gh exit $LASTEXITCODE)." }

    # VERIFY, never assert (the verify-never-assert lesson): read the setting back.
    $val = gh api "repos/$repo" --jq ".allow_auto_merge"
    if ($LASTEXITCODE -ne 0) { throw "enabled auto-merge on $repo but could not verify (gh exit $LASTEXITCODE)." }
    if ($val -ne "true") {
        throw "VERIFICATION FAILED: allow_auto_merge on $repo reads '$val', not true."
    }
    Write-Host "ok AND VERIFIED: auto-merge enabled on $repo"
}
Write-Host ""
Write-Host "done: auto-merge enabled and verified on $($targets.Count) repo(s)."
