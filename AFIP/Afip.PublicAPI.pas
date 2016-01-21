unit Afip.PublicAPI;

interface

uses
  Afip.PublicAPI.Types,
  Afip.PublicAPI.Parsers,
  System.Classes,
  System.Net.URLClient,
  System.Net.HttpClient,
  System.Net.HttpClientComponent;

type
{$REGION 'TAfipQuery'}
  TAfipQuery = class(TInterfacedObject, IApi_Afip)
  private type
    TServiceType = (stPersona, stPersonasDni, stConstancia);
  strict private
    FParser: IAfip_PersonParser;
    FHttpClient: TNetHTTPClient;
    FHttpRequest: TNetHTTPRequest;
    FServicesUrl: array [TServiceType] of string;

    function DoExecuteRequest(const AService: TServiceType; const Param: string): IHTTPResponse; overload;
    function DoExecuteRequest(const AService: TServiceType; const Param: string; out RawJson: string): IHTTPResponse; overload;
  public
    constructor Create;
    destructor Destroy; override;
    function ConsultaNroDocumento(const NroDocumento: string): TArray<string>; overload;
    function ObtenerConstancia(const Cuit: string): TStream; overload;
    function ObtenerConstancia(const Cuit: Int64): TStream; overload;
    function ConsultaPersona(const NroDocumento: string): IPersona_Afip; overload;
  end;
{$ENDREGION}

// estas funciones mapean a las mismas provistas por la clase; es para usarlas de forma static,
// es decir, como si fueran funciones de clase
function ConsultaNroDocumento(const NroDocumento: string): TArray<string>; overload;
function ObtenerConstancia(const Cuit: string): TStream; overload;
function ObtenerConstancia(const Cuit: Int64): TStream; overload;
function ConsultaPersona(const NroDocumento: string): IPersona_Afip; overload;

implementation

uses
  System.SysUtils;

{$REGION 'TAfipQuery'}
constructor TAfipQuery.Create;
const
  BASE_URL = 'https://soa.afip.gob.ar/sr-padron/';
begin
  inherited;

  FParser := TAfip_PersonParser.Create;

  FServicesUrl[stPersona] := BASE_URL + 'v2/persona/';
  FServicesUrl[stPersonasDni] := BASE_URL + 'v2/personas/';
  FServicesUrl[stConstancia] := BASE_URL + 'v1/constancia/';

  FHttpClient := TNetHTTPClient.Create(NIL);
  FHttpClient.AllowCookies := True;
  FHttpClient.HandleRedirects := True;

  FHttpRequest := TNetHTTPRequest.Create(NIL);
  FHttpRequest.Client := FHttpClient;
  FHttpRequest.MethodString := 'GET';
end;

destructor TAfipQuery.Destroy;
begin
  FHttpClient.Free;
  FHttpRequest.Free;
  inherited;
end;

function TAfipQuery.DoExecuteRequest(const AService: TServiceType; const Param: string): IHTTPResponse;
begin
  FHttpRequest.URL := FServicesUrl[AService] + Param;
  Result := FHttpRequest.Execute;
end;

function TAfipQuery.DoExecuteRequest(const AService: TServiceType; const Param: string; out RawJson: string): IHTTPResponse;
begin
  Result := DoExecuteRequest(AService, Param);
  RawJson := Result.ContentAsString(TEncoding.UTF8);
end;

function TAfipQuery.ConsultaNroDocumento(const NroDocumento: string): TArray<string>;
var
  AResponse: IHTTPResponse;
  RawJson: string;
begin
  AResponse := DoExecuteRequest(stPersonasDni, NroDocumento, RawJson);
  Result := FParser.JsonToDocumentos(RawJson);
  if Length(Result) = 0 then
    raise EPersonNotFound.Create(RawJson);
end;

function TAfipQuery.ConsultaPersona(const NroDocumento: string): IPersona_Afip;
var
  AResponse: IHTTPResponse;
  RawJson: string;
begin
  AResponse := DoExecuteRequest(stPersona, NroDocumento, RawJson);
  Result := FParser.JsonToPerson(RawJson);
end;

function TAfipQuery.ObtenerConstancia(const Cuit: Int64): TStream;
begin
  Result := ObtenerConstancia(Cuit.ToString);
end;

function TAfipQuery.ObtenerConstancia(const Cuit: string): TStream;
var
  AResponse: IHTTPResponse;
begin
  Result := TMemoryStream.Create;
  AResponse := FHttpClient.Get(FServicesUrl[stConstancia] + Cuit, Result);
end;
{$ENDREGION}

function ConsultaNroDocumento(const NroDocumento: string): TArray<string>;
var
  Afip_API: IApi_Afip;
begin
  Afip_API := TAfipQuery.Create;
  Result := Afip_API.ConsultaNroDocumento(NroDocumento);
end;

function ObtenerConstancia(const Cuit: Int64): TStream;
var
  Afip_API: IApi_Afip;
begin
  Afip_API := TAfipQuery.Create;
  Result := Afip_API.ObtenerConstancia(Cuit);
end;

function ObtenerConstancia(const Cuit: string): TStream;
var
  Afip_API: IApi_Afip;
begin
  Afip_API := TAfipQuery.Create;
  Result := Afip_API.ObtenerConstancia(Cuit);
end;

function ConsultaPersona(const NroDocumento: string): IPersona_Afip;
var
  Afip_API: IApi_Afip;
begin
  Afip_API := TAfipQuery.Create;
  Result := Afip_API.ConsultaPersona(NroDocumento);
end;

end.
