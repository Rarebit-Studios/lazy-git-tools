# Login to git using website callback (GitHub device flow)
$ErrorActionPreference = "Stop"
$ClientId = if ($env:GITHUB_OAUTH_DEVICE_CLIENT_ID) { $env:GITHUB_OAUTH_DEVICE_CLIENT_ID } else { "178c6fc778ccc68e1d6a" }
$Scope = if ($env:GITHUB_LOGIN_SCOPE) { $env:GITHUB_LOGIN_SCOPE } else { "repo,read:org,workflow" }

$body = @{ client_id = $ClientId; scope = $Scope }
$r = Invoke-RestMethod -Method Post -Uri "https://github.com/login/device/code" -Body $body

if (-not $r.device_code -or -not $r.verification_uri) {
  Write-Error "Failed to get device code. Check network or try again."
  exit 1
}

Write-Host "Open this URL in your browser and enter the code: $($r.user_code)"
Write-Host "  $($r.verification_uri)"
Write-Host ""

try { Start-Process $r.verification_uri } catch { }

$interval = [int]$r.interval
if (-not $interval) { $interval = 5 }
Write-Host "Waiting for you to authorize..."

while ($true) {
  Start-Sleep -Seconds $interval
  $tokenBody = @{
    client_id   = $ClientId
    device_code = $r.device_code
    grant_type  = "urn:ietf:params:oauth:grant-type:device_code"
  }
  try {
    $tokenR = Invoke-RestMethod -Method Post -Uri "https://github.com/login/oauth/access_token" -Body $tokenBody
  } catch { continue }

  if ($tokenR.access_token) {
    $accessToken = $tokenR.access_token
    break
  }
  if ($tokenR.error -eq "expired_token" -or $tokenR.error -eq "access_denied") {
    Write-Error "Authorization failed or expired ($($tokenR.error)). Try again."
    exit 1
  }
}

$hostName = "github.com"
$credPath = Join-Path $env:USERPROFILE ".git-credentials"
$line = "https://${accessToken}:x-oauth-basic@${hostName}"
$content = @()
if (Test-Path $credPath) {
  $content = Get-Content $credPath | Where-Object { $_ -notmatch "https://.*@${hostName}" }
}
$content + $line | Set-Content $credPath -Encoding utf8
Write-Host "Logged in to GitHub. Git over HTTPS will use this token."
