program AndroidDeviceInfoDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  ReportMemoryLeaksOnShutDown := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
