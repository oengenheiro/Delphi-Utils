object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 443
  ClientWidth = 461
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pClient: TPanel
    Left = 0
    Top = 0
    Width = 461
    Height = 402
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pClient'
    ShowCaption = False
    TabOrder = 0
    ExplicitLeft = 146
    ExplicitTop = 222
    ExplicitWidth = 185
    ExplicitHeight = 41
    object Memo1: TMemo
      Left = 0
      Top = 0
      Width = 461
      Height = 402
      Align = alClient
      Lines.Strings = (
        'Memo1')
      TabOrder = 0
      ExplicitLeft = 12
      ExplicitTop = 16
      ExplicitWidth = 425
      ExplicitHeight = 355
    end
  end
  object pBottom: TPanel
    Left = 0
    Top = 402
    Width = 461
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'pBottom'
    ShowCaption = False
    TabOrder = 1
    ExplicitLeft = 146
    ExplicitTop = 222
    ExplicitWidth = 185
    object btnAutoConnect: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 113
      Height = 35
      Align = alLeft
      Caption = 'Auto-Connect'
      TabOrder = 0
      OnClick = btnAutoConnectClick
      ExplicitLeft = 4
      ExplicitTop = 4
      ExplicitHeight = 33
    end
    object btnDisconnectFirstManager: TButton
      AlignWithMargins = True
      Left = 335
      Top = 3
      Width = 123
      Height = 35
      Align = alRight
      Caption = 'Disconnect First'
      TabOrder = 1
      OnClick = btnDisconnectFirstManagerClick
      ExplicitLeft = 142
      ExplicitTop = 16
      ExplicitHeight = 25
    end
  end
end
