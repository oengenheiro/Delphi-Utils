unit AppTethering.Observer;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// Implements observer pattern for App Tethering
// It will listen for disconnects on Tethering Managers and Tethering Profiles

interface

uses
  System.Tether.Manager, 
  System.Tether.AppProfile, 
  System.Generics.Collections;

type
  ITetheringObserver = interface
    ['{067AE18E-8141-4D72-BCCA-8349CA911CB8}']
    procedure OnDeviceConnected(const Sender: TObject; const AManagerInfo: TTetheringManagerInfo);
    procedure OnDeviceDisconnected(const Sender: TObject; const AProfileInfo: TTetheringProfileInfo);
  end;

  ITetheringSubject = interface
    ['{361088ED-4873-46D1-874C-B73BD26D4885}']
    procedure RegisterObserver(const AObserver: ITetheringObserver);
    procedure RemoveObserver(const AObserver: ITetheringObserver);
    procedure NotifyConnected(const Sender: TObject; const AManagerInfo: TTetheringManagerInfo);
    procedure NotifyDisconnected(const Sender: TObject; const AProfileInfo: TTetheringProfileInfo);
  end;

  TTetheringSubject = class(TInterfacedObject, ITetheringSubject)
  private
    FTetheringMgr: TTetheringManager;
    FTetheringAppProfile: TTetheringAppProfile;
    FObserverList: TList<ITetheringObserver>;
    procedure OnConnectedHook(const Sender: TObject; const AManagerInfo: TTetheringManagerInfo);
    procedure OnDisconnectedHook(const Sender: TObject; const AProfileInfo: TTetheringProfileInfo);
  protected
    procedure NotifyConnected(const Sender: TObject; const AManagerInfo: TTetheringManagerInfo);
    procedure NotifyDisconnected(const Sender: TObject; const AProfileInfo: TTetheringProfileInfo);
    property TetMgr: TTetheringManager read FTetheringMgr;
    property TetProfile: TTetheringAppProfile read FTetheringAppProfile;
  public
    constructor Create(ATetheringMgr: TTetheringManager; ATetheringAppProfile: TTetheringAppProfile);
    destructor Destroy; override;
    procedure RegisterObserver(const AObserver: ITetheringObserver);
    procedure RemoveObserver(const AObserver: ITetheringObserver);
  end;

implementation

uses
  System.SysUtils;

{ TTetheringSubject }

constructor TTetheringSubject.Create(ATetheringMgr: TTetheringManager; ATetheringAppProfile: TTetheringAppProfile);
begin
  if not Assigned(ATetheringMgr) then
    raise Exception.Create('TTetheringSubject.Create :: TetheringManager is unassigned!');

  if not Assigned(ATetheringAppProfile) then
    raise Exception.Create('TTetheringSubject.Create :: TetheringAppProfile is unassigned!');

  inherited Create;
  FTetheringMgr := ATetheringMgr;
  FTetheringAppProfile := ATetheringAppProfile;
  FTetheringMgr.OnPairedToRemote := OnConnectedHook;
  FTetheringAppProfile.OnDisconnect := OnDisconnectedHook;
  FObserverList := TList<ITetheringObserver>.Create;
end;

destructor TTetheringSubject.Destroy;
begin
  FObserverList.Free;
  FTetheringMgr.OnPairedToRemote := NIL;
  FTetheringAppProfile.OnDisconnect := NIL;
  inherited Destroy;
end;

procedure TTetheringSubject.NotifyConnected(const Sender: TObject; const AManagerInfo: TTetheringManagerInfo);
var
  LItem: ITetheringObserver;
begin
  for LItem in FObserverList do
    LItem.OnDeviceConnected(Self, AManagerInfo);
end;

procedure TTetheringSubject.NotifyDisconnected(const Sender: TObject; const AProfileInfo: TTetheringProfileInfo);
var
  LItem: ITetheringObserver;
begin
  for LItem in FObserverList do
    LItem.OnDeviceDisconnected(Self, AProfileInfo);
end;

procedure TTetheringSubject.OnConnectedHook(const Sender: TObject; const AManagerInfo: TTetheringManagerInfo);
begin
  NotifyConnected(Sender, AManagerInfo);
end;

procedure TTetheringSubject.OnDisconnectedHook(const Sender: TObject; const AProfileInfo: TTetheringProfileInfo);
begin
  NotifyDisconnected(Sender, AProfileInfo);
end;

procedure TTetheringSubject.RegisterObserver(const AObserver: ITetheringObserver);
var
  Index: Integer;
begin
  if not FObserverList.BinarySearch(AObserver, Index) then
  begin
    FObserverList.Add(AObserver);
    FObserverList.Sort;
  end;
end;

procedure TTetheringSubject.RemoveObserver(const AObserver: ITetheringObserver);
var
  Index: Integer;
begin
  if FObserverList.BinarySearch(AObserver, Index) then
  begin
    FObserverList.Delete(Index);
    FObserverList.Sort;
  end;
end;

end.
