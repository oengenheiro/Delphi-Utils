unit Vcl.TrayNotifications.Tethering;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// Sends a notification on the tray when a device is connected/disconnected
// see Vcl.TrayNotifications

interface

uses
  Vcl.TrayNotifications, 
  AppTethering.Observer, 
  System.Tether.Manager;

type
  TTrayIconAppTetheringObserver = class(TInterfacedObject, ITetheringObserver)
  strict private
    TrayIconNotificationDisplayer: ITrayIconNotificationDisplayer;
    FActive: Boolean;
    procedure OnDeviceConnected(const Sender: TObject; const AManagerInfo: TTetheringManagerInfo);
    procedure OnDeviceDisconnected(const Sender: TObject; const AProfileInfo: TTetheringProfileInfo);
    procedure SetActive(const Value: Boolean);
  public
    constructor Create(const ATrayIconNotificationsService: ITrayIconNotificationDisplayer);
    property Active: Boolean read FActive write SetActive;
  end;

implementation

uses
  System.SysUtils;

{ TTrayIconAppTetheringObserver }

constructor TTrayIconAppTetheringObserver.Create(const ATrayIconNotificationsService: ITrayIconNotificationDisplayer);
begin
  if not Assigned(ATrayIconNotificationsService) then
      raise Exception.Create('TTrayIconAppTetheringObserver.Create :: Unassigned TrayIconNotificationsService');

  TrayIconNotificationDisplayer := ATrayIconNotificationsService;
  FActive := True;
end;

procedure TTrayIconAppTetheringObserver.OnDeviceConnected(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  if not Active then
    Exit;

  TrayIconNotificationDisplayer.ShowTrayNotificationFmt('Dispositivo conectado', 'Se conectó el dispositivo %s',
    [AManagerInfo.ManagerText]);
end;

procedure TTrayIconAppTetheringObserver.OnDeviceDisconnected(const Sender: TObject;
  const AProfileInfo: TTetheringProfileInfo);
begin
  if not Active then
    Exit;

  TrayIconNotificationDisplayer.ShowTrayNotificationFmt('Dispositivo desconectado', 'Se desconectó el dispositivo %s',
    [AProfileInfo.ProfileText]);
end;

procedure TTrayIconAppTetheringObserver.SetActive(const Value: Boolean);
begin
  Active := Value;
end;

end.
