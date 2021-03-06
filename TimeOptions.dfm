object Form2: TForm2
  Left = 92
  Top = 344
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Set Time Limit'
  ClientHeight = 231
  ClientWidth = 257
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 20
    Top = 15
    Width = 221
    Height = 161
    Caption = 'Time Limit Options'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object EasyLimit: TRadioButton
      Left = 15
      Top = 35
      Width = 151
      Height = 17
      Caption = 'Easy (10 minutes)'
      TabOrder = 0
    end
    object ModerateLimit: TRadioButton
      Left = 15
      Top = 55
      Width = 176
      Height = 17
      Caption = 'Moderate (5 minutes)'
      TabOrder = 1
    end
    object HardLimit: TRadioButton
      Left = 15
      Top = 75
      Width = 151
      Height = 17
      Caption = 'Hard (2 minutes)'
      TabOrder = 2
    end
    object CustomLimit: TRadioButton
      Left = 15
      Top = 105
      Width = 196
      Height = 17
      Caption = 'Custom (Insert value 60-999)'
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Verdana'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object CustomLimitValue: TEdit
      Left = 35
      Top = 125
      Width = 41
      Height = 21
      TabOrder = 4
      Text = '500'
    end
    object UpDown1: TUpDown
      Left = 76
      Top = 125
      Width = 16
      Height = 21
      Associate = CustomLimitValue
      Min = 60
      Max = 999
      Position = 500
      TabOrder = 5
      Wrap = False
    end
  end
  object Button1: TButton
    Left = 45
    Top = 190
    Width = 75
    Height = 25
    Caption = 'OK'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 140
    Top = 190
    Width = 75
    Height = 25
    Caption = 'Cancel'
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
