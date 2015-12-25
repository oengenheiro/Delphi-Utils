unit RTL.Benchmark;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// TBenchmark is a class used to easily measure how much time takes to execute procedure
// Uses RTL.Chronometer

interface

uses
  RTL.Chronometer,
  SysUtils;

type
  TBenchmarkTime = record
  strict private
    FMsecs: Cardinal;
    FSecs: Cardinal;
  public
    constructor Create(const AMsecs, ASecs: Cardinal);
    property MSecs: Cardinal read FMsecs;
    property Secs: Cardinal read FSecs;
  end;

  TBenchmark = class
  strict private
    FProc: TProc;
    FChronometer: TChronometer;
  public
    constructor Create(AProc: TProc);
    destructor Destroy; override;
    function Benchmark(const ATimesCount: Integer = 1): TBenchmarkTime; overload;
    class function Benchmark(const ATimesCount: Integer; AProc: TProc): TBenchmarkTime; overload; static;
  end;

implementation

{ TBenchmarkTime }

constructor TBenchmarkTime.Create(const AMsecs, ASecs: Cardinal);
begin
  FMsecs := AMsecs;
  FSecs := ASecs;
end;

{ TBenchmark }

function TBenchmark.Benchmark(const ATimesCount: Integer): TBenchmarkTime;
var
  I: Integer;
begin
  if ATimesCount <= 0 then
    Exit(TBenchmarkTime.Create(0, 0));

  FChronometer.Start;
  for I := 0 to ATimesCount - 1 do
    FProc;

  FChronometer.Stop;
  Result := TBenchmarkTime.Create(FChronometer.MSecsElapsed, FChronometer.SecsElapsed);
end;

class function TBenchmark.Benchmark(const ATimesCount: Integer; AProc: TProc): TBenchmarkTime;
var
  LBenchmark: TBenchmark;
begin
  LBenchmark := TBenchmark.Create(AProc);
  try
    Result := LBenchmark.Benchmark(ATimesCount);
  finally
    LBenchmark.Free;
  end;
end;

constructor TBenchmark.Create(AProc: TProc);
begin
  if not Assigned(AProc) then
    raise Exception.Create('TBenchmark :: Create: AProc is not assigned');

  inherited Create;
  FProc := AProc;
  FChronometer := TChronometer.Create;
end;

destructor TBenchmark.Destroy;
begin
  FChronometer.Free;
  inherited Destroy;
end;

end.
