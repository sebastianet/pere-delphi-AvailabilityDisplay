object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 646
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
    Top = 514
    Width = 1184
    Height = 132
    Align = alBottom
    Caption = 'Panel1'
    TabOrder = 0
    ExplicitTop = 461
    object ListBox1: TListBox
      Left = 1
      Top = 1
      Width = 1182
      Height = 111
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
    end
    object StatusBar1: TStatusBar
      Left = 1
      Top = 112
      Width = 1182
      Height = 19
      Panels = <>
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1184
    Height = 41
    Align = alTop
    TabOrder = 1
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
    Height = 473
    Align = alClient
    TabOrder = 2
    ExplicitLeft = -1
    ExplicitTop = 47
    DesignSize = (
      1184
      473)
    object PaintBoxToday: TPaintBox
      Left = 430
      Top = 27
      Width = 746
      Height = 382
      Hint = 'Ping Duration'
      Anchors = [akLeft, akRight, akBottom]
      ParentShowHint = False
      ShowHint = True
      OnMouseMove = PaintBoxTodayMouseMove
      OnPaint = PaintBoxTodayPaint
    end
    object PaintBoxMonth1: TPaintBox
      Left = 12
      Top = 39
      Width = 88
      Height = 73
      OnMouseDown = PaintBoxMonthMouseDown
      OnMouseMove = PaintBoxMonthMouseMove
      OnPaint = PaintBoxMonthPaint
    end
    object PaintBoxMonth2: TPaintBox
      Left = 12
      Top = 139
      Width = 88
      Height = 73
      OnMouseDown = PaintBoxMonthMouseDown
      OnMouseMove = PaintBoxMonthMouseMove
      OnPaint = PaintBoxMonthPaint
    end
    object PaintBoxMonth3: TPaintBox
      Left = 12
      Top = 239
      Width = 88
      Height = 73
      OnMouseDown = PaintBoxMonthMouseDown
      OnMouseMove = PaintBoxMonthMouseMove
      OnPaint = PaintBoxMonthPaint
    end
    object PaintBoxCurrentMonth: TPaintBox
      Left = 107
      Top = 27
      Width = 317
      Height = 382
      OnMouseDown = PaintBoxCurrentMonthMouseDown
      OnMouseMove = PaintBoxCurrentMonthMouseMove
      OnPaint = PaintBoxCurrentMonthPaint
    end
    object PaintBoxMonth4: TPaintBox
      Left = 13
      Top = 337
      Width = 88
      Height = 72
      OnMouseDown = PaintBoxMonthMouseDown
      OnMouseMove = PaintBoxMonthMouseMove
      OnPaint = PaintBoxMonthPaint
    end
    object Label2: TLabel
      Left = 107
      Top = 12
      Width = 55
      Height = 13
      Caption = 'Month year'
    end
    object Label3: TLabel
      Left = 430
      Top = 12
      Width = 77
      Height = 13
      Caption = 'Day Month year'
    end
    object Label4: TLabel
      Left = 13
      Top = 24
      Width = 55
      Height = 13
      Caption = 'Month year'
    end
    object Label5: TLabel
      Left = 12
      Top = 125
      Width = 55
      Height = 13
      Caption = 'Month year'
    end
    object Label6: TLabel
      Left = 13
      Top = 225
      Width = 55
      Height = 13
      Caption = 'Month year'
    end
    object Label7: TLabel
      Left = 13
      Top = 324
      Width = 55
      Height = 13
      Caption = 'Month year'
    end
    object Label1: TLabel
      Left = 544
      Top = 12
      Width = 31
      Height = 13
      Caption = 'Label1'
    end
    object Label8: TLabel
      Left = 174
      Top = 12
      Width = 54
      Height = 13
      Caption = '000000000'
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 680
    Top = 8
  end
  object Timer1: TTimer
    Interval = 60000
    OnTimer = Timer1Timer
    Left = 640
    Top = 8
  end
end
