# install.ps1 — installs the personal SOUL into ~/.copilot/copilot-instructions.md (Windows)
# The repo-level config (.github/, .vscode/) needs no install; it works on open in VS Code.

$ErrorActionPreference = "Stop"

$source = Join-Path $PSScriptRoot "templates\soul.copilot-instructions.md"
$destDir = Join-Path $HOME ".copilot"
$dest = Join-Path $destDir "copilot-instructions.md"

if (-not (Test-Path $source)) {
    Write-Error "Source template not found: $source"
    exit 1
}

if (-not (Test-Path $destDir)) {
    New-Item -ItemType Directory -Path $destDir | Out-Null
    Write-Host "Created $destDir"
}

if (Test-Path $dest) {
    $backup = "$dest.bak"
    Copy-Item $dest $backup -Force
    Write-Host "Existing personal instructions backed up to: $backup"
}

Copy-Item $source $dest -Force
Write-Host "Installed SOUL -> $dest"
Write-Host "Done. Reload VS Code (or restart Copilot Chat) to pick it up."
