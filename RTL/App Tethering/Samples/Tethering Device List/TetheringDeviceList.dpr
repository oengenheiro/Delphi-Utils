program TetheringDeviceList;

uses
  Vcl.Forms,
  AppTethering.Module in 'AppTethering.Module.pas',
  Main in 'Main.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TTetheringModule, TetheringModule);
  Application.CreateForm(TFDevices, FDevices);
  Application.Run;
end.
