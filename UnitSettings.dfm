object FormSettings: TFormSettings
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099
  ClientHeight = 201
  ClientWidth = 292
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Difficulty: TRadioGroup
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 286
    Height = 195
    Align = alClient
    Caption = #1057#1083#1086#1078#1085#1086#1089#1090#1100
    TabOrder = 0
  end
  object RadioButtonEasy: TRadioButton
    Left = 16
    Top = 32
    Width = 113
    Height = 17
    Caption = #1053#1086#1074#1080#1095#1086#1082
    Checked = True
    TabOrder = 1
    TabStop = True
    OnClick = DifficultyEasy
  end
  object RadioButtonMedium: TRadioButton
    Left = 16
    Top = 58
    Width = 113
    Height = 17
    Caption = #1051#1102#1073#1080#1090#1077#1083#1100
    TabOrder = 2
    OnClick = DifficultyMedium
  end
  object RadioButtonHard: TRadioButton
    Left = 16
    Top = 85
    Width = 113
    Height = 17
    Caption = #1055#1088#1086#1092#1077#1089#1089#1080#1086#1085#1072#1083
    TabOrder = 3
    OnClick = DifficultyHard
  end
  object RadioButtonSpecial: TRadioButton
    Left = 16
    Top = 112
    Width = 113
    Height = 17
    Caption = #1054#1089#1086#1073#1099#1081
    TabOrder = 4
    OnClick = DifficultySpecial
  end
  object TextWidth: TStaticText
    Left = 150
    Top = 58
    Width = 48
    Height = 17
    Caption = #1064#1080#1088#1080#1085#1072':'
    TabOrder = 5
  end
  object TextHeight: TStaticText
    Left = 150
    Top = 85
    Width = 45
    Height = 17
    Caption = #1042#1099#1089#1086#1090#1072':'
    TabOrder = 6
  end
  object TextMines: TStaticText
    Left = 150
    Top = 112
    Width = 59
    Height = 17
    Caption = #1063#1080#1089#1083#1086' '#1084#1080#1085':'
    TabOrder = 7
  end
  object EditWidth: TEdit
    Left = 229
    Top = 56
    Width = 52
    Height = 21
    Enabled = False
    TabOrder = 8
    Text = '9'
  end
  object EditMines: TEdit
    Left = 229
    Top = 110
    Width = 52
    Height = 21
    Enabled = False
    TabOrder = 9
    Text = '10'
  end
  object EditHeight: TEdit
    Left = 229
    Top = 83
    Width = 52
    Height = 21
    Enabled = False
    TabOrder = 10
    Text = '9'
  end
  object ButtonOk: TButton
    Left = 54
    Top = 160
    Width = 75
    Height = 25
    Caption = #1054#1050
    TabOrder = 11
    OnClick = DifficultyApply
  end
  object ButtonCancel: TButton
    Left = 160
    Top = 160
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 12
    OnClick = DifficultyCancel
  end
end
