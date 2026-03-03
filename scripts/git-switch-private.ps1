# Switch this GitHub repo to private
$ErrorActionPreference = "Stop"
function Get-GitHubToken {
  if ($env:GITHUB_TOKEN) { return $env:GITHUB_TOKEN }
  $cred = Join-Path $env:USERPROFILE ".git-credentials"
  if (Test-Path $cred) {
    $line = Get-Content $cred | Where-Object { $_ -match "github\.com" } | Select-Object -First 1
    if ($line -match "https://([^:]+):x-oauth-basic@github\.com") { return $Matches[1] }
  }
  if (Get-Command gh -ErrorAction SilentlyContinue) { return (gh auth token 2>$null) }
  return $null
}
$token = Get-GitHubToken
if (-not $token) { Write-Error "No GitHub token found. Run git-login or set GITHUB_TOKEN."; exit 1 }
$root = git rev-parse --show-toplevel 2>$null
if (-not $root) { Write-Error "Not a git repository"; exit 1 }
Set-Location $root
$origin = git remote get-url origin 2>$null
if (-not $origin) { Write-Error "No remote 'origin' found."; exit 1 }
if ($origin -notmatch "github\.com[:/]([^/]+)/([^/]+?)(?:\.git)?$") { Write-Error "Could not parse owner/repo from origin."; exit 1 }
$owner = $Matches[1]; $repo = $Matches[2] -replace '\.git$', ''
$headers = @{ Authorization = "token $token"; Accept = "application/vnd.github.v3+json" }
$uri = "https://api.github.com/repos/$owner/$repo"
try {
  Invoke-RestMethod -Method Patch -Uri $uri -Headers $headers -Body '{"private":true}' -ContentType "application/json" | Out-Null
} catch {
  $err = $_.ErrorDetails.Message
  if ($err) {
    $o = $err | ConvertFrom-Json -ErrorAction SilentlyContinue
    if ($o.message) { $err = $o.message }
  }
  Write-Host "GitHub API error for $owner/$repo" -ForegroundColor Red
  Write-Error $err
  if ($_.Exception.Response.StatusCode.value__ -eq 404) {
    Write-Host "If the repo was transferred, update remote: git remote set-url origin https://github.com/NEW_OWNER/REPO.git"
  }
  exit 1
}
Write-Host "Repo is now private: https://github.com/$owner/$repo"
