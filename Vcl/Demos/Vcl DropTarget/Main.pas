unit Main;

interface

uses
  Vcl.DropTarget,
  System.Classes,
  Vcl.Forms,
  Vcl.Controls,
  Vcl.StdCtrls;

type
  TForm1 = class(TForm, IDragDrop)
    Memo1: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    FDropTarget: IDropTarget;
    procedure CreateWnd; override;
  public
    function DropAllowed(const FileNames: array of string): Boolean;
    procedure Drop(const FileNames: array of string);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  Vcl.CustomDialogs;

procedure TForm1.Drop(const FileNames: array of string);
var
  AFile: string;
begin
  Memo1.Clear;
  for AFile in FileNames do
    Memo1.Lines.Add(AFile);
end;

function TForm1.DropAllowed(const FileNames: array of string): Boolean;
begin
  Result := Length(FileNames) > 0;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TForm1.CreateWnd;
begin
  inherited;
  FDropTarget := TDropTarget.Create(Handle, Self);
end;

end.
