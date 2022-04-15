$CurrentScriptPath = $MyInvocation.MyCommand.Path
$CurrentScriptDir = Split-Path $CurrentScriptPath -Parent
Write-Output "Current Script Directory is $CurrentScriptDir"
. "$CurrentScriptDir\00.CommonFunctions.ps1"

Write-Output "Downloading PowershellCore latest version"
DownloadFromGithubReleasePage "https://github.com/PowerShell/PowerShell/releases" "*-win-x64.msi*"