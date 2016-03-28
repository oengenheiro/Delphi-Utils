unit Afip.PublicAPI.Parsers.Native;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// Implements Json parsing using Delphi 10 Seattle System.Json library

interface

uses
  Afip.PublicAPI.Types,
  Afip.PublicAPI.Parsers;

type
  TNativeJsonAfip_Parser = class(TInterfacedObject, IAfip_PersonParser, IAfip_ItemParser)
  public
{$REGION 'IAfip_PersonParser'}
    function JsonToPerson(const AJson: string): IPersona_Afip;
    function JsonToDocumentos(const AJson: string): TArray<string>;
{$ENDREGION}

{$REGION 'IAfip_ItemParser'}
    function JsonToItems(const AJson: string): TArray<TItem_Afip>;
    function JsonToDependencies(const AJson: string): TArray<TDependencia_Afip>;
{$ENDREGION}
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  System.Generics.Collections,
  System.Json,
  System.Json.Types,
  System.Json.Readers;

{$REGION 'TAfip_Parser'}
function TNativeJsonAfip_Parser.JsonToDocumentos(const AJson: string): TArray<string>;
var
  TextReader: TTextReader;
  JsonReader: TJsonReader;
  List: TList<string>;
begin
  List := TList<string>.Create;
  TextReader := TStringReader.Create(AJson);
  try
    JsonReader := TJsonTextReader.Create(TextReader);
    try
      while JsonReader.Read do
      begin
        if JsonReader.TokenType = TJsonToken.Integer then
          List.Add(JsonReader.Value.ToString);
      end;
    finally
      JsonReader.Free;
    end;
  finally
    Result := List.ToArray;
    TextReader.Free;
    List.Free;
  end;
end;

function TNativeJsonAfip_Parser.JsonToItems(const AJson: string): TArray<TItem_Afip>;
var
  TextReader: TTextReader;
  JsonReader: TJsonReader;
  List: TList<TItem_Afip>;
  Item: TItem_Afip;
begin
  List := TList<TItem_Afip>.Create;
  TextReader := TStringReader.Create(AJson);
  try
    JsonReader := TJsonTextReader.Create(TextReader);
    try
      while JsonReader.Read do
      begin
        case JsonReader.TokenType of
          TJsonToken.Integer:
          begin
            Item.Id := JsonReader.Value.AsInteger;
          end;

          TJsonToken.String:
          begin
            Item.Descripcion := JsonReader.Value.ToString;
            List.Add(Item);
          end;
        end;
      end;
    finally
      JsonReader.Free;
    end;
  finally
    Result := List.ToArray;
    TextReader.Free;
    List.Free;
  end;
end;

function TNativeJsonAfip_Parser.JsonToDependencies(const AJson: string): TArray<TDependencia_Afip>;
begin
{ TODO : function TAfip_Parser.JsonToDependencies(const AJson: string): TArray<TDependencia_Afip>; }
end;

function TNativeJsonAfip_Parser.JsonToPerson(const AJson: string): IPersona_Afip;
var
  JObject, JData: TJSONObject;
  JsonValue: TJSONValue;
  PersonObj: TPersona_Afip;

  {$REGION 'procedimientos auxiliares'}
  function ParseBoolean(const AInput: string): Boolean;
  begin
    Result := AInput = 'ACTIVO';
  end;

  function ParseDate(const AInput: string): TDate;
  var
    AFormatSettings: TFormatSettings;
  begin
    AFormatSettings := TFormatSettings.Create;
    AFormatSettings.DateSeparator := '-';
    AFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
    AFormatSettings.LongDateFormat := 'yyyy-mm-dd';
    Result := StrToDate(AInput, AFormatSettings);
  end;

  function ParseArray(AInput: TJSONArray): TArray<Integer>;
  var
    I: Integer;
  begin
    SetLength(Result, AInput.Count);
    for I := 0 to AInput.Count - 1 do
      Result[I] := AInput.Items[I].GetValue<Integer>;
  end;

  function ParseArrayCategorias(AInput: TJSONArray): TArray<TPair<Integer, Integer>>;
  var
    I, IdImpuesto, IdCategoria: Integer;
    LItem: TJSONValue;
  begin
    SetLength(Result, AInput.Count);
    for I := 0 to AInput.Count - 1 do
    begin
      LItem := AInput.Items[I];
      if not LItem.TryGetValue<Integer>('idImpuesto', IdImpuesto) then
        Continue;

      if not LItem.TryGetValue<Integer>('idCategoria', IdCategoria) then
        Continue;

      Result[I] := TPair<Integer, Integer>.Create(IdImpuesto, IdCategoria);
    end;
  end;

  function ParseArrayDomicilioFiscal(AInput: TJSONObject): TDomicilioFiscal;
  var
    AValue: string;
  begin
    AInput.TryGetValue<string>('direccion', AValue);
    Result.Direccion := AValue;

    AInput.TryGetValue<string>('localidad', AValue);
    Result.Localidad := AValue;

    AInput.TryGetValue<string>('codPostal', AValue);
    Result.CodPostal := AValue;

    AInput.TryGetValue<string>('idProvincia', AValue);
    Result.IdProvincia := AValue.ToInteger;
  end;
  {$ENDREGION}

begin
  JObject := TJSONObject(TJSONObject.ParseJSONValue(AJson));
  try
    // accediendo mediante la clase TPersona_Afip puedo utilizar los setters
    // la interface IPersona_Afip expone las propiedades como solo lectura
    PersonObj := TPersona_Afip.Create(AJson);
    Result := PersonObj;
    if not(TJSONBool(JObject.GetValue('success'))).AsBoolean then
      raise EAfipNotFound.Create(AJson);

    JData := TJSONObject(JObject.GetValue('data'));
    if JData = NIL then
      raise EAfipNotFound.Create(AJson);

    JsonValue := JData.GetValue('idPersona');
    if JsonValue <> NIL then
      PersonObj.IdPersona := TJSONNumber(JsonValue).AsInt64;

    JsonValue := JData.GetValue('tipoPersona');
    if JsonValue <> NIL then
      PersonObj.TipoPersona := TTipoPersona.FromString(JsonValue.Value);

    JsonValue := JData.GetValue('tipoClave');
    if JsonValue <> NIL then
      PersonObj.TipoClave := TTipoClave.FromString(JsonValue.Value);

    JsonValue := JData.GetValue('estadoClave');
    if JsonValue <> NIL then
      PersonObj.EstadoClave := ParseBoolean(JsonValue.Value);

    JsonValue := JData.GetValue('nombre');
    if JsonValue <> NIL then
      PersonObj.Nombre := JsonValue.Value;

    JsonValue := JData.GetValue('tipoDocumento');
    if JsonValue <> NIL then
      PersonObj.TipoDocumento := JsonValue.Value;

    JsonValue := JData.GetValue('numeroDocumento');
    if JsonValue <> NIL then
      PersonObj.NroDocumento := JsonValue.Value;

    JsonValue := JData.GetValue('fechaInscripcion');
    if JsonValue <> NIL then
      PersonObj.FechaInscripcion := ParseDate(JsonValue.Value);

    JsonValue := JData.GetValue('fechaContratoSocial');
    if JsonValue <> NIL then
      PersonObj.FechaContratoSocial := ParseDate(JsonValue.Value);

    JsonValue := JData.GetValue('fechaFallecimiento');
    if JsonValue <> NIL then
      PersonObj.FechaFallecimiento := ParseDate(JsonValue.Value);

    JsonValue := JData.GetValue('idDependencia');
    if JsonValue <> NIL then
      PersonObj.IdDependencia := TJSONNumber(JsonValue).AsInt;

    JsonValue := JData.GetValue('mesCierre');
    if JsonValue <> NIL then
      PersonObj.MesCierre := TJSONNumber(JsonValue).AsInt;

    JsonValue := JData.GetValue('impuestos');
    if JsonValue <> NIL then
      PersonObj.Impuestos := ParseArray(TJSONArray(JsonValue));

    JsonValue := JData.GetValue('actividades');
    if JsonValue <> NIL then
      PersonObj.Actividades := ParseArray(TJSONArray(JsonValue));

    JsonValue := JData.GetValue('caracterizaciones');
    if JsonValue <> NIL then
      PersonObj.Caracterizaciones := ParseArray(TJSONArray(JsonValue));

    JsonValue := JData.GetValue('categoriasMonotributo');
    if JsonValue <> NIL then
      PersonObj.CategoriasMonotributo := ParseArrayCategorias(TJSONArray(JsonValue));

    JsonValue := JData.GetValue('domicilioFiscal');
    if JsonValue <> NIL then
      PersonObj.DomicilioFiscal := ParseArrayDomicilioFiscal(TJSONObject(JsonValue));
  finally
    JObject.Free;
  end;
end;
{$ENDREGION}

end.
