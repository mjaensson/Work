# Add regex for each application search for
$ApplicationNameToFind = @('.*AdoptOpenJDK.*','.*Eclipse Temurin JDK.*')


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
    Where-Object -Property 'DisplayName' -Match $DisplayName |
    Select-Object -Property 'DisplayName', 'UninstallString', 'ModifyPath' |
    Sort-Object -Property 'DisplayName'
}

$InstalledApp = Get-InstalledPrograms -DisplayName ($ApplicationNameToFind -join "|")

if ([string]::IsNullOrEmpty($InstalledApp.DisplayName))
{
    Write-Host "NotFound"
    exit 1
}
else {
    Write-Host "Found"
    exit 0
}
