unit RTL.Chronometer;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// implements a time chronometer; can report the elapsed time in ms or seconds

interface

type
  TChronometer = class
  strict private
    FElapsed: Cardinal;
    FStart: Int64;
    FFinish: Int64;
    FFrec: Int64;
    FReportOnStop: Boolean;
    FProcedureName: string;
    procedure SetProcedureName(const Value: string);
    function GetSecsElapsed: Cardinal;
    procedure SetReportOnStop(const Value: Boolean);
  strict protected
    procedure DoReport; virtual;
  public
    constructor Create; overload;
    constructor Create(const AReportOnStop: Boolean); overload;
    constructor Create(const AProcedureName: string; const AReportOnStop: Boolean); overload;
    function Start: Cardinal;
    function Stop: Cardinal;
    property MSecsElapsed: Cardinal read FElapsed;
    property SecsElapsed: Cardinal read GetSecsElapsed;
    property ProcedureName: string read FProcedureName write SetProcedureName;
    property ReportOnStop: Boolean read FReportOnStop write SetReportOnStop;
  end;

implementation

uses
  Vcl.CustomDialogs,
  Windows,
  SysUtils;

{ TChronometer }

constructor TChronometer.Create;
begin
  inherited Create;
  FElapsed := 0;
  FStart := 0;
  FFinish := 0;
  FFrec := 0;
end;

constructor TChronometer.Create(const AReportOnStop: Boolean);
begin
  Create;
  FReportOnStop := AReportOnStop;
end;

constructor TChronometer.Create(const AProcedureName: string; const AReportOnStop: Boolean);
begin
  Create(AReportOnStop);
  FProcedureName := AProcedureName;
end;

procedure TChronometer.DoReport;
var
  LReportStr: string;
begin
  if FProcedureName <> EmptyStr then
    LReportStr := Format('[ %s ] - Elapsed %d MSec =~ %d Secs ', [ProcedureName, MSecsElapsed, SecsElapsed])
  else
    LReportStr := Format('Elapsed %d MSec =~ %d Secs ', [MSecsElapsed, SecsElapsed]);

  InfoMsg(LReportStr);
end;

function TChronometer.Stop: Cardinal;
begin
  QueryPerformanceCounter(FFinish);
  Result := FFinish;
  FElapsed := (FFinish - FStart) * MSecsPerSec div FFrec;
  if ReportOnStop then
    DoReport;
end;

function TChronometer.Start: Cardinal;
begin
  QueryPerformanceFrequency(FFrec);
  QueryPerformanceCounter(FStart);
  Result := FStart;
end;

function TChronometer.GetSecsElapsed: Cardinal;
begin
  Result := FElapsed div MSecsPerSec;
end;

procedure TChronometer.SetProcedureName(const Value: string);
begin
  FProcedureName := Value;
end;

procedure TChronometer.SetReportOnStop(const Value: Boolean);
begin
  FReportOnStop := Value;
end;

end.

