unit Vcl.AppTethering.DevicesListView;

interface

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// TDeviceListView hooks to a ListView and a Tethering Manager + Profile and list the connected devices

uses
  AppTethering.Observer,
  System.Classes,
  System.Generics.Collections,
  System.Tether.Manager,
  System.Tether.AppProfile,
  Vcl.StdCtrls,
  Vcl.ComCtrls;

type
 {$REGION 'Helper classes'}
 {$REGION 'TDisconectDeviceButton'}
  // Button for each item of the ListView: will disconnect the device when clicked
  TDisconectDeviceButton = class(TButton)
  strict private
    FDevice: TTetheringManagerInfo;
  public
    constructor Create(AOwner: TComponent; const ADeviceInfo: TTetheringManagerInfo); reintroduce;
    property Device: TTetheringManagerInfo read FDevice;
  end;
  {$ENDREGION}

 {$REGION 'TDeviceListItem'}
  // ListItem class for the ListView: holds the data of the paired tethering manager and a reference to the disconnect button
  TDeviceListItem = class(TListItem)
  private
    FDevice: TTetheringManagerInfo;
    FButton: TDisconectDeviceButton;
  public
    constructor Create(AOwner: TListItems; const ADevice: TTetheringManagerInfo; OnButtonClick: TNotifyEvent); reintroduce;
    destructor Destroy; override;
    property Device: TTetheringManagerInfo read FDevice;
  end;
  {$ENDREGION}
  {$ENDREGION}

  // see AppTethering.Observer
  IListViewTetheringObserver = interface(ITetheringObserver)
    ['{884C020B-0F35-4906-9D17-53E7990B2DAC}']
    function GetDeviceItems: TEnumerable<TDeviceListItem>;
    procedure AddDevice(const AManagerInfo: TTetheringManagerInfo);
    procedure DisconnectDevice(const AManagerInfo: TTetheringManagerInfo);
    property DeviceItems: TEnumerable<TDeviceListItem> read GetDeviceItems;
  end;

  TDeviceListView = class(TInterfacedObject, IListViewTetheringObserver)
  strict private
    ListView: TListView;
    DeviceListItemDic: TDictionary<string, TDeviceListItem>;
    TetheringManager: TTetheringManager;
    TetheringAppProfile: TTetheringAppProfile;
    FAfterConnect: TNotifyEvent;
    FAfterDisconnect: TNotifyEvent;
    function SumColumnWidths(const UntilIndex: Integer): Integer;
    procedure DoAfterConnect;
    procedure DoAfterDisconnect;
    procedure OnDeviceConnected(const Sender: TObject; const AManagerInfo: TTetheringManagerInfo);
    procedure OnDeviceDisconnected(const Sender: TObject; const AProfileInfo: TTetheringProfileInfo);
    procedure OnCustomDraw(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    procedure SetAfterConnect(const Value: TNotifyEvent);
    procedure SetAfterDisconnect(const Value: TNotifyEvent);
    procedure DisconnectButtonClick(Sender: TObject);
    function GetDeviceItems: TEnumerable<TDeviceListItem>;
    procedure DisconnectDevice(const AManagerInfo: TTetheringManagerInfo); virtual;
  protected
    FImageColumn: TListColumn;
    FDescriptionColumn: TListColumn;
    FIpColumn: TListColumn;
    FButtonColumn: TListColumn;
    procedure SetupColumns; virtual;
  public
    constructor Create(AListView: TListView; ATetMgr: TTetheringManager; ATetAppProfile: TTetheringAppProfile);
    destructor Destroy; override;
    procedure AddDevice(const AManagerInfo: TTetheringManagerInfo);
    property AfterConnect: TNotifyEvent read FAfterConnect write SetAfterConnect;
    property AfterDisconnect: TNotifyEvent read FAfterDisconnect write SetAfterDisconnect;
    property DeviceItems: TEnumerable<TDeviceListItem> read GetDeviceItems;
  end;

implementation

uses
  Vcl.CustomDialogs,
  System.SysUtils,
  Vcl.Controls,
  Vcl.Graphics,
  Winapi.Windows;

type
  TListViewHelper = class helper for TCustomListView
  public
    function GetColumns: TListColumns;
  end;

{ TDisconectDeviceButton }

constructor TDisconectDeviceButton.Create(AOwner: TComponent; const ADeviceInfo: TTetheringManagerInfo);
begin
  inherited Create(AOwner);
  Caption := 'Desconectar';
  Font.Name := 'Segoe UI';
  Font.Style := [];
  Font.Size := 11;
  TabStop := False;
  FDevice := ADeviceInfo;
end;

{ TDeviceListItem }

constructor TDeviceListItem.Create(AOwner: TListItems; const ADevice: TTetheringManagerInfo;
  OnButtonClick: TNotifyEvent);
begin
  inherited Create(AOwner);
  FDevice := ADevice;
  SubItems.Add(ADevice.ManagerText);
  SubItems.Add(ADevice.ConnectionString);
  FButton := TDisconectDeviceButton.Create(ListView, ADevice);
  FButton.Parent := ListView;
  FButton.OnClick := OnButtonClick;
end;

destructor TDeviceListItem.Destroy;
begin
  // if we free the button then we get and Access Violation when we use VCL Styles, so hide it
  // since its owned by the listview it will be freed somehow
  FButton.Visible := False;
  FButton.ClicksDisabled := True;
  inherited Destroy;
end;

{ TDeviceListView }

procedure TDeviceListView.AddDevice(const AManagerInfo: TTetheringManagerInfo);
var
  LItem: TDeviceListItem;
begin
  if DeviceListItemDic.ContainsKey(AManagerInfo.ManagerIdentifier) then
    Exit;
    
  LItem := TDeviceListItem.Create(ListView.Items, AManagerInfo, DisconnectButtonClick);
  ListView.Items.AddItem(LItem);
  DeviceListItemDic.Add(AManagerInfo.ManagerIdentifier, LItem);
end;

constructor TDeviceListView.Create(AListView: TListView; ATetMgr: TTetheringManager;
  ATetAppProfile: TTetheringAppProfile);
begin
  if not Assigned(AListView) then
    raise Exception.Create('TDeviceListView.Create :: Unassigned ListView');

  if not Assigned(ATetMgr) then
    raise Exception.Create('TDeviceListView.Create :: Unassigned TetheringManager');

  if not Assigned(ATetAppProfile) then
    raise Exception.Create('TDeviceListView.Create :: Unassigned TetheringAppProfile');

  ListView := AListView;
  ListView.OnCustomDrawItem := OnCustomDraw;
  TetheringManager := ATetMgr;
  TetheringAppProfile := ATetAppProfile;
  DeviceListItemDic := TDictionary<string, TDeviceListItem>.Create;
  SetupColumns;
end;

destructor TDeviceListView.Destroy;
begin
  DeviceListItemDic.Free;
  inherited Destroy;
end;

procedure TDeviceListView.DisconnectButtonClick(Sender: TObject);
var
  LButton: TDisconectDeviceButton;
begin
  if not(Sender is TDisconectDeviceButton) then
    Exit;

  LButton := Sender as TDisconectDeviceButton;
  DisconnectDevice(LButton.Device);
end;

procedure TDeviceListView.DisconnectDevice(const AManagerInfo: TTetheringManagerInfo);
var
  LProfile: TTetheringProfileInfo;
begin
  for LProfile in TetheringManager.RemoteProfiles do
  begin
    if AManagerInfo.ManagerIdentifier = LProfile.ManagerIdentifier then
    begin
      TetheringManager.UnPairManager(LProfile.ManagerIdentifier);
      TetheringAppProfile.Disconnect(LProfile);
      Break;
    end;
  end;
end;

procedure TDeviceListView.DoAfterConnect;
begin
  if Assigned(FAfterConnect) then
    FAfterConnect(Self);
end;

procedure TDeviceListView.DoAfterDisconnect;
begin
  if Assigned(FAfterDisconnect) then
    FAfterDisconnect(Self);
end;

function TDeviceListView.GetDeviceItems: TEnumerable<TDeviceListItem>;
begin
  Result := DeviceListItemDic.Values;
end;

procedure TDeviceListView.OnCustomDraw(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var
  LButtonRect: TRect;
  LItem: TDeviceListItem;
begin
  if not(Item is TDeviceListItem) then
  begin
    DefaultDraw := True;
    Exit;
  end;

  LItem := TDeviceListItem(Item);
  LButtonRect := LItem.DisplayRect(drBounds);
  LButtonRect.Left := LButtonRect.Left + SumColumnWidths(FButtonColumn.Index);
  LButtonRect.Right := LButtonRect.Left + FButtonColumn.Width;
  LItem.FButton.BoundsRect := LButtonRect;
end;

procedure TDeviceListView.OnDeviceConnected(const Sender: TObject; const AManagerInfo: TTetheringManagerInfo);
begin
  AddDevice(AManagerInfo);
  DoAfterConnect;
end;

procedure TDeviceListView.OnDeviceDisconnected(const Sender: TObject; const AProfileInfo: TTetheringProfileInfo);
var
  LPair: TPair<string, TDeviceListItem>;
begin
  LPair := DeviceListItemDic.ExtractPair(AProfileInfo.ManagerIdentifier);

  ListView.Items.Delete(LPair.Value.Index);
  DoAfterDisconnect;
end;

procedure TDeviceListView.SetAfterConnect(const Value: TNotifyEvent);
begin
  FAfterConnect := Value;
end;

procedure TDeviceListView.SetAfterDisconnect(const Value: TNotifyEvent);
begin
  FAfterDisconnect := Value;
end;

procedure TDeviceListView.SetupColumns;
var
  cols: TListColumns;
begin
  cols := ListView.GetColumns;

  FImageColumn := cols.Add;
  FImageColumn.Caption := EmptyStr;
  FImageColumn.Width := 50;
  FImageColumn.MaxWidth := 50;
  FImageColumn.MinWidth := 50;
  FImageColumn.ImageIndex := -1;
  FImageColumn.AutoSize := False;

  FDescriptionColumn := cols.Add;
  FDescriptionColumn.Caption := 'Descripción';
  FDescriptionColumn.Width := 300;
  FDescriptionColumn.ImageIndex := -1;
  FDescriptionColumn.AutoSize := True;

  FIpColumn := cols.Add;
  FIpColumn.Caption := 'Dirección IP';
  FIpColumn.Width := 250;
  FIpColumn.ImageIndex := -1;
  FIpColumn.AutoSize := True;

  FButtonColumn := cols.Add;
  FButtonColumn.Caption := EmptyStr;
  FButtonColumn.Width := 100;
  FButtonColumn.MaxWidth := 100;
  FButtonColumn.MinWidth := 100;
  FButtonColumn.ImageIndex := -1;
  FButtonColumn.AutoSize := False;
end;

function TDeviceListView.SumColumnWidths(const UntilIndex: Integer): Integer;
var
  I: Integer;
  LColumn: TListColumn;
begin
  Result := 0;
  for I := 0 to UntilIndex - 1 do
  begin
    LColumn := ListView.GetColumns[I];
    Result := Result + LColumn.Width;
  end;
end;

{ TListViewHelper }

function TListViewHelper.GetColumns: TListColumns;
begin
  Result := Self.Columns;
end;

end.
