{$I jedi.inc}

unit Afip.PublicAPI.Parsers.lkJson;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// Implements Json parsing using lkJson library
// See more @ http://lkjson.sourceforge.net/

interface

uses
  Afip.PublicAPI.Types,
  Afip.PublicAPI.Parsers;

type
  TlkJsonAfip_Parser = class(TInterfacedObject, IAfip_PersonParser, IAfip_ItemParser)
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
  uLkJSON,
  SysUtils,
  Variants,
  Generics.Collections,
  Windows;

type
{$REGION 'TlkJSONobjectHelper'}
  // la biblioteca lkJson no tiene ningun metodo que retorne Int64
  TlkJSONobjectHelper = class helper for TlkJSONobject
  public
    function getInt64(const FieldName: string): Int64;
  end;
{$ENDREGION}

function TlkJsonAfip_Parser.JsonToDocumentos(const AJson: string): TArray<string>;
var
  I: Integer;
  JsonObject: TlkJSONobject;
  Data: TlkJSONcustomlist;
begin
  JsonObject := TlkJSON.ParseText(AJson) as TlkJSONobject;
  try
    Data := JsonObject.Field['data'] as TlkJSONcustomlist;
    SetLength(Result, Data.Count);
    for I := 0 to Data.Count - 1 do
      Result[I] := Data.Child[0].Value;
  finally
    JsonObject.Free;
  end;
end;

function TlkJsonAfip_Parser.JsonToItems(const AJson: string): TArray<TItem_Afip>;
var
  I: Integer;
  JsonObject: TlkJSONobject;
  Data: TlkJSONcustomlist;
  JsonField: TlkJSONobjectmethod;
begin
  JsonObject := TlkJSON.ParseText(AJson) as TlkJSONobject;
  try
    Data := JsonObject.Field['data'] as TlkJSONcustomlist;
    SetLength(Result, Data.Count);
    for I := 0 to Data.Count - 1 do
    begin
      JsonField := TlkJSONobjectmethod(Data.Child[I].Child[0]);
      Result[I].Id := Data.Child[I].Field[JsonField.Name].Value;

      JsonField := TlkJSONobjectmethod(Data.Child[I].Child[1]);
      Result[I].Descripcion := Data.Child[I].Field[JsonField.Name].Value;
    end;
  finally
    JsonObject.Free;
  end;
end;

function TlkJsonAfip_Parser.JsonToDependencies(const AJson: string): TArray<TDependencia_Afip>;
begin
{ TODO : function TlkJsonAfip_Parser.JsonToDependencies(const AJson: string): TArray<TDependencia_Afip>; }
end;

function TlkJsonAfip_Parser.JsonToPerson(const AJson: string): IPersona_Afip;
var
  JsonObject, Data: TlkJSONobject;
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
{$IFDEF DELPHIXE8_UP}
    AFormatSettings := TFormatSettings.Create;
{$ELSE}
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, AFormatSettings);
{$ENDIF}
    AFormatSettings.DateSeparator := '-';
    AFormatSettings.ShortDateFormat := 'yyyy-mm-dd';
    AFormatSettings.LongDateFormat := 'yyyy-mm-dd';
    Result := StrToDateDef(AInput, 0, AFormatSettings);
  end;

  function ParseArray(AInput: TlkJSONcustomlist): TArray<Integer>;
  var
    I: Integer;
  begin
    if AInput = NIL then
      Exit;

    SetLength(Result, AInput.Count);
    for I := 0 to AInput.Count - 1 do
      Result[I] := AInput.getInt(I);
  end;

  function ParseArrayCategorias(AInput: TlkJSONcustomlist): TArray<TPair<Integer, Integer>>;
  var
    I, IdImpuesto, IdCategoria: Integer;
    LItem: TlkJSONobject;
  begin
    if AInput = NIL then
      Exit;

    SetLength(Result, AInput.Count);
    for I := 0 to AInput.Count - 1 do
    begin
      LItem := AInput.Child[I] as TlkJSONobject;

      try
        IdImpuesto := LItem.Field['idImpuesto'].Value;
        IdCategoria := LItem.Field['idCategoria'].Value;
      except
        Continue;
      end;

      Result[I] := TPair<Integer, Integer>.Create(IdImpuesto, IdCategoria);
    end;
  end;

  function ParseArrayDomicilioFiscal(AInput: TlkJSONcustomlist): TDomicilioFiscal;
  begin
    if AInput = NIL then
      Exit;

    Result.Direccion := AInput.Field['direccion'].Value;
    Result.Localidad := AInput.Field['localidad'].Value;
    Result.CodPostal := AInput.Field['codPostal'].Value;
    Result.IdProvincia := AInput.Field['idProvincia'].Value;
  end;
  {$ENDREGION}
begin
  JsonObject := TlkJSON.ParseText(AJson) as TlkJSONobject;
  try
    // accediendo mediante la clase TPersona_Afip puedo utilizar los setters
    // la interface IPersona_Afip expone las propiedades como solo lectura
    PersonObj := TPersona_Afip.Create(AJson);
    Result := PersonObj;

    if not JsonObject.getBoolean('success') then
      raise EAfipNotFound.Create(AJson);

    Data := JsonObject.Field['data'] as TlkJSONobject;

    PersonObj.IdPersona := Data.getInt64('idPersona');

  {$IFDEF DELPHIXE3_UP}
    PersonObj.TipoPersona := TTipoPersona.Parse(Data.getString('tipoPersona'));
    PersonObj.TipoClave := TTipoClave.Parse(Data.getString('tipoClave'));
  {$ELSE}
    PersonObj.TipoPersona := TTipoPersonaHelper.Parse(Data.getString('tipoPersona'));
    PersonObj.TipoClave := TTipoClaveHelper.Parse(Data.getString('tipoClave'));
  {$ENDIF}

    PersonObj.EstadoClave := ParseBoolean(Data.getString('estadoClave'));
    PersonObj.Nombre := Data.getString('nombre');
    PersonObj.TipoDocumento := Data.getString('tipoDocumento');
    PersonObj.NroDocumento := Data.getString('numeroDocumento');
    PersonObj.FechaInscripcion := ParseDate(Data.getString('fechaInscripcion'));
    PersonObj.FechaContratoSocial := ParseDate(Data.getString('fechaContratoSocial'));
    PersonObj.FechaFallecimiento := ParseDate(Data.getString('fechaFallecimiento'));
    PersonObj.IdDependencia := Data.getInt('idDependencia');
    PersonObj.MesCierre := Data.getInt('mesCierre');
    PersonObj.Impuestos := ParseArray(Data.Field['impuestos'] as TlkJSONcustomlist);
    PersonObj.Actividades := ParseArray(Data.Field['actividades'] as TlkJSONcustomlist);
    PersonObj.Caracterizaciones := ParseArray(Data.Field['caracterizaciones'] as TlkJSONcustomlist);
    PersonObj.CategoriasMonotributo := ParseArrayCategorias(Data.Field['categoriasMonotributo'] as TlkJSONcustomlist);
    PersonObj.DomicilioFiscal := ParseArrayDomicilioFiscal(Data.Field['domicilioFiscal'] as TlkJSONcustomlist);
  finally
    JsonObject.Free;
  end;
end;

{$REGION 'TlkJSONobjectHelper'}
function TlkJSONobjectHelper.getInt64(const FieldName: string): Int64;
var
  jn: TlkJSONnumber;
begin
  jn := Field[FieldName] as TlkJSONnumber;
  if not assigned(jn) then
    Result := 0
  else
    Result := Round(jn.Value);
end;
{$ENDREGION}

end.
