# Download Theme
powershell.exe -Command "Start-BitsTransfer -Source 'https://github.com/V0lk3n/AutoDows/releases/download/Release/AutoDows-V.1.0.0.zip' -Destination 'C:\Users\$env:UserName\Desktop\AutoDows-V.1.0.0.zip'"

# Extract Theme and run installer
powershell.exe -Command "Start-Process powershell.exe -ArgumentList '-noprofile', '-exec', 'Bypass', '-Command Expand-Archive -Path C:\Users\$env:UserName\Desktop\AutoDows-V.1.0.0.zip -DestinationPath C:\Users\$env:UserName\Desktop;C:\Users\$env:UserName\Desktop\AutoDows\AutoUpdater.ps1' -Verb RunAs"
