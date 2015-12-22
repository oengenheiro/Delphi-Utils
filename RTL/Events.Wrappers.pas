unit Events.Wrappers;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin
  
// Implements TEventWrapper

interface

uses
  Events.Core,
  {$IF CompilerVersion > 21}
  System.Classes,
  System.SysUtils,
  Vcl.Controls,
  {$ELSE}
  Classes,
  SysUtils,
  Controls;
  {$IFEND}

type
  TNotifyEventWrapper = class(TEventWrapper<TObject, TNotifyEvent>)
  public
    class function CreateEvent(AOwner: TComponent; AProc: TProc<TObject>): TNotifyEvent; override;
  end;

  TMouseDownEventWrapper = class(TEventWrapper<TObject, TMouseButton, TShiftState, Integer, Integer, TMouseEvent>)
  public
    class function CreateEvent(AOwner: TComponent; AProc: TProc<TObject, TMouseButton, TShiftState,
                               Integer, Integer>): TMouseEvent; override;
  end;

implementation

{ TNotifyEventWrapper }

class function TNotifyEventWrapper.CreateEvent(AOwner: TComponent; AProc: TProc<TObject>): TNotifyEvent;
begin
  Result := TNotifyEventWrapper.Create(AOwner, AProc).Event;
end;

{ TMouseEventWrapper }

class function TMouseDownEventWrapper.CreateEvent(AOwner: TComponent; AProc: TProc<TObject, TMouseButton, TShiftState,
  Integer, Integer>): TMouseEvent;
begin
  Result := TMouseDownEventWrapper.Create(AOwner, AProc).Event;
end;

end.
