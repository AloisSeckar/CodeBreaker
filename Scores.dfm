object Form4: TForm4
  Left = 191
  Top = 183
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'High Scores'
  ClientHeight = 270
  ClientWidth = 248
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ScoresChart: TPageControl
    Left = 25
    Top = 15
    Width = 196
    Height = 201
    ActivePage = TabSheet1
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabIndex = 0
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Easy'
      object Label1: TLabel
        Left = 20
        Top = 15
        Width = 12
        Height = 13
        Caption = '1.'
      end
      object Label2: TLabel
        Left = 20
        Top = 30
        Width = 12
        Height = 13
        Caption = '2.'
      end
      object Label3: TLabel
        Left = 20
        Top = 45
        Width = 12
        Height = 13
        Caption = '3.'
      end
      object Label4: TLabel
        Left = 20
        Top = 60
        Width = 12
        Height = 13
        Caption = '4.'
      end
      object Label5: TLabel
        Left = 20
        Top = 75
        Width = 12
        Height = 13
        Caption = '5.'
      end
      object Label6: TLabel
        Left = 20
        Top = 90
        Width = 12
        Height = 13
        Caption = '6.'
      end
      object Label7: TLabel
        Left = 20
        Top = 105
        Width = 12
        Height = 13
        Caption = '7.'
      end
      object Label8: TLabel
        Left = 20
        Top = 120
        Width = 12
        Height = 13
        Caption = '8.'
      end
      object Label9: TLabel
        Left = 20
        Top = 135
        Width = 12
        Height = 13
        Caption = '9.'
      end
      object Label10: TLabel
        Left = 12
        Top = 150
        Width = 20
        Height = 13
        Caption = '10.'
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Moderate'
      ImageIndex = 1
      object Label11: TLabel
        Left = 20
        Top = 15
        Width = 12
        Height = 13
        Caption = '1.'
      end
      object Label12: TLabel
        Left = 20
        Top = 30
        Width = 12
        Height = 13
        Caption = '2.'
      end
      object Label13: TLabel
        Left = 20
        Top = 45
        Width = 12
        Height = 13
        Caption = '3.'
      end
      object Label14: TLabel
        Left = 20
        Top = 60
        Width = 12
        Height = 13
        Caption = '4.'
      end
      object Label15: TLabel
        Left = 20
        Top = 75
        Width = 12
        Height = 13
        Caption = '5.'
      end
      object Label16: TLabel
        Left = 20
        Top = 105
        Width = 12
        Height = 13
        Caption = '7.'
      end
      object Label17: TLabel
        Left = 20
        Top = 120
        Width = 12
        Height = 13
        Caption = '8.'
      end
      object Label18: TLabel
        Left = 20
        Top = 135
        Width = 12
        Height = 13
        Caption = '9.'
      end
      object Label19: TLabel
        Left = 12
        Top = 150
        Width = 20
        Height = 13
        Caption = '10.'
      end
      object Label20: TLabel
        Left = 20
        Top = 90
        Width = 12
        Height = 13
        Caption = '6.'
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Hard'
      ImageIndex = 2
      object Label21: TLabel
        Left = 20
        Top = 15
        Width = 12
        Height = 13
        Caption = '1.'
      end
      object Label22: TLabel
        Left = 20
        Top = 30
        Width = 12
        Height = 13
        Caption = '2.'
      end
      object Label23: TLabel
        Left = 20
        Top = 45
        Width = 12
        Height = 13
        Caption = '3.'
      end
      object Label24: TLabel
        Left = 20
        Top = 60
        Width = 12
        Height = 13
        Caption = '4.'
      end
      object Label25: TLabel
        Left = 20
        Top = 75
        Width = 12
        Height = 13
        Caption = '5.'
      end
      object Label26: TLabel
        Left = 20
        Top = 105
        Width = 12
        Height = 13
        Caption = '7.'
      end
      object Label27: TLabel
        Left = 20
        Top = 120
        Width = 12
        Height = 13
        Caption = '8.'
      end
      object Label28: TLabel
        Left = 20
        Top = 135
        Width = 12
        Height = 13
        Caption = '9.'
      end
      object Label29: TLabel
        Left = 12
        Top = 150
        Width = 20
        Height = 13
        Caption = '10.'
      end
      object Label30: TLabel
        Left = 20
        Top = 90
        Width = 12
        Height = 13
        Caption = '6.'
      end
    end
  end
  object OKButton: TButton
    Left = 40
    Top = 230
    Width = 75
    Height = 25
    Hint = 'Close Chart'
    Caption = 'OK'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = OKButtonClick
  end
  object Button2: TButton
    Left = 130
    Top = 230
    Width = 75
    Height = 25
    Hint = 'Delete all achieved scores'
    Caption = 'Clear'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = Button2Click
  end
end
