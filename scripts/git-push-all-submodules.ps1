# Push this repo and all submodules
$ErrorActionPreference = "Stop"
$root = git rev-parse --show-toplevel 2>$null
if (-not $root) { Write-Error "Not a git repository"; exit 1 }
Set-Location $root
git push --recurse-submodules=on-demand
