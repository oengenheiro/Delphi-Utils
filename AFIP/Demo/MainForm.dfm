object Main: TMain
  Left = 0
  Top = 0
  Caption = 'Test API Publica AFIP'
  ClientHeight = 379
  ClientWidth = 469
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 469
    Height = 379
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Consulta por numero de cuit'
      object btnQueryPersona: TButton
        Left = 328
        Top = 15
        Width = 75
        Height = 25
        Caption = 'Consultar'
        TabOrder = 0
        OnClick = btnQueryPersonaClick
      end
      object MemoQueryPersona: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 100
        Width = 455
        Height = 121
        Align = alBottom
        ScrollBars = ssVertical
        TabOrder = 1
        ExplicitLeft = 0
        ExplicitTop = 83
      end
      object edNroCuit: TLabeledEdit
        Left = 3
        Top = 19
        Width = 292
        Height = 21
        EditLabel.Width = 39
        EditLabel.Height = 13
        EditLabel.Caption = 'Nro Cuit'
        NumbersOnly = True
        TabOrder = 2
      end
      object MemoRawJsonPersona: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 227
        Width = 455
        Height = 121
        Align = alBottom
        ScrollBars = ssVertical
        TabOrder = 3
        ExplicitTop = 46
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Consulta por numero de documento'
      ImageIndex = 1
      ExplicitLeft = 8
      object MemoQueryDni: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 104
        Width = 455
        Height = 244
        Align = alBottom
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object btnQueryDni: TButton
        Left = 330
        Top = 17
        Width = 75
        Height = 25
        Caption = 'Consultar'
        TabOrder = 1
        OnClick = btnQueryDniClick
      end
      object edNroDni: TLabeledEdit
        Left = 5
        Top = 21
        Width = 292
        Height = 21
        EditLabel.Width = 38
        EditLabel.Height = 13
        EditLabel.Caption = 'Nro DNI'
        NumbersOnly = True
        TabOrder = 2
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Obtener PDF constancia'
      ImageIndex = 2
      object btnObtenerConstancia: TButton
        Left = 332
        Top = 19
        Width = 75
        Height = 25
        Caption = 'Descargar'
        TabOrder = 0
        OnClick = btnObtenerConstanciaClick
      end
      object edCuitConstancia: TLabeledEdit
        Left = 7
        Top = 23
        Width = 292
        Height = 21
        EditLabel.Width = 39
        EditLabel.Height = 13
        EditLabel.Caption = 'Nro Cuit'
        NumbersOnly = True
        TabOrder = 1
      end
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 406
    Top = 76
  end
end
