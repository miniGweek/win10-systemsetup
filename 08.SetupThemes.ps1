param([string]$ParentScriptDir)
# Will be installed using PowerShell Core
Write-Output "Parent Script Directory is $ParentScriptDir"
. "$ParentScriptDir\00.CommonFunctions.ps1"

Set-Location ~/Downloads

Write-Log -Message "Installing module posh-git"
Install-Module posh-git -Force

Write-Log -Message "Installing module oh-my-posh"
Install-Module oh-my-posh -Force

Write-Log -Message "Installing module PSReadLine"
Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck

Add-EntryToProfile -Content "Import-Module posh-git"
Add-EntryToProfile -Content "Import-Module oh-my-posh"
Add-EntryToProfile -Content "Set-PSReadLineOption -PredictionViewStyle ListView"


# Install Cascadia Code PL Fonts
Remove-File "*CascadiaCode-*"
$FileName = DownloadFromGithubReleasePage  -ReleasePageUrl "https://github.com/microsoft/cascadia-code/releases"  -SetupFilePatternName "*CascadiaCode-*"

$FolderName = $FileName -Split ".zip" | Select-Object -First 1
if (Test-Path -Path $FolderName) {
    Remove-Item $FolderName -Recurse -Force
}
Expand-Archive -LiteralPath $FileName -DestinationPath $FolderName
Invoke-InstallFonts $FolderName "CascadiaCodePL*.otf"

# Install Meslo Nerd Fonts patched for PowerLevel10k
$MesloNerdFontsLinks = @("https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf",
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf",
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf",
    "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf");
$MesloFontsFolder = "~/Downloads/MesloNerdFonts"
if (Test-Path -Path $MesloFontsFolder) {
    Remove-Item $MesloFontsFolder -Recurse -Force
}
New-Item $MesloFontsFolder -Type Directory -Force | Out-Null
$ReplaceSearchString = "%20";
$replaceWithString = " ";
$splitBy = "/";
#$MesloNerdFontsLinks | Where-Object { $s = "$MesloFontsFolder$($_.Split($splitBy)[-1].Replace($replaceString, $replaceWithString))"; Write-Host $s }

$MesloNerdFontsLinks | `
    ForEach-Object { 
    $downloadPath = "$MesloFontsFolder/$($_.Split($splitBy)[-1].Replace($replaceString, $replaceWithString))";
    Write-Host Downloading to $downloadPath
    Get-File -Uri $_ -OutFile $downloadPath
}
Invoke-InstallFonts "MesloNerdFonts" "Meslo*.ttf"
