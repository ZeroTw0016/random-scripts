New-Item -Path "$HOME/ZeroCode/" -ItemType Directory -Force -Name "scripts"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ZeroTw0016/random-scripts/main/seamlessCOOP/updater.ps1" -OutFile "$HOME/ZeroCode/scripts/updater.ps1"
Set-Location "$HOME/ZeroCode/scripts/"
start powershell {powershell.exe -ExecutionPolicy Bypass -File ".\updater.ps1"}
clear