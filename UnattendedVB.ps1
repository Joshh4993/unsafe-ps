New-Item -Path "c:\" -Name "VBox" -ItemType "directory"
$InstallDir = 'C:\VBox\virtualbox.exe'
$url = "https://download.virtualbox.org/virtualbox/7.0.2/VirtualBox-7.0.2-154219-Win.exe"

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $InstallDir)

$args = @("silent")
Start-Process -Filepath $InstallDir '-silent'

$metasurl = "https://sourceforge.net/projects/metasploitable/files/latest/download"
$kaliurl = "https://sourceforge.net/projects/osboxes/files/v/vb/25-Kl-l-x/2022.3/64bit.7z/download"

New-Item -Path "c:\" -Name "Networking" -ItemType "directory"
New-Item -Path "c:\Networking" -Name "ISOs" -ItemType "directory"

$isodir = "C:\Networking\ISOs"

$wckali = New-Object System.Net.WebClient
$wckali.DownloadFile($kaliurl, "$isodir/kali.7z")

$wcmeta = New-Object System.Net.WebClient
$wcmeta.DownloadFile($metasurl, "$isodir/metas.zip")


$kalizippath = "C:\Networking\ISOs\kali.zip"
$metaszippath = "C:\Networking\ISOs\metas.zip"

New-Item -Path "c:\Networking\ISOs" -Name "kali" -ItemType "directory"
New-Item -Path "c:\Networking\ISOs" -Name "metasploitable" -ItemType "directory"

$kalioutput = "C:\Networking\ISOs\kali"
$metasoutput = "C:\Networking\ISOs\metasploitable"

Expand-Archive -LiteralPath $kalizippath -DestinationPath $kalioutput
Expand-Archive -LiteralPath $metaszippath -DestinationPath $metasoutput

Remove-Item $kalizippath
Remove-Item $metaszippath