unit MainForm;

interface

uses
  System.Classes,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.Controls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Dialogs;

type
  TMain = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    btnQueryPersona: TButton;
    MemoQueryPersona: TMemo;
    edNroCuit: TLabeledEdit;
    MemoQueryDni: TMemo;
    btnQueryDni: TButton;
    edNroDni: TLabeledEdit;
    TabSheet3: TTabSheet;
    btnObtenerConstancia: TButton;
    SaveDialog1: TSaveDialog;
    edCuitConstancia: TLabeledEdit;
    MemoRawJsonPersona: TMemo;
    TabSheet4: TTabSheet;
    memoParametros: TMemo;
    btnGetParametros: TButton;
    cbParametros: TComboBox;
    lbTime: TLabel;
    procedure btnQueryPersonaClick(Sender: TObject);
    procedure btnQueryDniClick(Sender: TObject);
    procedure btnObtenerConstanciaClick(Sender: TObject);
    procedure btnGetParametrosClick(Sender: TObject);
  strict private
    procedure DoGetParametros(const AText: string);
  end;

var
  Main: TMain;

implementation

{$R *.dfm}

uses
  RTL.Benchmark,
  Afip.PublicAPI,
  Afip.PublicAPI.Types,
  Afip.PublicAPI.Persistance,
  System.SysUtils,
  System.Generics.Collections;

var
  Api: IApi_Afip;

function ParseArray(Input: TArray<Integer>): string;
var
  s: Integer;
begin
  for s in Input do
  begin
    if Result = EmptyStr then
      Result := s.ToString
    else
      Result := Result + ', ' + s.ToString;
  end;
end;

function ParseArrayCategorias(Input: TArray<TPair<Integer, Integer>>): string;
var
  LPair: TPair<Integer, Integer>;
  AString: string;
begin
  for LPair in Input do
  begin
    AString := Format('[%d, %d]', [LPair.Key, LPair.Value]);
    if Result = EmptyStr then
      Result := AString
    else
      Result := Result + ' - ' + AString;
  end;
end;

procedure TMain.btnQueryPersonaClick(Sender: TObject);
var
  Api: IApi_Afip;
  Persona: IPersona_Afip;
begin
  Api := TAfipQuery.Create;
  Persona := Api.ConsultaPersona(edNroCuit.Text);
  MemoRawJsonPersona.Text := Persona.RawJson;
  MemoQueryPersona.Clear;
  MemoQueryPersona.Lines.Add('IdPersona = ' + Persona.IdPersona.ToString);
  MemoQueryPersona.Lines.Add('TipoPersona = ' + Persona.TipoPersona.ToString);
  MemoQueryPersona.Lines.Add('TipoClave = ' + Persona.TipoClave.ToString);
  MemoQueryPersona.Lines.Add('EstadoClave = ' + Persona.EstadoClave.ToString(TUseBoolStrs.True));
  MemoQueryPersona.Lines.Add('Nombre = ' + Persona.Nombre);
  MemoQueryPersona.Lines.Add('TipoDocumento = ' + Persona.TipoDocumento);
  MemoQueryPersona.Lines.Add('NumeroDocumento = ' + Persona.NroDocumento);
  MemoQueryPersona.Lines.Add('IdDependencia = ' + Persona.IdDependencia.ToString);
  MemoQueryPersona.Lines.Add('MesCierre = ' + Persona.MesCierre.ToString);
  MemoQueryPersona.Lines.Add('FechaInscripcion = ' + DateToStr(Persona.FechaInscripcion));
  MemoQueryPersona.Lines.Add('FechaContratoSocial = ' + DateToStr(Persona.FechaContratoSocial));
  MemoQueryPersona.Lines.Add('FechaFallecimiento = ' + DateToStr(Persona.FechaFallecimiento));
  MemoQueryPersona.Lines.Add(Format('Impuestos = [%s]', [ParseArray(Persona.Impuestos)]));
  MemoQueryPersona.Lines.Add(Format('Caracterizaciones = [%s]', [ParseArray(Persona.Caracterizaciones)]));
  MemoQueryPersona.Lines.Add(Format('Actividades = [%s]', [ParseArray(Persona.Actividades)]));
  MemoQueryPersona.Lines.Add(Format('CategoriasMonotributo = [%s]', [ParseArrayCategorias(Persona.CategoriasMonotributo)]));
  MemoQueryPersona.Lines.Add('DomicilioFiscal = ' + Persona.DomicilioFiscal.ToString);
end;

procedure TMain.DoGetParametros(const AText: string);
var
  Time: TBenchmarkTime;
begin
  Time := TBenchmark.Benchmark(1, procedure
  var
    I: Integer;
    Data: TArray<TItem_Afip>;
    Data_Dependencies: TArray<TDependencia_Afip>;
  begin
    if CompareText(AText, 'actividades') = 0 then
      Data := Api.GetActividades
    else if CompareText(AText, 'conceptos') = 0 then
      Data := Api.GetConceptos
    else if CompareText(AText, 'Impuestos') = 0 then
      Data := Api.GetImpuestos
    else if CompareText(AText, 'Caracterizaciones') = 0 then
      Data := Api.GetCaracterizaciones
    else if CompareText(AText, 'CategoriasMonotributo') = 0 then
      Data := Api.GetCategoriasMonotributo
    else if CompareText(AText, 'CategoriasAutonomo') = 0 then
      Data := Api.GetCategoriasAutonomo
    else if CompareText(AText, 'Provincias') = 0 then
      Data := Api.GetProvincias
    else if CompareText(AText, 'GetDependecias') = 0 then
    begin
      Data_Dependencies := Api.GetDependecias;
      memoParametros.Lines.BeginUpdate;
      try
        for I := 0 to High(Data) do
          memoParametros.Lines.Add(Format('Id %d, Descripcion %s', [Data_Dependencies[I].Id,
                                                                    Data_Dependencies[I].Descripcion]));
      finally
        memoParametros.Lines.EndUpdate;
      end;
      Exit;
    end;

    memoParametros.Lines.BeginUpdate;
    try
      for I := 0 to High(Data) do
        memoParametros.Lines.Add(Format('Id = %d ------ Descripcion = %s', [Data[I].Id, Data[I].Descripcion]));
    finally
      memoParametros.Lines.EndUpdate;
    end;
  end);

  lbTime.Caption := Format('Time: %d msec', [Time.MSecs]);
end;

procedure TMain.btnGetParametrosClick(Sender: TObject);
begin
  btnGetParametros.Enabled := False;
  try
    memoParametros.Clear;
    DoGetParametros(cbParametros.Text);
  finally
    btnGetParametros.Enabled := True;
  end;
end;

procedure TMain.btnObtenerConstanciaClick(Sender: TObject);
var
  AStream: TStream;
  AFileStream: TFileStream;
begin
  AStream := ObtenerConstancia(edCuitConstancia.Text);
  try
    AStream.Position := 0;
    if not SaveDialog1.Execute then
      Exit;

    AFileStream := TFileStream.Create(SaveDialog1.FileName, fmCreate or fmOpenReadWrite);
    try
      AFileStream.CopyFrom(AStream, AStream.Size);
    finally
      AFileStream.Free;
      ShowMessage('Descargado');
    end;
  finally
    AStream.Free;
  end;
end;

procedure TMain.btnQueryDniClick(Sender: TObject);
var
  Items: TArray<string>;
  Nro: string;
begin
  Items := ConsultaNroDocumento(edNroDni.Text);
  MemoQueryDni.Clear;
  for Nro in Items do
    MemoQueryDni.Lines.Add(Nro);
end;

initialization
  Api := TAfipQuery.Create(TMemoryAfipPersister.Create);

end.
