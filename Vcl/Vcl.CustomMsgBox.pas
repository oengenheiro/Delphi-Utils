unit Vcl.CustomMsgBox;

// Source: http://clubdelphi.com/foros/showthread.php?t=80897
// Author: Lord Delfos
  
// This unit implement a Custom Dialog Form
// Suports:
// Easy customizable button captions
// Callbacks
// Displaying a Checkbox

interface

uses
  {$IF CompilerVersion > 21}
  Vcl.Dialogs;
  {$ELSE}
  Dialogs;
  {$IFEND}

type
  TMsgBoxCallBack = procedure;

// Muestra un cuadro de diálogo común.
function MsgBox(const Titulo, Texto: string; TipoDialogo: TMsgDlgType; const Botones: array of string;
  Defecto: Integer = 0): Integer; overload;

// Muestra un cuadro de diálogo y llama a una función callback al clickear el último botón.
function MsgBox(const Titulo, Texto: string; TipoDialogo: TMsgDlgType; const Botones: array of string;
  CallBack: TMsgBoxCallBack; Defecto: Integer = 0): Integer; overload;

// Muestra un cuadro de diálogo con una CheckBox.
function MsgBox(const Titulo, Texto: string; TipoDialogo: TMsgDlgType; const Botones: array of string;
  const TituloCheckBox: string; var CBChecked: Boolean; Defecto: Integer = 0): Integer; overload;

// Muestra un cuadro de diálogo con una CheckBox y con función callback.
function MsgBox(const Titulo, Texto: string; TipoDialogo: TMsgDlgType; const Botones: array of string;
  const TituloCheckBox: string; var CBChecked: Boolean; CallBack: TMsgBoxCallBack; Defecto: Integer = 0): Integer; overload;

implementation

uses
  {$IF CompilerVersion > 21}
  Winapi.Windows,
  System.Classes,
  System.SysUtils,
  System.Math,
  Vcl.Forms,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Graphics;
  {$ELSE}
  Windows,
  Classes,
  SysUtils,
  Math,
  Forms,
  StdCtrls,
  ExtCtrls,
  Graphics;
  {$IFEND}

const
  IconIDs: array [TMsgDlgType] of PChar = (IDI_EXCLAMATION, IDI_HAND, IDI_ASTERISK, IDI_QUESTION, NIL);

type
  TDialogForm = class(TForm)
  protected
    FBotonClickeado: Integer;
    TipoDialogo: TMsgDlgType;
    SePuedeCerrar: Boolean;
    BotonCallBack: TComponent;
    CallBack: TMsgBoxCallBack;
    procedure PresTecla(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ClickBoton(Sender: TObject);
    procedure Cerrar(Sender: TObject; var CanClose: Boolean);
  public
    constructor Create(const Titulo, Texto: string; TipoDialogo: TMsgDlgType; const Botones: array of string;
      CallBack: TMsgBoxCallBack = NIL; Defecto: Integer = 0); reintroduce;
    property BotonClickeado: Integer read FBotonClickeado;
    function ShowModal: Integer; override;
  end;

{ TDialogForm }

constructor TDialogForm.Create(const Titulo, Texto: string; TipoDialogo: TMsgDlgType; const Botones: array of string;
  CallBack: TMsgBoxCallBack = NIL; Defecto: Integer = 0);
var
  Etiqueta: TLabel;
  Icono: TImage;
  Boton: TButton;
  AltoBotones, AnchoBotones, AnchoTotalBotones, Ind, Aux: Integer;
begin
  inherited CreateNew(Application);
  TipoDialogo := TipoDialogo;
  OnKeyDown := PresTecla;
  OnCloseQuery := Cerrar;
  KeyPreview := True;
  Caption := Titulo;
  BorderStyle := bsDialog;
  Position := poScreenCenter;
  SePuedeCerrar := False;

  AltoBotones := 0;
  AnchoBotones := 0;
  for Ind := 0 to Length(Botones) - 1 do
  begin
    if Canvas.TextWidth(Botones[Ind]) > AnchoBotones then
      AnchoBotones := Canvas.TextWidth(Botones[Ind]);

    if Canvas.TextHeight(Botones[Ind]) > AltoBotones then
      AltoBotones := Canvas.TextHeight(Botones[Ind]);
  end;
  AnchoBotones := Max(AnchoBotones + 16, 75);
  AltoBotones := Max(AltoBotones + 8, 25);
  AnchoTotalBotones := Length(Botones) * (AnchoBotones + 8) - 8;

  Icono := TImage.Create(Self);
  with Icono do
  begin
    Parent := Self;
    Picture.Icon.Handle := LoadIcon(0, IconIDs[TipoDialogo]);
    SetBounds(11, 11, 32, 32);
  end;

  Etiqueta := TLabel.Create(Self);
  with Etiqueta do
  begin
    Parent := Self;
    AutoSize := True;
    Caption := Texto;
    Left := Icono.Left + Icono.Width + 16;
    Top := 16;
  end;

  ClientWidth := Max(Etiqueta.Width + Etiqueta.Left + 16, 10 + AnchoTotalBotones + 10);
  ClientHeight := Max(Etiqueta.Height + Etiqueta.Top, Icono.Height + Icono.Top) + 16 + AltoBotones + 12;

  Aux := ClientWidth div 2 - (AnchoTotalBotones) div 2;
  for Ind := 0 to Length(Botones) - 1 do
  begin
    Boton := TButton.Create(Self);
    with Boton do
    begin
      Parent := Self;
      Caption := Botones[Ind];
      Tag := Ind;
      OnClick := ClickBoton;
      Left := Aux + (AnchoBotones + 8) * Ind;
      Width := AnchoBotones;
      Top := Max(Etiqueta.Height + Etiqueta.Top, Icono.Top + Icono.Height) + 16;
      if Defecto = Ind then
        ActiveControl := Boton;
    end;
  end;

  CallBack := CallBack;
  if Assigned(CallBack) then
    BotonCallBack := Controls[ControlCount - 1];
end;

function TDialogForm.ShowModal: Integer;
begin
  Result := inherited ShowModal;
end;

procedure TDialogForm.ClickBoton(Sender: TObject);
begin
  if (TComponent(Sender) = BotonCallBack) and Assigned(CallBack) then
    CallBack
  else
  begin
    FBotonClickeado := TButton(Sender).Tag;
    SePuedeCerrar := True;
    Close;
  end;
end;

procedure TDialogForm.PresTecla(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_F4) and (ssAlt in Shift) then
    Key := 0;

  if Key = VK_ESCAPE then
  begin
    FBotonClickeado := -1;
    SePuedeCerrar := True;
    Close;
  end;
end;

procedure TDialogForm.Cerrar(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := SePuedeCerrar;
end;

function MsgBox(const Titulo, Texto: string; TipoDialogo: TMsgDlgType; const Botones: array of string;
  Defecto: Integer = 0): Integer;
var
  Dlg: TDialogForm;
begin
  if Length(Botones) = 0 then
    raise Exception.Create('MsgBox: Debe haber al menos un botón.');

  Dlg := TDialogForm.Create(Titulo, Texto, TipoDialogo, Botones, NIL, Defecto);
  try
    Dlg.ShowModal;
    Result := Dlg.BotonClickeado;
  finally
    Dlg.Free;
  end;
end;

function MsgBox(const Titulo, Texto: string; TipoDialogo: TMsgDlgType; const Botones: array of string;
  CallBack: TMsgBoxCallBack; Defecto: Integer = 0): Integer;
var
  Dlg: TDialogForm;
begin
  if Length(Botones) < 2 then
    raise Exception.Create('MsgBox: Debe haber al menos dos botones.');

  Dlg := TDialogForm.Create(Titulo, Texto, TipoDialogo, Botones, CallBack, Defecto);
  try
    Dlg.ShowModal;
    Result := Dlg.BotonClickeado;
  finally
    Dlg.Free;
  end;
end;

function MsgBox(const Titulo, Texto: string; TipoDialogo: TMsgDlgType; const Botones: array of string;
  const TituloCheckBox: string; var CBChecked: Boolean; Defecto: Integer = 0): Integer;
begin
  if Length(Botones) = 0 then
    raise Exception.Create('MsgBox: Debe haber al menos un botón.');

  Result := MsgBox(Titulo, Texto, TipoDialogo, Botones, TituloCheckBox, CBChecked, NIL, Defecto);
end;

function MsgBox(const Titulo, Texto: string; TipoDialogo: TMsgDlgType; const Botones: array of string;
  const TituloCheckBox: string; var CBChecked: Boolean; CallBack: TMsgBoxCallBack; Defecto: Integer = 0): Integer;
var
  Dlg: TDialogForm;
  CB: TCheckBox;
begin
  if Assigned(CallBack) and (Length(Botones) < 2) then
      raise Exception.Create('MsgBox: Debe haber al menos dos botones.');

  Dlg := TDialogForm.Create(Titulo, Texto, TipoDialogo, Botones, CallBack, Defecto);
  CB := TCheckBox.Create(Dlg);
  try
    with CB do
    begin
      Parent := Dlg;
      Left := 8;
      Top := Dlg.ClientHeight;
      Width := Dlg.Width;
      Caption := TituloCheckBox;
      Checked := CBChecked;
    end;
    Dlg.Height := Dlg.Height + CB.Height + 8;
    Dlg.ShowModal;
    CBChecked := CB.Checked;
    Result := Dlg.BotonClickeado;
  finally
    Dlg.Free;
  end;
end;

end.
