Install-PackageProvider -Name "NuGet" -Force
Install-Module -Name Microsoft.PowerShell.Archive -Force
Import-Module Microsoft.PowerShell.Archive
$CodeZipUrl = "https://github.com/miniGweek/win10-systemsetup/archive/refs/heads/users/miniGweek/feature/azure_arc_script.zip"
$DownloadFilePath = "$((Resolve-Path -Path "~/Downloads").Path)/win10-systemsetup.zip"
$ExtractFolderPath = (Resolve-Path -Path "~/Downloads").Path

Invoke-WebRequest -Uri $CodeZipUrl -UseBasicParsing -OutFile $DownloadFilePath
Expand-Archive -LiteralPath $DownloadFilePath -DestinationPath $ExtractFolderPath
Set-Location "$ExtractFolderPath\win10-systemsetup-main"
&"$ExtractFolderPath\win10-systemsetup-main\07.SetupWindowsTerminaAndPowerShell.ps1"