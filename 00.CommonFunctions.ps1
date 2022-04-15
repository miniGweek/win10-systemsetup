
Function Invoke-DownloadByTraversingManyPages($startUrl, $patterns , [string]$fileName, [bool]$direct = $false) {
    Write-Host "+++++ Entering Download code, params are $startUrl - $fileName - $direct "
    $downloadedFileName = DownloadFileIfUrlEndsWithExeOrMSI $startUrl $fileName $direct
    if ($patterns -ne $null -and $patterns.Length -gt 0) {
        $arrayOfPatterns = $patterns.Split(",");
        $url = @($startUrl)
        $uriObject = [System.Uri]$startUrl;
        $uriHost = $uriObject.Host;
        if ($null -eq $downloadedFileName) {
            foreach ($p in $arrayOfPatterns) {
                Write-Host "+++++ Visiting $($url[-1])"
                $page = Invoke-WebRequest -Uri $url[-1] -UseBasicParsing #Always use the last url
                Write-Host "+++++ Searching links with pattern $p"
                $link = $page.Links | Where-Object { $_.href -like $p } | Select -First 1
                Write-Host "+++++ Matched href $($link.href)"
                $newUrl = Get-AbsoluteUrl $uriHost $link.href
                $url += $newUrl
                Write-Host "+++++ Link matched $newUrl"
            }
            $downloadedFileName = DownloadFileIfUrlEndsWithExeOrMSI $url[-1] $fileName
        }
    }
    return $downloadedFileName
}

Function DownloadFileIfUrlEndsWithExeOrMSI($url, [string]$fileName, [bool]$direct = $false) {
    if (($url.EndsWith(".exe") -or $url.EndsWith(".msi")) -or $direct -eq $true) {
        Write-Host "+++++ Download link found - $url .Initiating download."
        $fileName = DownloadFile $url $fileName
        return $fileName
    }
    return $null
}

Function Get-AbsoluteUrl($uriHost, $uri) {
    if ($uri.IndexOf("https://") -ne 0) {
        return "https://$uriHost/$uri"
    }
    return $uri
}
function DownloadFile($url, [string]$fileName) {
    $installerLink = $url
    if ($fileName -eq $null -or $fileName -eq "") {
        $installerName = $installerLink -Split "/"
        if ($installerName[-1].IndexOf("=") -gt 0) {
            $installerName = $installerName[-1].Split("=");
        }
        $fileName = $installerName[-1]
    }
    Write-Host "+++++ Downloading File  $fileName from link $url "
    curl $url -Lo $fileName
    return $fileName;
}
function InstallMSI {
    param(
        [Parameter(Mandatory = $true)][string]$FileName,
        [string]$Arguments
    )
    Write-Host "+++++ Begin install of $FileName"
    $DataStamp = Get-Date -Format ddMMyyyyTHHmmss
    $InstallLogFile = '{0}-{1}.log' -f $fileName, $DataStamp
    $MSIArguments = @(
        "/i"
        ('"{0}"' -f $fileName)
        "/qn"
        $Arguments
        "/norestart"
        "/L*v"
        $InstallLogFile
    )
    Start-Process "msiexec.exe" -ArgumentList $MSIArguments -Wait -NoNewWindow 
    Write-Host "+++++ End install of $FileName"
}


Function SilentInstallExe($exeName) {
    $shortDate = Get-Date -Format "ddMMyyyy"
    Invoke-Expression ".\$exeName /VERYSILENT /NORESTART /LOG=$exeName.$shortDate.log"
}

Function SilentInstallExe2($exeName) {
    Invoke-Expression ".\$exeName /S"
}

function DownloadAndInstall($url) {
    $installerName = DownloadFile $url
    InstallMSI $installerName
}

function DownloadFromGithubReleasePage {
    param(
        [Parameter(Mandatory = $true)][string]$ReleasePageUrl,
        [Parameter(Mandatory = $true)][string]$SetupFilePatternName,
        [string]$ExcludePattern)

    $Releases = Invoke-WebRequest -Uri $ReleasePageUrl -UseBasicParsing
    $LatestReleaseUrl = $Releases.Links | Where-Object { $_.href -like $SetupFilePatternName -and $_.href -notlike $ExcludePattern } | Select-Object href -First 1
    Write-Host ++++++++++ LatestReleaseUrl = $LatestReleaseUrl
    $LatestReleaseFileName = $LatestReleaseUrl.href -Split "/" | Select-Object -Last 1
    Write-Host ++++++++++ LatestReleaseFileName = $LatestReleaseFileName
    $LatestReleaseDownloadUrl = "https://github.com$($LatestReleaseUrl.href)"
    Write-Host ++++++++++ LatestReleaseDownloadUrl = $LatestReleaseDownloadUrl
    if (Test-Path -Path $LatestReleaseFileName) {
        Remove-Item $LatestReleaseFileName
        Write-Host ++++++++++ Removing existing file with same name - $LatestReleaseFileName
    }
    Write-Host ++++++++++ Downloading $LatestReleaseFileName
    Invoke-WebRequest -Uri $LatestReleaseDownloadUrl -OutFile $LatestReleaseFileName -UseBasicParsing
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

function Remove-Installer($Pattern) {
    if (Test-Path -Path $Pattern) {
        Write-Output "Removing existing installer with file pattern $Pattern"
        Remove-Item $Pattern
    }
}