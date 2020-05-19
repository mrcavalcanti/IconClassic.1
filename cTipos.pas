unit cTipos;

interface

uses
  Graphics;

type
  TTypeIcon = (tiCategories, tiFiles);

  TIconFavorites = record
    Filename: String[255];
    Index: Integer;
    TypeIcon: TTypeIcon;
    Description: String[255];
  end;

  TBitmapTag = record
    Bitmap: TBitmap;
    Tag: Integer;
  end;
  
  TToolsDraw = (TDNone, TDLine, TDArrow, TDSquare, TDCircle, TDText, TDPolygon,
                TDBrush, TDCurve, TDPencil, TDClear, TDDropper, TDSpray, TDPincel,
                TDSelect, TDZoom);

  TTCursor = (TCBorracha, TCBrush, TCGota, TCLapis, TCPincel, TCSpray);
//  TSelecao = (SelecNormal, SelecPolig);

  TExtFileIcon = (EIdll, EIexe, EIico, EIocx, EIbmp, EIicl, EIscr, EIcur, EIani);

const

  TExtAbbreviated: array [0..8] of String = ('.dll', '.exe', '.ico',
                   '.ocx', '.bmp', '.icl', '.scr', '.cur', '.ani');

  // 0 = Não permite alterar os valores de registro / 1 = Permite alteração
  TExtChange: array [Low(TExtAbbreviated)..high(TExtAbbreviated)] of byte = (0,
                   0, 1, 1, 1, 1, 0, 1, 1);

  TExtDescription: array [Low(TExtAbbreviated)..high(TExtAbbreviated)] of String = ('Biblioteca (*.dll)',
                   'Executável (*.exe)', 'Ícone (*.ico)', 'ActiveX (*.ocx)',
                   'Bitmap (*.bmp)', 'Biblioteca de Ícone (*.icl)',
                   'Screen Saver (*.scr)', 'Cursor (*.cur)',
                   'Cursor Animado (*.ani)');

  FileIconFavorites = 'IconFavorites.dat';
  
var
    ToolsDraw: TToolsDraw;

implementation

initialization
    ToolsDraw := TDNone;

end.
