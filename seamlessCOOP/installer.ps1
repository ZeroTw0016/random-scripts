New-Item -Path "$HOME/ZeroCode/" -ItemType Directory -Force -Name "scripts"
$file = 
if(!Test-Path -Path "$HOME/ZeroCode/scripts/updater.ps1") {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/ZeroTw0016/random-scripts/main/seamlessCOOP/updater.ps1" -OutFile "$HOME/ZeroCode/scripts/updater.ps1"
}
Set-Location "$HOME/ZeroCode/scripts/updater.ps1"
start powershell {.\updater.ps1}

clear