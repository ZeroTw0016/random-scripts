[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$versionFile = "$HOME/ZeroCode/version.txt"
$modVersionFile = "$HOME/ZeroCode/mod_version.txt"
$modVers = (Get-Content -Raw -LiteralPath $modVersionFile -ErrorAction SilentlyContinue)
$vers = (Get-Content -Raw -LiteralPath $versionFile -ErrorAction SilentlyContinue)
$rawScriptUrl = "https://raw.githubusercontent.com/ZeroTw0016/random-scripts/main/seamlessCOOP/updater.ps1"
$onVerUrl = "https://raw.githubusercontent.com/ZeroTw0016/random-scripts/main/seamlessCOOP/version"
$onVers = ((Invoke-WebRequest -Uri $onVerUrl)).content | Out-String
$ver = [int]$vers
$onVer = [int]$onVers
$modVer = $modVers

Write-Host "Checking Updates and installing if there are any"





if(Test-Path -Path "$HOME/ZeroCode/path.conf") {
    $eldenFolder = (Get-Content -LiteralPath "$HOME/ZeroCode/path.conf" -ErrorAction SilentlyContinue)
    $eldenFolder
}
else {
    [System.Windows.MessageBox]::Show('Please select the "ELDEN RING" folder')
    $content =  Get-Folder
    $content = $content + "\Game\"
    if($content.Contains("ELDEN RING")) {
        Set-Content -Path "$HOME/ZeroCode/path.conf" -Value $content
        $eldenFolder = $content
    }
    else {
        [System.Windows.MessageBox]::Show('TThe Selected Folder is not Valid')
    }
}


if(Test-Path -Path $versionFile) {
    if($ver -lt $onVer) {
        Set-Content $versionFile -Value $onVer
        Write-host "Script Updating"
        $script = ((Invoke-WebRequest -Uri $rawScriptUrl)).content | Out-String
        Set-Content ./updater.ps1 -Value $script
        Start-Sleep 1
        start powershell {.\updater.ps1}
        exit
    }
}
else {
    New-Item -ItemType Directory -Force -Path "$HOME/ZeroCode/SeamlessCOOP"
    New-Item -Path $versionFile -ItemType "File"
    Set-Content $versionFile -Value $onVer
}

$tmp = "$HOME/ZeroCode/ZeroTMP"
New-Item -ItemType Directory -Force -Path "$tmp" | Out-Null
New-Item -ItemType File -Force -Path "$modVersionFile" | Out-Null
$url = 'https://github.com/LukeYui/EldenRingSeamlessCoopRelease/releases/latest'

$site = ((Invoke-WebRequest -Uri $url).Links.href) -like "*/download/*" | Select-Object -first 1 | Out-String
$site = "https://github.com/$site"
$fileName = ([uri]$site).Segments[-1]
if($fileName -ne $modVer) {
    Invoke-WebRequest -Uri $site -OutFile "$tmp/$fileName"
    Expand-Archive -Path "$tmp/$fileName" -DestinationPath "$tmp/" -Force
    Remove-Item -Path "$tmp/$fileName"
    Move-Item -Path "$tmp/launch_elden_ring_seamlesscoop.exe" -Destination $eldenFolder -Force
    $coopFolder = $eldenFolder + "/SeamlessCoop/"
    $settingsFile = $coopFolder + "seamlesscoopsettings.ini"
    $tmpsettingsFile = $tmp + "/SeamlessCoop/seamlesscoopsettings.ini"
    $dll = $coopFolder + "/elden_ring_seamless_coop.dll"
    Remove-Item -Path $dll -Force
    Move-Item -Path "$tmp/SeamlessCoop/elden_ring_seamless_coop.dll" -Destination $coopFolder -Force
    $settings = Get-Content -Path $settingsFile -ErrorAction SilentlyContinue
    foreach($line in $settings) {
        if(!$line.contains(";") -and !$line.contains("[") -and $line -ne "") {
            $pos = $line.IndexOf("=")
            $leftPart = $line.Substring(0, $pos)
            $rightPart = $line.Substring($pos+1)
            if($leftPart -like "cooppassword ") {
                $pwd = "cooppassword =" + $rightPart
            }
        }
    }
    $tmpSettings = Get-Content -Path $tmpsettingsFile -ErrorAction SilentlyContinue
    $tmpSettings -replace '^[^;]*\=+ $',$pwd | Set-Content $tmpsettingsFile
    Move-Item -Path $tmpsettingsFile -Destination $coopFolder -Force
    Set-Content -Path $modVersionFile -Value $fileName
}
Remove-Item $tmp -Force -Recurse
Set-Location $eldenFolder
.\launch_elden_ring_seamlesscoop.exe
exit
