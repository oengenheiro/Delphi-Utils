unit RTL.Excel;

interface

uses
  RTL.DB,
  Spring.Collections,
  System.Classes,
  Data.DB,
  Data.Win.ADODB;

type
  IExcelFile = interface
    ['{0CAB1799-A7A1-41E1-8BC9-DFA8D256CE39}']
    function GetOnFileOpen: TNotifyEvent;
    function GetSheets: IEnumerable<string>;
    function GetFileName: string;

    procedure SetFileName(const Value: string);
    procedure SetOnFileOpen(const Value: TNotifyEvent);

    function SheetData(const SheetName: string; const ACloner: IDataSetCloner): TDataSet;

    property FileName: string read GetFileName write SetFileName;
    property Sheets: IEnumerable<string> read GetSheets;

    property OnFileOpen: TNotifyEvent read GetOnFileOpen write SetOnFileOpen;
  end;

  TExcelFile = class(TInterfacedObject, IExcelFile)
  strict private
    FConnection: TADOConnection;
    FFileName: string;
    FOnFileOpen: TNotifyEvent;

    function CreateQuery(AOwner: TComponent): TADOQuery;

    procedure OpenFile(const AFileName: string);
    procedure CloseFile;

    function GetOnFileOpen: TNotifyEvent;
    function GetSheets: IEnumerable<string>;
    function GetFileName: string;

    procedure SetFileName(const Value: string);
    procedure SetOnFileOpen(const Value: TNotifyEvent);
  strict protected
    function GetConnectionString: string; virtual;
  public
    constructor Create; overload;
    constructor Create(const AFileName: string); overload;
    destructor Destroy; override;

    function SheetData(const SheetName: string; const ACloner: IDataSetCloner): TDataSet;

    property FileName: string read GetFileName write SetFileName;
    property Sheets: IEnumerable<string> read GetSheets;

    property OnFileOpen: TNotifyEvent read GetOnFileOpen write SetOnFileOpen;
  end;

implementation

uses
  System.SysUtils;

constructor TExcelFile.Create;
begin
  inherited Create;
  FFileName := EmptyStr;

  FConnection := TADOConnection.Create(NIL);
  FConnection.Provider := 'Microsoft.Jet.OLEDB.4.0';
  FConnection.LoginPrompt := False;
end;

constructor TExcelFile.Create(const AFileName: string);
begin
  Create;
  Filename := AFileName;
end;

destructor TExcelFile.Destroy;
begin
  FConnection.Free;
  inherited Destroy;
end;

function TExcelFile.CreateQuery(AOwner: TComponent): TADOQuery;
begin
  Result := TADOQuery.Create(AOwner);
  Result.Connection := FConnection;
end;

procedure TExcelFile.CloseFile;
begin
  if FFileName.IsEmpty then
    Exit;

  FFileName := EmptyStr;
  FConnection.Close;
end;

function TExcelFile.GetSheets: IEnumerable<string>;
var
  LSheets: IList<string>;
  LTables: TStrings;
  s: string;
begin
  LSheets := TCollections.CreateList<string>;

  if not FConnection.Connected then
    Exit(LSheets);

  LTables := TStringList.Create;
  try
    FConnection.GetTableNames(LTables);

    for s in LTables do
      LSheets.Add(s);
  finally
    LTables.Free;
  end;

  Result := LSheets;
end;

function TExcelFile.GetConnectionString: string;
begin
  Result := 'Provider=Microsoft.JET.OLEDB.4.0;Data Source=%s;Extended Properties="Excel 8.0;HDR=No";';
end;

function TExcelFile.GetFileName: string;
begin
  Result := FFileName;
end;

function TExcelFile.GetOnFileOpen: TNotifyEvent;
begin
  Result := FOnFileOpen;
end;

procedure TExcelFile.OpenFile(const AFileName: string);
begin
  FFileName := EmptyStr;
  FConnection.Close;
  FConnection.ConnectionString := Format(GetConnectionString, [AFileName]);
  FConnection.Open;
  FFileName := AFileName;

  if Assigned(FOnFileOpen) then
    FOnFileOpen(Self);
end;

procedure TExcelFile.SetFileName(const Value: string);
begin
  OpenFile(Value);
end;

procedure TExcelFile.SetOnFileOpen(const Value: TNotifyEvent);
begin
  FOnFileOpen := Value;
end;

function TExcelFile.SheetData(const SheetName: string; const ACloner: IDataSetCloner): TDataSet;
var
  LQuery: TADOQuery;
begin
  if not Assigned(ACloner) then
    raise Exception.CreateFmt('%s.SheetData :: ACloner is not assigned', [ClassName]);

  if SheetName.IsEmpty then
    raise Exception.CreateFmt('%s.SheetData :: SheetName is Empty', [ClassName]);

  LQuery := CreateQuery(NIL);
  try
    LQuery.SQL.Text := Format(' SELECT * FROM [%s] ', [SheetName]);
    LQuery.Open;
    Result := ACloner.Copy(LQuery);
  finally
    LQuery.Free;
  end;
end;

end.
