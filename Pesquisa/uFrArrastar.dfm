object fFrArrastar: TfFrArrastar
  Left = 0
  Top = 0
  Width = 520
  Height = 240
  TabOrder = 0
  object pnlIcones: TPanel
    Left = 0
    Top = 0
    Width = 520
    Height = 240
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      520
      240)
    object StatusBar1: TStatusBar
      Left = 0
      Top = 221
      Width = 520
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
    object ProgressBar1: TProgressBar
      Left = 369
      Top = 223
      Width = 150
      Height = 17
      Anchors = [akTop, akRight]
      TabOrder = 1
    end
    object IconGrid: TmccsIconGrid
      Left = 0
      Top = 0
      Width = 520
      Height = 221
      Align = alClient
      Color = clWhite
      ColCount = 8
      DefaultColWidth = 60
      DefaultRowHeight = 70
      DefaultDrawing = False
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goThumbTracking]
      PopupMenu = IconGrid.pm_Barcaca
      TabOrder = 2
      ExtractCancel = False
    end
  end
end
