# AutoSetup.ps1
# Used to Automate Tools installation and actiavtion.
# Used as first optional step in AutoUpdater.ps1

# Why do you existe? Need to find why before using it.
# Windows Configuration Designer
#Write-Host "[+] Installing Windows Configuration Designer" -ForegroundColor Yellow
#winget install --silent "Windows Configuration Designer" --accept-source-agreements --accept-package-agreements | Out-Null
#Write-Host "[+] Windows Configuration Designer has been installed!`n`n" -ForegroundColor Green

function default-tools {
    # Firefox
    Write-Host "[+] Installing Firefox..." -ForegroundColor Yellow
    winget install -e --silent --id Mozilla.Firefox --accept-source-agreements --accept-package-agreements | Out-Null
    Write-Host "[-] Firefox has been installed!`n`n" -ForegroundColor Green

    # Install Microsoft 365 Office (Entreprise)
    Write-Host "[+] Installing Microsoft365 Entreprise..." -ForegroundColor Yellow
    winget install -e --id=Microsoft.Office --accept-source-agreements --accept-package-agreements | Out-Null
    Write-Host "[-] Microsoft365 Entreprise has been installed!`n`n" -ForegroundColor Green

    # Install Windows Scan from MSStore
    Write-Host "[+] Installing Windows Scan" -ForegroundColor Yellow
    #winget search "Windows Scan" --source=msstore
    winget install -e --silent --id=9WZDNCRFJ3PV --accept-source-agreements --accept-package-agreements | Out-Null
    Write-Host "[-] Windows Scan has been installed!`n`n" -ForegroundColor Green
}

function special-utilities {
    # Obsidian
    Write-Host "[+] Installing Obsidian..." -ForegroundColor Yellow
    winget install -e --silent --id Obsidian.Obsidian --accept-source-agreements --accept-package-agreements | Out-Null
    Write-Host "[-] Obsidian has been installed!`n`n" -ForegroundColor Green

    # Install VmWare from setup.exe befcause of stupid broadcom shit
    Write-Host "[+] Installing VmWare Workstation Pro..." -ForegroundColor Yellow
    winget install -e --silent --id VMware.WorkstationPro --accept-source-agreements --accept-package-agreements | Out-Null
    Write-Host "[-] VmWare Workstation Pro has been instaleld!`n`n" -ForegroundColor Green
}

function social-tools {
    # Telegram
    Write-Host "[+] Installing Telegram..." -ForegroundColor Yellow
    winget install -e --silent --id Telegram.TelegramDesktop --accept-source-agreements --accept-package-agreements | Out-Null
    Write-Host "[-] Telegram has been installed!`n`n" -ForegroundColor Green

    # Discord
    Write-Host "[+] Installing Discord..." -ForegroundColor Yellow
    winget install -e --silent --id Discord.Discord --accept-source-agreements --accept-package-agreements | Out-Null
    Write-Host "[-] Discord has been installed!`n" -ForegroundColor Green
}

function dev-tools {
    # Install Visual Studio Code
    Write-Host "[+] Installing Visual Studio Code..." -ForegroundColor Yellow
    winget install -e --silent --id Microsoft.VisualStudioCode --accept-source-agreements --accept-package-agreements | Out-Null
    Write-Host "[-] VisualStudioCode has been installed!`n`n" -ForegroundColor Green

    # Install Visual Studio Community 2022
    Write-Host "[+] Installing VisualStudio 2022 Community Edition..." -ForegroundColor Yellow
    winget install -e --silent --id=Microsoft.VisualStudio.2022.Community --accept-source-agreements --accept-package-agreements | Out-Null
    Write-Host "[-] VisualStudio 2022 Community Edition has been installed!`n`n" -ForegroundColor Green

    # Install .NET SDK 8
    Write-Host "[+] Installing .NET DotNet SDK 8..." -ForegroundColor Yellow
    winget install --silent Microsoft.DotNet.SDK.8 --accept-source-agreements --accept-package-agreements | Out-Null
    Write-Host "[-] .NET DotNet SDK 8 has been installed!`n`n" -ForegroundColor Green
}

function pentesting-tools {
    # TODO
    Write-Host "[+] Nothing to see here yet!" -ForegroundColor Yellow
}

function activation-tools {
    # Run M.A.S
    Write-Host "`n`n[+] Starting M.A.S Microsoft Activation Script..." -ForegroundColor Yellow
    Write-Host "[+] Manual Configuration Needed!" -ForegroundColor Yellow
    irm https://get.activated.win | iex
    Write-Host "[-] System Activated!`n`n" -ForegroundColor Green
}

function cleaning {
    # Discord - Disable from startup
    Write-Host "[+] Removing Discord from Startup App..." -ForegroundColor Yellow
    # Define the name of the startup program to disable
    $programName = "Discord"
    # Remove the program from the HKCU Run key (Current User)
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name $programName -ErrorAction SilentlyContinue
    # Remove the program from the HKLM Run key (Local Machine)
    Remove-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -Name $programName -ErrorAction SilentlyContinue
    Write-Host "[-] Startup program '$programName' disabled successfully." -ForegroundColor Green
    # Remove Startup Shortcut
    Remove-Item -Path "C:\Users\V0lk3n\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Discord Inc\Discord.lnk"
    Write-Host "[-] Startup Shortcut Removed.`n`n" -ForegroundColor Green
}

# Main
# Starting Up
Write-Host "`n======Setup Installation Taks======`n" -ForegroundColor Blue

# What to install
while ($true) {
    $runDefaultTools = Read-Host "`nDo you want to install Default Tools? (Y/N)"
    if ($runDefaultTools -eq "Y" -or $runDefaultTools -eq "y") {
        $installDefaultTools = $true
        break
    }
    if ($runDefaultTools -eq "N" -or $runDefaultTools -eq "n") {
        Write-Host "[-] Default Tools will not be installed" -ForegroundColor Red
        $installDefaultTools = $false
        break
    }
    else {
        Write-Host "[WARNING] Invalid input. Please press ENTER only." -ForegroundColor Red
    }
}

while ($true) {
    $runSpecialUtilities = Read-Host "`nDo you want to install Special Utilities? (Y/N)"
    if ($runSpecialUtilities -eq "Y" -or $runSpecialUtilities -eq "y") {
        $installSpecialUtilities = $true
        break
    }
    if ($runSpecialUtilities -eq "N" -or $runSpecialUtilities -eq "n") {
        Write-Host "[-] Special Utilities will not be installed" -ForegroundColor Red
        $installSpecialUtilities = $false
        break
    }
    else {
        Write-Host "[WARNING] Invalid input. Please press ENTER only." -ForegroundColor Red
    }
}

while ($true) {
    $runSocialTools = Read-Host "`nDo you want to install Social Tools? (Y/N)"
    if ($runSocialTools -eq "Y" -or $runSocialTools -eq "y") {
        $installSocialTools = $true
        break
    }
    if ($runSocialTools -eq "N" -or $runSocialTools -eq "n") {
        Write-Host "[-] Social Tools will not be installed" -ForegroundColor Red
        $installSocialTools = $false
        break
    }
    else {
        Write-Host "[WARNING] Invalid input. Please press ENTER only." -ForegroundColor Red
    }
}

while ($true) {
    $runDevTools = Read-Host "`nDo you want to install Dev Tools? (Y/N)"
    if ($runDevTools -eq "Y" -or $runDevTools -eq "y") {
        $installDevTools = $true
        break
    }
    if ($runDevTools -eq "N" -or $runDevTools -eq "n") {
        Write-Host "[-] Dev Tools will not be installed" -ForegroundColor Red
        $installDevTools = $false
        break
    }
    else {
        Write-Host "[WARNING] Invalid input. Please press ENTER only." -ForegroundColor Red
    }
}

while ($true) {
    $runPentestingTools = Read-Host "`nDo you want to install Pentesting Tools? (Y/N)"
    if ($runPentestingTools -eq "Y" -or $runPentestingTools -eq "y") {
        $installPentestingTools = $true
        break
    }
    if ($runPentestingTools -eq "N" -or $runPentestingTools -eq "n") {
        Write-Host "[-] Pentesting Tools will not be installed" -ForegroundColor Red
        $installPentestingTools = $false
        break
    }
    else {
        Write-Host "[WARNING] Invalid input. Please press ENTER only." -ForegroundColor Red
    }
}

while ($true) {
    $runActivationTools = Read-Host "`nDo you want to install Activation Tools? (Y/N)"
    if ($runActivationTools -eq "Y" -or $runActivationTools -eq "y") {
        $installActivationTools = $true
        break
    }
    if ($runActivationTools -eq "N" -or $runActivationTools -eq "n") {
        Write-Host "[-] Activation Tools will not be installed" -ForegroundColor Red
        $installActivationTools = $false
        break
    }
    else {
        Write-Host "[WARNING] Invalid input. Please press ENTER only." -ForegroundColor Red
    }
}

Write-Host "`n======Starting Tools Installations======`n" -ForegroundColor Blue

# Respect Condition
if ($installDefaultTools) {
    default-tools
}
if ($installSpecialUtilities) {
    special-utilities
}
if ($installSocialTools) {
    social-tools
}
if ($installDevTools) {
    dev-tools
}
if ($installPentestingTools) {
    pentesting-tools
}
if ($installActivationTools) {
    activation-tools
}

cleaning

# Closing Powershell Window
Write-Host "======All Installation Done!======`n`n" -ForegroundColor Blue
