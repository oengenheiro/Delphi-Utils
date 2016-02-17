unit Vcl.Controls.Enumerator;

// Source: http://stackoverflow.com/questions/14892793/search-for-a-label-by-its-caption/14894296#14894296
// Author: David Heffernan

// Implements an enumerator for TControls
// Supports predicates and actions (an annonymous method to execute on each iteration)

interface

{$IF CompilerVersion > 21}

uses
  System.SysUtils,
  System.Generics.Collections,
  Vcl.Controls;

type
  TControls = class
  {$REGION 'private type'}
  private type
    TEnumerator<T: TControl> = record
      FControls: TArray<T>;
      FIndex: Integer;
      procedure Initialize(WinControl: TWinControl; Predicate: TFunc<T, Boolean>);
      class function Count(WinControl: TWinControl; Predicate: TFunc<T, Boolean>): Integer; static;
      function GetCurrent: T;
      function MoveNext: Boolean;
      property Current: T read GetCurrent;
    end;

    TEnumeratorFactory<T: TControl> = record
      FWinControl: TWinControl;
      FPredicate: TFunc<T, Boolean>;
      function Count: Integer;
      function Controls: TArray<T>;
      function GetEnumerator: TEnumerator<T>;
    end;
    {$ENDREGION}
  public
    class procedure WalkControls<T: TControl>(WinControl: TWinControl; Method: TProc<T>); overload; static;
    class procedure WalkControls<T: TControl>(WinControl: TWinControl; Predicate: TFunc<T, Boolean>; Method: TProc<T>); overload; static;
    class function Enumerator<T: TControl>(WinControl: TWinControl) : TEnumeratorFactory<T>; overload; static;
    class function Enumerator<T: TControl>(WinControl: TWinControl; Predicate: TFunc<T, Boolean>) : TEnumeratorFactory<T>; overload; static;
    class function ChildCount<T: TControl>(WinControl: TWinControl): Integer; overload; static;
    class function ChildCount<T: TControl>(WinControl: TWinControl; Predicate: TFunc<T, Boolean>): Integer; overload; static;
  end;

{$IFEND}

implementation

{$IF CompilerVersion > 21}

{ TControls.TEnumerator<T> }

procedure TControls.TEnumerator<T>.Initialize(WinControl: TWinControl; Predicate: TFunc<T, Boolean>);
var
  List: TList<T>;
  Method: TProc<T>;
begin
  List := TObjectList<T>.Create(False);
  try
    Method := procedure(Control: T)
    begin
      List.Add(Control);
    end;
    TControls.WalkControls<T>(WinControl, Predicate, Method);
    FControls := List.ToArray;
  finally
    List.Free;
  end;
  FIndex := -1;
end;

class function TControls.TEnumerator<T>.Count(WinControl: TWinControl; Predicate: TFunc<T, Boolean>): Integer;
var
  Count: Integer;
  Method: TProc<T>;
begin
  Method := procedure(Control: T)
  begin
    Inc(Count);
  end;

  Count := 0;
  TControls.WalkControls<T>(WinControl, Predicate, Method);
  Result := Count;
end;

function TControls.TEnumerator<T>.GetCurrent: T;
begin
  Result := FControls[FIndex];
end;

function TControls.TEnumerator<T>.MoveNext: Boolean;
begin
  Inc(FIndex);
  Result := FIndex < Length(FControls);
end;

{ TControls.TEnumeratorFactory<T> }

function TControls.TEnumeratorFactory<T>.Count: Integer;
begin
  Result := TEnumerator<T>.Count(FWinControl, FPredicate);
end;

function TControls.TEnumeratorFactory<T>.Controls: TArray<T>;
var
  Enumerator: TEnumerator<T>;
begin
  Enumerator.Initialize(FWinControl, FPredicate);
  Result := Enumerator.FControls;
end;

function TControls.TEnumeratorFactory<T>.GetEnumerator: TEnumerator<T>;
begin
  Result.Initialize(FWinControl, FPredicate);
end;

class procedure TControls.WalkControls<T>(WinControl: TWinControl; Predicate: TFunc<T, Boolean>; Method: TProc<T>);
var
  I: Integer;
  Control: TControl;
  Include: Boolean;
begin
  if not Assigned(WinControl) then
    Exit;

  for I := 0 to WinControl.ControlCount - 1 do
  begin
    Control := WinControl.Controls[I];
    if not(Control is T) then
      Include := False
    else if Assigned(Predicate) and not Predicate(Control) then
      Include := False
    else
      Include := True;

    if Include and Assigned(Method) then
      Method(Control);

    if Control is TWinControl then
      WalkControls<T>(TWinControl(Control), Predicate, Method);
  end;
end;

class function TControls.ChildCount<T>(WinControl: TWinControl): Integer;
begin
  Result := TControls.ChildCount<T>(WinControl, NIL);
end;

class procedure TControls.WalkControls<T>(WinControl: TWinControl; Method: TProc<T>);
begin
  WalkControls<T>(WinControl, NIL, Method);
end;

class function TControls.Enumerator<T>(WinControl: TWinControl; Predicate: TFunc<T, Boolean>): TEnumeratorFactory<T>;
begin
  Result.FWinControl := WinControl;
  Result.FPredicate := Predicate;
end;

class function TControls.Enumerator<T>(WinControl: TWinControl): TEnumeratorFactory<T>;
begin
  Result := Enumerator<T>(WinControl, NIL);
end;

class function TControls.ChildCount<T>(WinControl: TWinControl; Predicate: TFunc<T, Boolean>): Integer;
begin
  Result := Enumerator<T>(WinControl, Predicate).Count;
end;

{$IFEND}

end.

