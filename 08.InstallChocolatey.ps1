
param([string]$ParentScriptDir)

Start-Transcript -Path "~/Downloads/$($MyInvocation.MyCommand.Name).txt" -NoClobber

# Will be installed using PowerShell Core
Write-Output "Parent Script Directory is $ParentScriptDir"
. "$ParentScriptDir\00.CommonFunctions.ps1"

Set-Location ~/Downloads
# Install Chocolatey

$TestChoco = powershell choco -v
if ($false -eq $TestChoco) {
    Write-Log -Message "Chocolatey isn't installed in the system, Installing it"
}

Set-ExecutionPolicy Bypass -Scope Process `
    -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

Stop-Transcript 