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
    New-Item -Path $versionFile -ItemType "File"
    Set-Content $versionFile -Value $onVer
}
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$tmp = "$HOME/ZeroTMP"

$url = 'https://github.com/LukeYui/EldenRingSeamlessCoopRelease/releases/latest'
$request = [System.Net.WebRequest]::Create($url)
$response = $request.GetResponse()
$realTagUrl = $response.ResponseUri.OriginalString
$version = $realTagUrl.split('/')[-1].Trim('v')

$site = ((Invoke-WebRequest -Uri $realTagUrl).Links.href) -like "/LukeYui/EldenRingSeamlessCoopRelease/releases/download/*" | Select-Object -first 1 | Out-String
$site = "https://github.com/$site"
Invoke-WebRequest -Uri $site -OutFile "$tmp/seamlessCOOP-$version.zip"

## Add auto folder mgmt