

# Install Chocolatey if it's not installed
Write-Log "Checking if chocolatey is installed."
powershell.exe -NoProfile -Command choco -v
if ($false -eq $?) {
    Write-Log "Chocolatey isn't installed, installing the latest version of chocolatey."
    # Install Chocolatey
    Set-ExecutionPolicy Bypass -Scope Process `
        -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}