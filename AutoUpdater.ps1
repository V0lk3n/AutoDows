# AutoUpdate - Windows Update
# Using PSWindowsUpdate Module

param (
    [switch]$Install
)

$asciiART = @"








.=========================================================================================================.
||                                                                                                       ||
||   _       _--""--_   AutoUpdater.ps1                                                                  ||
||     " --""   |    |  - Auto Windows Updater using PSWindowsUpdate Module                              ||
||   " . _|     |    |  - Auto Microsoft Store Package Updater using Cim                                 ||
||   _    |  _--""--_|                                                                                   ||
||     " --""   |    |  Optional :                                                                       ||
||   " . _|     |    |  - Run AutoSetup.ps1 to install various tools                                     ||
||   _    |  _--""--_|  - Run saw-theme.ps1 to setup SAW Theme for Windows 11                            ||
||     " --""                                                                                            ||
||                        Made by V0lk3n                               https://v0lk3n.github.com         ||
'========================================================================================================='

ASCII Art from : https://ascii.co.uk/art/microsoft (Edited)

"@

###### Basic Start 
function Ensure-Administrator {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "[+] Not running as Administrator. Please run the script again inside a Administrator Powershell session..." -ForegroundColor Red
        Exit
    }
}

###### Setup Script
function Check-Password{
    Write-Host "[+] Check if Password is Blank..." -ForegroundColor Yellow
    Add-Type -AssemblyName System.DirectoryServices.AccountManagement
    $PrincipalContext = New-Object System.DirectoryServices.AccountManagement.PrincipalContext('Machine')

    Get-LocalUser | Where-Object Enabled -eq $true | ForEach-Object {
    
        Try{
            $myUsername = $_.Name
            $myPasswordIsBlank = $PrincipalContext.ValidateCRedentials($myUserName, $null)
     
            if ($myPasswordIsBlank) {
        
            }
            else {
                Write-Host "[-] User had Password set!" -ForegroundColor Green
            }
        }
        Catch {
            Write-Host "[-] $($myUsername)'s Password is blank!`n" -ForegroundColor Red
            Write-Host "[+] Please Setup a Password!" -ForegroundColor Yellow
            $Password = Read-Host "Enter the new password" -AsSecureString

            $UserAccount = Get-LocalUser -Name $myUsername
            $UserAccount | Set-LocalUser -Password $Password
            Write-Host "[-] $($myUsername)'s Password Set!" -ForegroundColor Green
        }
   
    }
}

function Disable-AutoUpdate {
    # To avoid Update Conflict
    Write-Host "`n[+] Disabling Windows Auto Update..." -ForegroundColor Yellow
    if (-not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -PathType Container)) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name WindowsUpdate | Out-Null
    }
    if (-not (Test-Path -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -PathType Container)) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name AU | Out-Null
    }    
    $wuauRegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
    if (-not (Get-ItemProperty -Path $wuauRegPath -Name 'NoAutoUpdate' -ErrorAction SilentlyContinue)) {
        New-ItemProperty -Path $wuauRegPath -Name NoAutoUpdate -PropertyType DWord -Value 00000001 -Force | Out-Null
    }
    else {
        Set-ItemProperty -Path $wuauRegPath -Name NoAutoUpdate -PropertyType DWord -Value 00000001 -Force | Out-Null
    }
    # MOOOOOOOOOOOOOOOOOOOOORE
    $pause = (Get-Date).AddDays(1)
    $pause = $pause.ToUniversalTime().ToString("yyyy-MM-dd-THH:mm:ssZ")
    if (Test-Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings') {
        if (-not (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseUpdatesExpiryTime' -ErrorAction SilentlyContinue)) {
            New-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseUpdatesExpiryTime' -Value $pause | Out-Null
        }
        else {
            Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseUpdatesExpiryTime' -Value $pause | Out-Null
        }
    }
    Write-Host "[-] Windows Auto Update Disabled!" -ForegroundColor Green
}

function Disable-EditMode {
    # To avoid pausing script
    Write-Host "`n[+] Disabling QuickEdit and Insert Mode..." -ForegroundColor Yellow
    $consoleRegistryPath = "HKCU:\Console"
    if (Test-Path $consoleRegistryPath) {
        if (-not (Get-ItemProperty -Path $consoleRegistryPath -Name 'InsertMode' -ErrorAction SilentlyContinue)) {
            Write-Host "`n[-] InsertMode Not found in registry, no change." -ForegroundColor Green
        }
        else {
            Set-ItemProperty -Path $consoleRegistryPath -Name "InsertMode" -Value 0 | Out-Null
            Write-Host "[-] InsertMode Disabled!" -ForegroundColor Green
        }
        if (-not (Get-ItemProperty -Path $consoleRegistryPath -Name 'QuickEdit' -ErrorAction SilentlyContinue)) {
            Write-Host "`n[-] QuickEdit Not found in registry, no change." -ForegroundColor Green
        }
        else {
            Set-ItemProperty -Path $consoleRegistryPath -Name "QuickEdit" -Value 0 | Out-Null
            Write-Host "[-] QuickEdit Disabled!" -ForegroundColor Green
        }
        if (-not (Get-ItemProperty -Path $consoleRegistryPath\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe -Name 'QuickEdit' -ErrorAction SilentlyContinue)) {
            Write-Host "`n[-] QuickEdit for System32 Not found in registry, no change." -ForegroundColor Green
        }
        else {
            Set-ItemProperty -Path $consoleRegistryPath\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe -Name "QuickEdit" -Value 0 | Out-Null
            Write-Host "[-] QuickEdit for System32 Disabled!" -ForegroundColor Green
        }
        if (-not (Get-ItemProperty -Path $consoleRegistryPath\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe -Name 'QuickEdit' -ErrorAction SilentlyContinue)) {
            Write-Host "`n[-] QuickEdit for SysWOW64 Not found in registry, no change." -ForegroundColor Green
        }
        else {
            Set-ItemProperty -Path $consoleRegistryPath\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe -Name "QuickEdit" -Value 0 | Out-Null
            Write-Host "[-] QuickEdit for SysWOW64 Disabled!" -ForegroundColor Green
        }
    }
}

function Install-Nuget {
    if (-not (Get-PackageProvider -Name NuGet)) {
        Write-Host "`n[+] Installing Nuget`n" -ForegroundColor Yellow
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.208 -Scope CurrentUser -Force
    }
}

function Install-PSWindowsUpdate {
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Write-Host "`n[+] Module PSWindowsUpdate not found, installing..." -ForegroundColor Yellow
        Install-Module -Name PSWindowsUpdate -Force
        Write-Host "[-] PSWindowsUpdate Module Installed!" -ForegroundColor Green
    }
}

function Check-WinName {
    Write-Host "`n[+] Checking OS Name" -ForegroundColor Yellow
    $winosname = (Get-WMIObject win32_operatingsystem).name
    $osname = $winosname.Split('|')[0]
    if ($winosname -match "Microsoft Windows 11") {
        Write-Host "[-] Your are running : $osname" -ForegroundColor Green
    }
    if ($winosname -match "Microsoft Windows 10") {
        Write-Host "[-] You are running : $osname" -ForegroundColor Green
        # If Windows 10 : Set Target Release Version to 22H2
        Import-Module PSWindowsUpdate
        Write-Host "`n[+] Setting Win 10 Target Release Version to 22H2..." -ForegroundColor Yellow
        Set-WUSettings -TargetReleaseVersion -TargetReleaseVersionInfo 22H2 -ProductVersion "Windows 10" -Confirm:$false | Out-Null
        Write-Host "[-] Windows 10 Target Release Version set to 22H2!" -ForegroundColor Green
    }
}

function Check-AutoLogon {
    $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    $regValueName = "AutoAdminLogon"
    
    if (-not (Test-Path -Path $regPath -PathType Container) -or
        -not (Test-Path -Path "$regPath\$regValueName") -or
        (Get-ItemProperty -Path $regPath -Name $regValueName).$regValueName -ne "1") {
        Enable-AutoLogon
    }
}

function Enable-AutoLogon {
    Write-Host "`n[+] Setting Up Autologon from Sysinternals for better security." -ForegroundColor Yellow
    Write-Host "[INFO] Stored password in LSA Memory will be removed once the script finish." -ForegroundColor Cyan
    while ($true) {
        $input = Read-Host "[WAIT] You will need to fill out the form and press 'enable' button, Ready? (Press ENTER)"
        if ($input -eq "") {
            break
        }
        else {
            Write-Host "[WARNING] Invalid input. Please press ENTER only." -ForegroundColor Red
        }
    }
    
    Write-Host `n(whoami) -ForegroundColor Red
    & "$PSScriptRoot\Autologon.exe"

    while ($true) {
        $input = Read-Host "`n[WAIT] Press ENTER once Autologon Enabled..."
        if ($input -eq "") {
            break
        }
        else {
            Write-Host "[WARNING] Invalid input. Please press ENTER only." -ForegroundColor Red
        }
    }
}

function Setup-ScheduledTask {
    Write-Host "`n[+] Scheduling AutoUpdater Task..." -ForegroundColor Yellow
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSScriptRoot\AutoUpdater.ps1`" -Install"
    $action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument $arguments
    $trigger = New-ScheduledTaskTrigger -AtLogon
    $principal = New-ScheduledTaskPrincipal -UserId $env:UserName -LogonType Interactive -RunLevel Highest
    $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -Hidden:$false
    Register-ScheduledTask -TaskName "AutoUpdater" -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force | Out-Null
    Write-Host "[-] AutoUpdater Task Scheduled!`n" -ForegroundColor Green
    Write-Host "[+] Rebooting to Start AutoUpdater Installation..." -ForegroundColor Yellow
    Start-Sleep 3
}

###### Reset Change and Clean Up
function Disable-AutoLogon {
    Write-Host "`n[+] Disabling AutoLogon..." -ForegroundColor Yellow
    while ($true) {
        $input = Read-Host "[WAIT] Disabling AutoLogon, you will need to fill out the form and press 'disable' button. Ready? (Press ENTER)"
        if ($input -eq "") {
            break
        }
        else {
            Write-Host "[WARNING] Invalid input. Please press ENTER only." -ForegroundColor Red
        }
    }
    & "$PSScriptRoot\Autologon.exe"
    while ($true) {
        $input = Read-Host "[WAIT] Press ENTER once Autologon Disabled"
        if ($input -eq "") {
            break
        }
        else {
            Write-Host "[WARNING] Invalid input. Please press ENTER only." -ForegroundColor Red
        }
    }
    Write-Host "`n[+] Removing Stored AutoLogon Credentials from LSA" -ForegroundColor Yellow
    cd $PSScriptRoot
    .\PsExec.exe -accepteula -i -s powershell.exe -c Remove-ItemProperty -path HKLM:\SECURITY\Policy\Secrets\DefaultPassword\CurrVal -Name * | Out-Null
    Write-Host "[-] Current Value Removed from LSA" -ForegroundColor Green
    .\PsExec.exe -accepteula -i -s powershell.exe -c Remove-ItemProperty -path HKLM:\SECURITY\Policy\Secrets\DefaultPassword\OldVal -Name * | Out-Null
    Write-Host "[-] Old Value Removed from LSA" -ForegroundColor Green

}

function Clean-Restore {
    Write-Host "`n======Restoring Configuration======" -ForegroundColor Cyan
    ### Call Disable-AutoLogon Function
    Disable-AutoLogon
    Write-Host "`n[+] Removing ScheduledTask..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName "AutoUpdater" -Confirm:$false
    Write-Host "[-] Scheduled Task Removed!" -ForegroundColor Green
    Write-Host "`n[+] Remove Windows Auto Update Pause..." -ForegroundColor Yellow
    if (Test-Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings') {
        if (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseUpdatesExpiryTime' -ErrorAction SilentlyContinue) {
            Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings' -Name 'PauseUpdatesExpiryTime' -Force | Out-Null
        }
    }

    if (Test-Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU') {
        if (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'NoAutoUpdate' -ErrorAction SilentlyContinue) {
            Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' -Name 'NoAutoUpdate' -Force | Out-Null
        }
    }
    Write-Host "[-] Windows Auto Update Re-Enabled!" -ForegroundColor Green
    Write-Host "`n[+] Enabling QuickEdit and Insert Mode..." -ForegroundColor Yellow
    $consoleRegistryPath = "HKCU:\Console"
    if (Test-Path $consoleRegistryPath) {
        if (Get-ItemProperty -Path $consoleRegistryPath -Name 'InsertMode' -ErrorAction SilentlyContinue) {
                Set-ItemProperty -Path $consoleRegistryPath -Name "InsertMode" -Value 1 | Out-Null
                Write-Host "[-] InsertMode Enabled!" -ForegroundColor Green
        }
        if (Get-ItemProperty -Path $consoleRegistryPath -Name 'QuickEdit' -ErrorAction SilentlyContinue) {
                Set-ItemProperty -Path $consoleRegistryPath -Name "QuickEdit" -Value 1 | Out-Null
                Write-Host "[-] QuickEdit Enabled!" -ForegroundColor Green
        }
        if (Get-ItemProperty -Path '$consoleRegistryPath\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe' -Name 'QuickEdit' -ErrorAction SilentlyContinue) {
                Set-ItemProperty -Path $consoleRegistryPath\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe -Name "QuickEdit" -Value 1 | Out-Null
                Write-Host "[-] QuickEdit for System32 Re-Enabled!" -ForegroundColor Green
        }
        if (Get-ItemProperty -Path '$consoleRegistryPath\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe' -Name 'QuickEdit' -ErrorAction SilentlyContinue) {
                Set-ItemProperty -Path $consoleRegistryPath\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe -Name "QuickEdit" -Value 1 | Out-Null
                Write-Host "[-] QuickEdit for SysWOW64 Re-Enabled!" -ForegroundColor Green
        }
    }
    Write-Host "`n======Configuration Restored======" -ForegroundColor Cyan
}

###### Optional Setup and Optional Theme
function Optional-Setup {
    Write-Host "`n======Optional Setup & Theme======" -ForegroundColor Cyan

    while ($true) {
        $runAutoSetup = Read-Host "`nDo you want to run AutoSetup.ps1? (Y/N)"
        if ($runAutoSetup -eq "Y" -or $runAutoSetup -eq "y") {
            Write-Host "`n[+] Starting AutoSetup Installation..." -ForegroundColor Yellow
            Write-Host "`n======Auto Setup Installation======" -ForegroundColor Cyan
            & "$PSScriptRoot\AutoSetup.ps1"
            break
        }
        if ($runAutoSetup -eq "N" -or $runAutoSetup -eq "n") {
            Write-Host "[-] AutoSetup will not be installed" -ForegroundColor Red
            break
        }
        else {
            Write-Host "[WARNING] Invalid input. Please press ENTER only." -ForegroundColor Red
        }
    }

    while ($true) {
        $runSawTheme = Read-Host "`nDo you want to run SawTheme.ps1? (Y/N)"
        if ($runSawTheme -eq "Y" -or $runSawTheme -eq "y") {
            Write-Host "`n[+] Setting up Saw Theme for Installation..." -ForegroundColor Yellow
            Write-Host "`n======Saw Theme Installation======" -ForegroundColor Cyan
            Write-Host "`n[+] Downloading SawTheme..." -ForegroundColor Yellow
            Start-BitsTransfer -Source https://github.com/V0lk3n/SawTheme/releases/download/Pre-Release/SawTheme.zip -Destination $PSScriptRoot\SawTheme.zip
            Write-Host "`n[+] Unzipping SawTheme..." -ForegroundColor Yellow
            $destSawTheme = "C:\Windows\Resources\Themes"
            Expand-Archive $PSScriptRoot\SawTheme.zip -DestinationPath $destSawTheme
            Write-Host "[-] Theme Content Extracted to $destSawTheme\SawTheme location!" -ForegroundColor Green
            Write-Host "`n[+] Scheduling AutoUpdater Task..." -ForegroundColor Yellow
            $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$destSawTheme\SawTheme\Setup\SawTheme.ps1`""
            $action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument $arguments
            $trigger = New-ScheduledTaskTrigger -AtLogon
            $principal = New-ScheduledTaskPrincipal -UserId $env:UserName -LogonType Interactive -RunLevel Highest
            $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -Hidden:$false
            Register-ScheduledTask -TaskName "SawThemeSetup" -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force | Out-Null
            Write-Host "[-] SawTheme Task Scheduled!" -ForegroundColor Green
            break
        }
        if ($runSawTheme -eq "N" -or $runSawTheme -eq "n") {
            Write-Host "[+] Saw Theme will not be installed" -ForegroundColor Red
            break
        }
        else {
            Write-Host "[WARNING] Invalid input. Please press ENTER only." -ForegroundColor Red
        }
    }
}

###### Microsoft Store Installation
function Install-StoreApp {
    Write-Host "`n[+] Installing Microsoft Store Updates Using Cim..." -ForegroundColor Yellow
    Get-CimInstance -Namespace "root\cimv2\mdm\dmmap" -ClassName "MDM_EnterpriseModernAppManagement_AppManagement01" | Invoke-CimMethod -MethodName UpdateScanMethod | Out-Null
    Write-Host "[-] Microsoft Store Updates Installed!" -ForegroundColor Green
}

###### Main function to Install Update and call others functions
function Main-Install {
    # Full Screen Mod
    Add-Type @"
using System;
using System.Runtime.InteropServices;
public class User32 {
[DllImport("user32.dll", SetLastError = true)]
[return: MarshalAs(UnmanagedType.Bool)]
public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
[DllImport("user32.dll", SetLastError = true)]
public static extern IntPtr GetForegroundWindow();
}
"@
    $hwnd = [User32]::GetForegroundWindow()
    [User32]::ShowWindow($hwnd, 3)  # 3 is for maximizing the window
    cls
    try {
        # Documentation Error Catch : https://www.it-connect.fr/chapitres/powershell-gerer-les-erreurs-avec-try-catch-finally
        # Import the module
        Import-Module PSWindowsUpdate
        # ASCII Art
        Write-Host $asciiART -ForegroundColor Yellow
        Write-Host "`n======Starting update installation process======" -ForegroundColor Cyan
        Write-Host "`n[+] Checking OS Name" -ForegroundColor Yellow
        $winosname = (Get-WMIObject win32_operatingsystem).name
        $osname = $winosname.Split('|')[0]
        # Check OS Name and Hide KB5034441 for Windows 10 when detected
        if ($winosname -match "Microsoft Windows 11") {
            Write-Host "[-] Your are running : $osname" -ForegroundColor Green
        }
        if ($winosname -match "Microsoft Windows 10") {
            Write-Host "[-] You are running : $osname" -ForegroundColor Green
            $lookforHiddenKB = Get-WindowsUpdate -IsHidden
            if ($lookforHiddenKB.KB -match "KB5034441") {
                Write-Host "[-] KB5034441 was already hidded!" -ForegroundColor Green
            }
            else {
                $lookforKB = Get-WindowsUpdate -MicrosoftUpdate
                if ($lookforKB.KB -match "KB5034441") {
                    Write-Host "`n[+] Windows 10 and KB5034441 Detected ! Hiding Update KB5034441..." -ForegroundColor Yellow
                    Hide-WindowsUpdate -KBArticleID KB5034441 -Confirm:$false | Out-Null
                    Write-Host "[-] Update KB5034441 has been hidded!" -ForegroundColor Green
                }
            }
        }
        # Install Microsoft App Updates
        Install-StoreApp
        # Install Microsoft WindowsUpdate Updates
        Write-Host "`n[+] Downloading Updates..." -ForegroundColor Yellow
        $pendingUpdates = Get-WindowsUpdate -MicrosoftUpdate -Download -AcceptAll | Where-Object { $_.IsInstalled -eq $false }
        if ($pendingUpdates.Count -ne 0) {
            Write-Host "[-] $($pendingUpdates.Count) Updates Downloaded!" -ForegroundColor Green
        }
        # Check if any updates are still pending after installation or Finalize Installations
        if ($pendingUpdates.Count -eq 0) {
            Write-Host "`n======All Updates are installed!======" -ForegroundColor Cyan
            # Call Clean-Restore Function
            Clean-Restore
            # Call Optional AutoSetup and SAW Theme Function
            Optional-Setup
            Write-Host "`n[+] Final Reboot..." -ForegroundColor Yellow
            while ($true) {
                 $input = Read-Host "[WAIT] Your Computer need to reboot to proceed all the change, press ENTER once ready for reboot."
                 if ($input -eq "") {
                     break
                 }
                 else {
                     Write-Host "[WARNING] Invalid input. Please press ENTER only." -ForegroundColor Red
                 }
            }
            Restart-Computer
        }
        # Installing Microsoft WindowsUpdate Updates
        else {
            Write-Host "`n[+] Installing WindowsUpdate Updates..." -ForegroundColor Yellow
            Write-Host "[-] Updates Installation will be logged to $PSScriptRoot\logs location" -ForegroundColor Green
            Write-Host "`n[INFO] Please Wait. You'r Computer will Auto Updates and Reboot until no more Updates found..." -ForegroundColor Yellow
            Get-WindowsUpdate -MicrosoftUpdate -Install -AcceptAll -AutoReboot | Out-File "$PSScriptRoot\logs\$(get-date -f yyyy-MM-dd_HH-mm)-MSUpdates.log" -Force
            Restart-Computer
        }
    }
    catch {
        if ($_.FullyQualifiedErrorId -eq 'System.ArgumentException,PSWindowsUpdate.GetWindowsUpdate' -or $_.FullyQualifiedErrorId -eq 'System.Runtime.InteropServices.COMException,PSWindowsUpdate.GetWindowsUpdate') {
            #Write-Error "`nERROR : $_.Exception.Message"
            Write-Host "`n[WARNING] Encountered Exception error. Resetting Windows Update components and retrying...`n" -ForegroundColor Red
            # Reset Windows Update Components
            Reset-WUComponents -Verbose

            # Retry Installation Proccess
            try {
                cls
                Main-Install
            }
            catch {
                #Write-Error "`n[FAIL] Failed to get Windows Updates after resetting components: `n`n$_.Exception.Message"
                Write-Host "`n[FAIL] Failed to get Windows Updates after resetting components." -ForegroundColor Red
                Write-Host "`n`n[+] Rebooting..." -ForegroundColor Yellow
                Start-Sleep 3
                Restart-Computer
            }
        }
    }
}        

# Main script logic
Ensure-Administrator
cls
# AutoUpdate Installation
if ($Install) {
    # Run Install-Update function
    Main-Install
# AutoUpdate Setup
} else {
    Write-Host $asciiART -ForegroundColor Yellow
    Write-Host "`n======Starting AutoUpdater Setup======`n" -ForegroundColor Cyan
    Check-Password
    Disable-AutoUpdate
    Disable-EditMode
    Install-Nuget
    Install-PSWindowsUpdate
    Check-WinName
    Check-AutoLogon
    Setup-ScheduledTask
    Restart-Computer
}
