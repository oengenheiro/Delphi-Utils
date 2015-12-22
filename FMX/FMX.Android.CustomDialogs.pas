unit FMX.Android.CustomDialogs;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin
  
// Easy calls to the MessageDlg function

interface

uses
  System.SysUtils,
  FMX.Dialogs;

procedure InfoMsg(const Msg: string); overload;
procedure InfoMsg(const Msg: string; const Args: array of const); overload;

procedure PromptMsg(const Prompt: string; ClickOk: TProc; ClickCancel: TProc = NIL); overload;
procedure PromptMsg(const Prompt: string; const AParams: array of const; ClickOk: TProc;
  ClickCancel: TProc = NIL); overload;  
procedure PromptConfirm(ClickOk: TProc; ClickCancel: TProc = NIL);
procedure PromptDiscardAndExit(ClickOk, ClickCancel: TProc);

procedure ErrorAndPromptMsg(const Prompt: string; ClickOk: TProc; ClickCancel: TProc = NIL);
procedure ErrorMsg(const Prompt: string);
procedure ErrorMsgFmt(const Msg: string; const Args: array of const);

procedure WarningMsg(const Prompt: string; ClickOk: TProc; ClickCancel: TProc = NIL);
procedure WarningMsgFmt(const Prompt: string; const Args: array of const; ClickOk: TProc; ClickCancel: TProc = NIL);

implementation

uses
  System.UITypes;

procedure InfoMsg(const Msg: string);
begin
  MessageDlg(Msg, TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0, NIL);
end;

procedure InfoMsg(const Msg: string; const Args: array of const);
begin
  InfoMsg(Format(Msg, Args));
end;

procedure PromptMsg(const Prompt: string; ClickOk, ClickCancel: TProc);
begin
  MessageDlg(Prompt, TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], 0,
    procedure(const AModalResult: TModalResult)
    begin
      case AModalResult of
        mrOk: if Assigned(ClickOk) then ClickOk;
      else
        if Assigned(ClickCancel) then ClickCancel;
      end;
    end);
end;

procedure PromptMsg(const Prompt: string; const AParams: array of const; ClickOk, ClickCancel: TProc);
begin
  PromptMsg(Format(Prompt, AParams), ClickOk, ClickCancel);
end;

procedure PromptConfirm(ClickOk, ClickCancel: TProc);
begin
  PromptMsg('Es correcto', ClickOk, ClickCancel);
end;

procedure PromptDiscardAndExit(ClickOk, ClickCancel: TProc);
begin
  PromptMsg('Descartar y salir?', ClickOk, ClickCancel);
end;

procedure ErrorAndPromptMsg(const Prompt: string; ClickOk, ClickCancel: TProc);
begin
  MessageDlg(Prompt, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], 0,
    procedure(const AModalResult: TModalResult)
    begin
      case AModalResult of
        mrOk: if Assigned(ClickOk) then ClickOk;
      else
        if Assigned(ClickCancel) then ClickCancel;
      end;
    end);
end;

procedure ErrorMsg(const Prompt: string);
begin
  MessageDlg(Prompt, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0, NIL);
end;

procedure ErrorMsgFmt(const Msg: string; const Args: array of const);
begin
  ErrorMsg(Format(Msg, Args));
end;

procedure WarningMsg(const Prompt: string; ClickOk, ClickCancel: TProc);
var
  Buttons: TMsgDlgButtons;
begin
  if Assigned(ClickCancel) then
    Buttons := [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel]
  else
    Buttons := [TMsgDlgBtn.mbOK];

  MessageDlg(Prompt, TMsgDlgType.mtWarning, Buttons, 0, procedure(const AModalResult: TModalResult)
    begin
      case AModalResult of
        mrOk: if Assigned(ClickOk) then ClickOk;
      else
        if Assigned(ClickCancel) then ClickCancel;
      end;
    end);
end;

procedure WarningMsgFmt(const Prompt: string; const Args: array of const; ClickOk, ClickCancel: TProc);
begin
  WarningMsg(Format(Prompt, Args), ClickOk, ClickCancel);
end;

end.
