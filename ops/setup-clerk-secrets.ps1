# L3 setup: put the clerk's PAT where ONLY the workflow can reach it.
# Sets the CONDUCTED_CLERK Actions secret on each given repo, read from a file
# on disk so the token is never typed on a command line, never echoed, and never
# stored in shell history. Run with the OWNER's signed-in gh identity. Idempotent:
# re-running overwrites the secret in place (that is how you rotate it).
#
# Usage:
#   .\setup-clerk-secrets.ps1 -SecretFile $HOME\clerk.pat -Repos owner/a,owner/b
#   .\setup-clerk-secrets.ps1 -SecretFile $HOME\clerk.pat -ReposFile $HOME\repos.txt
#
# WHY a machine USER's PAT and not an App: GitHub App review approvals are NOT
# counted by branch rulesets (proven in the field) - a ruleset-protected repo
# stays REVIEW_REQUIRED after an App "approves". The clerk is a dedicated machine
# USER whose approvals DO count. Two-key separation is the point: the
# author bot (L2) arms auto-merge but can never approve itself; the clerk approves
# but never authors. So the clerk PAT lives ONLY here, in Actions secrets - NEVER
# in a session's environment. A session that could read it could self-approve, and
# the whole no-self-review guarantee would collapse.
#
# PER-REPO by design: the secret is set on one repo at a time. A repo with no
# CONDUCTED_CLERK secret is a clean no-op - the bookkeeping-merge job's CONFIGURED
# check sees the empty secret and routes every PR to the owner lane. Adding L3 to a
# new repo is one run of this script; removing it is one `gh secret delete`.
param(
    [Parameter(Mandatory = $true)][string]$SecretFile,
    [string[]]$Repos,
    [string]$ReposFile,
    [string]$SecretName = "CONDUCTED_CLERK"
)
$ErrorActionPreference = "Stop"

if (-not (Test-Path $SecretFile)) {
    throw "SecretFile not found: $SecretFile - point -SecretFile at the file holding the clerk PAT."
}

# Build the repo list from -Repos and/or -ReposFile (one owner/name per line).
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

# Read the token into memory once and NEVER print it. Trim so a trailing newline
# in the file does not become part of the secret.
$token = (Get-Content -Raw -Path $SecretFile).Trim()
if (-not $token) { throw "SecretFile is empty: $SecretFile" }

foreach ($repo in $targets) {
    # Pipe the token to gh over stdin: it never appears as an argument, so it stays
    # out of the process table and shell history. --app actions: this is an Actions
    # secret, the only surface the workflow reads - never an environment secret.
    $token | gh secret set $SecretName --repo $repo --app actions
    if ($LASTEXITCODE -ne 0) { throw "FAILED to set $SecretName on $repo (gh exit $LASTEXITCODE)." }
    Write-Host "ok: $SecretName set on $repo (value not shown)"
}

# Scrub the token from memory promptly.
$token = $null
Write-Host ""
Write-Host "done: $SecretName set on $($targets.Count) repo(s)."
Write-Host "The clerk lane is now armed on those repos. Nothing was echoed."
Write-Host "To remove L3 from a repo: gh secret delete $SecretName --repo owner/name --app actions"
