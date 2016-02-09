unit Vcl.DropTarget;

// Source: http://stackoverflow.com/questions/4354071/
// Author: David Heffernan

// Wraps Windows IDragDrop interface in a TDropTarget class; to enable drag-drop files operations
// you must only implement IDragDrop and pass in the TDropTarget constructor

interface

uses
  Winapi.Windows,
  Winapi.ActiveX;

type
  IDragDrop = interface
    function DropAllowed(const FileNames: array of string): Boolean;
    procedure Drop(const FileNames: array of string);
  end;

  IDropTarget = Winapi.ActiveX.IDropTarget;

  TDropTarget = class(TInterfacedObject, IDropTarget)
  private
    FHandle: HWND;
    FDragDrop: IDragDrop;
    FDropAllowed: Boolean;
    procedure GetFileNames(const dataObj: IDataObject; var FileNames: TArray<string>);
    procedure SetEffect(var dwEffect: Integer);
    function DragEnter(const dataObj: IDataObject; grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult; stdcall;
    function DragOver(grfKeyState: LongInt; pt: TPoint; var dwEffect: LongInt): HResult; stdcall;
    function DragLeave: HResult; stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: LongInt; pt: TPoint; var dwEffect: LongInt): HResult; stdcall;
  public
    constructor Create(AHandle: HWND; const ADragDrop: IDragDrop);
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils,
  Vcl.Forms,
  Winapi.ShellAPI;

{ TDropTarget }

constructor TDropTarget.Create(AHandle: HWND; const ADragDrop: IDragDrop);
begin
  inherited Create;
  FHandle := AHandle;
  FDragDrop := ADragDrop;

  // RegisterDragDrop will increase the Reference Counting by 1, so the interface
  // will never be free'd
  // this is a hack fix
  if RegisterDragDrop(FHandle, Self) = S_OK then
    _Release
  else
    Abort;
end;

destructor TDropTarget.Destroy;
begin
  RevokeDragDrop(FHandle);
  inherited;
end;

procedure TDropTarget.GetFileNames(const dataObj: IDataObject; var FileNames: TArray<string>);
var
  I: Integer;
  formatetcIn: TFormatEtc;
  medium: TStgMedium;
  dropHandle: HDROP;
begin
  FileNames := NIL;
  formatetcIn.cfFormat := CF_HDROP;
  formatetcIn.ptd := NIL;
  formatetcIn.dwAspect := DVASPECT_CONTENT;
  formatetcIn.lindex := -1;
  formatetcIn.tymed := TYMED_HGLOBAL;
  if dataObj.GetData(formatetcIn, medium) = S_OK then
  begin
    (* This cast needed because HDROP is incorrectly declared as LongInt in ShellAPI.pas.
        It should be declared as THandle which is an unsigned integer.
        Without this fix the routine fails in top-down memory allocation scenarios. *)

    dropHandle := HDROP(medium.hGlobal);
    SetLength(FileNames, DragQueryFile(dropHandle, $FFFFFFFF, NIL, 0));
    for I := 0 to high(FileNames) do
    begin
      SetLength(FileNames[I], DragQueryFile(dropHandle, I, NIL, 0));
      DragQueryFile(dropHandle, I, @FileNames[I][1], Length(FileNames[I]) + 1);
    end;
  end;
end;

procedure TDropTarget.SetEffect(var dwEffect: Integer);
begin
  if FDropAllowed then
    dwEffect := DROPEFFECT_COPY
  else
    dwEffect := DROPEFFECT_NONE;
end;

function TDropTarget.DragEnter(const dataObj: IDataObject; grfKeyState: Integer; pt: TPoint;
  var dwEffect: Integer): HResult;
var
  FileNames: TArray<string>;
begin
  Result := S_OK;
  try
    GetFileNames(dataObj, FileNames);
    FDropAllowed := (Length(FileNames) > 0) and FDragDrop.DropAllowed(FileNames);
    SetEffect(dwEffect);
  except
    Result := E_UNEXPECTED;
  end;
end;

function TDropTarget.DragLeave: HResult;
begin
  Result := S_OK;
end;

function TDropTarget.DragOver(grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
begin
  Result := S_OK;
  try
    SetEffect(dwEffect);
  except
    Result := E_UNEXPECTED;
  end;
end;

function TDropTarget.Drop(const dataObj: IDataObject; grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
var
  FileNames: TArray<string>;
begin
  Result := S_OK;
  try
    GetFileNames(dataObj, FileNames);
    if Length(FileNames) > 0 then
      FDragDrop.Drop(FileNames);
  except
    Application.HandleException(Self);
  end;
end;

end.
