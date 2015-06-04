object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 593
  ClientWidth = 1184
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 461
    Width = 1184
    Height = 132
    Align = alBottom
    Caption = 'Panel1'
    TabOrder = 0
    ExplicitTop = 553
    ExplicitWidth = 739
    object ListBox1: TListBox
      Left = 1
      Top = 1
      Width = 1182
      Height = 111
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      ExplicitWidth = 737
    end
    object StatusBar1: TStatusBar
      Left = 1
      Top = 112
      Width = 1182
      Height = 19
      Panels = <>
      ExplicitWidth = 737
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1184
    Height = 41
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 739
    object Label1: TLabel
      Left = 288
      Top = 14
      Width = 31
      Height = 13
      Caption = 'Label1'
    end
    object Button1: TButton
      Left = 12
      Top = 11
      Width = 75
      Height = 25
      Caption = 'Load ...'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button3: TButton
      Left = 174
      Top = 11
      Width = 75
      Height = 25
      Caption = 'Stop'
      TabOrder = 1
      OnClick = Button3Click
    end
    object Button2: TButton
      Left = 93
      Top = 11
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 41
    Width = 1184
    Height = 420
    Align = alClient
    TabOrder = 2
    ExplicitLeft = 1
    ExplicitTop = 65
    DesignSize = (
      1184
      420)
    object PaintBoxToday: TPaintBox
      Left = 432
      Top = 16
      Width = 746
      Height = 393
      Hint = 'Ping Duration'
      Anchors = [akLeft, akRight, akBottom]
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = PaintBoxTodayMouseDown
      OnMouseMove = PaintBoxTodayMouseMove
      OnPaint = PaintBoxTodayPaint
      ExplicitWidth = 561
    end
    object PaintBoxMonth1: TPaintBox
      Left = 12
      Top = 16
      Width = 88
      Height = 84
      OnPaint = PaintBoxMonthPaint
    end
    object PaintBoxMonth2: TPaintBox
      Left = 12
      Top = 107
      Width = 88
      Height = 84
      OnPaint = PaintBoxMonthPaint
    end
    object PaintBoxMonth3: TPaintBox
      Left = 12
      Top = 200
      Width = 88
      Height = 84
      OnPaint = PaintBoxMonthPaint
    end
    object PaintBoxCurrentMonth: TPaintBox
      Left = 107
      Top = 16
      Width = 317
      Height = 393
      OnPaint = PaintBoxCurrentMonthPaint
    end
    object PaintBoxMonth4: TPaintBox
      Left = 13
      Top = 297
      Width = 88
      Height = 84
      OnPaint = PaintBoxMonthPaint
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 472
    Top = 16
  end
  object Timer1: TTimer
    Interval = 60000
    OnTimer = Timer1Timer
    Left = 424
    Top = 16
  end
end
