# Idempotent installer: copies skills/* from this repo into ~/.claude/skills/
$ErrorActionPreference = "Stop"
$src = Join-Path $PSScriptRoot "skills"
$dst = Join-Path $HOME ".claude\skills"
if (-not (Test-Path $src)) { throw "No skills/ directory found next to install.ps1" }
New-Item -ItemType Directory -Force -Path $dst | Out-Null
Get-ChildItem -Directory $src | ForEach-Object {
    $target = Join-Path $dst $_.Name
    New-Item -ItemType Directory -Force -Path $target | Out-Null
    Copy-Item -Path (Join-Path $_.FullName "*") -Destination $target -Recurse -Force
    Write-Host "installed skill: $($_.Name) -> $target"
}
Write-Host "done."
