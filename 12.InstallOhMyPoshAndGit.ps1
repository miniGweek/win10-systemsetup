param([string]$ParentScriptDir)

$CurrentDateTimeStamp = Get-Date -Format "ddMMyyyy_hhmmss"
Start-Transcript -Path "~/Downloads/$($MyInvocation.MyCommand.Name).$CurrentDateTimeStamp.txt" -NoClobber

# Will be installed using PowerShell Core
Write-Output "Parent Script Directory is $ParentScriptDir"
. "$ParentScriptDir\common\CommonFunctions.ps1"

Set-Location ~/Downloads

Write-Log -Message "Install git poshgit and oh-my-posh using Chocolatey"
$ChocolateyInstallPath = Get-ExePath -RootSearchDirectory "C:\ProgramData\chocolatey" `
    -ExeName "choco.exe" 

Start-Process $ChocolateyInstallPath  -ArgumentList "install git poshgit oh-my-posh -y" -Wait
# $CloudNativeThemePath = Get-ExePath -RootSearchDirectory "C:\Program Files (x86)\oh-my-posh" -ExeName "cloud-native-azure.omp.json" -Recurse
$ThemePath = "$ParentScriptDir\Themes\.mytheme.omp.json"

Write-Log -Message "Installing module posh-git"
Install-Module posh-git -Force

Write-Log -Message "Installing module PSReadLine"
Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck

Add-EntryToProfile -Content "Import-Module posh-git"
Add-EntryToProfile -Content "Set-PSReadLineOption -PredictionViewStyle ListView"
Add-EntryToProfile -Content "oh-my-posh init pwsh --config `"$ThemePath`" | Invoke-Expression"

Write-Log -Message "Done adding entries to the PowerShell Core profile"
# Launch PowerShell to pre-load the necessary modules


Write-Log -Message "Begin launch PowerShell Core to pre-load the necessary modules"
$PowerShellInstallFolder = "C:\Program Files\PowerShell"
$PowerShellExePath = Get-ExePath -RootSearchDirectory $PowerShellInstallFolder `
    -ExeName "pwsh.exe" `
    -Exclude "*preview*" `
    -Recurse
Start-Process $PowerShellExePath -ArgumentList "Write-Host 'Hello World'" -Wait
Write-Log -Message "Done with the launch of PowerShell Core to pre-load the necessary modules"

Stop-Transcript 