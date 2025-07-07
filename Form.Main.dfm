object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 809
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Button1: TButton
    Left = 329
    Top = 24
    Width = 80
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Memo1: TMemo
    Left = 8
    Top = 64
    Width = 608
    Height = 737
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
  end
  object Button2: TButton
    Left = 440
    Top = 24
    Width = 176
    Height = 25
    Caption = 'Button2'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 25
    Width = 315
    Height = 23
    TabOrder = 3
    Text = 
      'https://news.google.com/news/rss/headlines/section/topic/TECHNOL' +
      'OGY?ned=us&hl=en&gl=US'
  end
end
