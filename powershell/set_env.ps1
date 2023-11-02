# Environment settings
$buddiRegionCode = '1805'
$environment = 'prod'

# Update registry for region code
Set-ItemProperty -path 'HKCU:\Software\Bentley' -Name 'BuddiRegionCode' -value $buddiRegionCode

# List of processes to stop
$processesToStop = @(
    "Bentley.Connect.Client",
    "Bentley.Licensing.Service",
    "Bentley.Licensing.LicenseTool"
)

# Stop processes if they are running
foreach ($process in $processesToStop) {
    if ((Get-Process -Name $process -ErrorAction SilentlyContinue)) {
        Write-Host "Killing $process process..."
        Stop-Process -Name $process -Force
    }
}

# Get paths
$ccInstallLocation = (Get-ItemProperty -path 'HKLM:\Software\Bentley\BentleyDesktopClient\Install' -Name 'Location').Location
$sesInstallLocation = (Get-ItemProperty -path 'HKLM:\Software\Bentley\LicenseService\Install' -Name 'Location').Location

$ccPath = Join-Path -Path $ccInstallLocation -ChildPath "Bentley.Connect.Client.exe"
$sesPath = Join-Path -Path $sesInstallLocation -ChildPath "Bentley.Licensing.Service.exe"

# Start processes
Write-Host "Starting CC..."
Start-Process $ccPath

Start-Sleep -Seconds 1

Write-Host "Starting SES..."
Start-Process $sesPath
