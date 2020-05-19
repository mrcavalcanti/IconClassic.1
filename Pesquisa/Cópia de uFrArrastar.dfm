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
    object ListView1: TListView
      Left = 0
      Top = 0
      Width = 520
      Height = 221
      Align = alClient
      Columns = <
        item
          Caption = #205'cone'
        end
        item
          Caption = 'Nome'
        end>
      IconOptions.AutoArrange = True
      LargeImages = ImageList1
      RowSelect = True
      ShowWorkAreas = True
      TabOrder = 0
      OnClick = ListView1Click
      OnDblClick = ListView1DblClick
    end
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
      TabOrder = 2
    end
  end
  object ImageList1: TImageList
    Height = 32
    Width = 32
    Left = 344
    Top = 104
  end
end
