object Form1: TForm1
  Left = 264
  Top = 255
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Code Breaker 1.0'
  ClientHeight = 426
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TimeLeft: TLabel
    Left = 505
    Top = 70
    Width = 55
    Height = 30
    Hint = 'Time left til defeat'
    Alignment = taCenter
    Caption = '300'
    Color = clBlack
    Constraints.MaxHeight = 30
    Constraints.MaxWidth = 55
    Constraints.MinHeight = 30
    Constraints.MinWidth = 55
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clLime
    Font.Height = -23
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 10
    Top = 10
    Width = 612
    Height = 391
  end
  object GroupBox1: TGroupBox
    Left = 65
    Top = 95
    Width = 400
    Height = 300
    Caption = 'Now let'#39's show me your hacking skills...'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object GameStatus: TStatusBar
    Left = 0
    Top = 407
    Width = 632
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = '300 secs (Mod)'
        Width = 100
      end
      item
        Alignment = taCenter
        Text = '7 (Mod)'
        Width = 60
      end
      item
        Alignment = taCenter
        Text = 'Moderate'
        Width = 70
      end
      item
        Alignment = taCenter
        Text = 'Score'
        Width = 100
      end
      item
        Alignment = taCenter
        Width = 155
      end
      item
        Alignment = taCenter
        Text = 'Attempts Left'
        Width = 75
      end
      item
        Alignment = taCenter
        Text = 'Time Left'
        Width = 75
      end>
    ParentShowHint = False
    ShowHint = True
    SimplePanel = False
  end
  object GroupBox2: TGroupBox
    Left = 65
    Top = 20
    Width = 400
    Height = 66
    Caption = 'This code will be your task :'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Verdana'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
  end
  object MainMenu1: TMainMenu
    Left = 600
    Top = 5
    object Game1: TMenuItem
      Caption = 'Game'
      object New1: TMenuItem
        Caption = 'New'
        Hint = 'Start new game'
        OnClick = New1Click
      end
      object Pause1: TMenuItem
        Caption = 'Pause'
        Enabled = False
        Hint = 'Pause game'
        OnClick = Pause1Click
      end
      object HighScores1: TMenuItem
        Caption = 'High Scores'
        Hint = 'Show High scores'
        OnClick = HighScores1Click
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        Hint = 'Exit game'
        OnClick = Exit1Click
      end
    end
    object Options1: TMenuItem
      Caption = 'Options'
      object SetDifficulty1: TMenuItem
        Caption = 'Set Difficulty'
        object Easy1: TMenuItem
          Caption = 'Easy'
          GroupIndex = 1
          RadioItem = True
          OnClick = Easy1Click
        end
        object Moderate1: TMenuItem
          Caption = 'Moderate'
          Checked = True
          GroupIndex = 1
          RadioItem = True
          OnClick = Moderate1Click
        end
        object Hard1: TMenuItem
          Caption = 'Hard'
          GroupIndex = 1
          RadioItem = True
          OnClick = Hard1Click
        end
      end
      object TimeLimit1: TMenuItem
        Caption = 'Time Limit'
        Hint = 'Set time limit for game'
        OnClick = TimeLimit1Click
      end
      object Figures1: TMenuItem
        Caption = 'Figures'
        Hint = 'Set number of figures in code'
        OnClick = Figures1Click
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 570
    Top = 5
  end
end
