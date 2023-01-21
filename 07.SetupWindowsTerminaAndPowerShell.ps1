$CurrentScriptPath = $MyInvocation.MyCommand.Path
$CurrentScriptDir = Split-Path $CurrentScriptPath -Parent
Write-Output "Current Script Directory is $CurrentScriptDir"

$CurrentErrorActionPreference = $ErrorActionPreference
$ErrorActionPreference = 'Stop'
try {
    $CommonFunctionScriptPath = "$CurrentScriptDir\common\CommonFunctions.ps1"
    . "$CommonFunctionScriptPath"

    Write-Log "Common functions loaded."

    $CurrentDateTimeStamp = Get-Date -Format "ddMMyyyy_hhmmss"
    Start-Transcript -Path "~/Downloads/$($MyInvocation.MyCommand.Name).$CurrentDateTimeStamp.txt" -NoClobber

    Set-Location ~/Downloads

    # Install Chocolatey if it isn't installed 
    Write-Log -Message "Install Chocolatey package manager if it's not installed"
    $ChildScriptPath = "$CurrentScriptDir\08.InstallChocolatey.ps1"
    Start-Process "powershell.exe" -ArgumentList "-c $ChildScriptPath -ParentScriptDir $CurrentScriptDir" -Wait

    Write-Log -Message "Install PowerShellCore if it's not installed"
    $ChildScriptPath = "$CurrentScriptDir\09.InstallPoweShellCore.ps1"
    Start-Process "powershell.exe" -ArgumentList "-c $ChildScriptPath -ParentScriptDir $CurrentScriptDir" -Wait

    Write-Log -Message "Install WindowsTerminal"
    $ChildScriptPath = "$CurrentScriptDir\10.InstallWindowsTerminal.ps1"
    Start-Process "powershell.exe" -ArgumentList "-c $ChildScriptPath -ParentScriptDir $CurrentScriptDir" -Wait

    $PowerShellInstallFolder = "C:\Program Files\PowerShell"
    $PowerShellExePath = Get-ExePath -RootSearchDirectory $PowerShellInstallFolder `
        -ExeName "pwsh.exe" `
        -Exclude "*preview*" `
        -Recurse

    $ChildScriptPath = "$CurrentScriptDir\11.InstallFonts.ps1"
    Start-Process $PowerShellExePath -ArgumentList "-c $ChildScriptPath -ParentScriptDir $CurrentScriptDir" -Wait

    $ChildScriptPath = "$CurrentScriptDir\12.InstallOhMyPoshAndGit.ps1"
    Start-Process $PowerShellExePath -ArgumentList "-c $ChildScriptPath -ParentScriptDir $CurrentScriptDir" -Wait

    $ChildScriptPath = "$CurrentScriptDir\13.UpdateWindowsTerminalSettings.ps1"
    Start-Process $PowerShellExePath -ArgumentList "-c $ChildScriptPath -ParentScriptDir $CurrentScriptDir" -Wait

    Stop-Transcript 
}
catch {
    $_
}
finally {
    $ErrorActionPreference = $CurrentErrorActionPreference  
}