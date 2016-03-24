object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 292
  ClientWidth = 477
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 274
    Top = 176
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object Panel1: TPanel
    Left = 18
    Top = 8
    Width = 445
    Height = 107
    Caption = 'Panel1'
    TabOrder = 0
    object Button1: TButton
      Left = 14
      Top = 50
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
    end
    object RadioButton1: TRadioButton
      Left = 14
      Top = 16
      Width = 113
      Height = 17
      Caption = 'RadioButton1'
      TabOrder = 1
    end
    object Edit1: TEdit
      Left = 112
      Top = 14
      Width = 121
      Height = 21
      TabOrder = 2
      Text = 'Edit1'
    end
    object Memo1: TMemo
      Left = 247
      Top = 4
      Width = 185
      Height = 45
      Lines.Strings = (
        'Memo1')
      TabOrder = 3
    end
    object ComboBox1: TComboBox
      Left = 108
      Top = 55
      Width = 145
      Height = 21
      TabOrder = 4
      Text = 'ComboBox1'
    end
  end
  object ListView1: TListView
    Left = 16
    Top = 121
    Width = 250
    Height = 98
    Columns = <
      item
        Caption = 'Col 1'
      end>
    GridLines = True
    Items.ItemData = {
      054C0000000200000000000000FFFFFFFFFFFFFFFF00000000FFFFFFFF000000
      00064900740065006D002000310000000000FFFFFFFFFFFFFFFF00000000FFFF
      FFFF00000000064900740065006D0020003200}
    TabOrder = 1
    ViewStyle = vsReport
  end
  object DateTimePicker1: TDateTimePicker
    Left = 274
    Top = 134
    Width = 186
    Height = 21
    Date = 42453.528610034720000000
    Time = 42453.528610034720000000
    TabOrder = 2
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 246
    Width = 471
    Height = 43
    Align = alBottom
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 3
    ExplicitLeft = 1
    ExplicitTop = 241
    object btnWalkControls: TButton
      AlignWithMargins = True
      Left = 366
      Top = 4
      Width = 101
      Height = 35
      Align = alRight
      Caption = 'Walk Controls'
      TabOrder = 2
      OnClick = btnWalkControlsClick
    end
    object btnCountAll: TButton
      AlignWithMargins = True
      Left = 259
      Top = 4
      Width = 101
      Height = 35
      Align = alRight
      Caption = 'Count All Controls'
      TabOrder = 1
      OnClick = btnCountAllClick
      ExplicitLeft = 366
    end
    object btnCountButtons: TButton
      AlignWithMargins = True
      Left = 152
      Top = 4
      Width = 101
      Height = 35
      Align = alRight
      Caption = 'Count TButtons'
      TabOrder = 0
      OnClick = btnCountButtonsClick
      ExplicitLeft = 366
    end
  end
end
