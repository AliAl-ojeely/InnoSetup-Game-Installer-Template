# Advanced Inno Setup Game Installer Script

This is a generic, feature-rich Inno Setup script template originally designed for large game repacks. It includes advanced features like a decimal progress bar, elapsed/remaining time calculation, and automatic administrative rights handling.

## Features

* **Decimal Progress Bar:** Displays installation progress with decimal precision (e.g., `55.4%`).
* **Time Estimation:** Shows "Elapsed Time" and estimated "Remaining Time" under the progress bar.
* **Auto-Admin Rights:** Automatically flags the game executable to run as Administrator in the Windows Registry.
* **Installation Log:** Generates a detailed text log of the installation details.
* **Generic Configuration:** Easily customizable via a single configuration block at the top of the script.

## Installer Wizard Steps

The installer is configured to provide a standard, professional **8-step** experience:

1.  **Welcome Page:** Introduction.
2.  **License Agreement:** Displays the contents of `license.txt`.
3.  **Select Destination:** Allows the user to choose the install folder.
4.  **Select Start Menu Folder:** Allows customizing the Start Menu group name.
5.  **Select Additional Tasks:** Checkboxes for Desktop and Quick Launch icons.
6.  **Ready to Install:** Summary of settings before copying files.
7.  **Installing:** The custom page featuring the **Decimal Progress** and **Time Estimation**.
8.  **Finished:** Final success message.

## Single File vs. Multi-Part Installer

By default, this script generates a **single `.exe` file** containing the entire game.

**For large games (e.g., >4GB):**
If you want to split the installer into multiple parts (`setup.exe`, `setup-1.bin`, `setup-2.bin`...), simply uncomment the **Disk Spanning** section in the script:

```iss
; Remove the semicolon (;) from these lines in the script:
DiskSpanning=yes
SlicesPerDisk=1
DiskSliceSize=4294967296
```
## Required Folder Structure
To use this script without modifying the code, organize your project folder like this:

```iss
MyProject/
├── setup_script.iss         <-- This script
├── Build/                   <-- Put all your game files here
│   ├── Game.exe
│   └── ...
└── Assets/                  <-- Put installer images here
    ├── icon.ico
    ├── background.bmp       (Wizard Image)
    ├── smallbackground.bmp  (Small Wizard Image)
    └── license.txt

```

## How to Customize
Open the script in Inno Setup Compiler.

Edit the USER CONFIGURATION section at the very top:

Delphi

#define MyAppName "My Awesome Game"
#define MyAppVersion "1.5"
#define MyAppPublisher "My Studio"
#define MyAppURL "[https://mystudio.com](https://mystudio.com)"
#define MyAppExeName "GameLauncher.exe"
Crucial: Generate a new unique ID for your app. In Inno Setup, go to Tools -> Generate GUID, and paste it into the #define MyAppId line.

License
Free to use for any purpose.