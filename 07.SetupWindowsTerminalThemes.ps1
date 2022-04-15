$CurrentScriptPath = $MyInvocation.MyCommand.Path
$CurrentScriptDir = Split-Path $CurrentScriptPath -Parent
Write-Output "Current Script Directory is $CurrentScriptDir"
. "$CurrentScriptDir\00.CommonFunctions.ps1"

if (Test-Path -Path "PowerShell*-win-x64.msi") {
    Write-Output "Removing existing powershell version in the directory"
    Remove-Item "PowerShell*-win-x64.msi"
}

Write-Output "Downloading the latest version of PowerShellCore"

$PowerShellInstaller = DownloadFromGithubReleasePage -ReleasePageUrl "https://github.com/PowerShell/PowerShell/releases" -SetupFilePatternName "*-win-x64.msi*" -ExcludePattern "*preview*"
InstallMSI -FileName $PowerShellInstaller -Arguments "ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=0 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1"
