
param([string]$ParentScriptDir)

Start-Transcript -Path "~/Downloads/$($MyInvocation.MyCommand.Name).txt" -NoClobber

# Will be installed using PowerShell Core
Write-Host "Parent Script Directory is $ParentScriptDir"
. "$ParentScriptDir\00.CommonFunctions.ps1"

Set-Location ~/Downloads
# Install Chocolatey

$PowerShellInstallFolder = "C:\Program Files\PowerShell"
$Pwsh = Get-ChildItem $PowerShellInstallFolder -Recurse -Name "pwsh.exe" -ErrorAction "SilentlyContinue" | Where-Object { $_ -notlike "*preview*" }
if ($Pwsh.Length -eq 0 ) {
    Write-Log -Message "PowerShellCore is not installed, begin Installation" 

    Remove-File "PowerShell*-win-x64.msi"
    Write-Log -Message "Downloading the latest version of PowerShellCore"
    $PowerShellInstaller = DownloadFromGithubReleasePage -ReleasePageUrl "https://github.com/PowerShell/PowerShell/releases" -SetupFilePatternName "*-win-x64.msi*" -ExcludePattern "*preview*"
    InstallMSI -FileName $PowerShellInstaller -Arguments "ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ENABLE_PSREMOTING=0 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1"
}
else {
    Write-Host "PowerShellCore is already installed."
}

Stop-Transcript 

