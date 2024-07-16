# AutoDows - WIP

**NOTE : This is in Work In Progress, yes there is a Release because it should work as intended on Windows 10 or 11, bug may be possible, open an issue if needed.**

"Personal" Script Collection for Auto Update, Auto Setup and Auto Install SAW Theme on a fresh Windows 10 or 11 install.

# Disclaimer

Yes, this code is ugly, I'm not a dev. I'm just tired to repeat the step at each fresh installation.

# Installation

You can use the EasyInstall way, run the PowerShell command bellow, AutoDows will be Downloaded and Extracted on Desktop, then AutoUpdater.ps1 will automatically be run. It will ask user if AutoSetup and SawTheme need to be run at the end of Updates installation. If you need to run a specific script (SawTheme.ps1 as example), I suggest to download the release and run the specific script instead.

```
(New-Object System.Net.WebClient).DownloadString("https://raw.githubusercontent.com/V0lk3n/AutoDows/main/setup.bat") | iex
```

Or you can Download the Release zip file, extract it, and run it manually.

# Documentation

## AutoUpdate.ps1

### What it does?

- Use PSWindowsUpdate Module to apply Windows Updates.
- Use CIM to apply Microsoft Store Updates.
- Auto Reboot and repeat the process until no more updates are found.

### How?

There is 3 main phase, which are setup, updates, clean up. Finally an optional phase.

Setup :
- It ensure the code run as Administrator.
- It ensure that the user had a password, else prompt user to specifiy one.
- Disable Auto Updates from Windows Updates to avoid conflict.
- Disable QuickEdit and InserMode from powershell to avoid pause bug.
- Install Nuget and PSWindowsUpdate module.
- Check if the os run Win11 or Win10, if Win10 is found set target release to 22H2.
- Check if AutoLogon is enabled, if not it use AutoLogon from Sysinternals to setup Autologon. To allow the Auto Reboot feature.
- Schedule a task to run the script for updates installation at each logon.
- Reboot

Updates :
- Once rebooted, auto loggin happen, the scheduled task is triggered.
- It look if the os is Win11 or Win10, if it's Win10, it will look for KB5034441 and hide this update to avoid problem. If the update is already hidden, it continue to next step.
- It look for Microsoft Store App Updates and install these.
- It Download and Install Microsoft Windows Update Updates.
- Updates are logged inside logs directory in the script folder.
- If an error is detected, it will try to reset Windows Update Components.
- If error percist it will reboot.

Clean Up :
- Bring back Auto Updates from Windows Updates
- Bring Back QuickEdit and InsertMode in powershell.
- Remove Scheduled Task
- Disable AutoLogon.
- Remove AutoLogon Passwords from LSA by removing registry entry, using PsExec to operate as NT Authority\System.

Optional :
- Ask to execute AutoSetup.ps1
- Ask to execute SawTheme.ps1

Once everything is done, ask for a final reboot to apply everything.

## AutoSetup.ps1

This one is more personal, I will just publish a basic version that you will be able to modify at your need. 

### What it does?

- Install various tools

### How?

The script ask if we want to install :
- Default Tools
- Special Utilities
- Social Tools
- Dev Tools
- Pentesting Tools
- Activation Tools

Once answered, it start installing each tools pack using Winget.

## SawTheme.ps1

This Script isn't include inside AutoDows, it's here because AutoUpdater ask user if Yes or No it should install it.

### What it does?

Apply a SAW Theme to your Windows 10 or 11 system.

<a href="https://github.com/V0lk3n/W11-SAWTheme/">SawTheme Repository</a>

### How?

<a href="https://github.com/V0lk3n/W11-SAWTheme/">For more information refere to SawTheme repository.</a>
