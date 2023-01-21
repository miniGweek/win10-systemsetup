Function Install-WindowsTerminalAndTools {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $Branch
    )
    $CurrentErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = 'Stop'
    try {
        Install-PackageProvider -Name "NuGet" -Force
        Install-Module -Name Microsoft.PowerShell.Archive -Force
        Import-Module Microsoft.PowerShell.Archive

        $CodeZipUrl = "https://github.com/miniGweek/win10-systemsetup/archive/refs/heads/$Branch.zip"
        $DownloadFilePath = "$((Resolve-Path -Path "~/Downloads").Path)/win10-systemsetup.zip"
        $ExtractFolderPath = (Resolve-Path -Path "~/Downloads").Path

        Invoke-WebRequest -Uri $CodeZipUrl -UseBasicParsing -OutFile $DownloadFilePath
        Expand-Archive -LiteralPath $DownloadFilePath -DestinationPath $ExtractFolderPath

        $SourceFolderPath = "win10-systemsetup-$($Branch -Replace '/','-')"
        Write-Host "Source folder path = $ExtractFolderPath\$SourceFolderPath"

        Set-Location "$ExtractFolderPath\$SourceFolderPath"
        & "$ExtractFolderPath\$SourceFolderPath\07.SetupWindowsTerminaAndPowerShell.ps1"
    }
    catch {
        $_
    }
    finally {
        $ErrorActionPreference = $CurrentErrorActionPreference
    }
}