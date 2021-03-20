# Install Powershell Preview Latest version
$pwshPreviewFilename = DownloadFromGithubReleasePage https://github.com/PowerShell/powershell/releases *powershell*preview*win*x64*
InstallMSI $pwshPreviewFilename
# Install posh-git and oh-my-posh
Install-Module posh-git -Force
Install-Module oh-my-posh -Force

# Install Az Powershell Model
if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable)) {
    Write-Warning -Message ('Az module not installed. Having both the AzureRM and ' +
        'Az modules installed at the same time is not supported.')
}
else {
    Install-Module -Name Az -AllowClobber -Scope CurrentUser -Force
}

#Install CPU Z
$cpuZContent = Invoke-WebRequest -Uri https://www.cpuid.com/softwares/cpu-z.html
$taichiSetupPageLink = $cpuZContent.Links | ? { $_.href -like "*taichi*exe*" } | select href -First 1
$latestTaichiSetupContent = Invoke-WebRequest -Uri $taichiSetupPageLink.href
$latestTaichiSetupUri = ($latestTaichiSetupContent.Links | ? { $_.href -like "*taichi-en.exe*" } | Select href -First 1).href;
cd ~/Downloads
$cpuzTaichiInstallerName = DownloadFile $latestTaichiSetupUri
Invoke-Expression "./$cpuzTaichiInstallerName /VERYSILENT /NORESTART"


#Install CDIsplayEx
cd ~/Downloads
Invoke-WebRequest -Uri https://www.cdisplayex.com/findit.php -Method POST -OutFile CDisplay.exe
.\CDisplay.exe /VERYSILENT

# Install Cascadia Code PL Fonts
$FileName = DownloadFromGithubReleasePage https://github.com/microsoft/cascadia-code/releases/ *CascadiaCode-*

$FolderName = $FileName -Split ".zip" | Select -First 1
if (Test-Path -Path $FolderName) {
    Remove-Item $FolderName -Recurse -Force
}
Expand-Archive $FileName

$Destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
$SourceDir = ".\$FolderName\"

$TempFolder = "~/Downloads/TempFonts"
if (Test-Path -Path "TempFonts") {
    Remove-Item "TempFonts" -Recurse -Force
}
New-Item $TempFolder -Type Directory -Force | Out-Null
$FONTS = 0x14
$objShell = New-Object -ComObject Shell.Application
$objFolder = $objShell.Namespace($FONTS)
Get-ChildItem -Path $SourceDir -Include 'CascadiaCodePL*.otf' -Recurse | ForEach {
    $File = $_
    $try = $true
    $installedFonts = @(Get-ChildItem c:\windows\fonts | Where-Object { $_.PSIsContainer -eq $false } | Select-Object basename)
    $name = $File.baseName

    foreach ($font in $installedFonts) {
        $font = $font -replace "_", ""
        $name = $name -replace "_", ""
        if ($font -match $name) {
            $try = $false
        }
    }
    
    if ($try) {
        $objFolder.CopyHere($File.fullname)
        Write-Host ++++++++++ Installed $File.fullname
    }
    
}

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
cd ~/Downloads
if (Test-Path -Path $SteamSetupFileName) {
    Remove-Item $SteamSetupFileName 
}
Invoke-WebRequest -Uri $SteamSetupUrl -OutFile $SteamSetupFileName
$SilentInstallCmd = "& .\$SteamSetupFileName /S"
Invoke-Expression $SilentInstallCmd

# Installe Battle.net
CD ~/Downloads
Invoke-WebRequest -Uri "https://us.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe" -OutFile Battle.net-Setup.exe
./Battle.net-Setup.exe
# Install Surfshark vpn
cd ~/Downloads
DownloadFile "https://downloads.surfshark.com/windows/latest/SurfsharkSetup.exe";
./SurfsharkSetup.exe

# Installing and enabling WSL
# Steps from https://docs.microsoft.com/en-us/windows/wsl/install-win10#manual-installation-steps
# Step 1 - Enable the Windows Subsystem for Linux
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart#
# Step 2 Install WSL and Ubuntu / Step 2 - Check requirements for running WSL 2
choco install -y wsl wsl2 wsl-ubuntu-2004 
# Step 3 - Enable Virtual Machine feature
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
# Step 4 - Download the Linux kernel update package

# Install update to WSL
cd ~/Downloads
DownloadAndInstall "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"


# Step 5 - Set WSL 2 as your default version
wsl --set-default-version 2
#Unity