object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'LABA 7.1 SHESTAKOV 051007'
  ClientHeight = 558
  ClientWidth = 1096
  Color = clBtnFace
  Font.Charset = RUSSIAN_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Segoe UI'
  Font.Style = [fsBold]
  Menu = MainMenu1
  OldCreateOrder = False
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 110
  TextHeight = 19
  object Visualizer: TImage
    Left = 480
    Top = 62
    Width = 465
    Height = 467
    Stretch = True
  end
  object Label2: TLabel
    Left = 24
    Top = 18
    Width = 155
    Height = 25
    Caption = 'ADJENCY MATRIX'
    Color = 8454143
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object Label1: TLabel
    Left = 24
    Top = 494
    Width = 78
    Height = 25
    Caption = 'SET SIZE:'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 480
    Top = 18
    Width = 255
    Height = 25
    Caption = 'GRAPH AND SPANNING TREE'
    Color = 8454143
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object MatrixGrid: TStringGrid
    Left = 24
    Top = 62
    Width = 425
    Height = 403
    ColCount = 3
    DefaultColWidth = 35
    DefaultRowHeight = 35
    FixedColor = 5177501
    RowCount = 3
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
    ScrollBars = ssNone
    TabOrder = 0
    OnSetEditText = MatrixGridSetEditText
  end
  object OrderSpinEdit: TSpinEdit
    Left = 108
    Top = 491
    Width = 57
    Height = 36
    EditorEnabled = False
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -18
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    MaxValue = 10
    MinValue = 2
    ParentFont = False
    TabOrder = 1
    Value = 2
    OnChange = OrderSpinEditChange
  end
  object ShowGraphButton: TButton
    Left = 216
    Top = 491
    Width = 233
    Height = 38
    Caption = 'FIND THE SPANNING TREE'
    TabOrder = 2
    OnClick = ShowGraphButtonClick
  end
  object SaveDialog: TSaveDialog
    Left = 328
    Top = 16
  end
  object OpenDialog: TOpenDialog
    Left = 384
    Top = 16
  end
  object MainMenu1: TMainMenu
    Left = 264
    Top = 8
    object About1: TMenuItem
      Caption = 'About'
      OnClick = About1Click
    end
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'Open'
        OnClick = Open1Click
      end
    end
  end
  object SavePictureDialog: TSavePictureDialog
    Left = 1016
    Top = 296
  end
end
