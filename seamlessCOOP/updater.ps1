$versionFile = "$env:APPDATA/ZeroCode/SeamlessCOOP/version.txt"

if(Test-Path -Path $versionFile) {
    $ver = Get-Content -Path $versionFile
}
else {
    New-Item -Path $versionFile -ItemType "File"
}
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$downloads = "$HOME/Downloads"

$url = 'https://github.com/LukeYui/EldenRingSeamlessCoopRelease/releases/latest'
$request = [System.Net.WebRequest]::Create($url)
$response = $request.GetResponse()
$realTagUrl = $response.ResponseUri.OriginalString
$version = $realTagUrl.split('/')[-1].Trim('v')

$site = ((Invoke-WebRequest -Uri $realTagUrl).Links.href) -like "/LukeYui/EldenRingSeamlessCoopRelease/releases/download/*" | Select-Object -first 1 | Out-String
$site = "https://github.com/$site"
#Invoke-WebRequest -Uri $site -OutFile "$downloads/seamlessCOOP-$version.zip"

## Add auto folder mgmt