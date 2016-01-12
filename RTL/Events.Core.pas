unit Events.Core;

interface

// Based on: http://stackoverflow.com/questions/11491593/tproctobject-to-tnotifyevent
// Author: David Heffernan

// Classes defined here allows to assign annonymous methods to event handlers
// They must be implemented so that CreateEvent function returns the apropiate event type (TNotifyEvent, etc)
// See more at:

// http://stackoverflow.com/questions/11491593/tproctobject-to-tnotifyevent 
// http://www.clubdelphi.com/foros/showthread.php?t=89597

// Example of wrapped events @ unit Events.Wrappers https://github.com/ortuagustin/Delphi-Utils/blob/master/RTL/Events.Wrappers.pas

uses
  {$IF CompilerVersion > 21}
  System.Classes,
  System.SysUtils;
  {$ELSE}
  Classes,
  SysUtils;
  {$IFEND}

type
  TProc<T1, T2, T3, T4, T5> = reference to procedure (Arg1: T1; Arg2: T2; Arg3: T3; Arg4: T4; Arg5: T5);

  TEventWrapper<T1, R> = class abstract(TComponent)
  strict protected
    FProc: TProc<T1>;
  public
    class function CreateEvent(AOwner: TComponent; AProc: TProc<T1>): R; virtual; abstract;
    constructor Create(AOwner: TComponent; AProc: TProc<T1>); reintroduce;
    procedure Event(Arg1: T1);
  end;

  TEventWrapper<T1, T2, R> = class abstract(TComponent)
  strict protected
    FProc: TProc<T1, T2>;
  public
    class function CreateEvent(AOwner: TComponent; AProc: TProc<T1, T2>): R; virtual; abstract;
    constructor Create(AOwner: TComponent; AProc: TProc<T1, T2>); reintroduce;
    procedure Event(Arg1: T1; Arg2: T2);
  end;

  TEventWrapper<T1, T2, T3, R> = class abstract(TComponent)
  strict protected
    FProc: TProc<T1, T2, T3>;
  public
    class function CreateEvent(AOwner: TComponent; AProc: TProc<T1, T2, T3>): R; virtual; abstract;
    constructor Create(AOwner: TComponent; AProc: TProc<T1, T2, T3>); reintroduce;
    procedure Event(Arg1: T1; Arg2: T2; Arg3: T3);
  end;

  TEventWrapper<T1, T2, T3, T4, R> = class abstract(TComponent)
  strict protected
    FProc: TProc<T1, T2, T3, T4>;
  public
    class function CreateEvent(AOwner: TComponent; AProc: TProc<T1, T2, T3, T4>): R; virtual; abstract;
    constructor Create(AOwner: TComponent; AProc: TProc<T1, T2, T3, T4>); reintroduce;
    procedure Event(Arg1: T1; Arg2: T2; Arg3: T3; Arg4: T4);
  end;

  TEventWrapper<T1, T2, T3, T4, T5, R> = class abstract(TComponent)
  strict protected
    FProc: TProc<T1, T2, T3, T4, T5>;
  public
    class function CreateEvent(AOwner: TComponent; AProc: TProc<T1, T2, T3, T4, T5>): R; virtual; abstract;
    constructor Create(AOwner: TComponent; AProc: TProc<T1, T2, T3, T4, T5>); reintroduce;
    procedure Event(Arg1: T1; Arg2: T2; Arg3: T3; Arg4: T4; Arg5: T5);
  end;

implementation

{ TEventWrapper<T1, R> }

constructor TEventWrapper<T1, R>.Create(AOwner: TComponent; AProc: TProc<T1>);
begin
  inherited Create(AOwner);
  FProc := AProc;
end;

procedure TEventWrapper<T1, R>.Event(Arg1: T1);
begin
  FProc(Arg1);
end;

{ TEventWrapper<T1, T2, R> }

constructor TEventWrapper<T1, T2, R>.Create(AOwner: TComponent; AProc: TProc<T1, T2>);
begin
  inherited Create(AOwner);
  FProc := AProc;
end;

procedure TEventWrapper<T1, T2, R>.Event(Arg1: T1; Arg2: T2);
begin
  FProc(Arg1, Arg2);
end;

{ TEventWrapper<T1, T2, T3, R> }

constructor TEventWrapper<T1, T2, T3, R>.Create(AOwner: TComponent; AProc: TProc<T1, T2, T3>);
begin
  inherited Create(AOwner);
  FProc := AProc;
end;

procedure TEventWrapper<T1, T2, T3, R>.Event(Arg1: T1; Arg2: T2; Arg3: T3);
begin
  FProc(Arg1, Arg2, Arg3);
end;

{ TEventWrapper<T1, T2, T3, T4, R> }

constructor TEventWrapper<T1, T2, T3, T4, R>.Create(AOwner: TComponent; AProc: TProc<T1, T2, T3, T4>);
begin
  inherited Create(AOwner);
  FProc := AProc;
end;

procedure TEventWrapper<T1, T2, T3, T4, R>.Event(Arg1: T1; Arg2: T2; Arg3: T3; Arg4: T4);
begin
  FProc(Arg1, Arg2, Arg3, Arg4);
end;

{ TEventWrapper<T1, T2, T3, T4, T5, R> }

constructor TEventWrapper<T1, T2, T3, T4, T5, R>.Create(AOwner: TComponent; AProc: TProc<T1, T2, T3, T4, T5>);
begin
  inherited Create(AOwner);
  FProc := AProc;
end;

procedure TEventWrapper<T1, T2, T3, T4, T5, R>.Event(Arg1: T1; Arg2: T2; Arg3: T3; Arg4: T4; Arg5: T5);
begin
  FProc(Arg1, Arg2, Arg3, Arg4, Arg5);
end;

end.


