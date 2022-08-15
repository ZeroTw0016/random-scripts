Requires -RunAsAdministrator
(wget https://raw.githubusercontent.com/ZeroTw0016/random-scripts/main/seamlessCOOP/updater.ps1).content > updater.ps1
Install-Module -Name ps2exe -Confirm
Invoke-ps2exe -inputFile .\updater.ps1 -outputFile .\updater.exe -iconFile .\icon.jpg
New-Item -ItemType SymbolicLink -Path updater.exe -Target [Environment]::GetFolderPath("Desktop")