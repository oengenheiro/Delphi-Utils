program AfipPublicApi;

uses
  Forms,
  MainForm in 'MainForm.pas' {Main},
  Afip.PublicAPI.Types in '..\Afip.PublicAPI.Types.pas',
  Afip.PublicAPI in '..\Afip.PublicAPI.pas',
  Afip.PublicAPI.Parsers in '..\Afip.PublicAPI.Parsers.pas',
  Afip.PublicAPI.Persistance in '..\Afip.PublicAPI.Persistance.pas',
  Afip.PublicAPI.HttpClient in '..\Afip.PublicAPI.HttpClient.pas',
  Afip.PublicAPI.NetHttpClient in '..\Afip.PublicAPI.NetHttpClient.pas',
  Afip.PublicAPI.SynapseHttpClient in '..\Afip.PublicAPI.SynapseHttpClient.pas',
  Afip.PublicAPI.Parsers.Native in '..\Afip.PublicAPI.Parsers.Native.pas',
  Afip.PublicAPI.Parsers.lkJson in '..\Afip.PublicAPI.Parsers.lkJson.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ReportMemoryLeaksOnShutdown := True;
  Application.Title := 'AFIP - API Pública Consulta Padrón Contribuyentes';
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
