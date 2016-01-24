unit Afip.PublicAPI.Persistance;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// Implements IPersister_Afip as an in-memory cache for IApi_Afip using collections
// See Afip.PublicAPI.Types

interface

uses
  Afip.PublicAPI.Types,
  System.Generics.Collections;

type
{$REGION 'TMemoryAfipPersister'}
  TMemoryAfipPersister = class(TInterfacedObject, IPersister_Afip)
  private type
    // the TAfipDictionary dictionary will store items as pair of Integer, string, where the Integer is the Id of the
    // TItem_Afip record, and the string, the description
    TAfipDictionary = TDictionary<Integer, string>;

    TDependenciesDictionary = TDictionary<Integer, TDependencia_Afip>;
  strict private
    FProvincias: TAfipDictionary;
    FConceptos: TAfipDictionary;
    FActividades: TAfipDictionary;
    FCategoriasAutonomo: TAfipDictionary;
    FCategoriasMonotributo: TAfipDictionary;
    FCaracterizaciones: TAfipDictionary;
    FImpuestos: TAfipDictionary;
    FDependencias: TDependenciesDictionary;

    function DoGetFrom(ADictionary: TAfipDictionary): TArray<TItem_Afip>; overload;
    function DoGetFrom(ADictionary: TDependenciesDictionary): TArray<TDependencia_Afip>; overload;

    procedure DoAddItems(ADictionary: TAfipDictionary; const Items: TArray<TItem_Afip>); overload;
    procedure DoAddItems(ADictionary: TDependenciesDictionary; const Items: TArray<TDependencia_Afip>); overload;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Clear;

    function GetDescripcionProvincia(const AId: Integer): string;
    function GetDescripcionConcepto(const AId: Integer): string;
    function GetDescripcionActividad(const AId: Integer): string;
    function GetDescripcionCategoriaAutonomo(const AId: Integer): string;
    function GetDescripcionCategoriaMonotributo(const AId: Integer): string;
    function GetDescripcionCaracterizaciones(const AId: Integer): string;
    function GetDescripcionImpuesto(const AId: Integer): string;
    function GetDependencia(const AId: Integer): TDependencia_Afip;

    procedure AddDescripcionProvincia(const AId: Integer; const ADescripcion: string);
    procedure AddDescripcionConcepto(const AId: Integer; const ADescripcion: string);
    procedure AddDescripcionActividad(const AId: Integer; const ADescripcion: string);
    procedure AddDescripcionCategoriaAutonomo(const AId: Integer; const ADescripcion: string);
    procedure AddDescripcionCategoriaMonotributo(const AId: Integer; const ADescripcion: string);
    procedure AddDescripcionCaracterizaciones(const AId: Integer; const ADescripcion: string);
    procedure AddDescripcionImpuestos(const AId: Integer; const ADescripcion: string);
    procedure AddDependencia(const AId: Integer; const ADependencia: TDependencia_Afip);

    function GetImpuestos: TArray<TItem_Afip>;
    function GetConceptos: TArray<TItem_Afip>;
    function GetCaracterizaciones: TArray<TItem_Afip>;
    function GetCategoriasMonotributo: TArray<TItem_Afip>;
    function GetCategoriasAutonomo: TArray<TItem_Afip>;
    function GetActividades: TArray<TItem_Afip>;
    function GetProvincias: TArray<TItem_Afip>;
    function GetDependecias: TArray<TDependencia_Afip>;

    procedure AddImpuestos(const Items: TArray<TItem_Afip>);
    procedure AddConceptos(const Items: TArray<TItem_Afip>);
    procedure AddCaracterizaciones(const Items: TArray<TItem_Afip>);
    procedure AddCategoriasMonotributo(const Items: TArray<TItem_Afip>);
    procedure AddCategoriasAutonomo(const Items: TArray<TItem_Afip>);
    procedure AddActividades(const Items: TArray<TItem_Afip>);
    procedure AddProvincias(const Items: TArray<TItem_Afip>);
    procedure AddDependecias(const Items: TArray<TDependencia_Afip>);
  end;
{$ENDREGION}

implementation

{$REGION 'TMemoryAfipPersister'}
constructor TMemoryAfipPersister.Create;
begin
  inherited;
  FProvincias := TAfipDictionary.Create;
  FConceptos := TAfipDictionary.Create;
  FActividades := TAfipDictionary.Create;
  FCategoriasAutonomo := TAfipDictionary.Create;
  FCategoriasMonotributo := TAfipDictionary.Create;
  FCaracterizaciones := TAfipDictionary.Create;
  FImpuestos := TAfipDictionary.Create;
  FDependencias := TDependenciesDictionary.Create;
end;

destructor TMemoryAfipPersister.Destroy;
begin
  FProvincias.Free;
  FConceptos.Free;
  FActividades.Free;
  FCategoriasAutonomo.Free;
  FCategoriasMonotributo.Free;
  FCaracterizaciones.Free;
  FImpuestos.Free;
  FDependencias.Free;
  inherited;
end;

procedure TMemoryAfipPersister.Clear;
begin
  FProvincias.Clear;
  FConceptos.Clear;
  FActividades.Clear;
  FCategoriasAutonomo.Clear;
  FCategoriasMonotributo.Clear;
  FCaracterizaciones.Clear;
  FImpuestos.Clear;
  FDependencias.Clear;
end;

procedure TMemoryAfipPersister.AddActividades(const Items: TArray<TItem_Afip>);
begin
  DoAddItems(FActividades, Items);
end;

procedure TMemoryAfipPersister.AddCaracterizaciones(const Items: TArray<TItem_Afip>);
begin
  DoAddItems(FCaracterizaciones, Items);
end;

procedure TMemoryAfipPersister.AddCategoriasAutonomo(const Items: TArray<TItem_Afip>);
begin
  DoAddItems(FCategoriasAutonomo, Items);
end;

procedure TMemoryAfipPersister.AddCategoriasMonotributo(const Items: TArray<TItem_Afip>);
begin
  DoAddItems(FCategoriasMonotributo, Items);
end;

procedure TMemoryAfipPersister.AddConceptos(const Items: TArray<TItem_Afip>);
begin
  DoAddItems(FConceptos, Items);
end;

procedure TMemoryAfipPersister.AddDependecias(const Items: TArray<TDependencia_Afip>);
begin
  DoAddItems(FDependencias, Items);
end;

procedure TMemoryAfipPersister.AddImpuestos(const Items: TArray<TItem_Afip>);
begin
  DoAddItems(FImpuestos, Items);
end;

procedure TMemoryAfipPersister.AddProvincias(const Items: TArray<TItem_Afip>);
begin
  DoAddItems(FProvincias, Items);
end;

procedure TMemoryAfipPersister.AddDependencia(const AId: Integer; const ADependencia: TDependencia_Afip);
begin
  FDependencias.Add(AId, ADependencia);
end;

procedure TMemoryAfipPersister.AddDescripcionActividad(const AId: Integer; const ADescripcion: string);
begin
  FActividades.Add(AId, ADescripcion);
end;

procedure TMemoryAfipPersister.AddDescripcionCaracterizaciones(const AId: Integer; const ADescripcion: string);
begin
  FCaracterizaciones.Add(AId, ADescripcion);
end;

procedure TMemoryAfipPersister.AddDescripcionCategoriaAutonomo(const AId: Integer; const ADescripcion: string);
begin
  FCategoriasAutonomo.Add(AId, ADescripcion);
end;

procedure TMemoryAfipPersister.AddDescripcionCategoriaMonotributo(const AId: Integer; const ADescripcion: string);
begin
  FCategoriasMonotributo.Add(AId, ADescripcion);
end;

procedure TMemoryAfipPersister.AddDescripcionConcepto(const AId: Integer; const ADescripcion: string);
begin
  FConceptos.Add(AId, ADescripcion);
end;

procedure TMemoryAfipPersister.AddDescripcionImpuestos(const AId: Integer; const ADescripcion: string);
begin
  FImpuestos.Add(AId, ADescripcion);
end;

procedure TMemoryAfipPersister.AddDescripcionProvincia(const AId: Integer; const ADescripcion: string);
begin
  FProvincias.Add(AId, ADescripcion);
end;

function TMemoryAfipPersister.GetDependencia(const AId: Integer): TDependencia_Afip;
begin
  if not FDependencias.TryGetValue(AId, Result) then
    raise EAfipPersistanceNotFound.Create('Dependencia', AId);
end;

function TMemoryAfipPersister.GetDescripcionActividad(const AId: Integer): string;
begin
  if not FActividades.TryGetValue(AId, Result) then
    raise EAfipPersistanceNotFound.Create('Actividad', AId);
end;

function TMemoryAfipPersister.GetDescripcionCaracterizaciones(const AId: Integer): string;
begin
  if not FCaracterizaciones.TryGetValue(AId, Result) then
    raise EAfipPersistanceNotFound.Create('Caracterizacion', AId);
end;

function TMemoryAfipPersister.GetDescripcionCategoriaAutonomo(const AId: Integer): string;
begin
  if not FCategoriasAutonomo.TryGetValue(AId, Result) then
    raise EAfipPersistanceNotFound.Create('CategoriaAutonomo', AId);
end;

function TMemoryAfipPersister.GetDescripcionCategoriaMonotributo(const AId: Integer): string;
begin
  if not FCategoriasMonotributo.TryGetValue(AId, Result) then
    raise EAfipPersistanceNotFound.Create('CategoriaMonotributo', AId);
end;

function TMemoryAfipPersister.GetDescripcionConcepto(const AId: Integer): string;
begin
  if not FConceptos.TryGetValue(AId, Result) then
    raise EAfipPersistanceNotFound.Create('Concepto', AId);
end;

function TMemoryAfipPersister.GetDescripcionImpuesto(const AId: Integer): string;
begin
  if not FImpuestos.TryGetValue(AId, Result) then
    raise EAfipPersistanceNotFound.Create('Impuesto', AId);
end;

function TMemoryAfipPersister.GetDescripcionProvincia(const AId: Integer): string;
begin
  if not FProvincias.TryGetValue(AId, Result) then
    raise EAfipPersistanceNotFound.Create('Provincias', AId);
end;

procedure TMemoryAfipPersister.DoAddItems(ADictionary: TAfipDictionary; const Items: TArray<TItem_Afip>);
var
  LItem: TItem_Afip;
begin
  for LItem in Items do
    ADictionary.Add(LItem.Id, LItem.Descripcion);
end;

procedure TMemoryAfipPersister.DoAddItems(ADictionary: TDependenciesDictionary; const Items: TArray<TDependencia_Afip>);
var
  LItem: TDependencia_Afip;
begin
  for LItem in Items do
    ADictionary.Add(LItem.Id, LItem);
end;

function TMemoryAfipPersister.DoGetFrom(ADictionary: TDependenciesDictionary): TArray<TDependencia_Afip>;
var
  I: Integer;
  Keys: TArray<Integer>;
  Values: TArray<TDependencia_Afip>;
begin
  if ADictionary.Count = 0 then
    raise EAfipPersistanceEmpty.Create('No data in cache');

  Keys := ADictionary.Keys.ToArray;
  Values := ADictionary.Values.ToArray;

  SetLength(Result, ADictionary.Count);
  for I := 0 to ADictionary.Count - 1 do
  begin
    Result[I].Id := Keys[I];
    Result[I] := Values[I];
  end;
end;

function TMemoryAfipPersister.DoGetFrom(ADictionary: TAfipDictionary): TArray<TItem_Afip>;
var
  I: Integer;
  Keys: TArray<Integer>;
  Values: TArray<string>;
begin
  if ADictionary.Count = 0 then
    raise EAfipPersistanceEmpty.Create('No data in cache');

  Keys := ADictionary.Keys.ToArray;
  Values := ADictionary.Values.ToArray;

  SetLength(Result, ADictionary.Count);
  for I := 0 to ADictionary.Count - 1 do
  begin
    Result[I].Id := Keys[I];
    Result[I].Descripcion := Values[I];
  end;
end;

function TMemoryAfipPersister.GetActividades: TArray<TItem_Afip>;
begin
  Result := DoGetFrom(FActividades);
end;

function TMemoryAfipPersister.GetCaracterizaciones: TArray<TItem_Afip>;
begin
  Result := DoGetFrom(FCaracterizaciones);
end;

function TMemoryAfipPersister.GetCategoriasAutonomo: TArray<TItem_Afip>;
begin
  Result := DoGetFrom(FCategoriasAutonomo);
end;

function TMemoryAfipPersister.GetCategoriasMonotributo: TArray<TItem_Afip>;
begin
  Result := DoGetFrom(FCategoriasMonotributo);
end;

function TMemoryAfipPersister.GetConceptos: TArray<TItem_Afip>;
begin
  Result := DoGetFrom(FConceptos);
end;

function TMemoryAfipPersister.GetImpuestos: TArray<TItem_Afip>;
begin
  Result := DoGetFrom(FImpuestos);
end;

function TMemoryAfipPersister.GetProvincias: TArray<TItem_Afip>;
begin
  Result := DoGetFrom(FProvincias);
end;

function TMemoryAfipPersister.GetDependecias: TArray<TDependencia_Afip>;
begin
  Result := DoGetFrom(FDependencias);
end;
{$ENDREGION}

end.
