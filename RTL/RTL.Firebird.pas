unit RTL.Firebird;

// Source: // Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Agustin Ortu

// Firebird related stuff

interface

function GetFirebirdPath: string;

implementation

uses
{$IF CompilerVersion > 21}
  System.SysUtils,
  System.Win.Registry,
  Winapi.Windows;
{$ELSE}
  SysUtils,
  Registry,
  Windows;
{$IFEND}

function GetFirebirdPath: string;
begin
  with TRegistry.Create do
  begin
    try
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKeyReadOnly('\Software\Firebird Project\Firebird Server\Instances') then
        Result := ReadString('DefaultInstance')
      else
        Result := EmptyStr;
    finally
      Free;
    end;
  end;
end;

end.
