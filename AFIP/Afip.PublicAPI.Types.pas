unit Afip.PublicAPI.Types;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections;

type
{$REGION 'Enumerative types and helpers'}
  TTipoPersona = (tpUnknown, tpFisica, tpJuridica);

  TTipoPersonaHelper = record helper for TTipoPersona
  public
    /// <summary>
    ///   Devuelve una representacion en string para el valor de TTipoPersona
    /// </summary>
    class function ToString(const Value: TTipoPersona): string; overload; static;

    /// <summary>
    ///   Devuelve una representacion en string para el valor de TTipoPersona
    /// </summary>
    function ToString: string; overload;

    /// <summary>
    ///   Convierte una expresion string en su equivalente enumerativo
    ///   TTipoPersona
    /// </summary>
    class function FromString(const Value: string): TTipoPersona; static;
  end;

  TTipoClave = (tcUnknown, tpCuit, tpCuil, tpCdi);

  TTipoClaveHelper = record helper for TTipoClave
  public
    /// <summary>
    ///   Devuelve una representacion en string para el valor de TTipoClave
    /// </summary>
    class function ToString(const Value: TTipoClave): string; overload; static;

    /// <summary>
    ///   Devuelve una representacion en string para el valor de TTipoClave
    /// </summary>
    function ToString: string; overload;

    /// <summary>
    ///   Convierte una expresion string en su equivalente enumerativo
    ///   TTipoClave
    /// </summary>
    class function FromString(const Value: string): TTipoClave; static;
  end;
{$ENDREGION}

{$REGION 'Exceptions'}
  /// <summary>
  ///   Excepcion base para heredar, agrega la propiedad RawJson, de esta
  ///   forma, el desarrolador puede consultar el contenido original que
  ///   devolvio la AFIP
  /// </summary>
  EAfipException = class abstract(Exception)
  strict private
    FRawJson: string;
  public
    constructor Create(const ARawJson: string); virtual;
    property RawJson: string read FRawJson;
  end;

  /// <summary>
  ///   Esta excepcion se va a elevar cuando se lanza una busqueda y no se
  ///   encuentra a la persona
  /// </summary>
  EPersonNotFound = class(EAfipException)
  public
    constructor Create(const ARawJson: string); override;
  end;
{$ENDREGION}

{$REGION 'TDomicilioFiscal'}
  TDomicilioFiscal = record
  private
    FLocalidad: string;
    FDireccion: string;
    FIdProvincia: Integer;
    FCodPostal: string;
    FRawJson: string;

    procedure SetCodPostal(const Value: string);
    procedure SetDireccion(const Value: string);
    procedure SetIdProvincia(const Value: Integer);
    procedure SetLocalidad(const Value: string);
    procedure SetRawJson(const Value: string);
  public
    /// <summary>
    ///   Devuelve toda la direccion en una sola linea
    /// </summary>
    function ToString: string;

    /// <summary>
    ///   Calle, numero, piso, departamento, oficina, dato adicional
    /// </summary>
    property Direccion: string read FDireccion write SetDireccion;

    /// <summary>
    ///   Nombre de la localidad. No se informa cuando la provincia es CABA
    ///   (id=0)
    /// </summary>
    property Localidad: string read FLocalidad write SetLocalidad;

    property CodPostal: string read FCodPostal write SetCodPostal;
    property IdProvincia: Integer read FIdProvincia write SetIdProvincia;

    /// <summary>
    ///   Respuesta original AFIP, en formato Json
    /// </summary>
    property RawJson: string read FRawJson write SetRawJson;
  end;
{$ENDREGION}

{$REGION 'IPersona_Afip'}
  IPersona_Afip = interface
    ['{AFA9B722-AFD4-4FFF-91D3-090E3B44F878}']
    function GetActividades: TArray<Integer>;
    function GetCaracterizaciones: TArray<Integer>;
    function GetDomicilioFiscal: TDomicilioFiscal;
    function GetEstadoClave: Boolean;
    function GetFechaContratoSocial: TDate;
    function GetFechaFallecimiento: TDate;
    function GetFechaInscripcion: TDate;
    function GetIdDependencia: Integer;
    function GetIdPersona: Int64;
    function GetImpuestos: TArray<Integer>;
    function GetMesCierre: Integer;
    function GetNombre: string;
    function GetNroDocumento: string;
    function GetRawJson: string;
    function GetTipoClave: TTipoClave;
    function GetTipoDocumento: string;
    function GetTipoPersona: TTipoPersona;
    function GetCategoriasMonotributo: TArray<TPair<Integer, Integer>>;

    /// <summary>
    ///   Puede ser CUIT, CUIL o CDI
    /// </summary>
    property IdPersona: Int64 read GetIdPersona;

    /// <summary>
    ///   Tipo persona. Ver <see cref="Afip.PublicAPI|TTipoPersona" />
    /// </summary>
    property TipoPersona: TTipoPersona read GetTipoPersona;

    /// <summary>
    ///   TipoClave. Ver <see cref="Afip.PublicAPI|TTipoClave" />
    /// </summary>
    property TipoClave: TTipoClave read GetTipoClave;

    /// <summary>
    ///   La clave puede estar Activa o Inactiva
    /// </summary>
    property EstadoClave: Boolean read GetEstadoClave;

    /// <summary>
    ///   Apellido y nombre o razón social <br />
    /// </summary>
    property Nombre: string read GetNombre;

    /// <summary>
    ///   DNI, LC, etc
    /// </summary>
    property TipoDocumento: string read GetTipoDocumento;
    property NroDocumento: string read GetNroDocumento;

    /// <summary>
    ///   Dependencia de AFIP donde está inscripto
    /// </summary>
    property IdDependencia: Integer read GetIdDependencia;

    /// <summary>
    ///   Mes de cierre del ejercicio fiscal
    /// </summary>
    property MesCierre: Integer read GetMesCierre;
    property FechaInscripcion: TDate read GetFechaInscripcion;
    property FechaContratoSocial: TDate read GetFechaContratoSocial;
    property FechaFallecimiento: TDate  read GetFechaFallecimiento;
    property CategoriasMonotributo: TArray<TPair<Integer, Integer>> read GetCategoriasMonotributo;

    /// <summary>
    ///   Ids de los impuestos en los que el contribuyente está inscripto
    ///   excluyendo los que están sujetos a secreto fiscal: 66, 72 y 180
    /// </summary>
    property Impuestos: TArray<Integer> read GetImpuestos;

    /// <summary>
    ///   Ids de las caracterizaciones relacionadas con impuesto 103 Regímenes
    ///   Informativos
    /// </summary>
    property Caracterizaciones: TArray<Integer> read GetCaracterizaciones;

    /// <summary>
    ///   ds de las primeras 8 (ocho) actividades económicas según el orden
    ///   declarado por el contribuyente: primaria, secundarias
    /// </summary>
    property Actividades: TArray<Integer> read GetActividades;

    /// <summary>
    ///   Ver <see cref="Afip.PublicAPI|TDomicilioFiscal" />
    /// </summary>
    property DomicilioFiscal: TDomicilioFiscal read GetDomicilioFiscal;

    /// <summary>
    ///   Respuesta original AFIP, en formato Json
    /// </summary>
    property RawJson: string read GetRawJson;
  end;
{$ENDREGION}

{$REGION 'TPersona_Afip'}
  TPersona_Afip = class(TInterfacedObject, IPersona_Afip)
  strict private
    FCategoriasMonotributo: TArray<TPair<Integer, Integer>>;
    FActividades: TArray<Integer>;
    FCaracterizaciones: TArray<Integer>;
    FDomicilioFiscal: TDomicilioFiscal;
    FEstadoClave: Boolean;
    FFechaContratoSocial: TDate;
    FFechaFallecimiento: TDate;
    FFechaInscripcion: TDate;
    FIdDependencia: Integer;
    FIdPersona: Int64;
    FImpuestos: TArray<Integer>;
    FMesCierre: Integer;
    FNombre: string;
    FNroDocumento: string;
    FRawJson: string;
    FTipoClave: TTipoClave;
    FTipoDocumento: string;
    FTipoPersona: TTipoPersona;

    function GetActividades: TArray<Integer>;
    function GetCaracterizaciones: TArray<Integer>;
    function GetDomicilioFiscal: TDomicilioFiscal;
    function GetEstadoClave: Boolean;
    function GetFechaContratoSocial: TDate;
    function GetFechaFallecimiento: TDate;
    function GetFechaInscripcion: TDate;
    function GetIdDependencia: Integer;
    function GetIdPersona: Int64;
    function GetImpuestos: TArray<Integer>;
    function GetMesCierre: Integer;
    function GetNombre: string;
    function GetNroDocumento: string;
    function GetRawJson: string;
    function GetTipoClave: TTipoClave;
    function GetTipoDocumento: string;
    function GetTipoPersona: TTipoPersona;
    function GetCategoriasMonotributo: TArray<TPair<Integer, Integer>>;

    procedure SetActividades(const Value: TArray<Integer>);
    procedure SetCaracterizaciones(const Value: TArray<Integer>);
    procedure SetDomicilioFiscal(const Value: TDomicilioFiscal);
    procedure SetEstadoClave(const Value: Boolean);
    procedure SetFechaContratoSocial(const Value: TDate);
    procedure SetFechaFallecimiento(const Value: TDate);
    procedure SetFechaInscripcion(const Value: TDate);
    procedure SetIdDependencia(const Value: Integer);
    procedure SetIdPersona(const Value: Int64);
    procedure SetImpuestos(const Value: TArray<Integer>);
    procedure SetMesCierre(const Value: Integer);
    procedure SetNombre(const Value: string);
    procedure SetNroDocumento(const Value: string);
    procedure SetRawJson(const Value: string);
    procedure SetTipoClave(const Value: TTipoClave);
    procedure SetTipoDocumento(const Value: string);
    procedure SetTipoPersona(const Value: TTipoPersona);
    procedure SetCategoriasMonotributo(const Value: TArray<TPair<Integer, Integer>>);
  public
    constructor Create(const ARawJson: string);
    property IdPersona: Int64 read GetIdPersona write SetIdPersona;
    property TipoPersona: TTipoPersona read GetTipoPersona write SetTipoPersona;
    property TipoClave: TTipoClave read GetTipoClave write SetTipoClave;
    property EstadoClave: Boolean read GetEstadoClave write SetEstadoClave;
    property Nombre: string read GetNombre write SetNombre;
    property TipoDocumento: string read GetTipoDocumento write SetTipoDocumento;
    property NroDocumento: string read GetNroDocumento write SetNroDocumento;
    property IdDependencia: Integer read GetIdDependencia write SetIdDependencia;
    property MesCierre: Integer read GetMesCierre write SetMesCierre;
    property FechaInscripcion: TDate read GetFechaInscripcion write SetFechaInscripcion;
    property FechaContratoSocial: TDate read GetFechaContratoSocial write SetFechaContratoSocial;
    property FechaFallecimiento: TDate read GetFechaFallecimiento write SetFechaFallecimiento;
    property CategoriasMonotributo: TArray<TPair<Integer, Integer>> read GetCategoriasMonotributo write SetCategoriasMonotributo;
    property Impuestos: TArray<Integer> read GetImpuestos write SetImpuestos;
    property Caracterizaciones: TArray<Integer> read GetCaracterizaciones write SetCaracterizaciones;
    property Actividades: TArray<Integer> read GetActividades write SetActividades;
    property DomicilioFiscal: TDomicilioFiscal read GetDomicilioFiscal write SetDomicilioFiscal;
    property RawJson: string read GetRawJson write SetRawJson;
  end;
{$ENDREGION}

{$REGION 'IApi_Afip'}
  IApi_Afip = interface
    ['{DA395CEF-8DE0-4F25-88AC-BF584C3719CF}']
    /// <param name="NroDocumento">
    ///   Nro de Documento sobre el que se realiza la consulta
    /// </param>
    /// <returns>
    ///   <para>
    ///     Lista de Id's (cuit, cuil o cdi) de las persona físicas que tiene
    ///     ese número de documento.
    ///   </para>
    ///   <para>
    ///     Excepcionalmente más de una persona podría tener el mismo número
    ///     de documento. <br />
    ///   </para>
    /// </returns>
    function ConsultaNroDocumento(const NroDocumento: string): TArray<string>;

    /// <summary>
    ///   El response contiene un archivo en formato pdf con la Constancia de
    ///   Inscripción emitida por AFIP o con un texto indicando el motivo por
    ///   el cual esa constancia no pudo ser emitida. <br />
    /// </summary>
    /// <param name="Cuit">
    ///   Nro de cuit de la persona, solo númerico
    /// </param>
    function ObtenerConstancia(const Cuit: string): TStream; overload;

    /// <summary>
    ///   El response contiene un archivo en formato pdf con la Constancia de
    ///   Inscripción emitida por AFIP o con un texto indicando el motivo por
    ///   el cual esa constancia no pudo ser emitida. <br />
    /// </summary>
    /// <param name="Cuit">
    ///   Nro de cuit de la persona
    /// </param>
    function ObtenerConstancia(const Cuit: Int64): TStream; overload;

    /// <summary>
    ///   Devuelve información de una persona física o jurídica. <br />
    /// </summary>
    /// <param name="NroDocumento">
    ///   CUIT, CUIL, CDI. Solo formato númerico, sin guiones ni puntos
    /// </param>
    function ConsultaPersona(const NroDocumento: string): IPersona_Afip;
  end;
{$ENDREGION}

implementation

{$REGION 'TPersona_Afip'}
constructor TPersona_Afip.Create(const ARawJson: string);
begin
  inherited Create;
  FRawJson := ARawJson;
end;

function TPersona_Afip.GetActividades: TArray<Integer>;
begin
  Result := FActividades;
end;

function TPersona_Afip.GetCaracterizaciones: TArray<Integer>;
begin
  Result := FCaracterizaciones;
end;

function TPersona_Afip.GetDomicilioFiscal: TDomicilioFiscal;
begin
  Result := FDomicilioFiscal;
end;

function TPersona_Afip.GetEstadoClave: Boolean;
begin
  Result := FEstadoClave;
end;

function TPersona_Afip.GetFechaContratoSocial: TDate;
begin
  Result := FFechaContratoSocial;
end;

function TPersona_Afip.GetFechaFallecimiento: TDate;
begin
  Result := FFechaFallecimiento;
end;

function TPersona_Afip.GetFechaInscripcion: TDate;
begin
  Result := FFechaInscripcion;
end;

function TPersona_Afip.GetIdDependencia: Integer;
begin
  Result := FIdDependencia;
end;

function TPersona_Afip.GetIdPersona: Int64;
begin
  Result := FIdPersona;
end;

function TPersona_Afip.GetImpuestos: TArray<Integer>;
begin
  Result := FImpuestos;
end;

function TPersona_Afip.GetMesCierre: Integer;
begin
  Result := FMesCierre;
end;

function TPersona_Afip.GetNombre: string;
begin
  Result := FNombre;
end;

function TPersona_Afip.GetNroDocumento: string;
begin
  Result := FNroDocumento;
end;

function TPersona_Afip.GetRawJson: string;
begin
  Result := FRawJson;
end;

function TPersona_Afip.GetTipoClave: TTipoClave;
begin
  Result := FTipoClave;
end;

function TPersona_Afip.GetTipoDocumento: string;
begin
  Result := FTipoDocumento;
end;

function TPersona_Afip.GetTipoPersona: TTipoPersona;
begin
  Result := FTipoPersona;
end;

function TPersona_Afip.GetCategoriasMonotributo: TArray<TPair<Integer, Integer>>;
begin
  Result := FCategoriasMonotributo;
end;

procedure TPersona_Afip.SetActividades(const Value: TArray<Integer>);
begin
  FActividades := Value;
end;

procedure TPersona_Afip.SetCaracterizaciones(const Value: TArray<Integer>);
begin
  FCaracterizaciones := Value;
end;

procedure TPersona_Afip.SetCategoriasMonotributo(const Value: TArray <TPair<Integer, Integer>>);
begin
  FCategoriasMonotributo := Value;
end;

procedure TPersona_Afip.SetDomicilioFiscal(const Value: TDomicilioFiscal);
begin
  FDomicilioFiscal := Value;
end;

procedure TPersona_Afip.SetEstadoClave(const Value: Boolean);
begin
  FEstadoClave := Value;
end;

procedure TPersona_Afip.SetFechaContratoSocial(const Value: TDate);
begin
  FFechaContratoSocial := Value;
end;

procedure TPersona_Afip.SetFechaFallecimiento(const Value: TDate);
begin
  FFechaFallecimiento := Value;
end;

procedure TPersona_Afip.SetFechaInscripcion(const Value: TDate);
begin
  FFechaInscripcion := Value;
end;

procedure TPersona_Afip.SetIdDependencia(const Value: Integer);
begin
  FIdDependencia := Value;
end;

procedure TPersona_Afip.SetIdPersona(const Value: Int64);
begin
  FIdPersona := Value;
end;

procedure TPersona_Afip.SetImpuestos(const Value: TArray<Integer>);
begin
  FImpuestos := Value;
end;

procedure TPersona_Afip.SetMesCierre(const Value: Integer);
begin
  FMesCierre := Value;
end;

procedure TPersona_Afip.SetNombre(const Value: string);
begin
  FNombre := Value;
end;

procedure TPersona_Afip.SetNroDocumento(const Value: string);
begin
  FNroDocumento := Value;
end;

procedure TPersona_Afip.SetRawJson(const Value: string);
begin
  FRawJson := Value;
end;

procedure TPersona_Afip.SetTipoClave(const Value: TTipoClave);
begin
  FTipoClave := Value;
end;

procedure TPersona_Afip.SetTipoDocumento(const Value: string);
begin
  FTipoDocumento := Value;
end;

procedure TPersona_Afip.SetTipoPersona(const Value: TTipoPersona);
begin
  FTipoPersona := Value;
end;
{$ENDREGION}

{$REGION 'TDomicilioFiscal'}
procedure TDomicilioFiscal.SetCodPostal(const Value: string);
begin
  FCodPostal := Value;
end;

procedure TDomicilioFiscal.SetDireccion(const Value: string);
begin
  FDireccion := Value;
end;

procedure TDomicilioFiscal.SetIdProvincia(const Value: Integer);
begin
  FIdProvincia := Value;
end;

procedure TDomicilioFiscal.SetLocalidad(const Value: string);
begin
  FLocalidad := Value;
end;

procedure TDomicilioFiscal.SetRawJson(const Value: string);
begin
  FRawJson := Value;
end;

function TDomicilioFiscal.ToString: string;
begin
  Result := Direccion + ', ' + Localidad + ', ' + CodPostal;
end;

{$ENDREGION}

{ TTipoPersonaHelper }

class function TTipoPersonaHelper.FromString(const Value: string): TTipoPersona;
var
  AResult: TTipoPersona;
begin
  for AResult := Low(TTipoPersona) to High(TTipoPersona) do
  begin
    if CompareText(Value, AResult.ToString) = 0 then
      Exit(AResult);
  end;

  Result := tpUnknown;
end;

class function TTipoPersonaHelper.ToString(const Value: TTipoPersona): string;
begin
  case Value of
    tpFisica: Result := 'Fisica';
    tpJuridica: Result := 'Juridica';
  else
    Result := 'Unknown';
  end;
end;

function TTipoPersonaHelper.ToString: string;
begin
  Result := ToString(Self);
end;

{ TTipoClaveHelper }

class function TTipoClaveHelper.FromString(const Value: string): TTipoClave;
var
  AResult: TTipoClave;
begin
  for AResult := Low(TTipoClave) to High(TTipoClave) do
  begin
    if Value = AResult.ToString  then
      Exit(AResult);
  end;

  Result := tcUnknown;
end;

class function TTipoClaveHelper.ToString(const Value: TTipoClave): string;
begin
  case Value of
    tpCuit: Result := 'CUIT';
    tpCuil: Result := 'CUIL';
    tpCdi: Result := 'CDI';
  else
    Result := 'Unknown';
  end;
end;

function TTipoClaveHelper.ToString: string;
begin
  Result := ToString(Self);
end;

{$REGION 'Exceptions'}
constructor EAfipException.Create(const ARawJson: string);
begin
  inherited;
  FRawJson := ARawJson;
end;

constructor EPersonNotFound.Create(const ARawJson: string);
begin
  inherited;
  Message := 'No se encontraron resultados';
end;
{$ENDREGION}

end.
