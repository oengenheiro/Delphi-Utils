unit Vcl.CustomDialogs;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin
  
// Easy calls to the TDialogForm
// see Vcl.CustomMsgBox @ https://github.com/ortuagustin/Delphi-Utils/blob/master/Vcl/Vcl.CustomMsgBox.pas

interface

/// <summary> Shows an Information Message </summary>
procedure InfoMsg(const Msg: string);
/// <summary> Shows an Information Message with custom formatting </summary>
procedure InfoMsgFmt(const Msg: string; const Args: array of const);
/// <summary> Displays a Confirmation Message with a custom formatted prompt (OK-Cancel). Returns True if click on OK. False otherwise </summary>
function PromptMsg(const Prompt: string): Boolean;
/// <summary> Displays a Confirmation Message with a prompt (OK-Cancel). Returns True if click on OK. False otherwise </summary>
function PromptMsgFmt(const Prompt: string; const AParams: array of const): Boolean;
/// <summary> Displays a Confirmation Message prompting to discard changes (OK-Cancel). Returns True if click on OK. False otherwise </summary>
function PromptDiscardAndExit: Boolean;
/// <summary> Displays a Error Message with a custom formatted prompt (OK-Cancel). Returns True if click on OK. False otherwise</summary>
function ErrorAndPromptMsg(const Prompt: string): Boolean;
/// <summary> Shows an Error Message </summary>
procedure ErrorMsg(const Msg: string);
/// <summary> Shows an Error Message with custom formatting </summary>
procedure ErrorMsgFmt(const Msg: string; const Args: array of const);
/// <summary> Shows an Error Message and then calls System.Abort </summary>
procedure ErrorAbortMsg(const Msg: string);
/// <summary> Shows an Error Message with custom formatting and then calls System.Abort </summary>
procedure ErrorAbortMsgFmt(const Msg: string; const Args: array of const);
/// <summary> Displays a Warning Message </summary>
function WarningMsg(const Msg: string; const ShowCancelButton: Boolean = False): Integer;
/// <summary> Displays a Warning Message with custom formatting </summary>
function WarningMsgFmt(const Msg: string; const Args: array of const; const ShowCancelButton: Boolean = False): Integer;
/// <summary> Displays a Warning Message with a prompt (OK-Cancel). Returns True if click on OK. False otherwise </summary>
function WarningPrompt(const Prompt: string): Boolean;
/// <summary> Displays a Warning Message with a custom formatted prompt (OK-Cancel). Returns True if click on OK. False otherwise </summary>
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

procedure ErrorAbortMsg(const Msg: string);
begin
  ErrorMsg(Msg);
  Abort;
end;

procedure ErrorAbortMsgFmt(const Msg: string; const Args: array of const);
begin
  ErrorAbortMsg(Format(Msg, Args));
end;

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

procedure ErrorMsg(const Msg: string);
begin
  MsgBox('Error', Msg, mtError, ['Aceptar']);
end;

function WarningMsgFmt(const Msg: string; const Args: array of const;
  const ShowCancelButton: Boolean): Integer;
begin
  Result := WarningMsg(Format(Msg, Args), ShowCancelButton);
end;

function WarningMsg(const Msg: string; const ShowCancelButton: Boolean): Integer;
begin
  if ShowCancelButton then
    Result := MsgBox('Advertencia', Msg, mtWarning, ['Aceptar', 'Cancelar'])
  else
    Result := MsgBox('Advertencia', Msg, mtWarning, ['Aceptar'])
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
