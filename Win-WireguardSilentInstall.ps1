# Suppress the progress bar when downloading files
$ProgressPreference='SilentlyContinue'

# Find the latest release of wireguard from their website
$base="https://download.wireguard.com/windows-client/"
$links=(Invoke-WebRequest -Uri "$base" -UseBasicParsing).links.href
$filename=($links | select-string "wireguard-amd64" | Out-String).Trim("")

# Download the file and silently install it with msiexec
Write-Host "Downloading Wireguard"
Invoke-WebRequest -Uri "$base/$filename" -OutFile $env:temp\wireguard.msi -UseBasicParsing
Write-Host "Installing Wireguard"
Start-Process "MSIEXEC.EXE" -ArgumentList "/i $env:temp\wireguard.msi DO_NOT_LAUNCH=1 /qn"
Write-Host "INSTALLED!"

Write-Host "Excluding Wireguard from firewall"
netsh advfirewall firewall add rule name="Wireguard GUI" dir=in action=allow program="C:\Program Files\WireGuard\wireguard.exe" enable=yes profile=domain,public,private
netsh advfirewall firewall add rule name="Wireguard CLI" dir=in action=allow program="C:\Program Files\WireGuard\wg.exe" enable=yes profile=domain,public,private
Write-Host "DONE!"
