# setup_env.ps1
# This script helps set up the environment variables

# Check if .env file exists
if (-not (Test-Path .env)) {
    Write-Host "Error: .env file not found. Please create it from .env.example" -ForegroundColor Red
    Exit 1
}

# Create strings.xml from example
$stringsExamplePath = "android\app\src\main\res\values\strings.xml.example"
$stringsPath = "android\app\src\main\res\values\strings.xml"

if (-not (Test-Path $stringsExamplePath)) {
    Write-Host "Error: $stringsExamplePath not found" -ForegroundColor Red
    Exit 1
}

# Read .env file
$envContent = Get-Content .env -Raw

# Extract values
$facebookAppId = ($envContent | Select-String -Pattern "FACEBOOK_APP_ID=(.*?)$" -AllMatches).Matches.Groups[1].Value.Trim()
$facebookClientToken = ($envContent | Select-String -Pattern "FACEBOOK_CLIENT_TOKEN=(.*?)$" -AllMatches).Matches.Groups[1].Value.Trim()

# Create strings.xml
(Get-Content $stringsExamplePath) -replace '\$\{facebookAppId\}', $facebookAppId `
                                -replace '\$\{facebookClientToken\}', $facebookClientToken | 
    Set-Content $stringsPath -Encoding UTF8

Write-Host "Environment setup complete!" -ForegroundColor Green
