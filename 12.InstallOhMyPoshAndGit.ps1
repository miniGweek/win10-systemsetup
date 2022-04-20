param([string]$ParentScriptDir)

Start-Transcript -Path "~/Downloads/$($MyInvocation.MyCommand.Name).txt" -NoClobber

# Will be installed using PowerShell Core
Write-Output "Parent Script Directory is $ParentScriptDir"
. "$ParentScriptDir\00.CommonFunctions.ps1"

Set-Location ~/Downloads

Write-Log -Message "Install git poshgit and oh-my-posh using Chocolatey"
$ChocolateyInstallPath = Get-ExePath -RootSearchDirectory "C:\ProgramData\chocolatey" `
    -ExeName "choco.exe" 

Start-Process $ChocolateyInstallPath  -ArgumentList "install git poshgit oh-my-posh -y" -Wait

Write-Log -Message "Installing module posh-git"
Install-Module posh-git -Force

Write-Log -Message "Installing module oh-my-posh"
Install-Module oh-my-posh -Force
Import-Module oh-my-posh


Write-Log -Message "Installing module PSReadLine"
Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck

Add-EntryToProfile -Content "Import-Module posh-git"
Add-EntryToProfile -Content "Import-Module oh-my-posh"
Add-EntryToProfile -Content "Set-PSReadLineOption -PredictionViewStyle ListView"
Add-EntryToProfile -Content "oh-my-posh --init --shell pwsh --config ~/jandedobbeleer.omp.json | Invoke-Expression"

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