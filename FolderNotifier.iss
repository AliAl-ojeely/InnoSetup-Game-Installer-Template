; ============================================================
; Folder Notifier Inno Setup Script
; ============================================================
#define MyAppName "Folder Notifier"
#define MyAppVersion "1.2"
#define MyAppPublisher "Ali Al-ojeely"
#define MyAppURL "https://github.com/AliAl-ojeely/Folder-Notifier"
#define MyAppExeName "FolderNotifier.exe"

; Generate a new GUID in Inno Setup (Tools → Generate GUID)
; Replace the placeholder below with your own generated GUID.
#define MyAppId "{8A2F3C4D-5E6F-7890-ABCD-EF1234567890}"
#define MyBuildPath "C:\Users\Mr.Ghost\source\repos\FolderNotifier\bin\Debug\net10.0-windows\publish\win-x64"

[Setup]
AppId={{#MyAppId}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
OutputDir=.
OutputBaseFilename=FolderNotifier-Setup-v1.2
Compression=lzma2/ultra64
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64
UninstallDisplayIcon={app}\{#MyAppExeName}
PrivilegesRequired=admin
MinVersion=6.1sp1

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop shortcut"; GroupDescription: "Additional icons:"

[Files]
Source: "{#MyBuildPath}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon; IconFilename: "{app}\{#MyAppExeName}"
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#MyAppExeName}"
Name: "{group}\Uninstall {#MyAppName}"; Filename: "{uninstallexe}"; IconFilename: "{app}\{#MyAppExeName}"

[Registry]
; Add "Show Folder Note" when right-clicking empty space inside a folder (Background)
Root: HKCU; Subkey: "Software\Classes\Directory\Background\shell\FolderNotifier"; ValueType: string; ValueName: ""; ValueData: "Show Folder Note"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\Directory\Background\shell\FolderNotifier"; ValueType: string; ValueName: "Icon"; ValueData: "shell32.dll,269"
Root: HKCU; Subkey: "Software\Classes\Directory\Background\shell\FolderNotifier\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" -show ""%V"""

; Add "Show Folder Note" when right-clicking a specific folder icon
Root: HKCU; Subkey: "Software\Classes\Directory\shell\FolderNotifier"; ValueType: string; ValueName: ""; ValueData: "Show Folder Note"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\Directory\shell\FolderNotifier"; ValueType: string; ValueName: "Icon"; ValueData: "shell32.dll,269"
Root: HKCU; Subkey: "Software\Classes\Directory\shell\FolderNotifier\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" -show ""%1"""

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Launch {#MyAppName}"; Flags: nowait postinstall skipifsilent
