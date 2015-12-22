unit App.AutoRun;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// Defines an intreface to enable/disable application AutoRun (ie. on operating system startup)

interface

type
  IAppAutoRun = interface
    ['{54C38496-FB39-4E8C-A980-D089A72AF479}']
    function RegisterAutoStart: Boolean;
    function RemoveAutoStart: Boolean;
  end;

implementation


end.
