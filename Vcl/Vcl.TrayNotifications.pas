unit Vcl.TrayNotifications;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// Helper class TTrayIconNotificationDisplayer, will use a given TTrayIcon to display notifications with single-line calls

interface

uses
  {$IF CompilerVersion > 21}
  Vcl.ExtCtrls;
  {$ELSE}
  ExtCtrls;
  {$IFEND}

type
  ITrayIconNotificationDisplayer = interface
    ['{9F983CC3-93ED-41C7-AA0E-8898CABE593D}']
    procedure ShowTrayNotification(const Title, Msg: string; const Kind: TBalloonFlags = bfInfo);
    procedure ShowTrayNotificationFmt(const Title, Msg: string; Params: array of const;
      const Kind: TBalloonFlags = bfInfo);
  end;

  TTrayIconNotificationDisplayer = class(TInterfacedObject, ITrayIconNotificationDisplayer)
  private
    FTrayIcon: TTrayIcon;
  public
    constructor Create(ATrayIcon: TTrayIcon);
    property TrayIcon: TTrayIcon read FTrayIcon;
    procedure ShowTrayNotification(const Title, Msg: string; const Kind: TBalloonFlags = bfInfo);
    procedure ShowTrayNotificationFmt(const Title, Msg: string; Params: array of const;
      const Kind: TBalloonFlags = bfInfo);
  end;

implementation

uses
  {$IF CompilerVersion > 21}
  System.SysUtils;
  {$ELSE}
  SysUtils;
  {$IFEND}

{ TTrayIconNotificationDisplayer }

constructor TTrayIconNotificationDisplayer.Create(ATrayIcon: TTrayIcon);
begin
  if not Assigned(ATrayIcon) then
    raise Exception.Create('TTrayIconNotificationDisplayer.Create :: Unassigned TrayIcon!');

  FTrayIcon := ATrayIcon;
end;

procedure TTrayIconNotificationDisplayer.ShowTrayNotification(const Title, Msg: string; const Kind: TBalloonFlags);
begin
  if not FTrayIcon.Visible then
    FTrayIcon.Visible := True;

  TrayIcon.BalloonTitle := Title;
  TrayIcon.BalloonHint := Msg;
  TrayIcon.BalloonFlags := Kind;
  TrayIcon.ShowBalloonHint;
end;

procedure TTrayIconNotificationDisplayer.ShowTrayNotificationFmt(const Title, Msg: string; Params: array of const;
  const Kind: TBalloonFlags);
begin
  ShowTrayNotification(Title, Format(Msg, Params), Kind);
end;

end.
