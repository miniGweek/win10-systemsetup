
Function Write-Log {
    param(
        [Parameter(Mandatory = $true)][string]$Message
    )
    $CurrentDateTimeStamp = Get-Date -Format "dd/MM/yyyy hh:mm:ss"
    Write-Host "### $CurrentDateTimeStamp ### ... $Message ..."
}

Function Get-File {
    param(
        [Parameter(Mandatory = $true)][string]$Uri,
        [string]$OutFile
    )
    $WebClient = New-Object System.Net.WebClient
    $OutFileDir = ""
    if ($null -eq $OutFile -or "" -eq $OutFile) {
        $OutFile = ($Uri -Split "/")[-1]
        # Write-Log -Message "OutFile is null or empty, split url and derived OutFile = $OutFile"
    }
    else {
        $OutFileDir = Split-Path $OutFile -Parent
        #  Write-Log -Message "OutFile is not null or not empty, split url and derived OutFileDir = $OutFileDir"
    }
    if ($null -eq $OutFileDir -or "" -eq $OutFileDir) {
        $OutFilePath = "$pwd\$OutFile"
        #   Write-Log -Message "OutFilDir is null or empty, setting it to $OutFileDir"
    }
    else {
        $OutFilePath = "$(Resolve-Path $OutFileDir)\$(($OutFile -Split "/")[-1])"
        #   Write-Log -Message "OutFilDir is not null or not empty, setting OutFilePath to $OutFilePath"
    }

    Write-Log -Message "Begin download from url $Uri and save as file $OutFilePath"
    $WebClient.Downloadfile($Uri, $OutFilePath)
    Write-Log -Message "Download done"
    return $OutFilePath
}
Function Invoke-DownloadByTraversingManyPages($startUrl, $patterns , [string]$fileName, [bool]$direct = $false) {
    Write-Log -Message "Entering Download code, params are $startUrl - $fileName - $direct"
    $downloadedFileName = DownloadFileIfUrlEndsWithExeOrMSI $startUrl $fileName $direct
    if ($null -ne $patterns -and $patterns.Length -gt 0) {
        $arrayOfPatterns = $patterns.Split(",");
        $url = @($startUrl)
        $uriObject = [System.Uri]$startUrl;
        $uriHost = $uriObject.Host;
        if ($null -eq $downloadedFileName) {
            foreach ($p in $arrayOfPatterns) {
                Write-Log -Message "Visiting $($url[-1])"
                $page = Invoke-WebRequest -Uri $url[-1] -UseBasicParsing #Always use the last url
                Write-Log -Message "Searching links with pattern $p"
                $link = $page.Links | Where-Object { $_.href -like $p } | Select-Object -First 1
                Write-Log -Message "Matched href $($link.href)"
                $newUrl = Get-AbsoluteUrl $uriHost $link.href
                $url += $newUrl
                Write-Log -Message "Link matched $newUrl"
            }
            $downloadedFileName = DownloadFileIfUrlEndsWithExeOrMSI $url[-1] $fileName
        }
    }
    return $downloadedFileName
}

Function DownloadFileIfUrlEndsWithExeOrMSI($url, [string]$fileName, [bool]$direct = $false) {
    if (($url.EndsWith(".exe") -or $url.EndsWith(".msi")) -or $direct -eq $true) {
        Write-Log -Message "Download link found - $url .Initiating download."
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
    Write-Log -Message "Downloading File  $fileName from link $url"
    curl $url -Lo $fileName
    return $fileName;
}
function InstallMSI {
    param(
        [Parameter(Mandatory = $true)][string]$FileName,
        [string]$Arguments
    )
    Write-Log -Message "Begin install of $FileName"
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
    Write-Log -Message "End install of $FileName"
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
    Write-Log -Message "LatestReleaseUrl = $LatestReleaseUrl"
    $LatestReleaseFileName = $LatestReleaseUrl.href -Split "/" | Select-Object -Last 1
    Write-Log -Message "LatestReleaseFileName = $LatestReleaseFileName"
    $LatestReleaseDownloadUrl = "https://github.com$($LatestReleaseUrl.href)"
    Write-Log -Message "LatestReleaseDownloadUrl = $LatestReleaseDownloadUrl"
    if (Test-Path -Path $LatestReleaseFileName) {
        Remove-Item $LatestReleaseFileName -Recurse -Force
        Write-Log -Message "Removing existing file with same name - $LatestReleaseFileName"
    }
    Write-Log -Message "Downloading $LatestReleaseFileName"
    Get-File -Uri $LatestReleaseDownloadUrl -OutFile $LatestReleaseFileName | Out-Null
    return $LatestReleaseFileName
}

Function Invoke-InstallFonts($FolderPath, $FontsPatternToInstall) {
    $Destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
    $SourceDir = ".\$FolderPath\"

    $TempFolder = "~/Downloads/TempFonts"
    $FontInstallPath = "C:\Windows\Fonts"

    Write-Log "Begin Installation of fonts $FontsPatternToInstall"

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
            Write-Log -Message "Copying $($File.fullname)"
            $objFolder.CopyHere($File.fullname, 16)
            Write-Log -Message "Installed $File.fullname"
        }
    
    }
}

function Remove-File($Pattern) {
    if (Test-Path -Path $Pattern) {
        Write-Log -Message "Removing existing installer with file pattern $Pattern"
        Remove-Item $Pattern -Recurse -Force
    }
}

Function Add-EntryToProfile {
    param(
        [Parameter(Mandatory = $true)][string]$Content
    )

    Write-Log -Message "Beging adding $Content to PowerShell (core) profile"
    $PSProfileDirectory = "$env:USERPROFILE\Documents\PowerShell"
    $PSProfilePath = "$PSProfileDirectory\Microsoft.PowerShell_profile.ps1"
    $ProfileContent = ""
    if (Test-Path -Path $PSProfilePath) {
        Write-Log -Message "$PSProfilePath exists. "
        $ProfileContent = Get-Content -Path  $PSProfilePath
    }
    else {
        Write-Log -Message "$PSProfilePath doesn't exist"
        if ((Test-Path $PSProfileDirectory) -ne $true) {
            Write-Log -Message "$PSProfileDirectory doesn't exist. Creating $PSProfileDirectory"
            New-Item -Type Directory $PSProfileDirectory   | Out-Null 
        }
    }

    if (($ProfileContent -Contains $Content) -eq $False) {
        Write-Log -Message "$Profile doesn't contain the script $Content...Adding it..."
        Add-Content $PSProfilePath $Content
        Write-Log -Message "Added $Content to Powershell profile"
    }
    else {
        Write-Log -Message "The $Profile script already contains $Content.Skipping"
    }
}

Function Get-ExePath {
    param(
        [Parameter(Mandatory = $true)][string]$RootSearchDirectory,
        [Parameter(Mandatory = $true)][string]$ExeName,
        [string]$Exclude,
        [switch]$Recurse
    )
    
    $ExeRelativePath = ""
    if ($Recurse.IsPresent) {
        $ExeRelativePath = Get-ChildItem -Path $RootSearchDirectory -Recurse -Name $ExeName
    }
    else {
        $ExeRelativePath = Get-ChildItem -Path $RootSearchDirectory -Name $ExeName
    }
    if ($null -ne $Exclude -and "" -ne $Exclude -and $Exclude.Length -gt 0) {
        $ExeRelativePath = $ExeRelativePath  | Where-Object { $_ -notlike $Exclude }
    }
    if ($null -eq $ExeRelativePath -or $ExeRelativePath -eq "" -or ($ExeRelativePath.GetType().Name -eq "Object[]")) {
        throw "More than 1 match found, quitting"
    }
   
    $ExePath = Join-Path -Path $RootSearchDirectory -ChildPath $ExeRelativePath
    return $ExePath
}