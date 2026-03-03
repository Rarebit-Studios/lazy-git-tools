# Add a git repo as a submodule in this folder
# Usage: git-import-submodule <repository-url> [path]
param(
  [Parameter(Mandatory=$true, Position=0)]
  [string]$Url,
  [Parameter(Position=1)]
  [string]$Path
)
$ErrorActionPreference = "Stop"
$root = git rev-parse --show-toplevel 2>$null
if (-not $root) { Write-Error "Not a git repository"; exit 1 }
Set-Location $root
if (-not $Path) {
  $Path = [System.IO.Path]::GetFileNameWithoutExtension($Url -replace '\.git$', '')
}
git submodule add $Url $Path
