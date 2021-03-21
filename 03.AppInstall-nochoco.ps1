# vscode
Invoke-WebRequest -uri "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user" -OutFile vscodeusersetup.exe
SilentInstallExe vscodeusersetup.exe

# Install notepad++
# $releasePage = Invoke-WebRequest -Uri https://notepad-plus-plus.org/downloads/ 
# $latestReleaseLink = $releasePage.Links | ? { $_ -like "*release*" } | Select -First 1 | Select href
# $latestReleasePage = Invoke-WebRequest -Uri $latestReleaseLink.href
# $latestReleasePage.Links | ? { $_ -like "*release*" } | Select -First 1 | Select href

# Notepadplusplus
$nppInstallerName = DownloadFromGithubReleasePage https://github.com/notepad-plus-plus/notepad-plus-plus/releases *x64.exe*
SilentInstallExe2 $nppInstallerName 

# Google chrome browser
Invoke-WebRequest -Uri "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B2681C7F7-75A7-0A42-9A9A-3F3D39F28F5B%7D%26lang%3Den%26browser%3D4%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/update2/installers/ChromeSetup.exe" `
    -OutFile ChromeSetup.Exe
.\ChromeSetup.exe /INSTALL

# Firefox browser
Invoke-WebRequest -Uri "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US" -OutFile FireFoxSetup.exe
.\FireFoxSetup.exe -ms

# Brave browser
DownloadFromGithubReleasePage "https://github.com/brave/brave-browser/releases" *BraveBrowserStandaloneSetup.exe*
./BraveBrowserStandaloneSetup.exe /INSTALL



# $vivaldiDownloadPage = Invoke-WebRequest -Uri "https://vivaldi.com/download/"
# $vivaldiDownloadLink = $vivaldiDownloadPage.Links | Where-Object { $_.href -like "*x64.exe*" }
# Invoke-WebRequest -Uri $vivaldiDownloadLink.href -OutFile VivaldiOfflineInstaller_latest.x64.exe


# $7zipDownloadPage = Invoke-WebRequest -Uri "https://www.7-zip.org/download.html"
# $7ZipUrl = ($7zipDownloadPage.Links | ? { $_.href -like "*-x64.msi*" }   | Select -First 1).href
# Invoke-Webrequest -Uri "https://www.7-zip.org/$7ZipUrl" -OutFile 7zip-x64.msi


# Git for windows
$GitForWindowsExe = DownloadFromGithubReleasePage "https://github.com/git-for-windows/git/releases" *-64-bit.exe*
SilentInstallExe $GitForWindowsExe

# Microsoft Teams
$MSTeamsUri = "https://go.microsoft.com/fwlink/p/?LinkID=869426&clcid=0x409&culture=en-us&country=US&lm=deeplink&lmsrc=groupChatMarketingPageWeb&cmpid=directDownloadWin64"
Invoke-WebRequest -Uri $MSTeamsUri  -OutFile MSTeamsSetup.exe
./MSTeamsSetup.exe -s



# Azure CLI
$AzcliMsiInstaller = DownloadFromGithubReleasePage "https://github.com/Azure/azure-cli/releases" "*msi*"
InstallMSI $AzcliMsiInstaller 

# Az Powershell
$AzPowershellMsiInstaller = DownloadFromGithubReleasePage "https://github.com/Azure/azure-powershell/releases" "*-x64.msi"
InstallMSI $AzPowershellMsiInstaller




# Ifrfanview
Echo manually download from "https://www.irfanview.com/64bit.htm"
Start-Process chrome "https://www.irfanview.com/64bit.htm"   



# Vivaldi Browser
$installerName = Invoke-DownloadByTraversingManyPages "https://vivaldi.com/download/" "*x64.exe*" # "VivaldiOfflineInstaller_latest.x64.exe"
Invoke-Expression ".\$installerName --vivaldi-silent --do-not-launch-chrome --system-level" #.\VivaldiOfflineInstaller_latest.x64.exe --vivaldi-silent --do-not-launch-chrome --system-level

# 7Zip
$installerName = Invoke-DownloadByTraversingManyPages "https://www.7-zip.org/download.html" "*-x64.msi*"
InstallMSI $installerName 

# Python
$installerName = Invoke-DownloadByTraversingManyPages "https://www.python.org/downloads/" "*/release/*,*amd64.exe*"
Invoke-Expression ".\$installerName /passive /log $installerName.log"

# Snagit
$installerName = Invoke-DownloadByTraversingManyPages "https://download.techsmith.com/snagit/releases/2015/snagit.exe" "*snagit.exe*"
SilentInstallExe $installerName

# Install IDM
$installerName = Invoke-DownloadByTraversingManyPages "https://www.internetdownloadmanager.com/download.html" "*.exe"
Invoke-Expression "./$installerName /skipdlgs"

# BeyondCompare 4
$installerName = Invoke-DownloadByTraversingManyPages "https://www.scootersoftware.com/download.php" "*.exe"
SilentInstallExe $installerName

# Gitkraken
$installerName = Invoke-DownloadByTraversingManyPages "https://release.gitkraken.com/win64/GitKrakenSetup.exe" "*.exe"
Invoke-Expression "./$installerName -s"

# Everything 
$installerName = Invoke-DownloadByTraversingManyPages "https://www.voidtools.com/downloads/" "*x64-Setup.exe"
Invoke-Expression "./$installerName /S"

# Docker desktop for windows
$installerName = Invoke-DownloadByTraversingManyPages "https://desktop.docker.com/win/stable/Docker Desktop Installer.exe" "*Installer.exe"
Invoke-Expression "./$installerName install --quiet"

# Teamviewer
$installerName = Invoke-DownloadByTraversingManyPages  "https://download.teamviewer.com/download/TeamViewer_Setup.exe" "*TeamViewer_Setup.exe"
Invoke-Expression "./$installerName /S"

# Chrome Remote Desktop
$installerName = Invoke-DownloadByTraversingManyPages  "https://dl.google.com/edgedl/chrome-remote-desktop/chromeremotedesktophost.msi" "*.msi"
InstallMSI $installerName

# Go Lang
$installerName = Invoke-DownloadByTraversingManyPages  "https://golang.org/dl/" "*amd64.msi"
InstallMSI $installerName

# NodeJs
$installerName = Invoke-DownloadByTraversingManyPages  "https://nodejs.org/en/download/" "*x64.msi"
InstallMSI $installerName