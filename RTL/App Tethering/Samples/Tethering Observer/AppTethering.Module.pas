unit AppTethering.Module;

interface

uses
  AppTethering.Observer,
  System.SysUtils,
  System.Classes,
  IPPeerClient,
  IPPeerServer,
  System.Tether.Manager,
  System.Tether.AppProfile;

type
  TTetheringModule = class(TDataModule)
    TetheringManager: TTetheringManager;
    TetheringAppProfile: TTetheringAppProfile;
    procedure DataModuleCreate(Sender: TObject);
  strict private
    TetheringSubject: ITetheringSubject;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AutoConnect;
    procedure RegisterObserver(const AObserver: ITetheringObserver);
    procedure RemoveObserver(const AObserver: ITetheringObserver);
  end;

var
  TetheringModule: TTetheringModule;

implementation

{ %CLASSGROUP 'Vcl.Controls.TControl' }

{$R *.dfm}

{ TTetheringModule }

procedure TTetheringModule.AutoConnect;
begin
  TetheringManager.AutoConnect;
end;

procedure TTetheringModule.DataModuleCreate(Sender: TObject);
begin
  TetheringSubject := TTetheringSubject.Create(TetheringManager, TetheringAppProfile);
end;

procedure TTetheringModule.RegisterObserver(const AObserver: ITetheringObserver);
begin
  TetheringSubject.RegisterObserver(AObserver);
end;

procedure TTetheringModule.RemoveObserver(const AObserver: ITetheringObserver);
begin
  TetheringSubject.RemoveObserver(AObserver);
end;

end.
