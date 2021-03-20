
function DownloadFile($url) {
    $installerLink = $url
    $installerName = $installerLink -Split "/"
    Invoke-WebRequest $url -OutFile $installerName[-1]
    return $installerName[-1];
}
function InstallMSI($fileName) {
    $DataStamp = Get-Date -Format ddMMyyyyTHHmmss
    $InstallLogFile = '{0}-{1}.log' -f $fileName, $DataStamp
    $MSIArguments = @(
        "/i"
        ('"{0}"' -f $fileName)
        "/qn"
        "/norestart"
        "/L*v"
        $InstallLogFile
    )
    Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow 
}
function DownloadAndInstall($url) {
    $installerName = DownloadFile $url
    InstallMSI $installerName
}

function DownloadFromGithubReleasePage($releasePageUrl, $setupFilePatternName) {
    $Releases = Invoke-WebRequest -Uri $releasePageUrl
    $LatestReleaseUrl = $Releases.Links | Where-Object { $_.href -like $setupFilePatternName } | Select href -First 1
    Write-Host ++++++++++ LatestReleaseUrl = $LatestReleaseUrl
    $LatestReleaseFileName = $LatestReleaseUrl.href -Split "/" | Select -Last 1
    Write-Host ++++++++++ LatestReleaseFileName = $LatestReleaseFileName
    $LatestReleaseDownloadUrl = "https://github.com$($LatestReleaseUrl.href)"
    Write-Host ++++++++++ LatestReleaseDownloadUrl = $LatestReleaseDownloadUrl
    if (Test-Path -Path $LatestReleaseFileName) {
        Remove-Item $LatestReleaseFileName
        Write-Host ++++++++++ Removing existing file with same name - $LatestReleaseFileName
    }
    Write-Host ++++++++++ Downloading $LatestReleaseFileName
    Invoke-WebRequest -Uri $LatestReleaseDownloadUrl -OutFile $LatestReleaseFileName
    return $LatestReleaseFileName
}

Function Invoke-InstallFonts($FolderPath, $FontsPatternToInstall) {
    $Destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
    $SourceDir = ".\$FolderPath\"

    $TempFolder = "~/Downloads/TempFonts"
    $FontInstallPath = "C:\Windows\Fonts"

    if (Test-Path -Path $TempFolder ) {
        Remove-Item $TempFolder -Recurse -Force
    }
    New-Item $TempFolder -Type Directory -Force | Out-Null
    $FONTS = 0x14
    $objShell = New-Object -ComObject Shell.Application
    $objFolder = $objShell.Namespace($FONTS)
    Get-ChildItem -Path $SourceDir -Include $FontsPatternToInstall -Recurse | ForEach {
        $File = $_
        $try = $true
        $installedFonts = @(Get-ChildItem $FontInstallPath | Where-Object { $_.PSIsContainer -eq $false } | Select-Object basename)
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
}