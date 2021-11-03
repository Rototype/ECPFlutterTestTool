; -- Example2.iss --
; Same as Example1.iss, but creates its icon in the Programs folder of the
; Start Menu instead of in a subfolder, and also creates a desktop icon.

; SEE THE DOCUMENTATION FOR DETAILS ON CREATING .ISS SCRIPT FILES!

[Setup]
AppName=Rototype WebSocket Console
AppVersion=1.0.0
WizardStyle=modern
DefaultDirName={autopf}\Rototype\
DefaultGroupName=Rototype
AppPublisher=Rototype
AppPublisherURL=http://www.rototype.com/
UninstallDisplayIcon={app}\rotosocket.exe
Compression=lzma2
SolidCompression=yes
OutputDir=WebSocketConsoleSetup

[Files]
Source: "..\build\windows\runner\Release\*.*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{autoprograms}\Rototype\WebSocket Console"; Filename: "{app}\rotosocket.exe"
Name: "{autodesktop}\WebSocket Console"; Filename: "{app}\rotosocket.exe"
