; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Wonderful Toolchain"
#define MyAppVersion "1.0"
#define MyAppPublisher "Adrian Siekierka"
#define MyAppURL "https://wonderful.asie.pl/"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{DDAE3BFA-BAB5-43FC-932E-CF937D26923B}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName=C:\msys64
DefaultGroupName={#MyAppName}
DirExistsWarning=no
PrivilegesRequiredOverridesAllowed=commandline
OutputDir=C:\msys64\wf\build\bootstrap
OutputBaseFilename=wf-bootstrap-windows-x86_64
Compression=lzma
SolidCompression=yes
WizardStyle=modern
SetupIconFile="C:\msys64\wf\misc\windows\wonderful_installer.ico"
UninstallDisplayIcon={uninstallexe}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
Source: "C:\msys64\wf\build\bootstrap\windows-x86_64\*"; DestDir: "{app}\opt\wonderful"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Wonderful Toolchain Shell"; Filename: "{app}\opt\wonderful\wonderful_shell.cmd"; WorkingDir: "{app}\opt\wonderful"; IconFilename: "{app}\opt\wonderful\wonderful_shell.ico"

[UninstallDelete]
Type: filesandordirs; Name: "{app}\opt\wonderful"