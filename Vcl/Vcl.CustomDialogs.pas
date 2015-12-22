unit Vcl.CustomDialogs;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin
  
// Easy calls to the TDialogForm
// see Vcl.CustomMsgBox @ https://github.com/ortuagustin/Delphi-Utils/blob/master/Vcl/Vcl.CustomMsgBox.pas

interface

procedure InfoMsg(const Msg: string);
procedure InfoMsgFmt(const Msg: string; const Args: array of const);

function PromptMsg(const Prompt: string): Boolean;
function PromptMsgFmt(const Prompt: string; const AParams: array of const): Boolean;
function PromptDiscardAndExit: Boolean;
function ErrorAndPromptMsg(const Prompt: string): Boolean;

procedure ErrorMsg(const Prompt: string);
procedure ErrorMsgFmt(const Msg: string; const Args: array of const);

function WarningMsg(const Prompt: string; const ShowCancelButton: Boolean = False): Integer;
function WarningMsgFmt(const Prompt: string; const Args: array of const; const ShowCancelButton: Boolean = False): Integer;
function WarningPrompt(const Prompt: string): Boolean;
function WarningPromptFmt(const Prompt: string; const Args: array of const): Boolean;

implementation

uses
  {$IF CompilerVersion > 21}
  System.SysUtils,
  Vcl.Dialogs,
  {$ELSE}
  SysUtils,
  Dialogs,
  {$IFEND}
  Vcl.CustomMsgBox;

procedure ErrorMsgFmt(const Msg: string; const Args: array of const);
begin
  ErrorMsg(Format(Msg, Args));
end;

procedure InfoMsg(const Msg: string);
begin
  MsgBox('Información', Msg, mtInformation, ['Aceptar']);
end;

procedure InfoMsgFmt(const Msg: string; const Args: array of const);
begin
  InfoMsg(Format(Msg, Args));
end;

function PromptMsg(const Prompt: string): Boolean;
begin
  Result := MsgBox('Confirmar', Prompt, mtConfirmation, ['Si', 'No']) = 0;
end;

function PromptMsgFmt(const Prompt: string; const AParams: array of const): Boolean;
begin
  Result := PromptMsg(Format(Prompt, AParams));
end;

function PromptDiscardAndExit: Boolean;
begin
  Result := PromptMsg('Descartar cambios y salir?');
end;

function ErrorAndPromptMsg(const Prompt: string): Boolean;
begin
  Result := MsgBox('Error', Prompt, mtError, ['Aceptar', 'Cancelar']) = 0;
end;

procedure ErrorMsg(const Prompt: string);
begin
  MsgBox('Error', Prompt, mtError, ['Aceptar']);
end;

function WarningMsgFmt(const Prompt: string; const Args: array of const;
  const ShowCancelButton: Boolean): Integer;
begin
  Result := WarningMsg(Format(Prompt, Args), ShowCancelButton);
end;

function WarningMsg(const Prompt: string; const ShowCancelButton: Boolean): Integer;
begin
  if ShowCancelButton then
    Result := MsgBox('Advertencia', Prompt, mtWarning, ['Aceptar', 'Cancelar'])
  else
    Result := MsgBox('Advertencia', Prompt, mtWarning, ['Aceptar'])
end;

function WarningPrompt(const Prompt: string): Boolean;
begin
  Result := WarningMsg(Prompt, True) = 0;
end;

function WarningPromptFmt(const Prompt: string; const Args: array of const): Boolean;
begin
  Result := WarningPrompt(Format(Prompt, Args));
end;

end.
