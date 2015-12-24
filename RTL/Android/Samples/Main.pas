unit Main;

interface

uses
  System.Rtti,
  System.Classes,
  FMX.Forms,
  FMX.Grid,
  FMX.Layouts,
  FMX.Controls,
  FMX.TabControl,
  FMX.Types;

type
  TFormMain = class(TForm)
    StringGridOs: TStringGrid;
    StringColumnValue: TStringColumn;
    StringColumnName: TStringColumn;
    TabControl: TTabControl;
    TabItemOs: TTabItem;
    TabItemTelephony: TTabItem;
    StringGridTelephony: TStringGrid;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    TabItemWifi: TTabItem;
    StringGridWifi: TStringGrid;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    procedure TabControlChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure AddRow(StringGrid: TStringGrid; const Name, Value: string);
    procedure InitOsTab;
    procedure InitTelephonyTab;
    procedure InitWifiTab;
  end;

var
  FormMain: TFormMain;

implementation

uses
  RTL.DeviceInfo.Android,
  System.SysUtils;

{$R *.fmx}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  TabControlChange(TabControl);
end;

procedure TFormMain.AddRow(StringGrid: TStringGrid; const Name, Value: string);
begin
  StringGrid.RowCount := StringGrid.RowCount + 1;
  StringGrid.Cells[0, StringGrid.RowCount - 1] := Name;
  StringGrid.Cells[1, StringGrid.RowCount - 1] := Value;
end;

procedure TFormMain.TabControlChange(Sender: TObject);
begin
  if TabControl.ActiveTab = TabItemOs then
    InitOsTab
  else if TabControl.ActiveTab = TabItemTelephony then
    InitTelephonyTab
  else if TabControl.ActiveTab = TabItemWifi then
    InitWifiTab;
end;

procedure TFormMain.InitOsTab;
begin
  if StringGridOs.RowCount = 0 then
    StringGridOs.RowCount := 26;

  StringGridOs.Cells[0, 0] := 'Board';
  StringGridOs.Cells[1, 0] := TAndroidDeviceInfo.Board;

  StringGridOs.Cells[0, 1] := 'Bootloader';
  StringGridOs.Cells[1, 1] := TAndroidDeviceInfo.Bootloader;

  StringGridOs.Cells[0, 2] := 'Brand';
  StringGridOs.Cells[1, 2] := TAndroidDeviceInfo.Brand;

  StringGridOs.Cells[0, 3] := 'CPU ABI';
  StringGridOs.Cells[1, 3] := TAndroidDeviceInfo.CPU_ABI;

  StringGridOs.Cells[0, 4] := 'CPU ABI 2';
  StringGridOs.Cells[1, 4] := TAndroidDeviceInfo.CPU_ABI_2;

  StringGridOs.Cells[0, 5] := 'Device';
  StringGridOs.Cells[1, 5] := TAndroidDeviceInfo.Device;

  StringGridOs.Cells[0, 6] := 'Display';
  StringGridOs.Cells[1, 6] := TAndroidDeviceInfo.Display;

  StringGridOs.Cells[0, 7] := 'Fingerprint';
  StringGridOs.Cells[1, 7] := TAndroidDeviceInfo.Fingerprint;

  StringGridOs.Cells[0, 9] := 'Hardware';
  StringGridOs.Cells[1, 9] := TAndroidDeviceInfo.Hardware;

  StringGridOs.Cells[0, 10] := 'Host';
  StringGridOs.Cells[1, 10] := TAndroidDeviceInfo.Host;

  StringGridOs.Cells[0, 11] := 'ID';
  StringGridOs.Cells[1, 11] := TAndroidDeviceInfo.ID;

  StringGridOs.Cells[0, 12] := 'Manufacturer';
  StringGridOs.Cells[1, 12] := TAndroidDeviceInfo.Manufacturer;

  StringGridOs.Cells[0, 13] := 'Model';
  StringGridOs.Cells[1, 13] := TAndroidDeviceInfo.Model;

  StringGridOs.Cells[0, 14] := 'Product';
  StringGridOs.Cells[1, 14] := TAndroidDeviceInfo.Product;

  StringGridOs.Cells[0, 15] := 'Radio';
  StringGridOs.Cells[1, 15] := TAndroidDeviceInfo.Radio;

  StringGridOs.Cells[0, 16] := 'Radio version';
  StringGridOs.Cells[1, 16] := TAndroidDeviceInfo.RadioVersion;

  StringGridOs.Cells[0, 17] := 'Serial';
  StringGridOs.Cells[1, 17] := TAndroidDeviceInfo.Serial;

  StringGridOs.Cells[0, 18] := 'Tags';
  StringGridOs.Cells[1, 18] := TAndroidDeviceInfo.Tags;

  StringGridOs.Cells[0, 19] := 'Type';
  StringGridOs.Cells[1, 19] := TAndroidDeviceInfo.&Type;

  StringGridOs.Cells[0, 20] := 'User';
  StringGridOs.Cells[1, 20] := TAndroidDeviceInfo.User;

  StringGridOs.Cells[0, 21] := 'OS Codename';
  StringGridOs.Cells[1, 21] := TAndroidOsInfo.CodeName;

  StringGridOs.Cells[0, 22] := 'OS Incremental';
  StringGridOs.Cells[1, 22] := TAndroidOsInfo.Incremental;

  StringGridOs.Cells[0, 23] := 'OS Release';
  StringGridOs.Cells[1, 23] := TAndroidOsInfo.Release;

  StringGridOs.Cells[0, 24] := 'OS SDK';
  StringGridOs.Cells[1, 24] := TAndroidOsInfo.SDK;

  StringGridOs.Cells[0, 25] := 'OS Version';
  StringGridOs.Cells[1, 25] := TAndroidOsInfo.Version.ToString;
end;

procedure TFormMain.InitTelephonyTab;
var
  LInfo: TAndroidTelephonyInfo;
begin
  LInfo := TAndroidTelephonyInfo.Create;
  if StringGridTelephony.RowCount = 0 then
    StringGridTelephony.RowCount := 16;

  StringGridTelephony.Cells[0, 0] := 'Device';
  StringGridTelephony.Cells[1, 0] := LInfo.DeviceId;

  StringGridTelephony.Cells[0, 1] := 'SW version';
  StringGridTelephony.Cells[1, 1] := LInfo.SoftwareVersion;

  StringGridTelephony.Cells[0, 2] := 'Group 1';
  StringGridTelephony.Cells[1, 2] := LInfo.GroupId_Level1;

  StringGridTelephony.Cells[0, 3] := 'Phone 1';
  StringGridTelephony.Cells[1, 3] := LInfo.Line1_Number;

  StringGridTelephony.Cells[0, 4] := 'MMS url';
  StringGridTelephony.Cells[1, 4] := LInfo.MMS_Profile_Url;

  StringGridTelephony.Cells[0, 5] := 'MMS';
  StringGridTelephony.Cells[1, 5] := LInfo.MMS_User_Agent;

  StringGridTelephony.Cells[0, 6] := 'Country ISO';
  StringGridTelephony.Cells[1, 6] := LInfo.Network_Country_ISO;

  StringGridTelephony.Cells[0, 7] := 'Operator';
  StringGridTelephony.Cells[1, 7] := LInfo.Network_Operator;

  StringGridTelephony.Cells[0, 8] := 'Operator name';
  StringGridTelephony.Cells[1, 8] := LInfo.Network_Operator_Name;

  StringGridTelephony.Cells[0, 9] := 'SIM country ISO';
  StringGridTelephony.Cells[1, 9] := LInfo.SIM_Country_ISO;

  StringGridTelephony.Cells[0, 10] := 'SIM operator';
  StringGridTelephony.Cells[1, 10] := LInfo.SIM_Operator;

  StringGridTelephony.Cells[0, 11] := 'SIM operator name';
  StringGridTelephony.Cells[1, 11] := LInfo.SIM_Operator_Name;

  StringGridTelephony.Cells[0, 12] := 'SIM serial';
  StringGridTelephony.Cells[1, 12] := LInfo.SIM_Serial;

  StringGridTelephony.Cells[0, 13] := 'Subscriber';
  StringGridTelephony.Cells[1, 13] := LInfo.Suscriber_Id;

  StringGridTelephony.Cells[0, 14] := 'Voice mail tag';
  StringGridTelephony.Cells[1, 14] := LInfo.Voice_Mail_Tag;

  StringGridTelephony.Cells[0, 15] := 'Voice mail number';
  StringGridTelephony.Cells[1, 15] := LInfo.Voice_Mail_Number;
end;

procedure TFormMain.InitWifiTab;
var
  LWifi: TAndroidWifiInfo;
  ScanResults: TArray<TWifiNetwork>;
  I: Integer;
begin
  StringGridWifi.RowCount := 0;

  LWifi := TAndroidWifiInfo.Create;
  AddRow(StringGridWifi, 'SSID', LWifi.SSID);
  AddRow(StringGridWifi, 'BSSID', LWifi.BSSID);
  AddRow(StringGridWifi, 'MAC address', LWifi.Mac);
  ScanResults := LWifi.ScanWifi;
  for I := 0 to High(ScanResults) do
  begin
    AddRow(StringGridWifi, 'Access point ' + I.ToString, '');
    AddRow(StringGridWifi, '  SSID', ScanResults[I].SSID);
    AddRow(StringGridWifi, '  BSSID', ScanResults[I].BSSID);
    AddRow(StringGridWifi, '  Capabilities', ScanResults[I].Capabilities);
    AddRow(StringGridWifi, '  Frequency', ScanResults[I].Frecuency);
    AddRow(StringGridWifi, '  Signal level', ScanResults[I].Signal_Level);
  end
end;

end.
