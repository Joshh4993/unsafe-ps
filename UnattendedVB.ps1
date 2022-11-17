<#
Installs:
    - VirtualBox w/:
        - Kali ISO
        - Metasploitable ISO
    - Git CLI
    - Wireshark

    (See blog for downloads)
    - All My LAN
    - Network Inspector
    - Network Port Scanner
    https://www.networkworld.com/article/3325736/10-useful-and-free-networking-tools-that-are-windows-10-apps.html
#>

#Download Virtualbox, silently
Write-Host "Downloading VirtualBox..." -ForegroundColor Cyan
New-Item -Path "c:\" -Name "TempVB" -ItemType "directory"
$VBInstallDir = 'C:\TempVB\virtualbox.exe'
$VBurl = "https://download.virtualbox.org/virtualbox/7.0.2/VirtualBox-7.0.2-154219-Win.exe"
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($VBurl, $VBInstallDir)
$args = @("silent")
Start-Process -Filepath $VBInstallDir '-silent'
Write-Host "VirtualBox Installed..." -ForegroundColor Cyan

#Download ISOs
Write-Host "Downloading ISO Zips..." -ForegroundColor Cyan
$metasurl = "https://sourceforge.net/projects/metasploitable/files/latest/download"
# NEED TO CHANGE 7ZIP TO ZIP (UPLOAD TO G-DRIVE)
$kaliurl = "https://sourceforge.net/projects/osboxes/files/v/vb/25-Kl-l-x/2022.3/64bit.7z/download"
New-Item -Path "c:\" -Name "Networking" -ItemType "directory"
New-Item -Path "c:\Networking" -Name "ISOs" -ItemType "directory"
$isodir = "C:\Networking\ISOs"
$wckali = New-Object System.Net.WebClient
$wckali.DownloadFile($kaliurl, "$isodir/kali.7z")
$wcmeta = New-Object System.Net.WebClient
$wcmeta.DownloadFile($metasurl, "$isodir/metas.zip")
$kalizippath = "C:\Networking\ISOs\kali.7z"
$metaszippath = "C:\Networking\ISOs\metas.zip"
New-Item -Path "c:\Networking\ISOs" -Name "kali" -ItemType "directory"
New-Item -Path "c:\Networking\ISOs" -Name "metasploitable" -ItemType "directory"
$kalioutput = "C:\Networking\ISOs\kali"
$metasoutput = "C:\Networking\ISOs\metasploitable"
Write-Host "Unpacking ISO Zips..." -ForegroundColor Cyan
Expand-Archive -LiteralPath $kalizippath -DestinationPath $kalioutput
Expand-Archive -LiteralPath $metaszippath -DestinationPath $metasoutput

Write-Host "Removing ISO Zips..." -ForegroundColor Cyan
#Remove Temporary Zips
Remove-Item $kalizippath
Remove-Item $metaszippath
Write-Host "Zips Removed, ISOs Installed..." -ForegroundColor Cyan

Write-Host "Installing Git for windows..." -ForegroundColor Cyan
#Git 
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
Write-Host "Git Installed:" -ForegroundColor Cyan
git '--version'
