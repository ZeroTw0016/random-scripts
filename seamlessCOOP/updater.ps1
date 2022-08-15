[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$versionFile = "$HOME/ZeroCode/version.txt"
$vers = (Get-Content -Raw -LiteralPath $versionFile)
$rawScriptUrl = "https://raw.githubusercontent.com/ZeroTw0016/random-scripts/main/seamlessCOOP/updater.ps1"
$onVerUrl = "https://raw.githubusercontent.com/ZeroTw0016/random-scripts/main/seamlessCOOP/version"
$onVers = ((Invoke-WebRequest -Uri $onVerUrl)).content | Out-String
$drives = Get-PSDrive -PSProvider FileSystem
$ver = [int]$vers
$onVer = [int]$onVers

foreach($drive in $drives) {
    #Write-Host $drive
}
if(Test-Path -Path $versionFile) {
    if($ver -lt $onVer) {
        Set-Content $versionFile -Value $onVer
        Write-host "Script Updating"
        $script = ((Invoke-WebRequest -Uri $rawScriptUrl)).content | Out-String
        Set-Content ./updater.ps1 -Value $script
        Start-Sleep 1
        #start powershell {.\updater.ps1}
        exit
    }
    else {
        Write-Host "no script update needed"
    }
}
else {
    New-Item -ItemType Directory -Force -Path "$HOME/ZeroCode/SeamlessCOOP"
    New-Item -Path $versionFile -ItemType "File"
    Set-Content $versionFile -Value $onVer
}

$tmp = "$HOME/ZeroCode/ZeroTMP"
New-Item -ItemType Directory -Force -Path "$tmp"
$url = 'https://github.com/LukeYui/EldenRingSeamlessCoopRelease/releases/latest'

$site = ((Invoke-WebRequest -Uri $url).Links.href) -like "*/download/*" | Select-Object -first 1 | Out-String
$site = "https://github.com/$site"
$fileName = ([uri]$site).Segments[-1]
Invoke-WebRequest -Uri $site -OutFile "$tmp/$fileName" 

## Add auto folder mgmt