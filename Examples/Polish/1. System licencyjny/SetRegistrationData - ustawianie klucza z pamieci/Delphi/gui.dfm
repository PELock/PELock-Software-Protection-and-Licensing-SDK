object frmMain: TfrmMain
  Left = 192
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'PELock Example: Setting registration key from the memory buffer'
  ClientHeight = 177
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblInfo: TLabel
    Left = 8
    Top = 8
    Width = 119
    Height = 13
    Caption = 'Application registered for:'
  end
  object btnExit: TBitBtn
    Left = 8
    Top = 144
    Width = 113
    Height = 25
    Caption = 'E&xit'
    TabOrder = 0
    OnClick = btnExitClick
  end
  object edtUsername: TMemo
    Left = 8
    Top = 24
    Width = 433
    Height = 113
    Lines.Strings = (
      'Unregistered version, please register!')
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
