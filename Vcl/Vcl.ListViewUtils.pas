unit Vcl.ListViewUtils;

interface

// source: http://delphiaccess.com/foros/index.php/topic/11740-como-colocar-las-flechitas-que-indican-el-orden-de-columnas-de-un-listview/
// author: escafandra
procedure SetSortIcon(const AListViewHandle: NativeInt; const ColIndex: Integer; const Ascending: Boolean);
procedure ClearSortIcon(const AListViewHandle: NativeInt; const ColIndex: Integer);

{$IF CompilerVersion > 21}
type
  TSortOrder = (soNone, soDescending, soAscending);

  TSortOrderHelper = record helper for TSortOrder
  strict private
    class function Parse(const Value: Integer): TSortOrder; static;
  public
    function ToInt: Integer;
    function Next: TSortOrder; overload;
    class function Next(const Value: TSortOrder): TSortOrder; overload; static;
    class function Next(const Value: Integer): TSortOrder; overload; static;
  end;
{$ENDIF}

implementation

uses
  {$IF CompilerVersion > 21}
  System.SysUtils,
  Winapi.CommCtrl,
  Winapi.Windows;
  {$ELSE}
  CommCtrl,
  Windows;
  {$IFEND}

{$IF CompilerVersion > 21}
class function TSortOrderHelper.Next(const Value: TSortOrder): TSortOrder;
begin
  case Value of
    soNone, soDescending: Result := soAscending;
    soAscending: Result := soDescending;
  else
    raise Exception.CreateFmt('TSortOrderHelper.Next :: Unknown next value for %d', [Ord(Value)]);
  end;
end;

class function TSortOrderHelper.Parse(const Value: Integer): TSortOrder;
begin
  case Value of
    0: Result := soNone;
    1: Result := soAscending;
    -1: Result := soDescending;
  else
    raise Exception.CreateFmt('TSortOrderHelper.Parse :: Unknown value for %d', [Value]);
  end;
end;

class function TSortOrderHelper.Next(const Value: Integer): TSortOrder;
begin
  Result := Next(Parse(Value));
end;

function TSortOrderHelper.ToInt: Integer;
begin
  case Self of
    soNone: Result := 0;
    soAscending: Result := 1;
    soDescending: Result := -1;
  else
    raise Exception.CreateFmt('TSortOrderHelper.ToInt :: Unknown Value for', [Ord(Self)]);
  end;
end;

function TSortOrderHelper.Next: TSortOrder;
begin
  Result := Next(Self);
end;
{$ENDIF}

procedure ClearSortIcon(const AListViewHandle: NativeInt; const ColIndex: Integer);
var
  LHeader: THandle;
  LItem: HD_ITEM;
begin
  LHeader := SendMessage(AListViewHandle, LVM_GETHEADER, 0, 0);
  LItem.Mask := HDI_FORMAT;
  SendMessage(LHeader, HDM_GETITEM, ColIndex, Integer(@LItem));
  LItem.fmt := (LItem.fmt and not(HDF_SORTUP or HDF_SORTDOWN));
  SendMessage(LHeader, HDM_SETITEM, ColIndex, Integer(@LItem));
end;

procedure SetSortIcon(const AListViewHandle: NativeInt; const ColIndex: Integer; const Ascending: Boolean);
const
  HDF_SORTDOWN = $0200;
  HDF_SORTUP = $0400;
var
  LHeader: THandle;
  LItem: HD_ITEM;
begin
  LHeader := SendMessage(AListViewHandle, LVM_GETHEADER, 0, 0);
  LItem.Mask := HDI_FORMAT;
  SendMessage(LHeader, HDM_GETITEM, ColIndex, Integer(@LItem));
  if Ascending then
    LItem.fmt := (LItem.fmt and not HDF_SORTUP) or HDF_SORTDOWN
  else
    LItem.fmt := (LItem.fmt and not HDF_SORTDOWN) or HDF_SORTUP;

  SendMessage(LHeader, HDM_SETITEM, ColIndex, Integer(@LItem));
end;

end.