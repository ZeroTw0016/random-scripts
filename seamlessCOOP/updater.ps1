$versionFile = "$env:APPDATA/ZeroCode/SeamlessCOOP/version.txt"
$rawScriptUrl = "https://raw.githubusercontent.com/ZeroTw0016/random-scripts/main/seamlessCOOP/updater.ps1"
$onVerUrl = "https://raw.githubusercontent.com/ZeroTw0016/random-scripts/main/seamlessCOOP/version"
$onVer = ((Invoke-WebRequest -Uri $onVerUrl)).content | Out-String

if(Test-Path -Path $versionFile) {
    $ver = Get-Content -Path $versionFile
    if(!$ver -eq $onVer) {
        Write-host "Script Updating"
        $script = ((Invoke-WebRequest -Uri $rawScriptUrl)).content | Out-String
        Set-Content ./updater.ps1 -Value $script
        ./updater.ps1
        exit
    }
}
else {
    New-Item -ItemType Directory -Force -Path "$env:APPDATA/ZeroCode/SeamlessCOOP"
    New-Item -Path $versionFile -ItemType "File"
    Set-Content $versionFile -Value $onVer
}

$tmp = "$HOME/ZeroTMP"
New-Item -ItemType Directory -Force -Path "$tmp"
$url = 'https://github.com/LukeYui/EldenRingSeamlessCoopRelease/releases/latest'

$site = ((Invoke-WebRequest -Uri $url).Links.href) -like "*/download/*" | Select-Object -first 1 | Out-String
$site = "https://github.com/$site"
$fileName = ([uri]$site).Segments[-1]
Invoke-WebRequest -Uri $site -OutFile "$tmp/$fileName"

## Add auto folder mgmt 
