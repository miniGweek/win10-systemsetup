$downloadUrls = @(
    @{url = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"; installerName = "vscodex64setup.exe"; skipParsing = $true };
    @{url = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases"; pattern = "*x64.exe*" },
    @{url = "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B2681C7F7-75A7-0A42-9A9A-3F3D39F28F5B%7D%26lang%3Den%26browser%3D4%26usagestats%3D1%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/update2/installers/ChromeSetup.exe"; pattern = "*ChromeSetup.exe*" },
    @{url = "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US"; installerName = "FireFoxSetup.exe"; skipParsing = $true },
    @{url = "https://github.com/brave/brave-browser/releases"; pattern = "*BraveBrowserStandaloneSetup.exe*" },
    @{url = "https://github.com/git-for-windows/git/releases"; pattern = "*-64-bit.exe*" },
    @{url = "https://go.microsoft.com/fwlink/p/?LinkID=869426&clcid=0x409&culture=en-us&country=US&lm=deeplink&lmsrc=groupChatMarketingPageWeb&cmpid=directDownloadWin64"; installerName = "MSTeamsSetup.exe"; skipParsing = $true },
    @{url = "https://github.com/Azure/azure-cli/releases"; pattern = "*msi*" },
    @{url = "https://github.com/Azure/azure-powershell/releases"; pattern = "*-x64.msi" },
    @{url = "https://vivaldi.com/download/" ; pattern = "*x64.exe*" },
    @{url = "https://www.7-zip.org/download.html"; pattern = "*-x64.msi*" },
    @{url = "https://www.python.org/downloads/"; pattern = "*/release/*,*amd64.exe*" },
    @{url = "https://download.techsmith.com/snagit/releases/2015/snagit.exe"; pattern = "*snagit.exe*" },
    @{url = "https://www.internetdownloadmanager.com/download.html"; pattern = "*.exe" },
    @{url = "https://release.gitkraken.com/win64/GitKrakenSetup.exe" ; pattern = "*.exe" },
    @{url = "https://www.voidtools.com/downloads/" ; pattern = "*x64-Setup.exe" },
    @{url = "https://desktop.docker.com/win/stable/Docker Desktop Installer.exe" ; pattern = "*Installer.exe" },
    @{url = "https://download.teamviewer.com/download/TeamViewer_Setup.exe" ; pattern = "*TeamViewer_Setup.exe" },
    @{url = "https://dl.google.com/edgedl/chrome-remote-desktop/chromeremotedesktophost.msi" ; pattern = "*.msi" },
    @{url = "https://golang.org/dl/" ; pattern = "*amd64.msi" },
    @{url = "https://nodejs.org/en/download/" ; pattern = "*x64.msi" };
    @{url = "https://release.gitkraken.com/win64/GitKrakenSetup.exe"; pattern = "*.exe" }
)
# Invoke-DownloadByTraversingManyPages -startUrl $downloadUrls[0].url -fileName $downloadUrls[0].installerName  -direct  $downloadUrls[0].skipParsing 
$downloadUrls 