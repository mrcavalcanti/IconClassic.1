object fFrPesquisa: TfFrPesquisa
  Left = 0
  Top = 0
  Width = 518
  Height = 240
  TabOrder = 0
  object pnlIcones: TPanel
    Left = 0
    Top = 0
    Width = 518
    Height = 240
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object ListView1: TListView
      Left = 12
      Top = 16
      Width = 494
      Height = 150
      Columns = <
        item
          Caption = #205'cone'
        end
        item
          Caption = 'Nome'
        end>
      LargeImages = imgList
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsList
    end
    object StatusBar1: TStatusBar
      Left = 0
      Top = 221
      Width = 518
      Height = 19
      Panels = <
        item
          Text = 'Total de '#237'cones: 0'
          Width = 150
        end
        item
          Width = 50
        end>
      SizeGrip = False
    end
  end
  object pnlPesquisa: TPanel
    Left = 0
    Top = 0
    Width = 518
    Height = 240
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Image1: TImage
      Left = 8
      Top = 8
      Width = 32
      Height = 32
    end
    object Label1: TLabel
      Left = 48
      Top = 8
      Width = 131
      Height = 13
      Caption = 'Extraindo '#237'cone do arquivo:'
      Transparent = True
    end
    object lblDeletado: TLabel
      Left = 208
      Top = 8
      Width = 55
      Height = 13
      Caption = 'Deletado: 0'
      Transparent = True
    end
    object Label2: TLabel
      Left = 48
      Top = 61
      Width = 109
      Height = 13
      Caption = 'Progresso da extra'#231#227'o:'
      Transparent = True
    end
    object Label3: TLabel
      Left = 48
      Top = 94
      Width = 96
      Height = 13
      Caption = 'Verificando diret'#243'rio:'
      Transparent = True
    end
    object lblDirectory: TLabel
      Left = 48
      Top = 110
      Width = 453
      Height = 37
      AutoSize = False
      Transparent = True
      WordWrap = True
    end
    object lblFileName: TLabel
      Left = 48
      Top = 24
      Width = 453
      Height = 37
      AutoSize = False
      Transparent = True
      WordWrap = True
    end
    object lblIconName: TLabel
      Left = 163
      Top = 61
      Width = 338
      Height = 13
      AutoSize = False
      Transparent = True
      WordWrap = True
    end
    object ProgressBar1: TProgressBar
      Left = 48
      Top = 76
      Width = 453
      Height = 16
      TabOrder = 0
    end
    object Panel2: TPanel
      Left = 0
      Top = 205
      Width = 518
      Height = 35
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object Bevel1: TBevel
        Left = 0
        Top = 0
        Width = 518
        Height = 2
        Align = alTop
        Style = bsRaised
      end
      object BitBtn1: TBitBtn
        Left = 4
        Top = 6
        Width = 133
        Height = 25
        Cancel = True
        Caption = 'Interromper Pesquisa'
        ModalResult = 2
        TabOrder = 0
        OnClick = BitBtn1Click
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333333333333333333333000033338833333333333333333F333333333333
          0000333911833333983333333388F333333F3333000033391118333911833333
          38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
          911118111118333338F3338F833338F3000033333911111111833333338F3338
          3333F8330000333333911111183333333338F333333F83330000333333311111
          8333333333338F3333383333000033333339111183333333333338F333833333
          00003333339111118333333333333833338F3333000033333911181118333333
          33338333338F333300003333911183911183333333383338F338F33300003333
          9118333911183333338F33838F338F33000033333913333391113333338FF833
          38F338F300003333333333333919333333388333338FFF830000333333333333
          3333333333333333333888330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
      end
    end
  end
  object imgList: TImageList
    Height = 32
    Width = 32
    Left = 472
    Top = 10
  end
end
