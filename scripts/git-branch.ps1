# Branch this repo with branchname and switch to it
# Usage: git-branch <branchname>
param([Parameter(Mandatory=$true, Position=0)][string]$Branchname)
$ErrorActionPreference = "Stop"
$root = git rev-parse --show-toplevel 2>$null
if (-not $root) { Write-Error "Not a git repository"; exit 1 }
Set-Location $root
git checkout -b $Branchname
