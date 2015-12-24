unit RTL.DeviceInfo.Android;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// This unit wraps some Android API calls to get info about the device, wifi, os version and telephony

interface

uses
  Androidapi.JNI.Os,
  Androidapi.Helpers,
  Androidapi.JNI.Telephony,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNIBridge,
  Android.Net.Wifi;

type
  TAndroidOs = (Base10, Base11, Cupcake, Development, Donut, Eclair, Eclair01, EclairMR1, Froyo, Gingerbread,
    GingerbreadMR1, Honeycomb, HoneycombMR1, HoneycombMR2, IceCreamSandwich, IceCreamSandwichMR1, JellyBean,
    JellyBeanMR1, JellyBeanMR2, KitKat, KitKatW, Lollipop, LollipopMR1, Unknown);

  TAndroidOsHelper = record helper for TAndroidOs
  public
    class function ToString(const Value: TAndroidOs): string; overload; static; inline;
    function ToString: string; overload; inline;
  end;

  TAndroidOsInfo = record
  private
    class function GetCodeName: string; static;
    class function GetIncremental: string; static;
    class function GetName: string; static;
    class function GetRelease: string; static;
    class function GetSDK: string; static;
    class function GetVersion: TAndroidOs; static;
  public
    class property Version: TAndroidOs read GetVersion;
    class property Name: string read GetName;
    class property CodeName: string read GetCodeName;
    class property Incremental: string read GetIncremental;
    class property Release: string read GetRelease;
    class property SDK: string read GetSDK;
  end;

  TAndroidTelephonyInfo = class(TInterfacedObject)
  private
    TelephonyService: JObject;
    TelephonyManager: JTelephonyManager;
    function GetDeviceId: string;
    function GetGroupId_Level1: string;
    function GetLine1_Numver: string;
    function GetMMS_Profile_Url: string;
    function GetMMS_User_Agent: string;
    function GetNetwork_Country_Iso: string;
    function GetNetwork_Operator: string;
    function GetSIM_Country_ISO: string;
    function GetSIM_Operator: string;
    function GetSIM_Operator_Name: string;
    function GetSoftwareVersion: string;
    function GetSuscriber_Id: string;
    function GetVoice_Mail_Number: string;
    function GetVoice_Mail_Tag: string;
    function GetNetwork_Operator_Name: string;
    function GetSIM_Serial: string;
  public
    constructor Create;
    property DeviceId: string read GetDeviceId;
    property SoftwareVersion: string read GetSoftwareVersion;
    property GroupId_Level1: string read GetGroupId_Level1;
    property Line1_Number: string read GetLine1_Numver;
    property MMS_Profile_Url: string read GetMMS_Profile_Url;
    property MMS_User_Agent: string read GetMMS_User_Agent;
    property Network_Country_ISO: string read GetNetwork_Country_Iso;
    property Network_Operator: string read GetNetwork_Operator;
    property Network_Operator_Name: string read GetNetwork_Operator_Name;
    property SIM_Country_ISO: string read GetSIM_Country_ISO;
    property SIM_Operator: string read GetSIM_Operator;
    property SIM_Operator_Name: string read GetSIM_Operator_Name;
    property SIM_Serial: string read GetSIM_Serial;
    property Suscriber_Id: string read GetSuscriber_Id;
    property Voice_Mail_Tag: string read GetVoice_Mail_Tag;
    property Voice_Mail_Number: string read GetVoice_Mail_Number;
  end;

  TWifiNetwork = record
  private
    FSSID: string;
    FBSSID: string;
    FCapabilities: string;
    FFrecuency: string;
    FSignal_Level: string;
  public
    property SSID: string read FSSID;
    property BSSID: string read FBSSID;
    property Capabilities: string read FCapabilities;
    property Frecuency: string read FFrecuency;
    property Signal_Level: string read FSignal_Level;
  end;


  TAndroidWifiInfo = class(TInterfacedObject)
  private
    Service: JObject;
    WifiManager: JWifiManager;
    FSSID: string;
    FBSSID: string;
    FMac: string;
  public
    constructor Create;
    property SSID: string read FSSID;
    property BSSID: string read FBSSID;
    property Mac: string read FMac;
    function ScanWifi: TArray<TWifiNetwork>;
  end;

  TAndroidDeviceInfo = record
  private
    class function GetBoard: string; static;
    class function GetBootloader: string; static;
    class function GetBrand: string; static;
    class function GetCPU_ABI: string; static;
    class function GetCPU_ABI_2: string; static;
    class function GetDevice: string; static;
    class function GetDisplay: string; static;
    class function GetFingerprint: string; static;
    class function GetHardware: string; static;
    class function GetHost: string; static;
    class function GetID: string; static;
    class function GetManufacturer: string; static;
    class function GetModel: string; static;
    class function GetProduct: string; static;
    class function GetRadio: string; static;
    class function GetSerial: string; static;
    class function GetTags: string; static;
    class function GetType: string; static;
    class function GetRadioVersion: string; static;
    class function GetUser: string; static;
  public
    class property Board: string read GetBoard;
    class property Bootloader: string read GetBootloader;
    class property Brand: string read GetBrand;
    class property CPU_ABI: string read GetCPU_ABI;
    class property CPU_ABI_2: string read GetCPU_ABI_2;
    class property Device: string read GetDevice;
    class property Display: string read GetDisplay;
    class property Fingerprint: string read GetFingerprint;
    class property Hardware: string read GetHardware;
    class property Host: string read GetHost;
    class property ID: string read GetID;
    class property Manufacturer: string read GetManufacturer;
    class property Model: string read GetModel;
    class property Product: string read GetProduct;
    class property Radio: string read GetRadio;
    class property RadioVersion: string read GetRadioVersion;
    class property Serial: string read GetSerial;
    class property Tags: string read GetTags;
    class property &Type: string read GetType;
    class property User: string read GetUser;
  end;

implementation

uses
  System.SysUtils;

{ TAndroidOsHelper }

class function TAndroidOsHelper.ToString(const Value: TAndroidOs): string;
begin
  case Value of
    Base10: Result := 'Android 1.0 (Base)';
    Base11: Result := 'Android 1.1 (Base 1.1)';
    Cupcake: Result := 'Android 1.5 (Cupcake)';
    Development: Result := 'Android current development';
    Donut: Result := 'Android 1.6 (Donut)';
    Eclair: Result := 'Android 2.0 (Eclair)';
    Eclair01: Result := 'Android 2.0.1 (Eclair 0.1)';
    EclairMR1: Result := 'Android 2.1 (Eclair MR1)';
    Froyo: Result := 'Android 2.2 (Froyo)';
    Gingerbread: Result := 'Android 2.3 (Gingerbread)';
    GingerbreadMR1: Result := 'Android 2.3.3 (Gingerbread MR1)';
    Honeycomb: Result := 'Android 3.0 (Honeycomb)';
    HoneycombMR1: Result := 'Android 3.1 (Honeycomb MR1)';
    HoneycombMR2: Result := 'Android 3.2 (Honeycomb MR2)';
    IceCreamSandwich: Result := 'Android 4.0 (Ice Cream Sandwich)';
    IceCreamSandwichMR1: Result := 'Android 4.0.3 (Ice Cream Sandwich MR1)';
    JellyBean: Result := 'Android 4.1 (Jelly Bean)';
    JellyBeanMR1: Result := 'Android 4.2 (Jelly Bean MR1)';
    JellyBeanMR2: Result := 'Android 4.3 (Jelly Bean MR2)';
    KitKat: Result := 'Android 4.4 (Kitkat)';
    KitKatW: Result := 'Android 4.4W (Kitkat Watch)';
    Lollipop: Result := 'Android 5.0 (Lollipop)';
    LollipopMR1: Result := 'Android 5.1 (Lollipop MR1)';
  else
    Result := 'Unknown';
  end;
end;

function TAndroidOsHelper.ToString: string;
begin
  Result := ToString(Self);
end;

{ TAndroidOsInfo }

class function TAndroidOsInfo.GetVersion: TAndroidOs;
var
  Value: Integer;
begin
  Value := TJBuild_VERSION.JavaClass.SDK_INT;
  if Value = TJBuild_VERSION_CODES.JavaClass.BASE then
    Result := Base10
  else if Value = TJBuild_VERSION_CODES.JavaClass.BASE_1_1 then
    Result := Base11
  else if Value = TJBuild_VERSION_CODES.JavaClass.Cupcake then
    Result := Cupcake
  else if Value = TJBuild_VERSION_CODES.JavaClass.CUR_DEVELOPMENT then
    Result := Development
  else if Value = TJBuild_VERSION_CODES.JavaClass.Donut then
    Result := Donut
  else if Value = TJBuild_VERSION_CODES.JavaClass.Eclair then
    Result := Eclair
  else if Value = TJBuild_VERSION_CODES.JavaClass.ECLAIR_0_1 then
    Result := Eclair01
  else if Value = TJBuild_VERSION_CODES.JavaClass.ECLAIR_MR1 then
    Result := EclairMR1
  else if Value = TJBuild_VERSION_CODES.JavaClass.Froyo then
    Result := Froyo
  else if Value = TJBuild_VERSION_CODES.JavaClass.Gingerbread then
    Result := Gingerbread
  else if Value = TJBuild_VERSION_CODES.JavaClass.GINGERBREAD_MR1 then
    Result := GingerbreadMR1
  else if Value = TJBuild_VERSION_CODES.JavaClass.Honeycomb then
    Result := Honeycomb
  else if Value = TJBuild_VERSION_CODES.JavaClass.HONEYCOMB_MR1 then
    Result := HoneycombMR1
  else if Value = TJBuild_VERSION_CODES.JavaClass.HONEYCOMB_MR2 then
    Result := HoneycombMR2
  else if Value = TJBuild_VERSION_CODES.JavaClass.ICE_CREAM_SANDWICH then
    Result := IceCreamSandwich
  else if Value = TJBuild_VERSION_CODES.JavaClass.ICE_CREAM_SANDWICH_MR1 then
    Result := IceCreamSandwichMR1
  else if Value = TJBuild_VERSION_CODES.JavaClass.JELLY_BEAN then
    Result := JellyBean
  else if Value = TJBuild_VERSION_CODES.JavaClass.JELLY_BEAN_MR1 then
    Result := JellyBeanMR1
  else if Value = TJBuild_VERSION_CODES.JavaClass.JELLY_BEAN_MR2 then
    Result := JellyBeanMR2
  else if Value = TJBuild_VERSION_CODES.JavaClass.KitKat then
    Result := KitKat
  else if Value = 20 then
    Result := KitKatW
  else if Value = 21 then
    Result := Lollipop
  else if Value = 22 then
    Result := LollipopMR1
  else
    Result := Unknown;
end;

class function TAndroidOsInfo.GetCodeName: string;
begin
  Result := JStringToString(TJBuild_VERSION.JavaClass.CODENAME);
end;

class function TAndroidOsInfo.GetIncremental: string;
begin
  Result := JStringToString(TJBuild_VERSION.JavaClass.INCREMENTAL);
end;

class function TAndroidOsInfo.GetName: string;
begin
  Result := GetVersion.ToString;
end;

class function TAndroidOsInfo.GetRelease: string;
begin
  Result := JStringToString(TJBuild_VERSION.JavaClass.RELEASE);
end;

class function TAndroidOsInfo.GetSDK: string;
begin
  Result := JStringToString(TJBuild_VERSION.JavaClass.SDK);
end;

{ TAndroidTelephonyInfo }

constructor TAndroidTelephonyInfo.Create;
begin
  TelephonyService := TAndroidHelper.Context.getSystemService(TJContext.JavaClass.TELEPHONY_SERVICE);
  if TelephonyService <> NIL then
    TelephonyManager := TJTelephonyManager.Wrap((TelephonyService as ILocalObject).GetObjectID);
end;

function TAndroidTelephonyInfo.GetDeviceId: string;
begin
  Result := JStringToString(TelephonyManager.getDeviceId);
end;

function TAndroidTelephonyInfo.GetGroupId_Level1: string;
begin
  Result := JStringToString(TelephonyManager.getGroupIdLevel1);
end;

function TAndroidTelephonyInfo.GetLine1_Numver: string;
begin
  Result := JStringToString(TelephonyManager.getLine1Number);
end;

function TAndroidTelephonyInfo.GetMMS_Profile_Url: string;
begin
  Result := JStringToString(TelephonyManager.getMmsUAProfUrl);
end;

function TAndroidTelephonyInfo.GetMMS_User_Agent: string;
begin
  Result := JStringToString(TelephonyManager.getMmsUserAgent);
end;

function TAndroidTelephonyInfo.GetNetwork_Country_Iso: string;
begin
  Result := JStringToString(TelephonyManager.getNetworkCountryIso);
end;

function TAndroidTelephonyInfo.GetNetwork_Operator: string;
begin
  Result := JStringToString(TelephonyManager.getNetworkOperator);
end;

function TAndroidTelephonyInfo.GetNetwork_Operator_Name: string;
begin
  Result := JStringToString(TelephonyManager.getNetworkOperatorName);
end;

function TAndroidTelephonyInfo.GetSIM_Country_ISO: string;
begin
  Result := JStringToString(TelephonyManager.getSimCountryIso);
end;

function TAndroidTelephonyInfo.GetSIM_Operator: string;
begin
  Result := JStringToString(TelephonyManager.getSimOperator);
end;

function TAndroidTelephonyInfo.GetSIM_Operator_Name: string;
begin
  Result := JStringToString(TelephonyManager.getSimOperatorName);
end;

function TAndroidTelephonyInfo.GetSIM_Serial: string;
begin
  Result := JStringToString(TelephonyManager.getSimSerialNumber);
end;

function TAndroidTelephonyInfo.GetSoftwareVersion: string;
begin
  Result := JStringToString(TelephonyManager.getDeviceSoftwareVersion);
end;

function TAndroidTelephonyInfo.GetSuscriber_Id: string;
begin
  Result := JStringToString(TelephonyManager.getSubscriberId);
end;

function TAndroidTelephonyInfo.GetVoice_Mail_Number: string;
begin
  Result := JStringToString(TelephonyManager.getVoiceMailNumber);
end;

function TAndroidTelephonyInfo.GetVoice_Mail_Tag: string;
begin
  Result := JStringToString(TelephonyManager.getVoiceMailAlphaTag);
end;

{ TAndroidWifiInfo }

constructor TAndroidWifiInfo.Create;
var
  ConnectionInfo: JWifiInfo;
begin
  Service := TAndroidHelper.Context.getSystemService(TJContext.JavaClass.WIFI_SERVICE);
  WifiManager := TJWifiManager.Wrap((Service as ILocalObject).GetObjectID);
  if not WifiManager.isWifiEnabled then
    raise Exception.Create('Wifi is not enabled');

  ConnectionInfo := WifiManager.getConnectionInfo;
  FSSID := JStringToString(ConnectionInfo.getSSID);
  FBSSID := JStringToString(ConnectionInfo.getBSSID);
  FMac := JStringToString(ConnectionInfo.getMacAddress);
end;

function TAndroidWifiInfo.ScanWifi: TArray<TWifiNetwork>;
var
  ScanResults: JList;
  ScanResult: JScanResult;
  I: Integer;
  LItem: TWifiNetwork;
begin
  ScanResults := WifiManager.getScanResults;

  SetLength(Result, ScanResults.size);

  for I := 0 to ScanResults.size - 1 do
  begin
    ScanResult := TJScanResult.Wrap((ScanResults.get(I) as ILocalObject).GetObjectID);
    LItem.FSSID := JStringToString(ScanResult.SSID);
    LItem.FBSSID := JStringToString(ScanResult.BSSID);
    LItem.FCapabilities := JStringToString(ScanResult.capabilities);
    LItem.FFrecuency := ScanResult.frequency.ToString + ' MHz';
    LItem.FSignal_Level := ScanResult.level.ToString + ' dBm';
    Result[I] := LItem;
  end
end;

{ TAndroidDeviceInfo }

class function TAndroidDeviceInfo.GetBoard: string;
begin
  Result := JStringToString(TJBuild.JavaClass.BOARD);
end;

class function TAndroidDeviceInfo.GetBootloader: string;
begin
  Result := JStringToString(TJBuild.JavaClass.BOOTLOADER);
end;

class function TAndroidDeviceInfo.GetBrand: string;
begin
  Result := JStringToString(TJBuild.JavaClass.BRAND);
end;

class function TAndroidDeviceInfo.GetCPU_ABI: string;
begin
  Result := JStringToString(TJBuild.JavaClass.CPU_ABI);
end;

class function TAndroidDeviceInfo.GetCPU_ABI_2: string;
begin
  Result := JStringToString(TJBuild.JavaClass.CPU_ABI2);
end;

class function TAndroidDeviceInfo.GetDevice: string;
begin
  Result := JStringToString(TJBuild.JavaClass.DEVICE);
end;

class function TAndroidDeviceInfo.GetDisplay: string;
begin
  Result := JStringToString(TJBuild.JavaClass.DISPLAY);
end;

class function TAndroidDeviceInfo.GetFingerprint: string;
begin
  Result := JStringToString(TJBuild.JavaClass.FINGERPRINT);
end;

class function TAndroidDeviceInfo.GetHardware: string;
begin
  Result := JStringToString(TJBuild.JavaClass.HARDWARE);
end;

class function TAndroidDeviceInfo.GetHost: string;
begin
  Result := JStringToString(TJBuild.JavaClass.HOST);
end;

class function TAndroidDeviceInfo.GetID: string;
begin
  Result := JStringToString(TJBuild.JavaClass.ID);
end;

class function TAndroidDeviceInfo.GetManufacturer: string;
begin
  Result := JStringToString(TJBuild.JavaClass.MANUFACTURER);
end;

class function TAndroidDeviceInfo.GetModel: string;
begin
  Result := JStringToString(TJBuild.JavaClass.MODEL);
end;

class function TAndroidDeviceInfo.GetProduct: string;
begin
  Result := JStringToString(TJBuild.JavaClass.PRODUCT);
end;

class function TAndroidDeviceInfo.GetRadio: string;
begin
  Result := JStringToString(TJBuild.JavaClass.RADIO);
end;

class function TAndroidDeviceInfo.GetRadioVersion: string;
begin
  Result := JStringToString(TJBuild.JavaClass.getRadioVersion);
end;

class function TAndroidDeviceInfo.GetSerial: string;
begin
   Result := JStringToString(TJBuild.JavaClass.SERIAL);
end;

class function TAndroidDeviceInfo.GetTags: string;
begin
  Result := JStringToString(TJBuild.JavaClass.TAGS);
end;

class function TAndroidDeviceInfo.GetType: string;
begin
  Result := JStringToString(TJBuild.JavaClass.&TYPE);
end;

class function TAndroidDeviceInfo.GetUser: string;
begin
  Result := JStringToString(TJBuild.JavaClass.USER);
end;

end.
