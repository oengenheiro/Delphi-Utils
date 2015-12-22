unit FMX.Win.CustomDialogs;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin
  
// Easy calls to the MessageDlg function

interface

uses
  FMX.Dialogs;

procedure InfoMsg(const AMsg: string); overload;
procedure InfoMsg(const AMsg: string; const Args: array of const); overload;

function PromptMsg(const APrompt: string): Boolean; overload;
function PromptMsg(const APrompt: string; const AParams: array of const): Boolean; overload;
function PromptConfirm: Boolean;
function PromptDiscardAndExit: Boolean;

function ErrorAndPromptMsg(const APrompt: string): Boolean;
procedure ErrorMsg(const APrompt: string);
procedure ErrorMsgFmt(const AMsg: string; const Args: array of const);

function WarningMsg(const APrompt: string; const ShowCancelButton: Boolean = False): Integer;
function WarningMsgFmt(const APrompt: string; const Args: array of const;
  const ShowCancelButton: Boolean = False): Integer;

function WarningPrompt(const APrompt: string): Boolean;
function WarningPromptFmt(const APrompt: string; const Args: array of const): Boolean;

implementation

uses
  System.SysUtils,
  System.UITypes;

procedure ErrorMsgFmt(const AMsg: string; const Args: array of const);
begin
  ErrorMsg(Format(AMsg, Args));
end;

procedure InfoMsg(const AMsg: string);
begin
  MessageDlg(AMsg, TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
end;

procedure InfoMsg(const AMsg: string; const Args: array of const);
begin
  InfoMsg(Format(AMsg, Args));
end;

function PromptMsg(const APrompt: string): Boolean;
begin
  Result := MessageDlg(APrompt, TMsgDlgType.mtConfirmation, mbOKCancel, 0) = mrOk;
end;

function PromptMsg(const APrompt: string; const AParams: array of const): Boolean;
begin
  Result := PromptMsg(Format(APrompt, AParams));
end;

function PromptConfirm: Boolean;
begin
  Result := PromptMsg('Confirmar?');
end;

function PromptDiscardAndExit: Boolean;
begin
  Result := PromptMsg('Descartar cambios y salir?');
end;

function ErrorAndPromptMsg(const APrompt: string): Boolean;
begin
  Result := MessageDlg(APrompt, TMsgDlgType.mtError, mbOKCancel, 0) = mrOk;
end;

procedure ErrorMsg(const APrompt: string);
begin
  MessageDlg(APrompt, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
end;

function WarningMsgFmt(const APrompt: string; const Args: array of const;
  const ShowCancelButton: Boolean = False): Integer;
begin
  Result := WarningMsg(Format(APrompt, Args), ShowCancelButton);
end;

function WarningMsg(const APrompt: string; const ShowCancelButton: Boolean): Integer;
begin
  if ShowCancelButton then
    Result := MessageDlg(APrompt, TMsgDlgType.mtWarning, mbOKCancel, 0)
  else
    Result := MessageDlg(APrompt, TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0)
end;

function WarningPrompt(const APrompt: string): Boolean;
begin
  Result := WarningMsg(APrompt, True) = mrOk;
end;

function WarningPromptFmt(const APrompt: string; const Args: array of const): Boolean;
begin
  Result := WarningPrompt(Format(APrompt, Args));
end;

end.
