param([string]$Branch)
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
&"$ExtractFolderPath\win10-systemsetup-main\07.SetupWindowsTerminaAndPowerShell.ps1"