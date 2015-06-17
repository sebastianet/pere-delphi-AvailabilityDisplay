object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'System Availability Display'
  ClientHeight = 441
  ClientWidth = 1087
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
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1087
    Height = 33
    Align = alTop
    TabOrder = 0
    ExplicitLeft = 8
    ExplicitTop = 370
    object Button1: TButton
      Left = 12
      Top = 3
      Width = 75
      Height = 26
      Caption = 'Load ...'
      Enabled = False
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button3: TButton
      Left = 174
      Top = 3
      Width = 75
      Height = 26
      Caption = 'Stop'
      Enabled = False
      TabOrder = 1
      OnClick = Button3Click
    end
    object Button2: TButton
      Left = 93
      Top = 3
      Width = 75
      Height = 26
      Caption = 'Start'
      Enabled = False
      TabOrder = 2
      OnClick = Button2Click
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 33
    Width = 1087
    Height = 389
    Align = alClient
    TabOrder = 1
    ExplicitTop = 41
    ExplicitWidth = 1184
    ExplicitHeight = 605
    object PaintBoxToday: TPaintBox
      Left = 398
      Top = 28
      Width = 683
      Height = 358
      Hint = 'Ping Duration'
      ParentShowHint = False
      ShowHint = True
      OnMouseMove = PaintBoxTodayMouseMove
      OnPaint = PaintBoxTodayPaint
    end
    object PaintBoxMonth1: TPaintBox
      Left = 12
      Top = 52
      Width = 88
      Height = 65
      Hint = 'Pings Failed Count'
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = PaintBoxMonthMouseDown
      OnMouseMove = PaintBoxMonthMouseMove
      OnPaint = PaintBoxMonthPaint
    end
    object PaintBoxMonth2: TPaintBox
      Left = 12
      Top = 134
      Width = 88
      Height = 65
      Hint = 'Pings Failed Count'
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = PaintBoxMonthMouseDown
      OnMouseMove = PaintBoxMonthMouseMove
      OnPaint = PaintBoxMonthPaint
    end
    object PaintBoxMonth3: TPaintBox
      Left = 12
      Top = 217
      Width = 88
      Height = 65
      Hint = 'Pings Failed Count'
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = PaintBoxMonthMouseDown
      OnMouseMove = PaintBoxMonthMouseMove
      OnPaint = PaintBoxMonthPaint
    end
    object PaintBoxCurrentMonth: TPaintBox
      Left = 107
      Top = 28
      Width = 284
      Height = 358
      Hint = 'Pings Failed Count'
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = PaintBoxCurrentMonthMouseDown
      OnMouseMove = PaintBoxCurrentMonthMouseMove
      OnPaint = PaintBoxCurrentMonthPaint
    end
    object PaintBoxMonth4: TPaintBox
      Left = 13
      Top = 300
      Width = 88
      Height = 64
      Hint = 'Pings Failed Count'
      ParentShowHint = False
      ShowHint = True
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
      Left = 398
      Top = 12
      Width = 91
      Height = 13
      Caption = 'Day Month year'
    end
    object Label4: TLabel
      Left = 13
      Top = 35
      Width = 74
      Height = 20
      Caption = 'Month year'
    end
    object Label5: TLabel
      Left = 12
      Top = 120
      Width = 55
      Height = 13
      Caption = 'Month year'
    end
    object Label6: TLabel
      Left = 13
      Top = 203
      Width = 55
      Height = 13
      Caption = 'Month year'
    end
    object Label7: TLabel
      Left = 13
      Top = 287
      Width = 55
      Height = 13
      Caption = 'Month year'
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 422
    Width = 1087
    Height = 19
    Panels = <>
    SimplePanel = True
    ExplicitLeft = 8
    ExplicitTop = 442
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
