unit Main;

interface

uses
  Vcl.AppTethering.DevicesListView,
  System.Tether.Manager,
  System.Tether.AppProfile,
  System.Classes,
  System.ImageList,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Menus,
  Vcl.ImgList;

type
  TFDevices = class(TForm)
    imDevices: TImageList;
    pmDevices: TPopupMenu;
    Desconectartodos1: TMenuItem;
    Refrescar1: TMenuItem;
    Buscaryconectar1: TMenuItem;
    lvDevices: TListView;
    pBottom: TPanel;
    btnRefresh: TButton;
    btnDisconnectAll: TButton;
    btnSearchAndConnect: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Buscaryconectar1Click(Sender: TObject);
    procedure Desconectartodos1Click(Sender: TObject);
    procedure Refrescar1Click(Sender: TObject);
    procedure btnSearchAndConnectClick(Sender: TObject);
    procedure btnDisconnectAllClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  strict private
    function GetTetMgr: TTetheringManager;
    function GetTetAppProfile: TTetheringAppProfile;
    procedure DoSearchAndConnect;
    procedure DoDisconnectAll;
    procedure PopulateList;
  strict private
    lvObserver: IListViewTetheringObserver;
    property TetMgr: TTetheringManager read GetTetMgr;
    property TetAppProfile: TTetheringAppProfile read GetTetAppProfile;
  end;

var
  FDevices: TFDevices;

implementation

{$R *.dfm}

uses
  AppTethering.Module;

{ TFDevices }

procedure TFDevices.Refrescar1Click(Sender: TObject);
begin
  PopulateList;
end;

procedure TFDevices.btnDisconnectAllClick(Sender: TObject);
begin
  DoDisconnectAll;
end;

procedure TFDevices.Desconectartodos1Click(Sender: TObject);
begin
  DoDisconnectAll;
  PopulateList;
end;

procedure TFDevices.btnRefreshClick(Sender: TObject);
begin
  PopulateList;
end;

procedure TFDevices.btnSearchAndConnectClick(Sender: TObject);
begin
  DoSearchAndConnect;
end;

procedure TFDevices.Buscaryconectar1Click(Sender: TObject);
begin
  DoSearchAndConnect;
end;

procedure TFDevices.DoDisconnectAll;
var
  LItem: TDeviceListItem;
begin
  for LItem in lvObserver.DeviceItems do
    lvObserver.DisconnectDevice(LItem.Device);
end;

procedure TFDevices.DoSearchAndConnect;
begin
  TetMgr.AutoConnect;
end;

procedure TFDevices.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
  lvObserver := TDeviceListView.Create(lvDevices, TetMgr, TetAppProfile);
  TetheringModule.RegisterObserver(lvObserver);
  PopulateList;
end;

function TFDevices.GetTetAppProfile: TTetheringAppProfile;
begin
  Result := TetheringModule.TetheringAppProfile;
end;

function TFDevices.GetTetMgr: TTetheringManager;
begin
  Result := TetheringModule.TetheringManager;
end;

procedure TFDevices.PopulateList;
var
  LRemoteManagers: TTetheringManagerInfoList;
  LManager: TTetheringManagerInfo;
begin
  lvDevices.Items.BeginUpdate;
  try
    lvDevices.Items.Clear;
    LRemoteManagers := TetMgr.PairedManagers;
    for LManager in LRemoteManagers do
      lvObserver.AddDevice(LManager);
  finally
    lvDevices.Items.EndUpdate;
  end;
end;

end.
