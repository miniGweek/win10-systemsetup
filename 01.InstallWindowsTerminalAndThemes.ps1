Set-ExecutionPolicy -Force -Scope Process -ExecutionPolicy Bypass; . { Invoke-WebRequest -useb https://raw.githubusercontent.com/miniGweek/win10-systemsetup/main/InstallWindowsTerminalAndThemes.ps1 } | Invoke-Expression; InstallWindowsTerminalAndThemes