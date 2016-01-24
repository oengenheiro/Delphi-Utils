unit Afip.PublicAPI;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// Implements IApi_Afip via the TNetHTTPClient and TNetHTTPRequest classes
// See Afip.PublicAPI.Types

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
    TServiceType = (stPersona, stPersonasDni, stConstancia, stImpuestos, stConceptos, stCaracterizaciones,
      stCatMonotributo, stCatAutonomo, stActividades, stProvincias, stDependencias);
  strict private
    FPersister: IPersister_Afip;
    FPersonParser: IAfip_PersonParser;
    FItemsParser: IAfip_ItemParser;
    FHttpClient: TNetHTTPClient;
    FHttpRequest: TNetHTTPRequest;
    FServicesUrl: array [TServiceType] of string;

    function GetHasPersister: Boolean;
    function GetPersister: IPersister_Afip;

    function DoExecuteRequest(const AService: TServiceType; const Param: string): IHTTPResponse; overload;
    function DoExecuteRequest(const AService: TServiceType; const Param: string; out RawJson: string): IHTTPResponse; overload;
  public
    constructor Create(const APersister: IPersister_Afip = NIL);
    destructor Destroy; override;

    function ConsultaNroDocumento(const NroDocumento: string): TArray<string>; overload;
    function ObtenerConstancia(const Cuit: string): TStream; overload;
    function ObtenerConstancia(const Cuit: Int64): TStream; overload;
    function ConsultaPersona(const NroDocumento: string): IPersona_Afip; overload;

    function GetImpuestos(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
    function GetConceptos(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
    function GetCaracterizaciones(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
    function GetCategoriasMonotributo(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
    function GetCategoriasAutonomo(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
    function GetActividades(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
    function GetProvincias(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
    function GetDependecias(const GetFromPersistent: Boolean): TArray<TDependencia_Afip>;

    property Persister: IPersister_Afip read GetPersister;
    property HasPersister: Boolean read GetHasPersister;
  end;
{$ENDREGION}

// estas funciones mapean a las mismas provistas por la clase; es para usarlas de forma static,
// es decir, como si fueran funciones de clase
function ConsultaNroDocumento(const NroDocumento: string): TArray<string>; overload;
function ObtenerConstancia(const Cuit: string): TStream; overload;
function ObtenerConstancia(const Cuit: Int64): TStream; overload;
function ConsultaPersona(const NroDocumento: string): IPersona_Afip; overload;
function GetImpuestos(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
function GetConceptos(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
function GetCaracterizaciones(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
function GetCategoriasMonotributo(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
function GetCategoriasAutonomo(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
function GetActividades(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
function GetProvincias(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
function GetDependecias(const GetFromPersistent: Boolean): TArray<TDependencia_Afip>;

implementation

uses
  System.SysUtils;

{$REGION 'TAfipQuery'}
constructor TAfipQuery.Create(const APersister: IPersister_Afip = NIL);
const
  BASE_URL = 'https://soa.afip.gob.ar';
  URL_PADRON_V1 = BASE_URL + '/sr-padron/v2/';
  URL_PADRON_V2 = BASE_URL + '/sr-padron/v1/';
  URL_PARAMETROS_V1 = BASE_URL + '/parametros/v1/';
  URL_PARAMETROS_V2 = BASE_URL + '/parametros/v2/';
begin
  inherited Create;
  FPersonParser := TAfip_Parser.Create;
  FItemsParser := TAfip_Parser.Create;
  if APersister <> NIL then
    FPersister := APersister;

  FServicesUrl[stPersona] := URL_PADRON_V2 + 'persona/';
  FServicesUrl[stPersonasDni] := URL_PADRON_V2 + 'personas/';
  FServicesUrl[stConstancia] := URL_PADRON_V1 + 'constancia/';
  FServicesUrl[stImpuestos] := URL_PARAMETROS_V1 + 'impuestos';
  FServicesUrl[stConceptos] := URL_PARAMETROS_V1 + 'conceptos';
  FServicesUrl[stCaracterizaciones] := URL_PARAMETROS_V1 + 'caracterizaciones';
  FServicesUrl[stCatMonotributo] := URL_PARAMETROS_V1 + 'categoriasMonotributo';
  FServicesUrl[stCatAutonomo] := URL_PARAMETROS_V1 + 'categoriasAutonomo';
  FServicesUrl[stActividades] := URL_PARAMETROS_V1 + 'actividades';
  FServicesUrl[stProvincias] := URL_PARAMETROS_V1 + 'provincias';
  FServicesUrl[stDependencias] := URL_PARAMETROS_V2 + 'dependencias';

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

function TAfipQuery.GetHasPersister: Boolean;
begin
  Result := FPersister <> NIL;
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
  Result := FPersonParser.JsonToDocumentos(RawJson);
  if Length(Result) = 0 then
    raise EAfipNotFound.Create(RawJson);
end;

function TAfipQuery.ConsultaPersona(const NroDocumento: string): IPersona_Afip;
var
  AResponse: IHTTPResponse;
  RawJson: string;
begin
  AResponse := DoExecuteRequest(stPersona, NroDocumento, RawJson);
  Result := FPersonParser.JsonToPerson(RawJson);
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
  if Result.Size = 0 then
    raise EConstanciaNotFound.Create;
end;

function TAfipQuery.GetActividades(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
var
  AResponse: IHTTPResponse;
  RawJson: string;
begin
  if GetFromPersistent and HasPersister then
  begin
    try
      // try to get data from cache
      Exit(Persister.GetActividades);
    except
      on E: EAfipPersistanceEmpty do
      begin
        // we can eat this exception, we must get the data from WebService
      end;

      on E: Exception do
        raise E;
    end;
  end;

  AResponse := DoExecuteRequest(stActividades, EmptyStr, RawJson);
  Result := FItemsParser.JsonToItems(RawJson);

  if HasPersister then
    Persister.AddActividades(Result);
end;

function TAfipQuery.GetCaracterizaciones(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
var
  AResponse: IHTTPResponse;
  RawJson: string;
begin
  if GetFromPersistent and HasPersister then
  begin
    try
      // try to get data from cache
      Exit(Persister.GetCaracterizaciones);
    except
      on E: EAfipPersistanceEmpty do
      begin
        // we can eat this exception, we must get the data from WebService
      end;

      on E: Exception do
        raise E;
    end;
  end;

  AResponse := DoExecuteRequest(stCaracterizaciones, EmptyStr, RawJson);
  Result := FItemsParser.JsonToItems(RawJson);

  if HasPersister then
    Persister.AddCaracterizaciones(Result);
end;

function TAfipQuery.GetCategoriasAutonomo(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
var
  AResponse: IHTTPResponse;
  RawJson: string;
begin
  if GetFromPersistent and HasPersister then
  begin
    try
      // try to get data from cache
      Exit(Persister.GetCategoriasAutonomo);
    except
      on E: EAfipPersistanceEmpty do
      begin
        // we can eat this exception, we must get the data from WebService
      end;

      on E: Exception do
        raise E;
    end;
  end;

  AResponse := DoExecuteRequest(stCatAutonomo, EmptyStr, RawJson);
  Result := FItemsParser.JsonToItems(RawJson);

  if HasPersister then
    Persister.AddCategoriasAutonomo(Result);
end;

function TAfipQuery.GetCategoriasMonotributo(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
var
  AResponse: IHTTPResponse;
  RawJson: string;
begin
  if GetFromPersistent and HasPersister then
  begin
    try
      // try to get data from cache
      Exit(Persister.GetCategoriasMonotributo);
    except
      on E: EAfipPersistanceEmpty do
      begin
        // we can eat this exception, we must get the data from WebService
      end;

      on E: Exception do
        raise E;
    end;
  end;

  AResponse := DoExecuteRequest(stCatMonotributo, EmptyStr, RawJson);
  Result := FItemsParser.JsonToItems(RawJson);

  if HasPersister then
    Persister.AddCategoriasMonotributo(Result);
end;

function TAfipQuery.GetConceptos(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
var
  AResponse: IHTTPResponse;
  RawJson: string;
begin
  if GetFromPersistent and HasPersister then
  begin
    try
      // try to get data from cache
      Exit(Persister.GetConceptos);
    except
      on E: EAfipPersistanceEmpty do
      begin
        // we can eat this exception, we must get the data from WebService
      end;

      on E: Exception do
        raise E;
    end;
  end;

  AResponse := DoExecuteRequest(stConceptos, EmptyStr, RawJson);
  Result := FItemsParser.JsonToItems(RawJson);

  if HasPersister then
    Persister.AddConceptos(Result);
end;

function TAfipQuery.GetDependecias(const GetFromPersistent: Boolean): TArray<TDependencia_Afip>;
var
  AResponse: IHTTPResponse;
  RawJson: string;
begin
  if GetFromPersistent and HasPersister then
  begin
    try
      // try to get data from cache
      Exit(Persister.GetDependecias);
    except
      on E: EAfipPersistanceEmpty do
      begin
        // we can eat this exception, we must get the data from WebService
      end;

      on E: Exception do
        raise E;
    end;
  end;

  AResponse := DoExecuteRequest(stDependencias, EmptyStr, RawJson);
  Result := FItemsParser.JsonToDependencies(RawJson);

  if HasPersister then
    Persister.AddDependecias(Result);
end;

function TAfipQuery.GetImpuestos(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
var
  AResponse: IHTTPResponse;
  RawJson: string;
begin
  if GetFromPersistent and HasPersister then
  begin
    try
      // try to get data from cache
      Exit(Persister.GetImpuestos);
    except
      on E: EAfipPersistanceEmpty do
      begin
        // we can eat this exception, we must get the data from WebService
      end;

      on E: Exception do
        raise E;
    end;
  end;
  AResponse := DoExecuteRequest(stImpuestos, EmptyStr, RawJson);
  Result := FItemsParser.JsonToItems(RawJson);

  if HasPersister then
    Persister.AddImpuestos(Result);
end;

function TAfipQuery.GetPersister: IPersister_Afip;
begin
  if not HasPersister then
    raise Exception.Create('No persister assigned');

  Result := FPersister;
end;

function TAfipQuery.GetProvincias(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
var
  AResponse: IHTTPResponse;
  RawJson: string;
begin
  if GetFromPersistent and HasPersister then
  begin
    try
      // try to get data from cache
      Exit(Persister.GetProvincias);
    except
      on E: EAfipPersistanceEmpty do
      begin
        // we can eat this exception, we must get the data from WebService
      end;

      on E: Exception do
        raise E;
    end;
  end;

  AResponse := DoExecuteRequest(stProvincias, EmptyStr, RawJson);
  Result := FItemsParser.JsonToItems(RawJson);

  if HasPersister then
    Persister.AddProvincias(Result);
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

function GetImpuestos(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
var
  Afip_API: IApi_Afip;
begin
  Afip_API := TAfipQuery.Create;
  Result := Afip_API.GetImpuestos(GetFromPersistent);
end;

function GetConceptos(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
var
  Afip_API: IApi_Afip;
begin
  Afip_API := TAfipQuery.Create;
  Result := Afip_API.GetConceptos(GetFromPersistent);
end;

function GetCaracterizaciones(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
var
  Afip_API: IApi_Afip;
begin
  Afip_API := TAfipQuery.Create;
  Result := Afip_API.GetCaracterizaciones(GetFromPersistent);
end;

function GetCategoriasMonotributo(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
var
  Afip_API: IApi_Afip;
begin
  Afip_API := TAfipQuery.Create;
  Result := Afip_API.GetCategoriasMonotributo(GetFromPersistent);
end;

function GetCategoriasAutonomo(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
var
  Afip_API: IApi_Afip;
begin
  Afip_API := TAfipQuery.Create;
  Result := Afip_API.GetCategoriasAutonomo(GetFromPersistent);
end;

function GetActividades(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
var
  Afip_API: IApi_Afip;
begin
  Afip_API := TAfipQuery.Create;
  Result := Afip_API.GetActividades(GetFromPersistent);
end;

function GetProvincias(const GetFromPersistent: Boolean): TArray<TItem_Afip>;
var
  Afip_API: IApi_Afip;
begin
  Afip_API := TAfipQuery.Create;
  Result := Afip_API.GetProvincias(GetFromPersistent);
end;

function GetDependecias(const GetFromPersistent: Boolean): TArray<TDependencia_Afip>;
var
  Afip_API: IApi_Afip;
begin
  Afip_API := TAfipQuery.Create;
  Result := Afip_API.GetDependecias(GetFromPersistent);
end;

end.
