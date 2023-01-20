
param([string]$ParentScriptDir)

$CurrentDateTimeStamp = Get-Date -Format "ddMMyyyy_hhmmss"
Start-Transcript -Path "~/Downloads/$($MyInvocation.MyCommand.Name).$CurrentDateTimeStamp.txt" -NoClobber

# Will be installed using PowerShell Core
Write-Output "Parent Script Directory is $ParentScriptDir"
. "$ParentScriptDir\common\CommonFunctions.ps1"

Set-Location ~/Downloads

Write-Log -Message "Updating the WindowsTerminal settings.json with default font face - MesloLGS NF, font size 10"

$WindowsTerminalSettingsFile = "$env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$WindowsTerminalSettings = Get-Content -Raw -Path $WindowsTerminalSettingsFile | ConvertFrom-Json

$WindowsTerminalSettings.defaultProfile = ($WindowsTerminalSettings.profiles.list | Where-Object { $_.name -eq "PowerShell" }).guid
$defaultProfile = @{font = @{face = "MesloLGS NF"; size = 10 } }

$WindowsTerminalSettings.profiles.defaults = $defaultProfile

ConvertTo-Json $WindowsTerminalSettings -Depth 10 | Out-File -FilePath $WindowsTerminalSettingsFile

Write-Log -Message "Done updating the WindowsTerminal settings.json with defaults"

Stop-Transcript