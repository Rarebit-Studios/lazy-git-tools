# Update latest commit and any submodules in this folder repo
$ErrorActionPreference = "Stop"
$root = git rev-parse --show-toplevel 2>$null
if (-not $root) { Write-Error "Not a git repository"; exit 1 }
Set-Location $root
git pull
git submodule update --init --recursive
