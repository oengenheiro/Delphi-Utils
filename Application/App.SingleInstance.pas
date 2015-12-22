unit App.SingleInstance;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// Defines an interface that ensures the application can execute one instance at most

interface

type
  IAppSingleInstance = interface
    ['{2F286EF6-393A-4B9F-8595-E94389727ACF}']
    procedure Initialize;
    procedure Finalize;
  end;

  TAppSingleInstance = record
  strict private
    FAppSingleInstance: IAppSingleInstance;
  public
    constructor Create(const AppSingleInstanceImpl: IAppSingleInstance);
  end;

implementation

{ TAppSingleInstance }

constructor TAppSingleInstance.Create(const AppSingleInstanceImpl: IAppSingleInstance);
begin
  FAppSingleInstance := AppSingleInstanceImpl;
  FAppSingleInstance.Initialize;
end;

end.
