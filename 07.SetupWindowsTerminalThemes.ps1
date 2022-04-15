$CurrentScriptPath = $MyInvocation.MyCommand.Path
$CurrentScriptDir = Split-Path $CurrentScriptPath -Parent
Write-Output "Current Script Directory is $CurrentScriptDir"
. "$CurrentScriptDir\00.CommonFunctions.ps1"

Remove-Installer "PowerShell*-win-x64.msi"
Write-Output "Downloading the latest version of PowerShellCore"

$PowerShellInstaller = DownloadFromGithubReleasePage -ReleasePageUrl "https://github.com/PowerShell/PowerShell/releases" -SetupFilePatternName "*-win-x64.msi*" -ExcludePattern "*preview*"
InstallMSI -FileName $PowerShellInstaller -Arguments "ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=0 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1"

Write-Output "Downloading latest stable release of Microsoft Windows Terminal"
Remove-Installer "*Microsoft.WindowsTerminal_Win10_*.msixbundle*"
$WindowsTerminalInstaller = DownloadFromGithubReleasePage -ReleasePageUrl https://github.com/microsoft/terminal/releases -SetupFilePatternName "*Microsoft.WindowsTerminal_Win10_*.msixbundle*" -ExcludePattern "*Microsoft.WindowsTerminalPreview_*"
Add-AppxPackage $WindowsTerminalInstaller