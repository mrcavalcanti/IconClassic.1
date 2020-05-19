object fFrWebBrowser: TfFrWebBrowser
  Left = 0
  Top = 0
  Width = 586
  Height = 254
  TabOrder = 0
  object WebBrowser1: TWebBrowser
    Left = 0
    Top = 53
    Width = 586
    Height = 182
    Align = alClient
    TabOrder = 0
    OnDownloadBegin = WebBrowser1DownloadBegin
    OnDownloadComplete = WebBrowser1DownloadComplete
    OnBeforeNavigate2 = WebBrowser1BeforeNavigate2
    ControlData = {
      4C000000913C0000CF1200000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 586
    Height = 53
    Align = alTop
    TabOrder = 1
    object SpeedButton1: TSpeedButton
      Left = 4
      Top = 4
      Width = 23
      Height = 22
      Caption = '<'
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      Left = 28
      Top = 4
      Width = 23
      Height = 22
      Caption = '>'
      OnClick = SpeedButton2Click
    end
    object StopBtn: TSpeedButton
      Left = 60
      Top = 4
      Width = 23
      Height = 22
      Caption = 'X'
      OnClick = StopBtnClick
    end
    object SpeedButton4: TSpeedButton
      Left = 84
      Top = 4
      Width = 23
      Height = 22
      Caption = '<->'
      OnClick = SpeedButton4Click
    end
    object URLs: TComboBox
      Left = 2
      Top = 28
      Width = 503
      Height = 21
      Hint = 'URL'
      ItemHeight = 13
      TabOrder = 0
      OnClick = URLsClick
      OnKeyDown = URLsKeyDown
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 235
    Width = 586
    Height = 19
    Panels = <>
  end
end
