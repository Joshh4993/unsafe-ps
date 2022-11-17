<#
Installs:
    - VirtualBox w/:
        - Kali ISO
        - Metasploitable ISO
    - Git CLI
    - Wireshark
#>

Write-Host "Downloading VirtualBox..." -ForegroundColor Cyan
New-Item -Path "c:\" -Name "TempVB" -ItemType "directory"
$VBInstallDir = 'C:\TempVB\virtualbox.exe'
$VBurl = "https://download.virtualbox.org/virtualbox/7.0.2/VirtualBox-7.0.2-154219-Win.exe"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($VBurl, $VBInstallDir)
Start-Process -Filepath $VBInstallDir '-silent'
Write-Host "VirtualBox Installed" -ForegroundColor Green



Write-Host "Downloading ISO Zips..." -ForegroundColor Cyan
$metasurl = "https://sourceforge.net/projects/metasploitable/files/latest/download"
$kaliurl = "https://drive.google.com/file/d/1e7DxtgKtlxqnk5k_bR5Q1V7M8s_FcQ6F/view?usp=share_link"
New-Item -Path "c:\" -Name "Networking" -ItemType "directory"
New-Item -Path "c:\Networking" -Name "ISOs" -ItemType "directory"
$isodir = "C:\Networking\ISOs"
$wckali = New-Object System.Net.WebClient
Write-Host "Downloading Kali Zip..." -ForegroundColor Cyan
$wckali.DownloadFile($kaliurl, "$isodir/kali.zip")
$wcmeta = New-Object System.Net.WebClient
Write-Host "Downloading Metasploitable Zip..." -ForegroundColor Cyan
$wcmeta.DownloadFile($metasurl, "$isodir/metas.zip")
$kalizippath = "C:\Networking\ISOs\kali.zip"
$metaszippath = "C:\Networking\ISOs\metas.zip"
New-Item -Path "c:\Networking\ISOs" -Name "kali" -ItemType "directory"
New-Item -Path "c:\Networking\ISOs" -Name "metasploitable" -ItemType "directory"
$kalioutput = "C:\Networking\ISOs\kali"
$metasoutput = "C:\Networking\ISOs\metasploitable"
Write-Host "Unpacking ISO Zips..." -ForegroundColor Cyan
Expand-Archive -LiteralPath $kalizippath -DestinationPath $kalioutput
Expand-Archive -LiteralPath $metaszippath -DestinationPath $metasoutput
Write-Host "ISO Zips Unpacked" -ForegroundColor Green



Write-Host "Installing Git for windows..." -ForegroundColor Cyan 
$GitURL = "https://github.com/git-for-windows/git/releases/download/v2.38.1.windows.1/Git-2.38.1-64-bit.exe"
$GitInstallDir = 'C:\TempVB\gitcli.exe'
$gitwc = New-Object System.Net.WebClient
$gitwc.DownloadFile($GitURL, $GitInstallDir)
Start-Process $GitInstallDir -Wait -ArgumentList '/NORESTART /NOCANCEL /VERYSILENT /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /COMPONENTS="icons,ext\reg\shellhere,assoc,assoc_sh" /LOG="C:\git-for-windows.log"'
foreach($level in "Machine","User") {
   [Environment]::GetEnvironmentVariables($level).GetEnumerator() | % {
      # For Path variables, append the new values, if they're not already in there
      if($_.Name -match 'Path$') { 
         $_.Value = ($((Get-Content "Env:$($_.Name)") + ";$($_.Value)") -split ';' | Select -unique) -join ';'
      }
      $_
   } | Set-Content -Path { "Env:$($_.Name)" }
}
Write-Host "Git Installed" -ForegroundColor Green

$dcURL = "https://discord.com/api/downloads/distributions/app/installers/latest?channel=stable&platform=win&arch=x86"
$dcInstallDir = 'C:\TempVB\dc.exe'
$dcwc = New-Object System.Net.WebClient
$dcwc.DownloadFile($dcURL, $dcInstallDir)
Start-Process $dcInstallDir -Wait '-s'

Write-Host "Installing Wireshark..." -ForegroundColor Cyan
$WiresharkURL = "https://1.eu.dl.wireshark.org/win64/Wireshark-win64-4.0.1.exe"
$WiresharkInstallDir = 'C:\TempVB\wireshark.exe'
$wswc = New-Object System.Net.WebClient
$wswc.DownloadFile($WiresharkURL, $WiresharkInstallDir)
Start-Process $WiresharkInstallDir -Wait -ArgumentList '/S'
Write-Host "Wireshark Installed" -ForegroundColor Green



Write-Host "Removing Temporary Directories..." -ForegroundColor Cyan
Remove-Item $kalizippath
Remove-Item $metaszippath
Remove-Item "C:\TempVB" -Recurse
Write-Host "Temporary Directories Removed" -ForegroundColor Green



#End
Write-Host "Operations Completed" -ForegroundColor Green
Write-Host "VirtualBox Version:" -ForegroundColor Cyan
Write-Host "virtualbox version 7.0.2" -ForegroundColor White
Write-Host "Git Version:" -ForegroundColor Cyan
git '--version'
Write-Host "Wireshark Version:" -ForegroundColor Cyan
Write-Host "wireshark version 4.0.1" -ForegroundColor White