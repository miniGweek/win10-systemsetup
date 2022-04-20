
param([string]$ParentScriptDir)

$CurrentDateTimeStamp = Get-Date -Format "ddMMyyyy_hhmmss"
Start-Transcript -Path "~/Downloads/$($MyInvocation.MyCommand.Name).$CurrentDateTimeStamp.txt" -NoClobber

# Will be installed using PowerShell Core
Write-Host "Parent Script Directory is $ParentScriptDir"
. "$ParentScriptDir\00.CommonFunctions.ps1"

Set-Location ~/Downloads
# Install Chocolatey

Write-Log -Message "Downloading latest version of Microsoft.VCLibs.x64.14.00.Desktop.appx"
$DownloadedFilePath = Get-File -Uri "https://aka.ms/Microsoft.VCLibs.x64.14.00.Desktop.appx" -OutFile "Microsoft.VCLibs.x64.14.00.Desktop.appx"

Write-Log -Message "Install Microsoft.VCLibs.x64.14.00.Desktop.appx"
Add-AppxPackage $DownloadedFilePath

Write-Log -Message "Downloading latest stable release of Microsoft Windows Terminal"
Remove-File "*Microsoft.WindowsTerminal_Win10_*.msixbundle*"
$WindowsTerminalInstaller = DownloadFromGithubReleasePage -ReleasePageUrl https://github.com/microsoft/terminal/releases -SetupFilePatternName "*Microsoft.WindowsTerminal_Win10_*.msixbundle*" -ExcludePattern "*Microsoft.WindowsTerminalPreview_*"
Add-AppxPackage $WindowsTerminalInstaller

# Initialize WindowsTerminal settings.json by starting it
Start-Process "$env:LocalAppData\Microsoft\WindowsApps\wt.exe"

Stop-Transcript 