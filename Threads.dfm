object fThreads: TfThreads
  Left = 0
  Top = 0
  Caption = 'fThreads'
  ClientHeight = 270
  ClientWidth = 513
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  PixelsPerInch = 96
  TextHeight = 15
  object edNumerosThreads: TEdit
    Left = 32
    Top = 32
    Width = 121
    Height = 23
    TabOrder = 0
    Text = '0'
  end
  object edValorMilissegundos: TEdit
    Left = 32
    Top = 61
    Width = 121
    Height = 23
    TabOrder = 1
    Text = '0'
  end
  object Button1: TButton
    Left = 422
    Top = 223
    Width = 75
    Height = 25
    Caption = 'Click aqui.'
    TabOrder = 2
    OnClick = Button1Click
  end
  object ProgressBar1: TProgressBar
    Left = 32
    Top = 200
    Width = 465
    Height = 17
    TabOrder = 3
  end
  object Memo1: TMemo
    Left = 32
    Top = 90
    Width = 465
    Height = 89
    TabOrder = 4
  end
end
