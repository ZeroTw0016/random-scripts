the seamlessCOOP is installed with a one liner:<br>
```powershell
Invoke-WebRequest -Uri "https://github.com/ZeroTw0016/random-scripts/blob/main/seamlessCOOP/installer.exe?raw=true" -OutFile "$HOME/Desktop/EldenRing-Coop.exe"
```
also for the seamlessCOOP you should set an exclude to for windows Defender as the EXE file does get put into the quarantine
```powershell
Add-MpPreference -ControlledFolderAccessAllowedApplications "$HOME/Desktop/EldenRing-Coop.exe"
```
