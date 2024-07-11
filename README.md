# AutoDows - WIP

Personal Script Collection for Auto Update, Auto Setup and Auto Install SAW Theme on a fresh Windows 10 or 11 install.

# Disclaimer

Yes, this code is ugly, I'm not a dev. I'm just tired to repeat the step at each fresh installation.

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

### What it does?

Apply a SAW Theme to your Windows 10 or 11 system.

### How?

Refere to the repository README.
