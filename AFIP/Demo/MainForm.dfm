object Main: TMain
  Left = 0
  Top = 0
  Caption = 'Test API Publica AFIP'
  ClientHeight = 554
  ClientWidth = 759
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 17
  object PageControl1: TPageControl
    Left = 0
    Top = 82
    Width = 759
    Height = 472
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Consulta por numero de cuit'
      object MemoQueryPersona: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 66
        Width = 745
        Height = 244
        Align = alBottom
        ScrollBars = ssVertical
        TabOrder = 3
      end
      object btnQueryPersona: TButton
        Left = 328
        Top = 15
        Width = 75
        Height = 25
        Caption = 'Consultar'
        TabOrder = 2
        OnClick = btnQueryPersonaClick
      end
      object MemoRawJsonPersona: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 316
        Width = 745
        Height = 121
        Align = alBottom
        ScrollBars = ssVertical
        TabOrder = 1
      end
      object edNroCuit: TLabeledEdit
        Left = 14
        Top = 19
        Width = 292
        Height = 25
        EditLabel.Width = 49
        EditLabel.Height = 17
        EditLabel.Caption = 'Nro Cuit'
        NumbersOnly = True
        TabOrder = 0
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Consulta por numero de documento'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 659
      ExplicitHeight = 453
      object MemoQueryDni: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 90
        Width = 745
        Height = 347
        Align = alBottom
        ScrollBars = ssVertical
        TabOrder = 0
        ExplicitTop = 103
        ExplicitWidth = 653
      end
      object btnQueryDni: TButton
        Left = 330
        Top = 33
        Width = 75
        Height = 25
        Caption = 'Consultar'
        TabOrder = 1
        OnClick = btnQueryDniClick
      end
      object edNroDni: TLabeledEdit
        Left = 7
        Top = 33
        Width = 292
        Height = 25
        EditLabel.Width = 49
        EditLabel.Height = 17
        EditLabel.Caption = 'Nro DNI'
        NumbersOnly = True
        TabOrder = 2
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Obtener PDF constancia'
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 659
      ExplicitHeight = 453
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
        Height = 25
        EditLabel.Width = 49
        EditLabel.Height = 17
        EditLabel.Caption = 'Nro Cuit'
        NumbersOnly = True
        TabOrder = 1
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Parametros'
      ImageIndex = 3
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 471
      ExplicitHeight = 453
      object lbTime: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 45
        Width = 745
        Height = 17
        Align = alBottom
        Caption = 'Time:'
        ExplicitWidth = 31
      end
      object btnGetParametros: TButton
        Left = 188
        Top = 10
        Width = 91
        Height = 33
        Caption = 'Consultar'
        TabOrder = 0
        OnClick = btnGetParametrosClick
      end
      object cbParametros: TComboBox
        Left = 10
        Top = 14
        Width = 145
        Height = 25
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 1
        Text = 'Actividades'
        Items.Strings = (
          'Actividades'
          'Conceptos'
          'Provincias'
          'Caracterizaciones'
          'CategoriasMonotributo'
          'CategoriasAutonomo'
          'Impuestos'
          'Dependencias')
      end
      object memoParametros: TMemo
        AlignWithMargins = True
        Left = 3
        Top = 68
        Width = 745
        Height = 369
        Align = alBottom
        ScrollBars = ssVertical
        TabOrder = 2
        ExplicitTop = 81
        ExplicitWidth = 465
      end
    end
  end
  object pTop: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 753
    Height = 76
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 1
    object rgHttpLibrary: TRadioGroup
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 236
      Height = 70
      Align = alLeft
      Caption = 'Biblioteca HTTP'
      ItemIndex = 0
      Items.Strings = (
        'Synapse (open source, third-party)'
        'NetHttp (Delphi XE8+)')
      TabOrder = 0
    end
    object rgPersistencia: TRadioGroup
      AlignWithMargins = True
      Left = 487
      Top = 3
      Width = 236
      Height = 70
      Align = alLeft
      Caption = 'Persistencia'
      ItemIndex = 0
      Items.Strings = (
        'No usar'
        'TMemoryAfipPersister')
      TabOrder = 2
      OnClick = rgPersistenciaClick
    end
    object rgJsonLibrary: TRadioGroup
      AlignWithMargins = True
      Left = 245
      Top = 3
      Width = 236
      Height = 70
      Align = alLeft
      Caption = 'Biblioteca JSON'
      ItemIndex = 0
      Items.Strings = (
        'System.Json'
        'lkJson (open source, third-party)')
      TabOrder = 1
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 406
    Top = 150
  end
end
