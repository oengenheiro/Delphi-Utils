unit App.SingleInstance.Win;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// Implements IAppSingleInstance (See App.SingleInstance) for Windows Platform
// Uses a mutex with a GUID to identify the application

interface

uses
  App.SingleInstance;

type
  TWindowsAppSingleInstanceMutex = class(TInterfacedObject, IAppSingleInstance)
  strict private
    FMutex: Cardinal;
  private
    procedure Finalize;
  public
    procedure Initialize;
    destructor Destroy; override;
  end;

implementation

uses
  {$IF CompilerVersion > 21}
  Winapi.Windows,
  System.SysUtils,
  Vcl.Forms,
  {$ELSE}
  Windows,
  SysUtils,
  Forms,
  {$IFEND}
  Vcl.CustomDialogs;

resourcestring
  MutexPrefix = '{7B33F22E-DDE1-45AE-BD69-CE53C4AB38E9}';

{ TWindowsAppSingleInstanceMutex }

procedure TWindowsAppSingleInstanceMutex.Initialize;
begin
  FMutex := CreateMutex(NIL, True, PWChar(Format('%s.mutex', [MutexPrefix])));
  if (FMutex = 0) or (GetLastError = ERROR_ALREADY_EXISTS) then
  begin
    WarningMsgFmt('%s ya se encuentra en ejecución!', [Application.Title]);
    FMutex := 0;
    Halt(ERROR_ALREADY_EXISTS);
  end;
end;

destructor TWindowsAppSingleInstanceMutex.Destroy;
begin
  Finalize;
  inherited Destroy;
end;

procedure TWindowsAppSingleInstanceMutex.Finalize;
begin
  if FMutex <> 0 then
  begin
    CloseHandle(FMutex);
    FMutex := 0;
  end;
end;

end.
