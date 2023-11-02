param(
    [string]$UserName,
    [string]$Password
)

# Check installation
$CCInstallLocation = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Bentley\BentleyDesktopClient\Install").Location
$CCApiLocation = Join-path $CCInstallLocation "Bentley.Connect.Client.API.dll"

if (-not (Test-Path -path $CCApiLocation)) {
    Write-Error "Could not find CC API DLL. Connection Client might not be installed..."
    exit -1
}

Add-Type -Path $CCApiLocation

# Initialize the Connect Client API
$CCInstance = New-Object Bentley.Connect.Client.API.V1.ConnectClientAPI

# Check if already logged-in
if ($CCInstance.IsLoggedIn()) {
    Write-Error "User already logged in to Connection Client."
    exit -1
}

Write-Host "Logging in to Connection Client with user: $UserName"

# Try to log-in
$CCInstance.Logon($UserName, $Password)

if ($CCInstance.IsLoggedIn()) {
    Write-Host "Login successful"
    exit 0
} else {
    Write-Error "Login failed."
    exit -1
}
