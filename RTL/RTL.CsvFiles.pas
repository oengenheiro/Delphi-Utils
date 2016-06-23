unit RTL.CsvFiles;

interface

uses
  Spring.Collections,
  System.SysUtils,
  System.Classes;

type
{$REGION 'ICsvLine'}
  /// <summary> Represents a line of a Comma Separated Values (.csv) File </summary>
  ICsvLine = interface
    ['{0163D87F-BF05-4B0F-8E2E-7408D27F809D}']
    function GetText: string;

    /// <summary> Splits the line using ASeparator and returns the result in an enumerable </summary>
    function SplitText(const ASeparator: Char): IEnumerable<string>; overload;
    /// <summary> Splits the line using the Separator of the ICsvFile and returns the result in an enumerable </summary>
    function SplitText: IEnumerable<string>; overload;
    /// <summary> The raw value of the line </summary>
    property Text: string read GetText;
  end;
{$ENDREGION}

{$REGION 'ICsvFile'}
  /// <summary> Represents a Comma Separated Values (.csv) File </summary>
  ICsvFile = interface
    ['{0AE06C11-ED60-4D81-8B06-74EA1F951061}']
    function GetCount: Integer;
    function GetFileName: string;
    function GetLine(Index: Integer): ICsvLine;
    function GetLines: IEnumerable<ICsvLine>;
    function GetSeparator: Char;
    function GetText: string;
    function GetEncoding: TEncoding;
    procedure SetSeparator(const Value: Char);

    /// <summary> The name of the csv File </summary>
    property FileName: string read GetFileName;
    /// <summary> The current separator char used to split the file </summary>
    property Separator: Char read GetSeparator write SetSeparator;
    /// <summary> Each line of the csv File, represented through an ICsvLine interface </summary>
    property Line[Index: Integer]: ICsvLine read GetLine;
    /// <summary> Returns the whole content of the csv File </summary>
    property Text: string read GetText;
    /// <summary> Returns a read-only collection of the ICsvLines that conforms the ICsvFile </summary>
    property Lines: IEnumerable<ICsvLine> read GetLines;
    /// <summary> Returns the amount of lines of the csv File </summary>
    property Count: Integer read GetCount;
    /// <summary> Returns the Encoding used by the file </summary>
    property Encoding: TEncoding read GetEncoding;
  end;
{$ENDREGION}

{$REGION 'ICsvFileHandler'}
  /// <summary> Used to work with Comma Separated Values (.csv) Files </summary>
  ICsvFileHandler = interface
    ['{8CDBE29D-DE51-467C-A0DD-E752ECF4BD44}']
    /// <summary> Creates a new file in disk, then open and return it </summary>
    function New(const AFileName: string; const ASeparator: Char; AEncoding: TEncoding): ICsvFile;
    /// <summary> Opens the file with the given separator and returns a ICsvFile interface with the file </summary>
    function Load(const AFileName: string; const ASeparator: Char; AEncoding: TEncoding): ICsvFile;
    /// <summary> Saves the given ICsvFile in the Physical File given by its FileName property </summary>
    procedure Save(const ACsvFile: ICsvFile; AEncoding: TEncoding); overload;
    /// <summary> Saves the given ICsvFile in the Physical File given by AFileName </summary>
    procedure Save(const ACsvFile: ICsvFile; const AFileName: string; AEncoding: TEncoding); overload;
  end;
{$ENDREGION}

{$REGION 'TCsvLine'}
  TCsvLine = class(TInterfacedObject, ICsvLine)
  strict private
    FOwnerSeparator: Char;
    FText: string;

    function GetText: string;
  strict protected
    function SplitText(const ASeparator: Char): IEnumerable<string>; overload;
    function SplitText: IEnumerable<string>; overload;
  public
    constructor Create(const AText: string; const AOwnerSeparator: Char);
  end;
{$ENDREGION}

{$REGION 'TCsvFile'}
  TCsvFile = class(TInterfacedObject, ICsvFile)
  strict private
    FFileContents: TStrings;
    FEncoding: TEncoding;
    FFileName: string;
    FSeparator: Char;

    function GetCount: Integer;
    function GetFileName: string;
    function GetLine(Index: Integer): ICsvLine;
    function GetLines: IEnumerable<ICsvLine>;
    function GetSeparator: Char;
    function GetText: string;
    function GetEncoding: TEncoding;
    procedure SetSeparator(const Value: Char);
  strict protected
    property FileContents: TStrings read FFileContents;
  public
    constructor Create(const AFileName: string; const ASeparator: Char; AEncoding: TEncoding = nil);
    destructor Destroy; override;
  end;
{$ENDREGION}

{$REGION 'TCsvFileHandler'}
  TCsvFileHandler = class(TInterfacedObject, ICsvFileHandler)
  strict protected
    function New(const AFileName: string; const ASeparator: Char; AEncoding: TEncoding): ICsvFile;
    function Load(const AFileName: string; const ASeparator: Char; AEncoding: TEncoding): ICsvFile;
    procedure Save(const ACsvFile: ICsvFile; AEncoding: TEncoding); overload;
    procedure Save(const ACsvFile: ICsvFile; const AFileName: string; AEncoding: TEncoding); overload;
  end;
{$ENDREGION}

{$REGION 'CSV'}
  /// <summary> Static abstract class that creates internally a ICsvFileHandler and delegates the method </summary>
  CSV = class abstract
  strict private
    /// <summary> Creates and returns a ICsvFileHandler </summary>
    class function Handler: ICsvFileHandler; static;
  public
    class function New(const AFileName: string; const ASeparator: Char; AEncoding: TEncoding): ICsvFile; static;
    class function Load(const AFileName: string; const ASeparator: Char; AEncoding: TEncoding): ICsvFile; static;
    class procedure Save(const ACsvFile: ICsvFile; AEncoding: TEncoding); overload; static;
    class procedure Save(const ACsvFile: ICsvFile; const AFileName: string; AEncoding: TEncoding); overload; static;
  end;
{$ENDREGION}

{$REGION 'Exceptions'}
  /// <summary> Raised when attemping to overwrite a file </summary>
  EFileExists = class(Exception)
  public
    constructor Create(const AFileName: string);
  end;

  /// <summary> Raised when the given AFilename is invalid because of the AChar </summary>
  EInvalidCharInFileName = class(Exception)
  public
    constructor Create(const AFileName: string; const AChar: Char);
  end;
{$ENDREGION}

implementation

uses
  System.IOUtils;

type
{$REGION 'TEncodingHelper'}
  TEncodingHelper = class helper for TEncoding
  public
    /// <summary> Returns Self if not nil, else returns TEncoding.Default </summary>
    function ThisOrDefault: TEncoding;
  end;
{$ENDREGION}

{$REGION 'CSV'}

class function CSV.Handler: ICsvFileHandler;
begin
  Result := TCsvFileHandler.Create;
end;

class function CSV.Load(const AFileName: string; const ASeparator: Char; AEncoding: TEncoding): ICsvFile;
begin
  Result := Handler.Load(AFileName, ASeparator, AEncoding)
end;

class function CSV.New(const AFileName: string; const ASeparator: Char; AEncoding: TEncoding): ICsvFile;
begin
  Result := Handler.New(AFileName, ASeparator, AEncoding);
end;

class procedure CSV.Save(const ACsvFile: ICsvFile; const AFileName: string; AEncoding: TEncoding);
begin
  Handler.Save(ACsvFile, AFileName, AEncoding);
end;

class procedure CSV.Save(const ACsvFile: ICsvFile; AEncoding: TEncoding);
begin
  Handler.Save(ACsvFile, AEncoding);
end;

{$ENDREGION}

{$REGION 'TCsvFileHandler'}

function TCsvFileHandler.New(const AFileName: string; const ASeparator: Char; AEncoding: TEncoding): ICsvFile;
var
  LChar: Char;
begin
  for LChar in AFileName do
  begin
    if not TPath.IsValidFileNameChar(LChar) then
      raise EInvalidCharInFileName.Create(AFileName, LChar);
  end;

  if TFile.Exists(AFileName) then
    raise EFileExists.Create(AFileName);

  TFile.Create(AFileName);
  Result := Load(AFileName, ASeparator, AEncoding);
end;

function TCsvFileHandler.Load(const AFileName: string; const ASeparator: Char; AEncoding: TEncoding): ICsvFile;
begin
  Result := TCsvFile.Create(AFileName, ASeparator, AEncoding.ThisOrDefault);
end;

procedure TCsvFileHandler.Save(const ACsvFile: ICsvFile; AEncoding: TEncoding);
begin
  Save(ACsvFile, ACsvFile.FileName, AEncoding);
end;

procedure TCsvFileHandler.Save(const ACsvFile: ICsvFile; const AFileName: string; AEncoding: TEncoding);
begin
  if not Assigned(ACsvFile) then
    raise Exception.CreateFmt('%s.Create :: ICsvFile is not assigned', [QualifiedClassName]);

  TFile.WriteAllText(AFileName, ACsvFile.Text, AEncoding.ThisOrDefault);
end;

{$ENDREGION}

{$REGION 'TCsvFile'}

constructor TCsvFile.Create(const AFileName: string; const ASeparator: Char; AEncoding: TEncoding);
begin
  inherited Create;
  FFileName := AFileName;
  FSeparator := ASeparator;
  FEncoding := AEncoding;
  FFileContents := TStringList.Create;
  FileContents.LoadFromFile(FFileName);
end;

destructor TCsvFile.Destroy;
begin
  FFileContents.Free;
  inherited Destroy;
end;

function TCsvFile.GetCount: Integer;
begin
  Result := FileContents.Count;
end;

function TCsvFile.GetEncoding: TEncoding;
begin
  Result := FEncoding;
end;

function TCsvFile.GetFileName: string;
begin
  Result := FFileName;
end;

function TCsvFile.GetLine(Index: Integer): ICsvLine;
begin
  Result := TCsvLine.Create(FileContents[Index], FSeparator);
end;

function TCsvFile.GetLines: IEnumerable<ICsvLine>;
var
  s: string;
  FLines: IList<ICsvLine>;
begin
  FLines := TCollections.CreateList<ICsvLine>;
  try
    FLines.Capacity := GetCount;
    for s in FileContents do
      FLines.Add(TCsvLine.Create(s, FSeparator));
  finally
    Result := FLines;
  end;
end;

function TCsvFile.GetSeparator: Char;
begin
  Result := FSeparator;
end;

function TCsvFile.GetText: string;
begin
  Result := FFileContents.Text;
end;

procedure TCsvFile.SetSeparator(const Value: Char);
begin
  FSeparator := Value;
end;

{$ENDREGION}

{$REGION 'TCsvLine'}

constructor TCsvLine.Create(const AText: string; const AOwnerSeparator: Char);
begin
  inherited Create;
  FText := AText;
  FOwnerSeparator := AOwnerSeparator;
end;

function TCsvLine.GetText: string;
begin
  Result := FText;
end;

function TCsvLine.SplitText: IEnumerable<string>;
begin
  Result := SplitText(FOwnerSeparator);
end;

function TCsvLine.SplitText(const ASeparator: Char): IEnumerable<string>;
begin
  Result := TCollections.CreateList<string>(FText.Split(ASeparator));
end;

{$ENDREGION}

{$REGION 'TEncodingHelper'}

function TEncodingHelper.ThisOrDefault: TEncoding;
begin
  if Assigned(Self) then
    Result := Self
  else
    Result := TEncoding.Default;
end;

{$ENDREGION}

{$REGION 'Exceptions'}

constructor EFileExists.Create(const AFileName: string);
begin
  inherited CreateFmt('%s already exists', [AFileName]);
end;

constructor EInvalidCharInFileName.Create(const AFileName: string; const AChar: Char);
begin
  inherited CreateFmt('%s is not a valid file name because of char %s', [AFileName, AChar]);
end;

{$ENDREGION}

end.
