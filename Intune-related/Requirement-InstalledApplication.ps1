
$ApplicationNameToFind = @('.*Adobe Acrobat Reader.*')
#$ApplicationNameToFind = @('.*realtek.*')

$DisplayVersionToFind = "25.001.21265"
#$DisplayVersionToFind = "6.1"

$VersionOperand = "lt" # LT or GT is supported
function Get-InstalledPrograms {

    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $DisplayName,
        [Parameter()]
        [version]
        $DisplayVersion
    )

    Set-StrictMode -Off
    if (-not $DisplayName)
    {
        $DisplayName = '*'
    }

    if ($VersionOperand -eq "lt")
    {
        Get-ItemProperty -Path $(
            'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*';
            'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*';
        ) -ErrorAction 'SilentlyContinue' | where {($_.DisplayName -match $DisplayName) -and ([version]$_.DisplayVersion -lt $DisplayVersion)}
    }
    elseif ($VersionOperand -eq "gt")
    {
        Get-ItemProperty -Path $(
            'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*';
            'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*';
        ) -ErrorAction 'SilentlyContinue' | where {($_.DisplayName -match $DisplayName) -and ([version]$_.DisplayVersion -gt $DisplayVersion)}
    }
}

if (-not $DisplayVersionToFind)
{
    $DisplayVersionToFind = '0.1'
}

$InstalledApp = Get-InstalledPrograms -DisplayName ($ApplicationNameToFind -join "|") -DisplayVersion $DisplayVersionToFind

if ([string]::IsNullOrEmpty($InstalledApp.DisplayName))
{
    Write-Host "NotFound"
    exit 1
}
else {
    Write-Host "Found"
    exit 0
}