# Pull/update all submodules in this repo (init, then pull each)
$ErrorActionPreference = "Stop"
$root = git rev-parse --show-toplevel 2>$null
if (-not $root) { Write-Error "Not a git repository"; exit 1 }
Set-Location $root
git submodule update --init --recursive
git submodule foreach 'git pull'
