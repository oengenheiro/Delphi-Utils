unit RTL.DB;

interface

uses
  System.Classes,
  Data.DB;

type
  /// <summary>
  /// Interface que copia un DataSet
  /// </summary>
  IDataSetCloner = interface
    ['{D61E44DC-3DDF-4CEF-B390-8F470B6017FB}']
    /// <summary>
    /// Retorna una copia del DataSet enviado en el parametro ASource
    /// </summary>
    function Copy(ASource: TDataSet; AOwner: TComponent): TDataSet;

    /// <summary>
    /// Retorna una copia del DataSet enviado en el parametro ASource; solo los record que estan en ASelectedRecords
    /// </summary>
    function CopySelected(const ASelectedRecords: TArray<TBookmark>; ASource: TDataSet; AOwner: TComponent): TDataSet;
  end;

implementation

end.
