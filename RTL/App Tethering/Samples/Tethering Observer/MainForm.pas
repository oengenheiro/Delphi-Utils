unit MainForm;

interface

uses
  AppTethering.Observer,
  System.Tether.Manager,
  System.Tether.AppProfile,
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TMemoOutputTetheringObserver = class(TInterfacedObject, ITetheringObserver)
  strict private
    FMemo: TMemo;
  public
    constructor Create(AStrings: TMemo);
    procedure OnDeviceConnected(const Sender: TObject; const AManagerInfo: TTetheringManagerInfo);
    procedure OnDeviceDisconnected(const Sender: TObject; const AProfileInfo: TTetheringProfileInfo);
  end;

  TForm1 = class(TForm)
    pClient: TPanel;
    Memo1: TMemo;
    pBottom: TPanel;
    btnAutoConnect: TButton;
    btnDisconnectFirstManager: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAutoConnectClick(Sender: TObject);
    procedure btnDisconnectFirstManagerClick(Sender: TObject);
  private
    { Private declarations }
    FTetheringObserver: ITetheringObserver;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  AppTethering.Module;

{$R *.dfm}

procedure TForm1.btnAutoConnectClick(Sender: TObject);
begin
  TetheringModule.AutoConnect;
end;

procedure TForm1.btnDisconnectFirstManagerClick(Sender: TObject);
begin
  TetheringModule.TetheringManager.UnPairManager(TetheringModule.TetheringManager.PairedManagers.First);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
  TetheringModule := TTetheringModule.Create(Self);
  FTetheringObserver := TMemoOutputTetheringObserver.Create(Memo1);
  TetheringModule.RegisterObserver(FTetheringObserver);
end;

{ TMemoOutputTetheringObserver }

constructor TMemoOutputTetheringObserver.Create(AStrings: TMemo);
begin
  inherited Create;
  FMemo := AStrings;
  FMemo.Clear;
end;

procedure TMemoOutputTetheringObserver.OnDeviceConnected(const Sender: TObject; const AManagerInfo: TTetheringManagerInfo);
begin
  FMemo.Lines.Add('Connected: ManagerIdentifier: ' + AManagerInfo.ManagerIdentifier);
  FMemo.Lines.Add('Connected: ManagerName: ' + AManagerInfo.ManagerName);
  FMemo.Lines.Add('Connected: ManagerText: ' + AManagerInfo.ManagerText);
  FMemo.Lines.Add('============================================');
  FMemo.Lines.Add('');
end;

procedure TMemoOutputTetheringObserver.OnDeviceDisconnected(const Sender: TObject; const AProfileInfo: TTetheringProfileInfo);
begin
  FMemo.Lines.Add('Disconnected: ManagerIdentifier: ' + AProfileInfo.ManagerIdentifier);
  FMemo.Lines.Add('Disconnected: ProfileIdentifier: ' + AProfileInfo.ProfileIdentifier);
  FMemo.Lines.Add('Disconnected: ProfileText: ' + AProfileInfo.ProfileText);
  FMemo.Lines.Add('Disconnected: ProfileGroup: ' + AProfileInfo.ProfileGroup);
  FMemo.Lines.Add('Disconnected: ProfileType: ' + AProfileInfo.ProfileType);
  FMemo.Lines.Add('============================================');
  FMemo.Lines.Add('');
end;

end.
