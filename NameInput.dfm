object Form5: TForm5
  Left = 214
  Top = 247
  Width = 170
  Height = 157
  BorderIcons = []
  Caption = 'Code Breaker 1.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 20
    Top = 20
    Width = 122
    Height = 13
    Hint = 'Insert your name for high scores chart'
    Caption = 'Type in your name'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object InputName: TEdit
    Left = 20
    Top = 45
    Width = 121
    Height = 21
    Hint = 'Insert your name for high scores chart'
    TabOrder = 0
  end
  object Button1: TButton
    Left = 45
    Top = 85
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
end
