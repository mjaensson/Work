# Use this as a requirement script in Intune for updates assigned to all users/devices
$ApplicationNameToFind = "*Citrix Workspace*"
function Get-InstalledPrograms {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $DisplayName
    );

    Set-StrictMode -Off
    if (-not $DisplayName)
    {
        $DisplayName = '*'
    }
    
    Get-ItemProperty -Path $(
        'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*';
        'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*';
    ) -ErrorAction 'SilentlyContinue' |
    Where-Object -Property 'DisplayName' -Like $DisplayName |
    Select-Object -Property 'DisplayName', 'UninstallString', 'ModifyPath' |
    Sort-Object -Property 'DisplayName'
}

$InstalledApp = Get-InstalledPrograms -DisplayName $ApplicationNameToFind

if ([string]::IsNullOrEmpty($InstalledApp.DisplayName))
{
    Write-Host "NotFound"
    exit 1
}
else {
    Write-Host "Found"
    exit 0
}