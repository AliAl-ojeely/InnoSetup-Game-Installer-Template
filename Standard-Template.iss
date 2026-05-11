; ==============================================================================
; Advanced Inno Setup Game Installer Template
; Features: Custom Progress Bar, Time Estimation, Split Files (.bin), Auto-Admin
; ==============================================================================

; ==============================================================================
; 1. USER CONFIGURATION (Edit this section before compiling)
; ==============================================================================

; [REQUIRED CHANGE] Basic Game Information
#define MyAppName "Games Name"
#define MyAppVersion "1.0"
#define MyAppPublisher "Mr.Ghost"
#define MyAppURL "https://www.MrGhost-Repack.com"

; [REQUIRED CHANGE] The main executable file of your game (e.g., Game.exe)
#define MyAppExeName "The Main EXE File of the Game" 

; [REQUIRED CHANGE] Generate a new GUID inside Inno Setup (Tools -> Generate GUID)
; Do NOT use the default one below for your final release!
#define MyAppId "{{EAFC25D4-E5F6-7890-1234-56789ABCDEF0}"

; [REQUIRED CHANGE] Paths & Folders
; Set the exact path where your game files and assets are located on your PC.
#define MyGameFilesDir "Game's File Path"
#define MyAssetsDir "Your Assets Path (Background Image for the Installer, License File ...etc)"

; ==============================================================================
; 2. MAIN SETUP SETTINGS
; ==============================================================================
[Setup]
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}/support
AppUpdatesURL={#MyAppURL}/update
AppId={#MyAppId}
VersionInfoVersion={#MyAppVersion}
VersionInfoCompany={#MyAppPublisher}
VersionInfoDescription={#MyAppName} Installer
VersionInfoCopyright=Copyright (C) 2026 {#MyAppPublisher}

; Default Installation Directory (Program Files)
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes

; [OPTIONAL CHANGE] Output Settings
; OutputDir is where the final setup.exe and .bin files will be saved.
OutputDir={#MyAssetsDir}\Installer Output
; OutputBaseFilename defines the name of your installer (e.g., setup.exe, setup-1.bin)
OutputBaseFilename=setup

; Visual Settings (Reads from the Assets Directory defined above)
SetupIconFile={#MyAssetsDir}\icon.ico
WizardImageFile={#MyAssetsDir}\background.bmp
WizardSmallImageFile={#MyAssetsDir}\smallbackground.bmp
UninstallDisplayIcon={app}\{#MyAppExeName}

; Compression Settings (LZMA2 Ultra64 for best compression ratio)
Compression=lzma2/ultra64
SolidCompression=yes

; ------------------------------------------------------------------------------
; [OPTIONAL CHANGE] SPLIT INSTALLER SETTINGS (For Large Games)
; ------------------------------------------------------------------------------
; DiskSpanning=yes allows the installer to be split into multiple .bin files.
DiskSpanning=yes
SlicesPerDisk=1
; DiskSliceSize sets the size of each .bin file in bytes. 
; 4294967296 = 4GB per file. Change this if you want smaller or larger parts.
DiskSliceSize=4294967296

; Pages & Settings
DisableWelcomePage=no
DisableDirPage=no
DisableProgramGroupPage=no
DisableReadyPage=no
DisableFinishedPage=no
LicenseFile={#MyAssetsDir}\license.txt
PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=dialog

; Uninstall Settings
UninstallDisplayName={#MyAppName}
UninstallFilesDir={app}\uninstall
CreateUninstallRegKey=yes
MinVersion=6.1sp1

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Messages]
WelcomeLabel1=Welcome to the {#MyAppName} Setup Wizard
WelcomeLabel2=This setup will install {#MyAppName} on your computer.%n%nPlease close other applications before continuing.%n%nClick Next to continue.
FinishedHeadingLabel=Installation Complete!
FinishedLabel={#MyAppName} has been successfully installed.%n%nClick Finish to start the game.

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop shortcut"; GroupDescription: "Additional icons:"
Name: "startmenuicon"; Description: "Add shortcut to &Start Menu"; GroupDescription: "Additional icons:"

[Files]
; ========== MAIN GAME FILES ==========
; Copies all contents from your game folder to the installation directory.
Source: "{#MyGameFilesDir}\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs ignoreversion

; ========== ICON FILE ==========
Source: "{#MyAssetsDir}\icon.ico"; DestDir: "{app}"; DestName: "icon.ico"; Flags: ignoreversion

[Icons]
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"; IconFilename: "{app}\{#MyAppExeName}"
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\icon.ico"; Comment: "Launch {#MyAppName}"; Tasks: startmenuicon
Name: "{group}\Uninstall {#MyAppName}"; Filename: "{uninstallexe}"; IconFilename: "{app}\icon.ico"

[Registry]
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppId}_is1"; ValueType: string; ValueName: "DisplayName"; ValueData: "{#MyAppName}"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppId}_is1"; ValueType: string; ValueName: "DisplayVersion"; ValueData: "{#MyAppVersion}"
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppId}_is1"; ValueType: string; ValueName: "Publisher"; ValueData: "{#MyAppPublisher}"
Root: HKCU; Subkey: "Software\{#MyAppName}"; ValueType: string; ValueName: "InstallPath"; ValueData: "{app}"; Flags: uninsdeletekey

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "Launch {#MyAppName}"; Flags: nowait postinstall runascurrentuser skipifsilent unchecked

[Code]
// ==================================================================
// PASCAL SCRIPT SECTION: Custom UI, Progress Bar, and Admin Rights
// Do not modify below unless you know what you are doing.
// ==================================================================
var
  InstallStartTime: Integer;
  LastUpdateTime: Integer;
  TimeLabel: TNewStaticText;
  ProgressPercentLabel: TNewStaticText;

function GetTickCount: Integer;
external 'GetTickCount@kernel32.dll stdcall';

function FormatSeconds(Seconds: Integer): String;
var
  Hours, Minutes, Secs: Integer;
begin
  Hours := Seconds div 3600;
  Minutes := (Seconds mod 3600) div 60;
  Secs := Seconds mod 60;
  if Hours > 0 then
    Result := Format('%d:%s:%s', [Hours, Format('%.2d', [Minutes]), Format('%.2d', [Secs])])
  else
    Result := Format('%d:%s', [Minutes, Format('%.2d', [Secs])]);
end;

function FormatPercentage(Progress, MaxProgress: Integer): String;
var
  Percentage: Extended;
begin
  if MaxProgress > 0 then
    Percentage := (Progress * 100.0) / MaxProgress
  else
    Percentage := 0.0;
  if Percentage > 100.0 then Percentage := 100.0;
  Result := Format('%.1f%%', [Percentage]);
end;

procedure UpdateInstallProgress;
var
  CurrentTime, ElapsedSeconds, TotalSeconds, RemainingSeconds: Integer;
  ProgressPercent: Extended;
  ElapsedStr, RemainingStr, ProgressStr: String;
begin
  CurrentTime := GetTickCount div 1000;
  ElapsedSeconds := CurrentTime - InstallStartTime;
  ProgressStr := FormatPercentage(WizardForm.ProgressGauge.Position, WizardForm.ProgressGauge.Max);

  if WizardForm.ProgressGauge.Max > 0 then
    ProgressPercent := (WizardForm.ProgressGauge.Position * 100.0) / WizardForm.ProgressGauge.Max
  else ProgressPercent := 0.0;

  if ProgressPercent > 100.0 then ProgressPercent := 100.0;
  if (CurrentTime - LastUpdateTime) < 1 then Exit;
  LastUpdateTime := CurrentTime;

  ElapsedStr := FormatSeconds(ElapsedSeconds);

  if ProgressPercent > 0 then begin
    TotalSeconds := Round((ElapsedSeconds / ProgressPercent) * 100);
    RemainingSeconds := TotalSeconds - ElapsedSeconds;
    if RemainingSeconds < 0 then RemainingSeconds := 0;
    RemainingStr := FormatSeconds(RemainingSeconds);
  end else begin
    RemainingStr := '--:--';
  end;

  ProgressPercentLabel.Caption := ProgressStr;
  TimeLabel.Caption := 'Elapsed: ' + ElapsedStr + '                                                               Remaining: ' + RemainingStr;
end;

procedure InitializeWizard();
begin
  WizardForm.ProgressGauge.Width := WizardForm.ProgressGauge.Width - 70;

  ProgressPercentLabel := TNewStaticText.Create(WizardForm);
  ProgressPercentLabel.Parent := WizardForm.InstallingPage;
  ProgressPercentLabel.Left := WizardForm.ProgressGauge.Left + WizardForm.ProgressGauge.Width + 10;
  ProgressPercentLabel.Top := WizardForm.ProgressGauge.Top;
  ProgressPercentLabel.Width := 60; 
  ProgressPercentLabel.Height := WizardForm.ProgressGauge.Height;
  ProgressPercentLabel.Caption := '0.0%';
  ProgressPercentLabel.Font.Style := [];
  ProgressPercentLabel.Font.Size := 9;
  ProgressPercentLabel.Font.Color := clWindowText;

  TimeLabel := TNewStaticText.Create(WizardForm);
  TimeLabel.Parent := WizardForm.InstallingPage;
  TimeLabel.Left := WizardForm.ProgressGauge.Left;
  TimeLabel.Top := WizardForm.ProgressGauge.Top + WizardForm.ProgressGauge.Height + 8;
  TimeLabel.Width := WizardForm.ProgressGauge.Width + 70; 
  TimeLabel.Height := 17;
  TimeLabel.Caption := 'Elapsed: 0:00                                                               Remaining: --:--';
  TimeLabel.Font.Style := [];
  TimeLabel.Font.Size := 8;
  TimeLabel.Font.Color := clWindowText;
end;

procedure CurInstallProgressChanged(CurProgress, MaxProgress: Integer);
begin
  UpdateInstallProgress;
end;

procedure SetRunAsAdminForExe;
var
  Key: string;
begin
  Key := 'Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers';
  RegWriteStringValue(HKLM, Key, ExpandConstant('{app}\{#MyAppExeName}'), 'RUNASADMIN');
  RegWriteStringValue(HKCU, Key, ExpandConstant('{app}\{#MyAppExeName}'), 'RUNASADMIN');
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  InstallPath: String;
begin
  Result := True;
  if CurPageID = wpSelectDir then begin
    InstallPath := AddBackslash(WizardDirValue);
    if FileExists(InstallPath + '{#MyAppExeName}') then begin
      if MsgBox('Game files detected in the selected directory.' + #13#10 +
                'This may indicate an existing installation. Continue anyway?' + #13#10 +
                'Warning: Existing files may be overwritten.',
                mbConfirmation, MB_YESNO) = IDNO then Result := False;
    end;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  LogContent: String;
begin
  if CurStep = ssInstall then begin
    InstallStartTime := GetTickCount div 1000;
    LastUpdateTime := InstallStartTime;
    ProgressPercentLabel.Caption := '0.0%';
    TimeLabel.Caption := 'Elapsed: 0:00                                                               Remaining: --:--';
  end;
  
  if CurStep = ssPostInstall then begin
    ProgressPercentLabel.Caption := '100.0%';
    TimeLabel.Caption := 'Installation complete!';
    SetRunAsAdminForExe;
    LogContent :=
      '========================================' + #13#10 +
      '{#MyAppName} Installation Log' + #13#10 +
      '========================================' + #13#10 +
      'Installation Date: ' + GetDateTimeString('yyyy/mm/dd hh:nn:ss', '-', ':') + #13#10 +
      'Installation Path: ' + ExpandConstant('{app}') + #13#10 +
      'Version: {#MyAppVersion}' + #13#10 +
      '========================================' + #13#10;
    SaveStringToFile(ExpandConstant('{app}\install.log'), LogContent, False);
  end;
end;

function InitializeUninstall(): Boolean;
begin
  Result := True;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  Key: string;
begin
  if CurUninstallStep = usUninstall then begin
   Key := 'Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers';
    RegDeleteValue(HKLM, Key, ExpandConstant('{app}\{#MyAppExeName}'));
    RegDeleteValue(HKCU, Key, ExpandConstant('{app}\{#MyAppExeName}'));
  end;
end;

[UninstallDelete]
Type: filesandordirs; Name: "{app}"
