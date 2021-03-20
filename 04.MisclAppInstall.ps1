#Navigate to Downloads folder to download and do stuff
cd ~/Downloads
# Install Powershell Preview Latest version
$pwshPreviewFilename = DownloadFromGithubReleasePage https://github.com/PowerShell/powershell/releases *powershell*preview*win*x64*
InstallMSI $pwshPreviewFilename
# Install posh-git and oh-my-posh
Install-Module posh-git -Force
Install-Module oh-my-posh -Force
Install-Module -Name PSReadLine -Scope CurrentUser -Force -SkipPublisherCheck

# Install Powershell Preview's history lookup and Az.Predictor 
Install-Module -Name PSReadLine -AllowPrerelease -Force -SkipPublisherCheck
Install-module -name Az.Tools.Predictor -RequiredVersion 0.2.0 -Force
Enable-AzPredictor -AllSession
Set-PSReadLineOption -PredictionViewStyle ListView

# Install Cascadia Code PL Fonts
$FileName = DownloadFromGithubReleasePage https://github.com/microsoft/cascadia-code/releases/ *CascadiaCode-*
$FolderName = $FileName -Split ".zip" | Select -First 1
if (Test-Path -Path $FolderName) {
    Remove-Item $FolderName -Recurse -Force
}
Expand-Archive $FileName
Invoke-InstallFonts $FolderName CascadiaCodePL*.otf

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
$replaceSearchString = "%20";
$replaceWithString = " ";
$splitBy = "/";
#$MesloNerdFontsLinks | Where-Object { $s = "$MesloFontsFolder$($_.Split($splitBy)[-1].Replace($replaceString, $replaceWithString))"; Write-Host $s }

$MesloNerdFontsLinks | `
    ForEach-Object { 
    $downloadPath = "$MesloFontsFolder/$($_.Split($splitBy)[-1].Replace($replaceString, $replaceWithString))";
    Write-Host Downloading to $downloadPath
    Invoke-WebRequest -URI $_ -OutFile $downloadPath
}
Invoke-InstallFonts MesloNerdFonts Meslo*.ttf


# Install Az Powershell Model
if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable)) {
    Write-Warning -Message ('Az module not installed. Having both the AzureRM and ' +
        'Az modules installed at the same time is not supported.')
}
else {
    Install-Module -Name Az -AllowClobber -Scope CurrentUser -Force
}



############## Installing and enabling WSL      ######################
# Steps from https://docs.microsoft.com/en-us/windows/wsl/install-win10#manual-installation-steps
# Step 1 - Enable the Windows Subsystem for Linux
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart#
# Step 2 Install WSL and Ubuntu / Step 2 - Check requirements for running WSL 2
choco install -y wsl wsl2 wsl-ubuntu-2004 
# Step 3 - Enable Virtual Machine feature
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
# Step 4 - Download the Linux kernel update package

# Install update to WSL
DownloadAndInstall "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"

# Step 5 - Set WSL 2 as your default version
wsl --set-default-version 2

#Install CPU Z
$cpuZContent = Invoke-WebRequest -Uri https://www.cpuid.com/softwares/cpu-z.html
$taichiSetupPageLink = $cpuZContent.Links | ? { $_.href -like "*taichi*exe*" } | select href -First 1
$latestTaichiSetupContent = Invoke-WebRequest -Uri $taichiSetupPageLink.href
$latestTaichiSetupUri = ($latestTaichiSetupContent.Links | ? { $_.href -like "*taichi-en.exe*" } | Select href -First 1).href;
$cpuzTaichiInstallerName = DownloadFile $latestTaichiSetupUri
Invoke-Expression "./$cpuzTaichiInstallerName /VERYSILENT /NORESTART"


#Install CDIsplayEx
Invoke-WebRequest -Uri https://www.cdisplayex.com/findit.php -Method POST -OutFile CDisplay.exe
.\CDisplay.exe /VERYSILENT

# Test
# Install Windows Power Toys
$FileName = DownloadFromGithubReleasePage https://github.com/microsoft/PowerToys/releases *PowerToysSetup*
$SilentInstallCmd = "& .\$FileName --silent"
Invoke-Expression $SilentInstallCmd

# Install alacritty terminal - disabled for now
# $FileName = DownloadFromGithubReleasePage https://github.com/alacritty/alacritty/releases *Alacritty*.msi
# InstallMSI $FileName

# Install Steam client
$SteamSetupUrl = "https://cdn.akamai.steamstatic.com/client/installer/SteamSetup.exe"
$SteamSetupFileName = $SteamSetupUrl -Split "/" | Select -Last 1
if (Test-Path -Path $SteamSetupFileName) {
    Remove-Item $SteamSetupFileName 
}
Invoke-WebRequest -Uri $SteamSetupUrl -OutFile $SteamSetupFileName
$SilentInstallCmd = "& .\$SteamSetupFileName /S"
Invoke-Expression $SilentInstallCmd

# Installe Battle.net
Invoke-WebRequest -Uri "https://us.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe" -OutFile Battle.net-Setup.exe
./Battle.net-Setup.exe
# Install Surfshark vpn
DownloadFile "https://downloads.surfshark.com/windows/latest/SurfsharkSetup.exe";
./SurfsharkSetup.exe