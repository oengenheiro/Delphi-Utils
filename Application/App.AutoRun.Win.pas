unit App.AutoRun.Win;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// Implements IAppAutoRun for Windows platform (Windows Registry method)

interface

uses
  App.AutoRun;

type
  TWindowsRegistryAutoStart = class(TInterfacedObject, IAppAutoRun)
  public
    function RegisterAutoStart: Boolean;
    function RemoveAutoStart: Boolean;
  end;

implementation

uses
  {$IF CompilerVersion > 21}
  Vcl.Forms,
  System.SysUtils,
  System.Win.Registry,
  Winapi.Windows;
  {$ELSE}
  Forms,
  SysUtils,
  Registry,
  Windows;
  {$IFEND}

{ TWindowsRegistryAutoStart }

function TWindowsRegistryAutoStart.RegisterAutoStart: Boolean;
var
  LKey, LValue: string;
  LReg: TRegistry;
begin
  Result := False;
  LKey := 'Software\Microsoft\Windows\CurrentVersion\Run';
  LValue := ParamStr(0) + ' -StartUp';
  LReg := TRegistry.Create;
  try
    try
      LReg.RootKey := HKEY_CURRENT_USER;
      if not LReg.OpenKey(LKey, False) then
        raise Exception.CreateFmt('Cannot open key %s', [LKey]);

      if LReg.ValueExists(Application.Title) and (LReg.GetDataAsString(Application.Title) = LValue) then
        Exit(True);

      LReg.WriteString(Application.Title, LValue);
      Result := True;
    finally
      LReg.Free;
    end;
  except
    Result := False;
  end;
end;

function TWindowsRegistryAutoStart.RemoveAutoStart: Boolean;
var
  LKey: string;
  LReg: TRegistry;
begin
  Result := False;
  LKey := 'Software\Microsoft\Windows\CurrentVersion\Run';
  LReg := TRegistry.Create;
  try
    try
      LReg.RootKey := HKEY_CURRENT_USER;
      if not LReg.OpenKey(LKey, False) then
        raise Exception.CreateFmt('Cannot open key %s', [LKey]);

      if LReg.ValueExists(Application.Title) then
      begin
        LReg.DeleteValue(Application.Title);
        Exit(True);
      end;

      Result := False;
    finally
      LReg.Free;
    end;
  except
    Result := False;
  end;
end;

end.
