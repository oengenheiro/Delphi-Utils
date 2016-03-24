unit Main;

interface

uses
  System.Classes,
  Vcl.Forms,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    RadioButton1: TRadioButton;
    Edit1: TEdit;
    Memo1: TMemo;
    ComboBox1: TComboBox;
    ListView1: TListView;
    DateTimePicker1: TDateTimePicker;
    Label1: TLabel;
    Panel2: TPanel;
    btnWalkControls: TButton;
    btnCountAll: TButton;
    btnCountButtons: TButton;
    procedure btnCountAllClick(Sender: TObject);
    procedure btnCountButtonsClick(Sender: TObject);
    procedure btnWalkControlsClick(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  Vcl.CustomDialogs,
  Vcl.Controls.Enumerator;

procedure TForm1.btnCountAllClick(Sender: TObject);
begin
  InfoMsgFmt('%d', [TControls.ChildCount<TWinControl>(Self)]);
end;

procedure TForm1.btnCountButtonsClick(Sender: TObject);
begin
  InfoMsgFmt('%d', [TControls.ChildCount<TWinControl>(Self, function(AControl: TWinControl): Boolean
  begin
    Result := AControl is TButton
  end)]);
end;

procedure TForm1.btnWalkControlsClick(Sender: TObject);
begin
  TControls.WalkControls<TWinControl>(Self, procedure(AControl: TWinControl)
  begin
    InfoMsg(AControl.ClassName);
  end);
end;

end.
