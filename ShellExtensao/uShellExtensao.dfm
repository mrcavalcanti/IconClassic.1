object frmShellExtensao: TfrmShellExtensao
  Left = 337
  Top = 215
  BorderStyle = bsDialog
  Caption = 'Associar Extens'#227'o'
  ClientHeight = 280
  ClientWidth = 594
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object gbx_Principal: TGroupBox
    Left = 8
    Top = 8
    Width = 577
    Height = 229
    Caption = 'Tipos de extens'#245'es:'
    TabOrder = 2
    object gbx_Extensoes: TGroupBox
      Left = 12
      Top = 18
      Width = 233
      Height = 200
      Caption = 'Associar extens'#227'o com o Icon Classic:'
      TabOrder = 0
      DesignSize = (
        233
        200)
      object Bevel1: TBevel
        Left = 2
        Top = 159
        Width = 228
        Height = 2
        Anchors = [akLeft, akBottom]
      end
      object btn_Todos: TButton
        Left = 8
        Top = 167
        Width = 81
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Todos'
        TabOrder = 0
        OnClick = btn_TodosClick
      end
      object btn_Restaurar: TButton
        Left = 104
        Top = 167
        Width = 119
        Height = 25
        Anchors = [akLeft, akBottom]
        Caption = 'Restaurar'
        TabOrder = 1
      end
      object ListView1: TListView
        Left = 7
        Top = 16
        Width = 217
        Height = 135
        Checkboxes = True
        Columns = <
          item
            Caption = 'Extens'#227'o'
            MaxWidth = 60
            MinWidth = 60
            Width = 60
          end
          item
            AutoSize = True
            Caption = 'Descri'#231#227'o'
            MaxWidth = 130
            MinWidth = 130
          end>
        ColumnClick = False
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 2
        ViewStyle = vsReport
        OnChange = ListView1Change
      end
    end
    object gbx_Detalhes: TGroupBox
      Left = 252
      Top = 18
      Width = 313
      Height = 200
      Caption = 'Detalhes:'
      TabOrder = 1
      object Label1: TLabel
        Left = 12
        Top = 24
        Width = 47
        Height = 13
        Caption = 'Extens'#227'o:'
      end
      object Label2: TLabel
        Left = 12
        Top = 49
        Width = 30
        Height = 13
        Caption = #205'cone:'
      end
      object Label3: TLabel
        Left = 12
        Top = 154
        Width = 47
        Height = 13
        Caption = 'Abrir com:'
      end
      object img_Icon: TImage
        Left = 48
        Top = 63
        Width = 32
        Height = 32
      end
      object lbl_Extensao: TLabel
        Left = 64
        Top = 24
        Width = 3
        Height = 13
      end
      object Label4: TLabel
        Left = 12
        Top = 108
        Width = 78
        Height = 13
        Caption = 'Extrair '#237'cone de:'
      end
      object edt_AbrirCom: TEdit
        Left = 12
        Top = 170
        Width = 249
        Height = 21
        TabOrder = 2
      end
      object btn_AbrirCom: TButton
        Left = 268
        Top = 169
        Width = 33
        Height = 23
        Caption = '...'
        TabOrder = 3
        OnClick = btn_AbrirComClick
      end
      object btn_AlterarIcone: TButton
        Left = 168
        Top = 69
        Width = 133
        Height = 25
        Caption = 'Alterar '#205'cone'
        TabOrder = 0
        OnClick = btn_AlterarIconeClick
      end
      object edt_ExtrairIconeDe: TEdit
        Left = 12
        Top = 122
        Width = 289
        Height = 21
        TabOrder = 1
      end
    end
  end
  object btn_Ok: TButton
    Left = 424
    Top = 247
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 0
    OnClick = btn_OkClick
  end
  object btn_Cancelar: TButton
    Left = 509
    Top = 247
    Width = 75
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 1
    OnClick = btn_CancelarClick
  end
  object ShellExt: TShellExt
    IconIndex = 0
    ExtDescription = 'IconClassicFile'
    FileDescription = 'IconClassic File'
    OpenWith = '[Self]'
    OpenWithMe = True
    ParamString = '%1'
    Left = 80
    Top = 208
  end
  object Advanced: TShellExt
    IconIndex = 0
    Extension = '.txt'
    OpenWith = '[Self]'
    OpenWithMe = False
    Left = 164
    Top = 204
  end
  object IconDialog: TJvChangeIconDialog
    IconIndex = 0
    Left = 280
    Top = 204
  end
  object OpenWithDialog: TJvOpenWithDialog
    Left = 364
    Top = 206
  end
end
