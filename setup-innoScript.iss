; ======================================================
; Enhanced Game Installer Script (Generic Template)
; Based on original script by Mr.Ghost
; ======================================================

; ======================================================
; USER CONFIGURATION (EDIT THIS SECTION ONLY)
; ======================================================
#define MyAppName "My Game Title"
#define MyAppVersion "1.0"
#define MyAppPublisher "My Studio Name"
#define MyAppURL "https://www.example.com"
#define MyAppExeName "GameExecutable.exe"
; IMPORTANT: Generate a new GUID inside Inno Setup (Tools -> Generate GUID) and paste it below
#define MyAppId "{{GENERATE-YOUR-OWN-GUID-HERE}"

; Folder names relative to where this script is saved
#define MyGameFilesFolder "Build"
#define MyAssetsFolder "Assets"

[Setup]
; ========== BASIC APPLICATION INFORMATION ==========
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
VersionInfoCopyright=Copyright (C) 2025 {#MyAppPublisher}

; ========== INSTALLATION PATHS ==========
DefaultDirName={autopf}\{#MyAppName}
DefaultGroupName={#MyAppName}
AllowNoIcons=yes

; ========== OUTPUT SETTINGS ==========
OutputDir={src}\Output
; This creates a filename like: Setup_MyGameName.exe
OutputBaseFilename=Setup_{#MyAppName}

; ========== VISUAL SETTINGS ==========
SetupIconFile={src}\{#MyAssetsFolder}\icon.ico
WizardImageFile={src}\{#MyAssetsFolder}\background.bmp
WizardSmallImageFile={src}\{#MyAssetsFolder}\smallbackground.bmp
UninstallDisplayIcon={app}\{#MyAppExeName}

; ========== COMPRESSION AND SPLITTING ==========
Compression=lzma2/ultra64
SolidCompression=yes

; -------------------------------------------------------------------------
; SPLIT INSTALLER SETTINGS (Enable for games larger than 4GB)
; -------------------------------------------------------------------------
; By default, the installer is ONE single file.
; To split it into multiple parts (.bin files) like "Dead Space",
; remove the semicolon (;) from the 3 lines below:
; -------------------------------------------------------------------------
; DiskSpanning=yes
; SlicesPerDisk=1
; DiskSliceSize=4294967296
; -------------------------------------------------------------------------

; ========== PAGES & SETTINGS ==========
DisableWelcomePage=no
DisableDirPage=no
DisableProgramGroupPage=no
DisableReadyPage=no
DisableFinishedPage=no
LicenseFile={src}\{#MyAssetsFolder}\license.txt
PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=dialog

; ========== UNINSTALL ==========
UninstallDisplayName={#MyAppName}
UninstallFilesDir={app}\uninstall
CreateUninstallRegKey=yes

; ========== SYSTEM REQ ==========
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
Name: "quicklaunchicon"; Description: "Create a &Quick Launch icon"; GroupDescription: "Additional icons:"; Flags: unchecked; OnlyBelowVersion: 6.1

[Files]
; ========== MAIN GAME FILES ==========
; Copies files from the "Build" folder defined at top
Source: "{src}\{#MyGameFilesFolder}\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs ignoreversion

; ========== ICON FILE ==========
Source: "{src}\{#MyAssetsFolder}\icon.ico"; DestDir: "{app}"; DestName: "icon.ico"; Flags: ignoreversion

[Icons]
; ========== DESKTOP SHORTCUT ==========
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; WorkingDir: "{app}"; IconFilename: "{app}\{#MyAppExeName}"

; ========== START MENU SHORTCUTS ==========
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\icon.ico"; Comment: "Launch {#MyAppName}"; Tasks: startmenuicon
Name: "{group}\Uninstall {#MyAppName}"; Filename: "{uninstallexe}"; IconFilename: "{app}\icon.ico"
Name: "{group}\Visit Website"; Filename: "{#MyAppURL}"; IconFilename: "{app}\icon.ico"

; ========== QUICK LAUNCH SHORTCUT ==========
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon; IconFilename: "{app}\icon.ico"

[Registry]
; ========== ADD/REMOVE PROGRAMS ENTRIES ==========
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppId}_is1"; ValueType: string; ValueName: "DisplayName"; ValueData: "{#MyAppName}"; Flags: uninsdeletekey
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppId}_is1"; ValueType: string; ValueName: "DisplayVersion"; ValueData: "{#MyAppVersion}"
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppId}_is1"; ValueType: string; ValueName: "Publisher"; ValueData: "{#MyAppPublisher}"
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppId}_is1"; ValueType: string; ValueName: "URLInfoAbout"; ValueData: "{#MyAppURL}"
Root: HKLM; Subkey: "Software\Microsoft\Windows\CurrentVersion\Uninstall\{#MyAppId}_is1"; ValueType: string; ValueName: "HelpLink"; ValueData: "{#MyAppURL}/support"

; ========== APPLICATION SETTINGS ==========
; Uses the App Name without spaces for the registry key to be safe
Root: HKCU; Subkey: "Software\{#MyAppName}"; ValueType: string; ValueName: "InstallPath"; ValueData: "{app}"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\{#MyAppName}"; ValueType: string; ValueName: "Version"; ValueData: "{#MyAppVersion}"

[Run]
; ========== POST-INSTALLATION ==========
Filename: "{app}\{#MyAppExeName}"; Description: "Launch {#MyAppName}"; Flags: nowait postinstall runascurrentuser skipifsilent unchecked

[Code]
// ==================================================================
// PASCAL SCRIPT SECTION
// ==================================================================
var
  InstallStartTime: Integer;
  LastUpdateTime: Integer;
  TimeLabel: TNewStaticText;
  ProgressPercentLabel: TNewStaticText;

// ==================================================================
// External DLL Calls
// ==================================================================
function GetTickCount: Integer;
external 'GetTickCount@kernel32.dll stdcall';

// ==================================================================
// Time Formatting Logic
// ==================================================================
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

// ==================================================================
// Decimal Percentage Formatting
// ==================================================================
function FormatPercentage(Progress, MaxProgress: Integer): String;
var
  Percentage: Extended;
begin
  if MaxProgress > 0 then
    Percentage := (Progress * 100.0) / MaxProgress
  else
    Percentage := 0.0;

  // Ensure percentage doesn't exceed 100%
  if Percentage > 100.0 then
    Percentage := 100.0;

  // Format to one decimal place (e.g., 5.6%, 10.9%, 100.0%)
  Result := Format('%.1f%%', [Percentage]);
end;

// ==================================================================
// Progress Update Logic
// ==================================================================
procedure UpdateInstallProgress;
var
  CurrentTime: Integer;
  ElapsedSeconds: Integer;
  ProgressPercent: Extended;
  TotalSeconds: Integer;
  RemainingSeconds: Integer;
  ElapsedStr: String;
  RemainingStr: String;
  ProgressStr: String;
begin
  CurrentTime := GetTickCount div 1000;
  ElapsedSeconds := CurrentTime - InstallStartTime;
  
  // Calculate progress percentage with decimal precision
  ProgressStr := FormatPercentage(WizardForm.ProgressGauge.Position, WizardForm.ProgressGauge.Max);

  // Calculate integer percentage for time estimation
  if WizardForm.ProgressGauge.Max > 0 then
    ProgressPercent := (WizardForm.ProgressGauge.Position * 100.0) / WizardForm.ProgressGauge.Max
  else
    ProgressPercent := 0.0;

  // Ensure progress doesn't exceed 100%
  if ProgressPercent > 100.0 then
    ProgressPercent := 100.0;

  { Only update every second to avoid excessive label flickering }
  if (CurrentTime - LastUpdateTime) < 1 then
    Exit;
  
  LastUpdateTime := CurrentTime;

  { Format elapsed time }
  ElapsedStr := FormatSeconds(ElapsedSeconds);

  { Estimate remaining time based on progress }
  if ProgressPercent > 0 then
  begin
    TotalSeconds := Round((ElapsedSeconds / ProgressPercent) * 100);
    RemainingSeconds := TotalSeconds - ElapsedSeconds;
    if RemainingSeconds < 0 then
      RemainingSeconds := 0;
    RemainingStr := FormatSeconds(RemainingSeconds);
  end
  else
  begin
    RemainingStr := '--:--';
  end;

  { Update the percentage label to the right of progress bar }
  ProgressPercentLabel.Caption := ProgressStr;

  { Update the time label below the progress bar with maximum professional spacing }
  TimeLabel.Caption := 'Elapsed: ' + ElapsedStr + '                                                                  Remaining: ' + RemainingStr;
end;

// ==================================================================
// Initialize Wizard - Create Labels and Adjust Progress Bar
// ==================================================================
procedure InitializeWizard();
begin
  // Make the progress bar shorter to make room for percentage
  WizardForm.ProgressGauge.Width := WizardForm.ProgressGauge.Width - 70;

  // Create percentage label to the right of the progress bar
  ProgressPercentLabel := TNewStaticText.Create(WizardForm);
  ProgressPercentLabel.Parent := WizardForm.InstallingPage;
  ProgressPercentLabel.Left := WizardForm.ProgressGauge.Left + WizardForm.ProgressGauge.Width + 10;
  ProgressPercentLabel.Top := WizardForm.ProgressGauge.Top;
  ProgressPercentLabel.Width := 60; // Wider to accommodate decimal numbers
  ProgressPercentLabel.Height := WizardForm.ProgressGauge.Height;
  ProgressPercentLabel.Caption := '0.0%';
  ProgressPercentLabel.Font.Style := [];
  ProgressPercentLabel.Font.Size := 9;
  ProgressPercentLabel.Font.Color := clWindowText;

  // Create time label below the progress bar
  TimeLabel := TNewStaticText.Create(WizardForm);
  TimeLabel.Parent := WizardForm.InstallingPage;
  TimeLabel.Left := WizardForm.ProgressGauge.Left;
  TimeLabel.Top := WizardForm.ProgressGauge.Top + WizardForm.ProgressGauge.Height + 8;
  TimeLabel.Width := WizardForm.ProgressGauge.Width + 70; // Full width including percentage area
  TimeLabel.Height := 17;
  TimeLabel.Caption := 'Elapsed: 0:00                                                                  Remaining: --:--';
  TimeLabel.Font.Style := [];
  TimeLabel.Font.Size := 8;
  TimeLabel.Font.Color := clWindowText;
end;

// ==================================================================
// Standard Event Handlers
// ==================================================================
procedure CurInstallProgressChanged(CurProgress, MaxProgress: Integer);
begin
  { This function runs automatically while files are copying }
  UpdateInstallProgress;
end;

procedure SetRunAsAdminForExe;
var
  Key: string;
begin
  Key := 'Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers';
  // Note: Using ExpandConstant to inject the generic Exe Name defined at the top
  RegWriteStringValue(HKLM, Key, ExpandConstant('{app}\{#MyAppExeName}'), 'RUNASADMIN');
  RegWriteStringValue(HKCU, Key, ExpandConstant('{app}\{#MyAppExeName}'), 'RUNASADMIN');
end;

function NextButtonClick(CurPageID: Integer): Boolean;
var
  InstallPath: String;
begin
  Result := True;
  if CurPageID = wpSelectDir then
  begin
    InstallPath := AddBackslash(WizardDirValue);
    // Generic check for the EXE file defined at the top
    if FileExists(InstallPath + '{#MyAppExeName}') then
    begin
      if MsgBox('Game files detected in the selected directory.' + #13#10 +
                'This may indicate an existing installation. Continue anyway?' + #13#10 +
                'Warning: Existing files may be overwritten.',
                mbConfirmation, MB_YESNO) = IDNO then
        Result := False;
    end;
  end;
end;

// ==================================================================
// MAIN STEP CHANGE PROCEDURE
// ==================================================================
procedure CurStepChanged(CurStep: TSetupStep);
var
  LogContent: String;
begin
  { Initialization Logic }
  if CurStep = ssInstall then
  begin
    InstallStartTime := GetTickCount div 1000;
    LastUpdateTime := InstallStartTime;
    // Initialize labels
    ProgressPercentLabel.Caption := '0.0%';
    TimeLabel.Caption := 'Elapsed: 0:00                                                                  Remaining: --:--';
  end;
  
  { Post Install Logic }
  if CurStep = ssPostInstall then
  begin
    { Update the labels }
    ProgressPercentLabel.Caption := '100.0%';
    TimeLabel.Caption := 'Installation complete!';
    
    { Run the Admin & Log logic }
    SetRunAsAdminForExe;
    LogContent :=
      '========================================' + #13#10 +
      '{#MyAppName} Installation Log' + #13#10 +
      '========================================' + #13#10 +
      'Installation Date: ' + GetDateTimeString('yyyy/mm/dd hh:nn:ss', '-', ':') + #13#10 +
      'Installation Path: ' + ExpandConstant('{app}') + #13#10 +
      'Version: {#MyAppVersion}' + #13#10 +
      'Admin Rights: Enabled' + #13#10 +
      'User: ' + GetUserNameString + #13#10 +
      'Computer: ' + GetComputerNameString + #13#10 +
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
  if CurUninstallStep = usUninstall then
  begin
   Key := 'Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers';
   // Generic cleanup based on variable
    RegDeleteValue(HKLM, Key, ExpandConstant('{app}\{#MyAppExeName}'));
    RegDeleteValue(HKCU, Key, ExpandConstant('{app}\{#MyAppExeName}'));
  end;
end;

[UninstallDelete]
Type: filesandordirs; Name: "{app}"