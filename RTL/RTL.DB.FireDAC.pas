unit RTL.DB.FireDAC;

interface

uses
  RTL.DB,
  Data.DB;

type
  TFDMemTableDataSetCloner = class(TInterfacedObject, IDataSetCloner)
  public
    function Copy(ASource: TDataSet): TDataSet;
    function CopySelected(const ASelectedRecords: TArray<TBookmark>; ASource: TDataSet): TDataSet;
  end;

implementation

uses
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

function TFDMemTableDataSetCloner.Copy(ASource: TDataSet): TDataSet;
var
  ACopy: TFDMemTable;
begin
  ACopy := TFDMemTable.Create(NIL);
  try
    ACopy.CopyDataSet(ASource, [coStructure, coAppend, coRestart]);
  finally
    Result := ACopy;
  end;
end;

function TFDMemTableDataSetCloner.CopySelected(const ASelectedRecords: TArray<TBookmark>; ASource: TDataSet): TDataSet;
var
  ACopy: TFDMemTable;
  I: Integer;
begin
  ACopy := TFDMemTable.Create(NIL);
  try
    ACopy.CopyDataSet(ASource, [coStructure, coRestart]);
    ASource.DisableControls;
    try
      for I := Low(ASelectedRecords) to High(ASelectedRecords) do
      begin
        ASource.GotoBookmark(ASelectedRecords[I]);
        ACopy.Append;
        ACopy.CopyFields(ASource);
        ACopy.Post;
      end;
    finally
      ASource.EnableControls;
    end;
  finally
    Result := ACopy;
  end;
end;

end.
