program AfipPublicApi;

uses
  Vcl.Forms,
  MainForm in 'MainForm.pas' {Main},
  Afip.PublicAPI.Types in '..\Afip.PublicAPI.Types.pas',
  Afip.PublicAPI in '..\Afip.PublicAPI.pas',
  Afip.PublicAPI.Parsers in '..\Afip.PublicAPI.Parsers.pas',
  Afip.PublicAPI.Persistance in '..\Afip.PublicAPI.Persistance.pas',
  Afip.PublicAPI.HttpClient in '..\Afip.PublicAPI.HttpClient.pas',
  Afip.PublicAPI.NetHttpClient in '..\Afip.PublicAPI.NetHttpClient.pas',
  Afip.PublicAPI.SynapseHttpClient in '..\Afip.PublicAPI.SynapseHttpClient.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  ReportMemoryLeaksOnShutdown := True;
  Application.CreateForm(TMain, Main);
  Application.Run;
end.
