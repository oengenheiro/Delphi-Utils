unit Vcl.ListViewUtils;

interface

// source: http://delphiaccess.com/foros/index.php/topic/11740-como-colocar-las-flechitas-que-indican-el-orden-de-columnas-de-un-listview/
// author: escafandra
procedure SetSortIcon(const AListViewHandle: NativeInt; const ColIndex: Integer; const Ascending: Boolean);
procedure ClearSortIcon(const AListViewHandle: NativeInt; const ColIndex: Integer);

implementation

uses
  {$IF CompilerVersion > 21}
  Winapi.CommCtrl,
  Winapi.Windows;
  {$ELSE}
  CommCtrl,
  Windows;
  {$IFEND}

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