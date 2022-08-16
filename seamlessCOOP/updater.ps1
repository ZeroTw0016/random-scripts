[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$rawScriptUrl = "https://raw.githubusercontent.com/ZeroTw0016/random-scripts/main/seamlessCOOP/updater.ps1"
$steamPath = Get-Item hklm:SOFTWARE\WOW6432Node\Valve\Steam
$steamPath = $steamPath.GetValue("InstallPath")
$libPath = $steamPath + "/steamapps/libraryfolders.vdf"
$Libraries = Get-Content -Path $libPath
$LibPaths = @()


foreach($line in $Libraries) {
    if($line.Contains("path")) {
        $LibPaths += $line.Replace('"path"		',"") -replace('"','') -replace("		","") -replace('\\',"\")
    }
}

if($LibPaths.Count -gt 0) {
    :outer foreach($path in $LibPaths) {
        $common = $path + "/steamapps/common/"
        $games = gci $common -Directory
        foreach($game in $games) {
            if($game.name -eq "ELDEN RING") {
                $fName = $game.FullName + "/Game/"
                $eldenFolder = $fName
            }
        }
    }
}

Write-Host "Checking Updates and installing if there are any"


$tmp = "$HOME/ZeroCode/ZeroTMP"
New-Item -ItemType Directory -Force -Path "$tmp" | Out-Null
$url = 'https://github.com/LukeYui/EldenRingSeamlessCoopRelease/releases/latest'

$site = ((Invoke-WebRequest -Uri $url).Links.href) -like "*/download/*" | Select-Object -first 1 | Out-String
$site = "https://github.com/$site"
$fileName = ([uri]$site).Segments[-1]


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


Remove-Item $tmp -Force -Recurse
Set-Location $eldenFolder
.\launch_elden_ring_seamlesscoop.exe
exit