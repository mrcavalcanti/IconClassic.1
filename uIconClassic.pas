unit uIconClassic;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, dxDockPanel, Menus, StdCtrls, ExtCtrls, ImgList,
  Clipbrd, dxBar, ActnList, dxDockControl, StdActns, dxBarExtItems, dxsbar,
  ColorPickerButton, cxGraphics, ShlObj, cxShellCommon, cxContainer,
  cxShellTreeView, cxControls, dxStatusBar, Spin, Buttons, ExtDlgs, cxPC,
  ShellCtrls, ToolWin, GraphicEx, BarMenus, BcDrawModule, BcCustomDrawModule,
  RXCtrls, BcRectUtilities,

  uFrArrastar, uFrWebBrowser,

  MccsPaletteColor, mccsViewPaintBoxShapes, mccsShape, mccsLayer, mccsTypes,
  mccsFillGradient, mccsCommons, mccsBlendModes, MccsAboutDinamic,
  mccsLayerManager, mccsFile,

  IconConvert, mccsIconGrid, mccsResearchIcons, IconLibrary, AdvancedIcon,
  IconTypes, MccsImage, Gradient, Grids, OleCtrls, SHDocVw, uIcoFiles;

const
  wm_IconMessage = wm_User + 255;
  CM_HOMEPAGEREQUEST = WM_USER + $1000;

type
  TPanel = class(ExtCtrls.TPanel)
  private
      fTransparent: Boolean;
      fBackground: TBitmap;
      procedure SetBackground(const Value: TBitmap);
  protected
      procedure Paint; override;
  public
      constructor Create(AOwner: TComponent); override;
      property Transparent: Boolean read fTransparent write fTransparent default False;
      property Background: TBitmap read fBackground write SetBackground;
  end;

  TcxTabSheet = class(cxPC.TcxTabSheet)
    FmccsViewPaintBoxShapes: TmccsViewPaintBoxShapes;
    FmccsIconGrid: TmccsIconGrid;
    procedure SetmccsViewPaintBoxShapes(Value: TmccsViewPaintBoxShapes);
    procedure SetmccsIconGrid(Value: TmccsIconGrid);
  public
    constructor Create(AOwner: TComponent); override;

    property mccsViewPaintBoxShapes: TmccsViewPaintBoxShapes read FmccsViewPaintBoxShapes write SetmccsViewPaintBoxShapes;
    property mccsIconGrid: TmccsIconGrid read FmccsIconGrid write SetmccsIconGrid;
  end;

  TPanelLayers = class(TPanel)
  private
    fpnlmenu: TPanel;
    fmccsLayerManager: TmccsLayerManager;
    fsbtnInsertLayer,
    fsbtnRemoveLayer,
    fsbtnPreview: TSpeedButton;
    fEditor: TmccsViewPaintBoxShapes;
    procedure onInsertLayer(Sender: TObject);
    procedure onRemoveLayer(Sender: TObject);
    procedure onPreview(Sender: TObject);
  protected
  public
    constructor Create(AOwner: TComponent; AEditor: TmccsViewPaintBoxShapes); reintroduce;
  end;

  TfrmIconClassic = class(TForm)
    dsHost: TdxDockSite;
    dpEditarIcone: TdxDockPanel;
    dxDockingManager1: TdxDockingManager;
    dpBibliotecas: TdxDockPanel;
    dxTabDiversos: TdxTabContainerDockSite;
    dpFavoritos: TdxDockPanel;
    ilDockIcons: TImageList;
    dxLayoutDockSite3: TdxLayoutDockSite;
    alMain: TActionList;
    actRateDemo: TAction;
    actAbout: TAction;
    iComponentsIcons: TImageList;
    dpIconesDiversos: TdxDockPanel;
    dxLayoutDockSite5: TdxLayoutDockSite;
    Spd: TSavePictureDialog;
    Opd: TOpenPictureDialog;
    cxDesktop: TcxPageControl;
    cxBibliotecaICL: TcxPageControl;
    cxIconesDiversos: TcxPageControl;
    ToolBar2: TToolBar;
    SpeedButton21: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton17: TSpeedButton;
    ToolButton8: TToolButton;
    SpeedButton18: TSpeedButton;
    ToolButton9: TToolButton;
    SpeedButton19: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton22: TSpeedButton;
    ListView1: TListView;
    cxTabSheet1: TcxTabSheet;
    LIBOpenDialog: TOpenDialog;
    LIBSaveDialog: TSaveDialog;
    MccsAboutDinamic: TMccsAboutDinamic;
    pnlRight: TPanel;
    imBarIcons: TImageList;
    ilHotImages: TImageList;
    pnlTop: TPanel;
    pnlBtnCadastro: TPanel;
    rxBtnCadastro: TRxSpeedButton;
    pnlBtnMovimento: TPanel;
    rxBtnMovimento: TRxSpeedButton;
    pnlBtnTree: TPanel;
    rxBtnTree: TRxSpeedButton;
    pnlBtnUtilitario: TPanel;
    rxBtnUtilitario: TRxSpeedButton;
    pnlBtnSair: TPanel;
    rxBtnSair: TRxSpeedButton;
    pnlBtnSobre: TPanel;
    rxBtnSobre: TRxSpeedButton;
    pnlBtnPesquisar: TPanel;
    rxBtnPesquisar: TRxSpeedButton;
    pnlBtnUsuario: TPanel;
    rxBtnUsuario: TRxSpeedButton;
    BcCustomDrawModule1: TBcCustomDrawModule;
    pmFile: TBcBarPopupMenu;
    MenuItem3: TMenuItem;
    Configurao1: TMenuItem;
    Relatrios1: TMenuItem;
    MenuItem12: TMenuItem;
    pmEdit: TBcBarPopupMenu;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    pmView: TBcBarPopupMenu;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem16: TMenuItem;
    pmDraw: TBcBarPopupMenu;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem31: TMenuItem;
    pnlTitle: TPanel;
    Gradient3: TGradient;
    pnlMenuLeft: TPanel;
    Gradient2: TGradient;
    dxStatusBar2: TdxStatusBar;
    dxStatusBar1Container0: TdxStatusBarContainerControl;
    pnlUsuario: TPanel;
    Image1: TImage;
    dxStatusBar1Container2: TdxStatusBarContainerControl;
    pnlData: TPanel;
    dxStatusBar1Container4: TdxStatusBarContainerControl;
    pnlHint: TPanel;
    dxStatusBar1Container3: TdxStatusBarContainerControl;
    pnlHora: TPanel;
    Gradient4: TGradient;
    Gradient5: TGradient;
    Panel2: TPanel;
    Gradient1: TGradient;
    pnlViewIcon: TPanel;
    imgViewIcon: TImage;
    Button1: TButton;
    Panel4: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Panel6: TPanel;
    Label12: TLabel;
    Label15: TLabel;
    Gradient7: TGradient;
    Gradient9: TGradient;
    pnlLeft: TPanel;
    pnlDirectory: TPanel;
    Panel11: TPanel;
    Gradient10: TGradient;
    Label16: TLabel;
    Label17: TLabel;
    ShellTreeView1: TShellTreeView;
    pnlPesquisar: TPanel;
    Panel5: TPanel;
    Gradient11: TGradient;
    Label18: TLabel;
    Label19: TLabel;
    pnlMenuRight: TPanel;
    Gradient12: TGradient;
    actMaskRectangle: TAction;
    actMaskCircle: TAction;
    actMaskFreeHand: TAction;
    actMaskPolygon: TAction;
    actMaskModeNormal: TAction;
    actMaskModeAdd: TAction;
    actMaskModeSub: TAction;
    actMaskClear: TAction;
    actCaptureDesktop: TAction;
    actCaptureMultDesktop: TAction;
    actCaptureSelectArea: TAction;
    actCaptureSelectAreaConfig: TAction;
    actCaptureFreeHand: TAction;
    actCaptureActiveWindow: TAction;
    actCaptureIcon: TAction;
    actCaptureObject: TAction;
    pmCapture: TBcBarPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem6: TMenuItem;
    readajanelaativa1: TMenuItem;
    reaporseleoprdefinida1: TMenuItem;
    readesenhomolivre1: TMenuItem;
    readajanelaativa2: TMenuItem;
    readecone32x321: TMenuItem;
    readeumobjeto1: TMenuItem;
    pmMask: TBcBarPopupMenu;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem30: TMenuItem;
    N2: TMenuItem;
    Limparmscara1: TMenuItem;
    pmAbout: TBcBarPopupMenu;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    iTools: TImageList;
    alTools: TActionList;
    acToolSelect: TAction;
    acToolSelect2: TAction;
    acToolPencil: TAction;
    acToolPaint: TAction;
    acToolDrops: TAction;
    acToolLine: TAction;
    acToolRectangle: TAction;
    acToolElipse: TAction;
    acToolPolygon: TAction;
    acToolLabel: TAction;
    acToolArc: TAction;
    acToolPie: TAction;
    acToolRectRound: TAction;
    acToolChord: TAction;
    Selecionar1: TMenuItem;
    Pintar1: TMenuItem;
    Contagota1: TMenuItem;
    N3: TMenuItem;
    Lpis1: TMenuItem;
    Linha1: TMenuItem;
    Retngulo1: TMenuItem;
    Retnguloarredondado1: TMenuItem;
    Elipse1: TMenuItem;
    Arco1: TMenuItem;
    Polgono1: TMenuItem;
    Corda1: TMenuItem;
    Pizza1: TMenuItem;
    exto1: TMenuItem;
    pnlToolLeft: TPanel;
    Panel33: TPanel;
    RxSpeedButton22: TRxSpeedButton;
    Panel32: TPanel;
    RxSpeedButton21: TRxSpeedButton;
    Panel31: TPanel;
    RxSpeedButton20: TRxSpeedButton;
    Panel30: TPanel;
    RxSpeedButton19: TRxSpeedButton;
    Panel29: TPanel;
    RxSpeedButton18: TRxSpeedButton;
    Panel28: TPanel;
    RxSpeedButton17: TRxSpeedButton;
    Panel27: TPanel;
    RxSpeedButton16: TRxSpeedButton;
    Panel26: TPanel;
    RxSpeedButton15: TRxSpeedButton;
    pnlToolRight: TPanel;
    Panel34: TPanel;
    RxSpeedButton23: TRxSpeedButton;
    Panel35: TPanel;
    RxSpeedButton24: TRxSpeedButton;
    Panel36: TPanel;
    RxSpeedButton25: TRxSpeedButton;
    Panel37: TPanel;
    RxSpeedButton26: TRxSpeedButton;
    Panel38: TPanel;
    RxSpeedButton27: TRxSpeedButton;
    Panel39: TPanel;
    RxSpeedButton28: TRxSpeedButton;
    Panel40: TPanel;
    RxSpeedButton29: TRxSpeedButton;
    Panel41: TPanel;
    RxSpeedButton30: TRxSpeedButton;
    pnlToolTop: TPanel;
    Panel25: TPanel;
    RxSpeedButton14: TRxSpeedButton;
    Panel24: TPanel;
    RxSpeedButton13: TRxSpeedButton;
    Panel23: TPanel;
    RxSpeedButton12: TRxSpeedButton;
    Panel22: TPanel;
    RxSpeedButton11: TRxSpeedButton;
    Panel21: TPanel;
    RxSpeedButton10: TRxSpeedButton;
    Panel20: TPanel;
    RxSpeedButton9: TRxSpeedButton;
    Panel19: TPanel;
    RxSpeedButton8: TRxSpeedButton;
    Panel18: TPanel;
    RxSpeedButton7: TRxSpeedButton;
    Panel17: TPanel;
    RxSpeedButton6: TRxSpeedButton;
    Panel16: TPanel;
    RxSpeedButton5: TRxSpeedButton;
    Panel15: TPanel;
    RxSpeedButton4: TRxSpeedButton;
    Panel14: TPanel;
    RxSpeedButton3: TRxSpeedButton;
    Panel13: TPanel;
    RxSpeedButton2: TRxSpeedButton;
    Panel12: TPanel;
    RxSpeedButton1: TRxSpeedButton;
    Bevel1: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    pnlGallery: TPanel;
    Panel42: TPanel;
    Gradient13: TGradient;
    Label20: TLabel;
    Label21: TLabel;
    Panel43: TPanel;
    cbxGallery: TComboBox;
    mccsIconGrid: TmccsIconGrid;
    acEffectGradient: TAction;
    acEffectEffect: TAction;
    N4: TMenuItem;
    Efeitos1: TMenuItem;
    Gradiente1: TMenuItem;
    Efeito1: TMenuItem;
    pnlToolBottom: TPanel;
    Bevel2: TBevel;
    FontDialog1: TFontDialog;
    pmPercent: TBcBarPopupMenu;
    MenuItem34: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem36: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem40: TMenuItem;
    MenuItem41: TMenuItem;
    MenuItem42: TMenuItem;
    MenuItem43: TMenuItem;
    acZoom100: TAction;
    acZoom200: TAction;
    acZoom400: TAction;
    acZoom800: TAction;
    acZoom1600: TAction;
    acZoom3200: TAction;
    acZoom6400: TAction;
    Panel46: TPanel;
    sbtnZoom: TRxSpeedButton;
    N5: TMenuItem;
    acZoomCustom: TAction;
    Personalizar1: TMenuItem;
    pnlTools: TPanel;
    Gradient8: TGradient;
    Label9: TLabel;
    Label3: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    sbtnFont: TSpeedButton;
    Label2: TLabel;
    Label11: TLabel;
    lblOpaque: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    lblTransparency: TLabel;
    Bevel5: TBevel;
    Bevel6: TBevel;
    SpinEditBorda: TSpinEdit;
    cbxInternal: TComboBox;
    cbxExternal: TComboBox;
    edtText: TEdit;
    sedtAngleFont: TSpinEdit;
    cbxBlendMode: TComboBox;
    Panel1: TPanel;
    Gradient6: TGradient;
    Label4: TLabel;
    Label5: TLabel;
    tckbTransparency: TTrackBar;
    tckbOpacity: TTrackBar;
    Panel44: TPanel;
    RxSpeedButton31: TRxSpeedButton;
    Panel45: TPanel;
    RxSpeedButton32: TRxSpeedButton;
    Label22: TLabel;
    Label23: TLabel;
    Panel47: TPanel;
    sbtnSizePage: TRxSpeedButton;
    pmSizePage: TBcBarPopupMenu;
    MenuItem44: TMenuItem;
    MenuItem45: TMenuItem;
    MenuItem46: TMenuItem;
    MenuItem47: TMenuItem;
    MenuItem48: TMenuItem;
    MenuItem49: TMenuItem;
    MenuItem50: TMenuItem;
    MenuItem52: TMenuItem;
    MenuItem53: TMenuItem;
    acSizePage16: TAction;
    acSizePage24: TAction;
    acSizePage32: TAction;
    acSizePage48: TAction;
    acSizePage64: TAction;
    acSizePage128: TAction;
    acSizePageCustom: TAction;
    Panel3: TPanel;
    sbtnBits: TRxSpeedButton;
    pmBits: TBcBarPopupMenu;
    MenuItem51: TMenuItem;
    MenuItem54: TMenuItem;
    MenuItem55: TMenuItem;
    MenuItem56: TMenuItem;
    MenuItem57: TMenuItem;
    MenuItem58: TMenuItem;
    MenuItem59: TMenuItem;
    acBits1: TAction;
    acBits4: TAction;
    acBits8: TAction;
    acBits16: TAction;
    acBits24: TAction;
    acBits32: TAction;
    Splitter1: TSplitter;
    pmCloseTabDesktop: TBcBarPopupMenu;
    MenuItem61: TMenuItem;
    pmCloseTabIcons: TBcBarPopupMenu;
    MenuItem60: TMenuItem;
    acFileSave: TAction;
    acFileSaveList: TAction;
    acFileNew: TAction;
    cxTabSheet2: TcxTabSheet;
    Panel10: TPanel;
    URLs: TComboBox;
    WebBrowser1: TWebBrowser;
    StatusBar1: TStatusBar;
    Panel48: TPanel;
    RxSpeedButton33: TRxSpeedButton;
    Panel49: TPanel;
    RxSpeedButton34: TRxSpeedButton;
    Panel50: TPanel;
    RxSpeedButton35: TRxSpeedButton;
    Panel51: TPanel;
    RxSpeedButton36: TRxSpeedButton;
    acEditCut: TAction;
    acEditCopy: TAction;
    acEditPaste: TAction;
    acViewTestIcon: TAction;
    acViewExtension: TAction;
    sbtnOcultarMenu: TSpeedButton;
    sbtnExibirMenu: TSpeedButton;
    Panel53: TPanel;
    sbtnPesquisar: TRxSpeedButton;
    CheckBox1: TCheckBox;
    cbxExtension: TComboBox;
    Label24: TLabel;
    Panel54: TPanel;
    sbtnSelectDirectorySearch: TRxSpeedButton;
    edtPesquisa: TEdit;
    Label1: TLabel;
    Gradient14: TGradient;
    pnlCaptureIE: TPanel;
    pnlCaptureZoom: TPanel;
    Gradient15: TGradient;
    Panel52: TPanel;
    Gradient16: TGradient;
    Label27: TLabel;
    Label28: TLabel;
    imgCaptureZoom: TImage;
    Panel7: TPanel;
    sbtnCaptureIE: TRxSpeedButton;
    sal1: TMenuItem;
    Image2: TImage;
    SalvarMVPBS1: TMenuItem;
    sd: TSaveDialog;
    od: TOpenDialog;
    AbrirMVPBS1: TMenuItem;
    N1: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    Importar3D1: TMenuItem;
    Image3: TImage;
    Button2: TButton;
    acSizePage256: TAction;
    N256x2561: TMenuItem;
    ImportarGIS1: TMenuItem;
    MccsPaletteColor1: TMccsPaletteColor;
    procedure FormShow(Sender: TObject);
    procedure actRateDemoExecute(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure cbxInternalDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cbxExternalDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure sbtnFontClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtPesquisaMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ShellTreeView1DblClick(Sender: TObject);
    procedure SpeedButton21Click(Sender: TObject);
    procedure btnm_AdquirirClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure sedtOpaqueChange(Sender: TObject);
    procedure SpinEditBordaChange(Sender: TObject);
    procedure cbxInternalChange(Sender: TObject);
    procedure cbxExternalChange(Sender: TObject);
    procedure tckbOpacityChange(Sender: TObject);
    procedure cbxBlendModeChange(Sender: TObject);
    procedure tckbTransparencyChange(Sender: TObject);
    procedure MccsPaletteColor1Change(Sender: TObject);
    procedure BcCustomDrawModule1DrawMenuItem(Sender: TObject;
      AMenuItem: TMenuItem; ACanvas: TCanvas; ARect: TRect;
      State: TOwnerDrawState; ABarVisible: Boolean;
      var DefaultDraw: Boolean);
    procedure BcCustomDrawModule1MeasureMenuItem(Sender: TObject;
      AMenuItem: TMenuItem; ACanvas: TCanvas; var Width, Height: Integer;
      ABarVisible: Boolean; var DefaultMeasure: Boolean);
    procedure pmFileMeasureMenuItem(Sender: TObject; AMenuItem: TMenuItem;
      ACanvas: TCanvas; var Width, Height: Integer; ABarVisible: Boolean;
      var DefaultMeasure: Boolean);
    procedure actCaptureDesktopExecute(Sender: TObject);
    procedure actCaptureMultDesktopExecute(Sender: TObject);
    procedure actCaptureSelectAreaExecute(Sender: TObject);
    procedure actCaptureSelectAreaConfigExecute(Sender: TObject);
    procedure actCaptureFreeHandExecute(Sender: TObject);
    procedure actCaptureActiveWindowExecute(Sender: TObject);
    procedure actCaptureIconExecute(Sender: TObject);
    procedure actCaptureObjectExecute(Sender: TObject);
    procedure actMaskRectangleExecute(Sender: TObject);
    procedure actMaskCircleExecute(Sender: TObject);
    procedure actMaskFreeHandExecute(Sender: TObject);
    procedure actMaskPolygonExecute(Sender: TObject);
    procedure actMaskModeNormalExecute(Sender: TObject);
    procedure actMaskModeAddExecute(Sender: TObject);
    procedure actMaskModeSubExecute(Sender: TObject);
    procedure actMaskClearExecute(Sender: TObject);
    procedure acToolSelectExecute(Sender: TObject);
    procedure acToolSelect2Execute(Sender: TObject);
    procedure acToolPencilExecute(Sender: TObject);
    procedure acToolPaintExecute(Sender: TObject);
    procedure acToolLineExecute(Sender: TObject);
    procedure acToolRectangleExecute(Sender: TObject);
    procedure acToolElipseExecute(Sender: TObject);
    procedure acToolPolygonExecute(Sender: TObject);
    procedure acToolLabelExecute(Sender: TObject);
    procedure acToolArcExecute(Sender: TObject);
    procedure acToolDropsExecute(Sender: TObject);
    procedure acToolPieExecute(Sender: TObject);
    procedure acToolRectRoundExecute(Sender: TObject);
    procedure acToolChordExecute(Sender: TObject);
    procedure cbxGalleryChange(Sender: TObject);
    procedure acEffectGradientExecute(Sender: TObject);
    procedure acEffectEffectExecute(Sender: TObject);
    procedure acZoom100Execute(Sender: TObject);
    procedure acZoom200Execute(Sender: TObject);
    procedure acZoom400Execute(Sender: TObject);
    procedure acZoom800Execute(Sender: TObject);
    procedure acZoom1600Execute(Sender: TObject);
    procedure acZoom3200Execute(Sender: TObject);
    procedure acZoom6400Execute(Sender: TObject);
    procedure acZoomCustomExecute(Sender: TObject);
    procedure acBits1Execute(Sender: TObject);
    procedure acBits4Execute(Sender: TObject);
    procedure acBits8Execute(Sender: TObject);
    procedure acBits16Execute(Sender: TObject);
    procedure acBits24Execute(Sender: TObject);
    procedure acBits32Execute(Sender: TObject);
    procedure MenuItem61Click(Sender: TObject);
    procedure MenuItem60Click(Sender: TObject);
    procedure acFileSaveExecute(Sender: TObject);
    procedure acFileSaveListExecute(Sender: TObject);
    procedure acFileNewExecute(Sender: TObject);
    procedure URLsClick(Sender: TObject);
    procedure URLsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure WebBrowser1BeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure WebBrowser1DownloadBegin(Sender: TObject);
    procedure WebBrowser1DownloadComplete(Sender: TObject);
    procedure RxSpeedButton33Click(Sender: TObject);
    procedure RxSpeedButton34Click(Sender: TObject);
    procedure RxSpeedButton35Click(Sender: TObject);
    procedure RxSpeedButton36Click(Sender: TObject);
    procedure acEditCutExecute(Sender: TObject);
    procedure acEditCopyExecute(Sender: TObject);
    procedure acEditPasteExecute(Sender: TObject);
    procedure acViewTestIconExecute(Sender: TObject);
    procedure acViewExtensionExecute(Sender: TObject);
    procedure rxBtnSairClick(Sender: TObject);
    procedure sbtnOcultarMenuClick(Sender: TObject);
    procedure sbtnExibirMenuClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure cbxExtensionChange(Sender: TObject);
    procedure sbtnSelectDirectorySearchClick(Sender: TObject);
    procedure sbtnPesquisarClick(Sender: TObject);
    procedure pnlCaptureIEMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pnlCaptureIEMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pnlCaptureIEMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbtnCaptureIEClick(Sender: TObject);
    procedure sal1Click(Sender: TObject);
    procedure SalvarMVPBS1Click(Sender: TObject);
    procedure AbrirMVPBS1Click(Sender: TObject);
    procedure Importar3D1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ImportarGIS1Click(Sender: TObject);
  private
    icBit: TIconCores;
    strExt: String;
    efExt: TExtFile;
    strPath: String;

    // Para trabalhar com biblioteca de ícones
    Icon: TAdvancedIcon;
    IconLib: TIconLibrary;
    NewImageList: TImageList;

    FDrawBuffer: TBitmap;

    //WEB BRowser
    HistoryIndex: Integer;
    HistoryList: TStringList;
    UpdateCombo: Boolean;

    XStart,
    YStart: Integer;
    fDraggingCaptureIE: Boolean;

    procedure WMDropFiles (var Msg: TMessage); message wm_DropFiles;
    procedure OnViewDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure OnViewDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure OnSelectedShape(Sender: TObject; AShape: TmccsShape);

    procedure ResizeView;

    procedure LibraryLoaded;

    function GetDrawBuffer: TBitmap;
    function GetApplicationPath: String;

    // WEB Browser
    procedure FindAddress;
    procedure HomePageRequest(var message: tmessage); message CM_HOMEPAGEREQUEST;

    procedure DrawZoomRegion(Dest: TImage);

  public
    procedure CopyData(var Msg: TWmCopyData); message wm_CopyData;

    procedure DrawGradient(Canvas: TCanvas; ARect: TRect; StartingColor,
       EndingColor: TColor; Style: TGradientStyle);

    property DrawBuffer: TBitmap read GetDrawBuffer;

  published
    procedure OnClickRBBit(Sender: TObject);

    procedure OnClickSelectIcon(Sender: TObject; IndexIcon: Integer;
        AFileIcon: TFileIcon; AIcon: TIcon; AIconAdv: TAdvancedIcon;
        ABitmap: TBitmap);
    procedure OnDblClickSelectIcon(Sender: TObject; IndexIcon: Integer;
        AFileIcon: TFileIcon; AIcon: TIcon; AIconAdv: TAdvancedIcon;
        ABitmap: TBitmap);

  end;

var
  frmIconClassic: TfrmIconClassic;

implementation

uses
    ShellAPI, uAvaliacao, uGlobal, uTestarIcone,
    cTipos, IconImage, IconTools, uShellExtensao,
    IconAni, mccsDrawPage, u3d, uGis;

{$R *.dfm}

function MakeDrop(const FileNames: array of string): THandle;
var
  I, Size: Integer;
  Data: PDragInfoA;
  P: PChar;
begin
  // Calculate memory size needed
  Size := SizeOf(TDragInfoA) + 1;
  for I := 0 to High(FileNames) do
    Inc(Size, Length(FileNames[I]) + 1);
  // allocate the memory
  Result := GlobalAlloc(GHND or GMEM_SHARE, Size);
  if Result <> 0 then
  begin
    Data := GlobalLock(Result);
    if Data <> nil then
      try
        // fill up with data
        Data.uSize := SizeOf(TDragInfoA);
        P  := PChar(@Data.grfKeyState) + 4;
        Data.lpFileList := P;
        // filenames at the at of the header (separated with #0)
        for I := 0 to High(FileNames) do
        begin
          Size := Length(FileNames[I]);
          Move(Pointer(FileNames[I])^, P^, Size);
          Inc(P, Size + 1);
        end;
      finally
        GlobalUnlock(Result);
      end
    else
    begin
      GlobalFree(Result);
      Result := 0;
    end;
  end;
end;

{ TPanel }

constructor TPanel.Create(AOwner: TComponent);
begin
    inherited;
    fBackground := TBitmap.Create;
end;

procedure TPanel.Paint;
const
  Alignments: array[TAlignment] of Longint = (DT_LEFT, DT_RIGHT, DT_CENTER);
var
  Rect: TRect;
  TopColor, BottomColor: TColor;
  FontHeight: Integer;
  Flags: Longint;

  procedure AdjustColors(Bevel: TPanelBevel);
  begin
    TopColor := clBtnHighlight;
    if Bevel = bvLowered then TopColor := clBtnShadow;
    BottomColor := clBtnShadow;
    if Bevel = bvLowered then BottomColor := clBtnHighlight;
  end;

begin
    if (fTransparent and (fBackground <> nil)) then
    begin
        Rect := GetClientRect;

        Canvas.Draw(0, 0, fBackground);

        if BevelOuter <> bvNone then
        begin
          AdjustColors(BevelOuter);
          Frame3D(Canvas, Rect, TopColor, BottomColor, BevelWidth);
        end;

        Frame3D(Canvas, Rect, Color, Color, BorderWidth);

        if BevelInner <> bvNone then
        begin
          AdjustColors(BevelInner);
          Frame3D(Canvas, Rect, TopColor, BottomColor, BevelWidth);
        end;
    end
    else
        inherited;
end;


procedure TPanel.SetBackground(const Value: TBitmap);
begin
    if Assigned(Value) then
    begin
        with fBackground do
        begin
            Width := Value.Width;
            Height := Value.Height;
            Canvas.Draw(0, 0, Value);
        end;
    end
    else
        fBackground := nil;
end;

{ TcxTabSheet }

constructor TcxTabSheet.Create(AOwner: TComponent);
begin
    inherited;
    FmccsViewPaintBoxShapes := nil;
    FmccsIconGrid := nil;
    Color := $00E9E9E9;
end;

procedure TcxTabSheet.SetmccsIconGrid(Value: TmccsIconGrid);
begin
    if (FmccsIconGrid <> Value) then
        FmccsIconGrid := Value;
end;

procedure TcxTabSheet.SetmccsViewPaintBoxShapes(Value: TmccsViewPaintBoxShapes);
begin
    if (FmccsViewPaintBoxShapes <> Value) then
        FmccsViewPaintBoxShapes := Value;
end;

{ TPanelLayers }

constructor TPanelLayers.Create(AOwner: TComponent; AEditor: TmccsViewPaintBoxShapes);
begin
    inherited Create(AOwner);

    Self.Caption := '';

    Self.fEditor := AEditor;

    Self.fpnlmenu := TPanel.Create(Self);
    Self.fpnlmenu.Parent := Self;
    Self.fpnlmenu.Align := alTop;
    Self.fpnlmenu.Height := 27;

    Self.fsbtnInsertLayer := TSpeedButton.Create(Self.fpnlmenu);
    Self.fsbtnInsertLayer.Parent := Self.fpnlmenu;
    Self.fsbtnInsertLayer.Left := 2;
    Self.fsbtnInsertLayer.Top := 3;
    Self.fsbtnInsertLayer.Width := 22;
    Self.fsbtnInsertLayer.Height := 22;
    Self.fsbtnInsertLayer.Flat := True;
    Self.fsbtnInsertLayer.OnClick := onInsertLayer;

    Self.fsbtnRemoveLayer := TSpeedButton.Create(Self.fpnlmenu);
    Self.fsbtnRemoveLayer.Parent := Self.fpnlmenu;
    Self.fsbtnRemoveLayer.Left := 24;
    Self.fsbtnRemoveLayer.Top := 3;
    Self.fsbtnRemoveLayer.Width := 22;
    Self.fsbtnRemoveLayer.Height := 22;
    Self.fsbtnRemoveLayer.Flat := True;
    Self.fsbtnRemoveLayer.OnClick := onRemoveLayer;

    Self.fsbtnPreview := TSpeedButton.Create(Self.fpnlmenu);
    Self.fsbtnPreview.Parent := Self.fpnlmenu;
    Self.fsbtnPreview.Left := 46;
    Self.fsbtnPreview.Top := 3;
    Self.fsbtnPreview.Width := 22;
    Self.fsbtnPreview.Height := 22;
    Self.fsbtnPreview.Flat := True;
    Self.fsbtnPreview.OnClick := onPreview;

    Self.fmccsLayerManager := TmccsLayerManager.Create(Self);
    Self.fmccsLayerManager.Parent := Self;
    Self.fmccsLayerManager.Align := alClient;
    Self.fmccsLayerManager.Editor := Self.fEditor;
end;

procedure TPanelLayers.onInsertLayer(Sender: TObject);
var
    L: TmccsLayer;
begin
    Randomize;
    L := Self.fEditor.LayersContainer.Add;
    L.Caption := 'Layer - ' + IntToStr(Random(10000));

    Self.fmccsLayerManager.Editor := nil;
    Self.fmccsLayerManager.Editor := Self.fEditor;
end;

procedure TPanelLayers.onRemoveLayer(Sender: TObject);
begin
end;

procedure TPanelLayers.onPreview(Sender: TObject);
begin
    Self.fmccsLayerManager.ShowPreview := not Self.fmccsLayerManager.ShowPreview;
end;

{ TfrmIconClassic }

procedure TfrmIconClassic.DrawGradient(Canvas: TCanvas; ARect: TRect; StartingColor,
  EndingColor: TColor; Style: TGradientStyle);
begin
    DrawBuffer.Height := RectHeight(ARect);
    DrawBuffer.Width := RectWidth(ARect);
    BarMenus.DrawGradient(DrawBuffer, nil, BitmapRect(DrawBuffer), startingColor, EndingColor, Style);
    Canvas.Draw(ARect.Left, ARect.Top, DrawBuffer); // copy the buffer
    DrawBuffer.Height := 0;
    DrawBuffer.Width := 0;
end;

procedure TfrmIconClassic.FormShow(Sender: TObject);
var
    lint_Loop: Integer;
    lstr_Temp: String;
    Drop: hDrop;
begin
    cbxExternal.ItemIndex := 0;
    cbxInternal.ItemIndex := 0;
    sedtAngleFont.Value := 1; // PAra alterar a imagem que será rotacionada
    sedtAngleFont.Value := 0;

    lstr_Temp := '';

    for lint_Loop := 1 to ParamCount do
    begin
        if (lint_Loop = 1) then
            lstr_Temp := ExtractShortPathName(ParamStr(lint_Loop))
        else
        begin
            if (ExtractShortPathName(ParamStr(lint_Loop)) <> '') then
                lstr_Temp := lstr_Temp + ' ' + ExtractShortPathName(ParamStr(lint_Loop))
            else
                lstr_Temp := lstr_Temp + ' ' + ParamStr(lint_Loop);
        end;
    end;

    if (lstr_Temp <> '') then
    begin
        Drop := MakeDrop([lstr_Temp]);
        if (Drop <> 0) then
            PostMessage(Handle, wm_DropFiles, Drop, 0);
    end;
end;

procedure TfrmIconClassic.actRateDemoExecute(Sender: TObject);
begin
  with TfrmAvaliacao.Create(Self) do
    try
      ShowModal;
    finally
      Free;
    end;
end;

procedure TfrmIconClassic.actAboutExecute(Sender: TObject);
begin
    MccsAboutDinamic.Execute;
end;

procedure TfrmIconClassic.cbxInternalDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  ListDrawValueBrush(TComboBox(Control).Items.ValueFromIndex[Index], Index,
    TComboBox(Control).Canvas , Rect, False, False);
end;

procedure TfrmIconClassic.cbxExternalDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  ListDrawValuePen(TComboBox(Control).Items.ValueFromIndex[Index], Index,
    TComboBox(Control).Canvas , Rect, False, False);
end;

procedure TfrmIconClassic.sbtnFontClick(Sender: TObject);
var
    I, J: Integer;
    mvpbs: TmccsViewPaintBoxShapes;
begin
    mvpbs := nil;
    mvpbs := TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes;

    if Assigned(mvpbs) then
    begin
        if (mvpbs.GetObjectList.Count > 0) then
        begin
            FontDialog1.Font.Assign(TmccsShape(mvpbs.GetObjectList.Items[0]).CaptionProperties.Font);
        end;

        if FontDialog1.Execute then
        begin
            for I := 0 to Pred(mvpbs.GetObjectList.Count) do
            begin
                TmccsShape(mvpbs.GetObjectList.Items[I]).CaptionProperties.Font.Assign(FontDialog1.Font);
                TmccsShape(mvpbs.GetObjectList.Items[I]).CaptionProperties.Visible := True;
            end;
            edtText.Font.Assign(FontDialog1.Font);
            mvpbs.ForcePaint;
        end;
    end;
end;

procedure TfrmIconClassic.FormCreate(Sender: TObject);
begin
    icBit := ic32Bit;
    Self.WindowState := wsMaximized;

    strExt := '.dll';
    efExt := EFdll;
    strPath := 'C:\';
    edtPesquisa.Text := strPath;
    cbxExtension.ItemIndex := 0;

    // Para arrastar imagem DragDrop
    DragAcceptFiles(Handle, True);

    IconLib := TIconLibrary.Create;

    cbxGallery.ItemIndex := 0;
    cbxGallery.OnChange(cbxGallery);

    // WEB Browser
    HistoryIndex := -1;
    HistoryList := TStringList.Create;
    { Find the home page - needs to be posted because HTML control hasn't been
      registered yet. }
    PostMessage(Handle, CM_HOMEPAGEREQUEST, 0, 0);

    pnlCaptureIE.SendToBack;
end;

procedure TfrmIconClassic.OnClickRBBit(Sender: TObject);
begin
    with TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes do
    try
        Page.Layer.Width := TAction(Sender).Tag;
        Page.Layer.Height := TAction(Sender).Tag;
        sbtnSizePage.Caption := '(' + TAction(Sender).Caption + ')';
        TAction(Sender).Checked := True;
        ResizeView;
    except
        PixelSize := 8;
        Page.Layer.Width := 32;
        Page.Layer.Height := 32;
        sbtnSizePage.Caption := '(32 x 32)';
    end;
end;

procedure TfrmIconClassic.FormDestroy(Sender: TObject);
begin
    FreeAndNil(HistoryList);
    FreeAndNil(FDrawBuffer);

    if (Screen.Cursor <> crDefault) then
        Screen.Cursor := crDefault;

    IconLib.Free;
end;

procedure TfrmIconClassic.edtPesquisaMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
    TEdit(Sender).Hint := TEdit(Sender).Text;
    if not TEdit(Sender).ShowHint and (TEdit(Sender).Text <> '') then
        TEdit(Sender).ShowHint := True;
end;

procedure TfrmIconClassic.WMDropFiles(var Msg: TMessage);
var
    lcxts_Temp: TcxTabSheet;
begin
    dxTabDiversos.AutoHide := False;
    cxIconesDiversos.Visible := True;
    lcxts_Temp := TcxTabSheet.Create(cxIconesDiversos);
    lcxts_Temp.Parent := cxIconesDiversos;
    lcxts_Temp.PageControl := cxIconesDiversos;
    lcxts_Temp.Color := $00E9E9E9;
    lcxts_Temp.ImageIndex := 0;
    lcxts_Temp.PopupMenu := pmCloseTabIcons;
    Randomize;
    lcxts_Temp.Name := 'lcxts_Temp_' + IntToStr(Random(High(Integer)));
    lcxts_Temp.Caption := 'Arquivo externo...';
    cxIconesDiversos.ActivePage := lcxts_Temp;

    with TfFrArrastar.Create(lcxts_Temp) do
    begin
        Parent := lcxts_Temp;
        Align := alClient;
        OnDblClick := OnDblClickSelectIcon;
        OnClick := OnClickSelectIcon;
        WMDrop(Msg);
    end;
end;

procedure TfrmIconClassic.ShellTreeView1DblClick(Sender: TObject);
var
    Drop: hDrop;
begin
    if (ShellTreeView1.Path <> '') and FileExists(ShellTreeView1.Path) then
    begin
        Drop := MakeDrop([ShellTreeView1.Path]);
        if (Drop <> 0) then
            PostMessage(Handle, wm_DropFiles, Drop, 0);
    end;
end;

procedure TfrmIconClassic.OnClickSelectIcon(Sender: TObject;
  IndexIcon: Integer; AFileIcon: TFileIcon; AIcon: TIcon;
  AIconAdv: TAdvancedIcon; ABitmap: TBitmap);
var
    icgrd: TmccsIconGrid;
    IAdv: TAdvancedIcon;
    FIco: TFileIcon;
    I: Integer;
begin
    if (IndexIcon < 0) or (cxDesktop.PageCount < 1) then
        exit;

    icgrd := TcxTabSheet(cxDesktop.Pages[cxDesktop.ActivePageIndex]).mccsIconGrid;
    IAdv := AIconAdv;
    if not ((Assigned(IAdv) and (IAdv is TAdvancedIcon)) and Assigned(icgrd)) then
        exit;
        
    icgrd.Clear;
    icgrd.Repaint;

    for I := 1 to IAdv.Images.Count do
    begin
        try
            FIco := TFileIcon.Create;
            FIco.FileName := AFileIcon.FileName;
            FIco.PathFileName := AFileIcon.PathFileName;
            FIco.IndexInFile := I - 1;
            FIco.Category := AFileIcon.Category;
            FIco.Icon := TAdvancedIcon.Create;
            FIco.Icon.Images.Add(IAdv.Images.Image[I - 1]);
            icgrd.AddFileIcon(FIco);

            icgrd.Repaint;
        except
            Continue;
        end;
    end;

end;

procedure TfrmIconClassic.OnDblClickSelectIcon(Sender: TObject; IndexIcon: Integer;
    AFileIcon: TFileIcon; AIcon: TIcon; AIconAdv: TAdvancedIcon; ABitmap: TBitmap);
var
    lcxts_Temp: TcxTabSheet;
    lsbx_Temp: TScrollBox;
    ligd_Temp: TmccsIconGrid;
    lviw_Temp: TmccsViewPaintBoxShapes;
    lishp_Temp: TmccsShape;
    lilyr_Temp: TmccsLayer;
    lbmp_Temp: TBitmap;
    lplyr_Temp: TPanelLayers;
begin
    if (not Assigned(ABitmap) or not Assigned(AIcon)) and not (Sender is TAction) then
        raise exception.Create('Não foi possível carregar o ícone desejado.')
    else
    if not Assigned(ABitmap) or not Assigned(AIcon) then
    begin
        lbmp_Temp := TBitmap.Create;
        lbmp_Temp.Width := 32;
        lbmp_Temp.Height := 32;
        lbmp_Temp.Canvas.Draw(0, 0, ABitmap);
    end
    else
    begin
        lbmp_Temp := TBitmap.Create;
        lbmp_Temp.Width := AIconAdv.Images.Image[AFileIcon.IndexIconSelected].Info.Width;
        lbmp_Temp.Height := AIconAdv.Images.Image[AFileIcon.IndexIconSelected].Info.Height;
        lbmp_Temp.Canvas.Draw(0, 0, AIcon);
    end;


    try
//        lbmp_Temp.Canvas.Draw(0, 0, AIcon);

        cxDesktop.Tag := cxDesktop.Tag + 1;
        lcxts_Temp := TcxTabSheet.Create(cxDesktop);
        lcxts_Temp.Parent := cxDesktop;
        lcxts_Temp.PageControl := cxDesktop;
        lcxts_Temp.Color := $00E9E9E9;
        lcxts_Temp.ImageIndex := 0;
        lcxts_Temp.PopupMenu := pmCloseTabDesktop;
        Randomize;
        lcxts_Temp.Name := 'lcxts_Desktop_' + IntToStr(Random(High(Integer)));
        lcxts_Temp.Caption := 'Icone ' + IntToStr(cxDesktop.Tag);
        cxDesktop.ActivePage := lcxts_Temp;

        lsbx_Temp := TScrollBox.Create(lcxts_Temp);
        lsbx_Temp.Parent := lcxts_Temp;
        lsbx_Temp.Align := alClient;
        lsbx_Temp.Color := $00E9E9E9;

        // Grade esquerda para representação de ícones (extraí ícone de um ícone múltiplo)
        ligd_Temp := TmccsIconGrid.Create(lcxts_Temp);
        ligd_Temp.Parent := lcxts_Temp;
        ligd_Temp.Align := alLeft;
        ligd_Temp.Width := 80;

        // Define o tamanho da página na criação
        lviw_Temp := TmccsViewPaintBoxShapes.Create(lsbx_Temp);//, lbmp_Temp.Width, lbmp_Temp.Height);
        lviw_Temp.Parent := lsbx_Temp;
        lviw_Temp.PixelSize := 8;
        lviw_Temp.Color := RGB(255, 254, 255);//clBtnFace;
        lviw_Temp.Page.Layer.Color:= RGB(255, 254, 255);//clBtnFace;
        lviw_Temp.Align := alClient;
        if not Assigned(ABitmap) or not Assigned(AIcon) then
        begin
            lviw_Temp.Page.Layer.Width := lbmp_Temp.Width;
            lviw_Temp.Page.Layer.Height := lbmp_Temp.Height;
        end
        else
        begin
            lviw_Temp.Page.Layer.Width := AIconAdv.Images.Image[AFileIcon.IndexIconSelected].Info.Width;
            lviw_Temp.Page.Layer.Height := AIconAdv.Images.Image[AFileIcon.IndexIconSelected].Info.Height;
        end;
        lviw_Temp.Page.Layer.Checkers.Width := 2;//2 div lviw_Temp.PixelSize;
        lviw_Temp.Page.Layer.Checkers.Height := 2;//2 div lviw_Temp.PixelSize;
        lviw_Temp.Page.Grid.GroupCount := 4;
        lviw_Temp.Page.Grid.X := 4;
        lviw_Temp.Page.Grid.Y := 4;
        lviw_Temp.Page.Frame.ShadowOffset := 0;
        lviw_Temp.Page.Frame.Visible := False;
        lviw_Temp.OnDragDrop := OnViewDragDrop;
        lviw_Temp.OnDragOver := OnViewDragOver;
        lviw_Temp.OnSelectedShape := OnSelectedShape;

        lcxts_Temp.mccsViewPaintBoxShapes := lviw_Temp;
        lcxts_Temp.mccsIconGrid := ligd_Temp;

        if Assigned(AIcon) then
        begin
            if (lviw_Temp.LayersContainer.Count <= 0) then
                lilyr_Temp := lviw_Temp.LayersContainer.Add
            else
                lilyr_Temp := lviw_Temp.LayersContainer.Items[0];

            lishp_Temp := lilyr_Temp.Shapes.Add;
            lishp_Temp.Vector := '005Mccs=0,0,1,1';
            lishp_Temp.Gradient.Visible := False;
            lishp_Temp.Shadow := False;
            lishp_Temp.Left := 0;
            lishp_Temp.Top := 0;
            lishp_Temp.Width := AIconAdv.Images.Image[AFileIcon.IndexIconSelected].Info.Width+1;
            lishp_Temp.Height := AIconAdv.Images.Image[AFileIcon.IndexIconSelected].Info.Height+1;
            lishp_Temp.Pen.Width := 0;
            lishp_Temp.Pen.Style := psClear;
            lishp_Temp.Opacity := 254;

            lishp_Temp.Picture.Assign(lbmp_Temp); // Para forçar a criação do objeto BITMAP
            lishp_Temp.Stretch := True;
        end
        else
        if Assigned(ABitmap) then
        begin
            if (lviw_Temp.LayersContainer.Count <= 0) then
                lilyr_Temp := lviw_Temp.LayersContainer.Add
            else
                lilyr_Temp := lviw_Temp.LayersContainer.Items[0];

            lishp_Temp := lilyr_Temp.Shapes.Add;
            lishp_Temp.Vector := '005Mccs=0,0,1,1';
            lishp_Temp.Gradient.Visible := False;
            lishp_Temp.Shadow := False;
            lishp_Temp.Left := 0;
            lishp_Temp.Top := 0;
            if Assigned(AIconAdv) then
            begin
                lishp_Temp.Width := AIconAdv.Images.Image[AFileIcon.IndexIconSelected].Info.Width+1;
                lishp_Temp.Height := AIconAdv.Images.Image[AFileIcon.IndexIconSelected].Info.Height+1;
            end
            else
            begin
                lishp_Temp.Width := ABitmap.Width+1;
                lishp_Temp.Height := ABitmap.Height+1;
            end;
            lishp_Temp.Pen.Width := 0;
            lishp_Temp.Pen.Style := psClear;
            lishp_Temp.Opacity := 254;

            lishp_Temp.Picture.Assign(lbmp_Temp); // Para forçar a criação do objeto BITMAP
            lishp_Temp.Stretch := True;
        end;

        lviw_Temp.ForcePaint;

        lplyr_Temp := TPanelLayers.Create(lcxts_Temp, lviw_Temp);
        lplyr_Temp.Parent := lcxts_Temp;
        lplyr_Temp.Align := alRight;
                
        imgViewIcon.Picture.Assign(lviw_Temp.BitmapBackground);
        imgViewIcon.Picture.Bitmap.TransparentColor := RGB(255, 254, 255);
        imgViewIcon.Picture.Bitmap.TransparentMode := tmFixed;
    finally
        FreeAndNil(lbmp_Temp);
    end;
end;

procedure TfrmIconClassic.SpeedButton21Click(Sender: TObject);
begin
  if not LIBSaveDialog.Execute then
    exit;
  IconLib.SaveToFile(LIBSaveDialog.Filename, True);
  ListView1.Clear;
  IconLib.LoadFromFile(LIBSaveDialog.Filename);
  LibraryLoaded;
end;

procedure TfrmIconClassic.LibraryLoaded;
var
  NewItem: TListItem;
  I, J: Integer;
  Img: TBitmap;
  advIcon: TAdvancedIcon;
  Image: TIconImage;
  imgL: TImageList;
begin
  if ListView1.Items.Count <> 0 then
    ListView1.clear;
  imgL := TImageList.Create(Self);
  imgL.Width := 32;
  imgL.Height := 32;
  for I := 0 to Pred(IconLib.Icons.Count) do
  begin
    advIcon := TAdvancedIcon(IconLib.Icons.Objects[I]);
    if not Assigned(advIcon) then
      exit;
    if not (advIcon is TAdvancedIcon) then
      exit;
    Icon.Assign(advIcon);
    with imgL do
    begin
      if (Icon.Images.Count > 1) then
      begin
        for J := 1 to Icon.Images.Count do
        begin
          Image := Icon.Images.Image[Pred(J)];
          if (Image.Info.Width = 32) and (Image.Info.Height = 32) and
            (Image.Info.BitCount >= 8) then
            Break;
        end;
//  Deixa o cor preta da borda dos icones como sombreamento
//  DrawIconEx(Image5.Canvas.Handle, 0, 0, Image.Icon.Handle, Image.Info.Height, Image.Info.Width, 0, 0, DI_NORMAL);
        AddIcon(Image.Icon);
      end
      else
      begin
        Image := Icon.Images.Image[0];
        AddIcon(Image.Icon);
      end;
    end;
//    ProgressBar1.Max := IconLib.Icons.Count - 1;
  end;
  NewImageList := imgL;
  ListView1.LargeImages := NewImageList;
//  ProgressBar1.Position := 0;
//  PProgress.Visible := True;
  for I := 0 to NewImageList.Count - 1 do
  begin
    NewItem := ListView1.Items.Add;
    NewItem.Caption := '';
    NewItem.Caption := ExtractFileName(IconLib.Filename);
    NewItem.ImageIndex := I;
//    StatusBar1.Panels[1].Text := 'Total de ícones: ' + IntToStr(I + 1);
//    ProgressBar1.Position := ProgressBar1.Position+1;
  end;
//  ProgressBar1.Position := 0;
//  PProgress.Visible := False;
  Img := TBitmap.Create;
  NewImageList.GetBitmap(0, Img);
//  TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.Bitmap := Img;
  TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.ForcePaint;
  Img.Destroy;
end;

procedure TfrmIconClassic.CopyData(var Msg: TWmCopyData);
var
    str_File: String;
    Drop: hDrop;
begin

    case Msg.CopyDataStruct.dwData of
        0: begin
               str_File := Copy(PChar(Msg.CopyDataStruct.lpData), 1, Msg.CopyDataStruct.cbData);
               if (str_File <> '') then
               begin
                   Drop := MakeDrop([str_File]);
                   if (Drop <> 0) then
                       PostMessage(Handle, wm_DropFiles, Drop, 0);
               end;
           end;
    end;
end;

procedure TfrmIconClassic.btnm_AdquirirClick(Sender: TObject);
begin
  ShowMessage('Obter imagem de dispositivos externos: WebCam / Scanner');
end;

procedure TfrmIconClassic.Button1Click(Sender: TObject);
begin
    ImgViewIcon.Picture.Assign(TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.BitmapBackground);
    ImgViewIcon.Invalidate;
end;

procedure TfrmIconClassic.sedtOpaqueChange(Sender: TObject);
begin
    if (cxDesktop.PageCount > 0) then
    begin
//        TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.PaintBoxShapes.Items[0].Shapes.Items[0].Opacity := sedtOpaque.Value;
//        TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.ForcePaint;
    end;
end;

procedure TfrmIconClassic.SpinEditBordaChange(Sender: TObject);
var
    I, J: Integer;
    mvpbs: TmccsViewPaintBoxShapes;
begin
    mvpbs := nil;
    mvpbs := TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes;
    if Assigned(mvpbs) then
    begin
        for I := 0 to Pred(mvpbs.LayersContainer.Count) do
        begin
            for J := 0 to Pred(mvpbs.LayersContainer.Items[I].Shapes.Count) do
            begin
                if (mvpbs.LayersContainer.Items[I].Shapes.Items[J].Selected) then
                begin
                    mvpbs.LayersContainer.Items[I].Shapes.Items[J].Pen.Width := TSpinEdit(Sender).Value;
                    mvpbs.ForcePaint;
                end;
            end;
        end;
    end;
end;

procedure TfrmIconClassic.cbxInternalChange(Sender: TObject);
var
    I, J: Integer;
    mvpbs: TmccsViewPaintBoxShapes;
begin
    mvpbs := nil;
    mvpbs := TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes;
    if Assigned(mvpbs) then
    begin
        for I := 0 to Pred(mvpbs.LayersContainer.Count) do
        begin
            for J := 0 to Pred(mvpbs.LayersContainer.Items[I].Shapes.Count) do
            begin
                if (mvpbs.LayersContainer.Items[I].Shapes.Items[J].Selected) then
                begin
                    mvpbs.LayersContainer.Items[I].Shapes.Items[J].Brush.Style := TBrushStyle(cbxInternal.ItemIndex);
                    mvpbs.ForcePaint;
                end;
            end;
        end;
    end;
end;

procedure TfrmIconClassic.cbxExternalChange(Sender: TObject);
var
    I, J: Integer;
    mvpbs: TmccsViewPaintBoxShapes;
begin
    mvpbs := nil;
    mvpbs := TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes;
    if Assigned(mvpbs) then
    begin
        for I := 0 to Pred(mvpbs.LayersContainer.Count) do
        begin
            for J := 0 to Pred(mvpbs.LayersContainer.Items[I].Shapes.Count) do
            begin
                if (mvpbs.LayersContainer.Items[I].Shapes.Items[J].Selected) then
                begin
                    mvpbs.LayersContainer.Items[I].Shapes.Items[J].Pen.Style := TPenStyle(cbxExternal.ItemIndex);
                    mvpbs.ForcePaint;
                end;
            end;
        end;
    end;
end;

procedure TfrmIconClassic.tckbOpacityChange(Sender: TObject);
begin
    lblOpaque.Caption := IntToStr(tckbOpacity.Position);
end;

procedure TfrmIconClassic.cbxBlendModeChange(Sender: TObject);
var
    I, J: Integer;
    mvpbs: TmccsViewPaintBoxShapes;
begin
    mvpbs := nil;
    mvpbs := TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes;
    if Assigned(mvpbs) then
    begin
        for I := 0 to Pred(mvpbs.LayersContainer.Count) do
        begin
            for J := 0 to Pred(mvpbs.LayersContainer.Items[I].Shapes.Count) do
            begin
                if (mvpbs.LayersContainer.Items[I].Shapes.Items[J].Selected) then
                begin
                    if (cbxBlendMode.ItemIndex >= Ord(Low(TBlendModes))) and
                        (cbxBlendMode.ItemIndex <= Ord(High(TBlendModes))) then
                        mvpbs.LayersContainer.Items[I].Shapes.Items[J].BlendMode := TBlendModes(cbxBlendMode.ItemIndex);
                    mvpbs.ForcePaint;
                end;
            end;
        end;
    end;
end;

procedure TfrmIconClassic.tckbTransparencyChange(Sender: TObject);
var
    I, J: Integer;
    mvpbs: TmccsViewPaintBoxShapes;
begin
    lblTransparency.Caption := IntToStr(tckbTransparency.Position);
    mvpbs := nil;
    mvpbs := TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes;
    if Assigned(mvpbs) then
    begin
        for I := 0 to Pred(mvpbs.LayersContainer.Count) do
        begin
            for J := 0 to Pred(mvpbs.LayersContainer.Items[I].Shapes.Count) do
            begin
                if (mvpbs.LayersContainer.Items[I].Shapes.Items[J].Selected) then
                begin
                    mvpbs.LayersContainer.Items[I].Shapes.Items[J].Opacity := tckbTransparency.Position;
                    mvpbs.ForcePaint;
                end;
            end;
        end;
    end;
end;

procedure TfrmIconClassic.MccsPaletteColor1Change(Sender: TObject);
var
    I, J: Integer;
    mvpbs: TmccsViewPaintBoxShapes;
    FColor, BColor: TColor;
begin
    lblTransparency.Caption := IntToStr(tckbOpacity.Position);
    mvpbs := nil;
    mvpbs := TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes;
    if Assigned(mvpbs) then
    begin
        mvpbs.DrawBrush(MccsPaletteColor1.ForegroundColor, False);
        for I := 0 to Pred(mvpbs.LayersContainer.Count) do
        begin
            for J := 0 to Pred(mvpbs.LayersContainer.Items[I].Shapes.Count) do
            begin
                if (mvpbs.LayersContainer.Items[I].Shapes.Items[J].Selected) then
                begin
                    FColor := MccsPaletteColor1.ForegroundColor;
                    BColor := MccsPaletteColor1.BackgroundColor;
                    if (GetRValue(FColor) = 255) and (GetGValue(FColor) = 255) and (GetBValue(FColor) = 255) then
                        FColor := RGB(255, 255, 254);
                    if (GetRValue(BColor) = 255) and (GetGValue(BColor) = 255) and (GetBValue(BColor) = 255) then
                        BColor := RGB(255, 255, 254);
                    mvpbs.LayersContainer.Items[I].Shapes.Items[J].Brush.Color := FColor;
                    mvpbs.LayersContainer.Items[I].Shapes.Items[J].Pen.Color := BColor;
                    mvpbs.ForcePaint;
                end;
            end;
        end;
    end;
end;

procedure TfrmIconClassic.OnViewDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
    mvpbs: TmccsViewPaintBoxShapes;
    lishp_Temp: TmccsShape;
    lipbxs_Temp: TmccsLayer;
    lbmp_Temp: TBitmap;
begin
    if (Source.ClassType = TmccsIconGrid) then
    begin
        if Assigned(TmccsIconGrid(Source).Bitmap) then
        begin
            lbmp_Temp := TBitmap.Create;
            lbmp_Temp.Assign(TmccsIconGrid(Source).Bitmap);
            try
                mvpbs := TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes;

                if (mvpbs.LayersContainer.Count <= 0) then
                    lipbxs_Temp := mvpbs.LayersContainer.Add
                else
                    lipbxs_Temp := mvpbs.LayersContainer.Items[0];

                lishp_Temp := lipbxs_Temp.Shapes.Add;
                lishp_Temp.Vector := '005Mccs=0,0,1,1';
                lishp_Temp.Gradient.Visible := False;
                lishp_Temp.Shadow := False;
                lishp_Temp.Left := X div mvpbs.PixelSize;
                lishp_Temp.Top := Y div mvpbs.PixelSize;
                lishp_Temp.Width := lbmp_Temp.Width;
                lishp_Temp.Height := lbmp_Temp.Height;
                lishp_Temp.Pen.Width := 0;
                lishp_Temp.Pen.Style := psClear;
                lishp_Temp.Opacity := 254;

                lishp_Temp.Picture.Assign(lbmp_Temp); // Para forçar a criação do objeto BITMAP

                lishp_Temp.Stretch := True;

                mvpbs.ForcePaint;

                imgViewIcon.Picture.Assign(mvpbs.BitmapBackground);
                imgViewIcon.Picture.Bitmap.TransparentColor := RGB(255, 254, 255);
                imgViewIcon.Picture.Bitmap.TransparentMode := tmFixed;
            finally
                FreeAndNil(lbmp_Temp);
            end;
        end;
    end;
end;

procedure TfrmIconClassic.OnViewDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
    Accept := False;
    if (Source.ClassType = TmccsIconGrid) or (Source is TfFrArrastar) then
        Accept := True;
end;

procedure TfrmIconClassic.BcCustomDrawModule1DrawMenuItem(Sender: TObject;
  AMenuItem: TMenuItem; ACanvas: TCanvas; ARect: TRect;
  State: TOwnerDrawState; ABarVisible: Boolean; var DefaultDraw: Boolean);
var
  R: TRect;
  ImageList: TCustomImageList;

  procedure DrawCheckedPattern(Inflate: Boolean);
  begin
    if odChecked in State then
    begin
      DrawGradient(ACanvas, R, clWhite, $00FFB56A, gsHorizontal);
      if Inflate then
        InflateRect(R, -2, -2);
      ACanvas.Brush.Color := clWhite;// clBlack
      ACanvas.FrameRect(R);
      if Inflate then
        InflateRect(R, 2, 2);
    end;
  end;

begin
  DefaultDraw := False;
  { menuitem drawing }
  if (AMenuItem.Caption = cLineCaption) then
  begin
    { background }
      ACanvas.Brush.Color := $00414141;
      ACanvas.Brush.Style := bsSolid;
      ACanvas.Rectangle(ARect);
      ACanvas.Font.Color := clSilver; // caption color

    { align the text and draw it }
    R := ARect;
    R.Left := R.Right - ACanvas.TextWidth(AMenuItem.Hint) - 15;
    ACanvas.Brush.Style := bsClear;
    DrawText(ACanvas.Handle,
      PChar(AMenuItem.Hint), Length(AMenuItem.Hint),
      R, 0);

    { draw the line so that it won't draw over text }
    R := ARect;
    Inc(R.Top, (R.Bottom - R.Top) div 2);
    R.Bottom := R.Top + 1;
    Dec(R.Right, ACanvas.TextWidth(AMenuItem.Hint) + 10 + 10);
    ACanvas.Brush.Color := clGray;
    ACanvas.FillRect(R);
  end else
  begin
    { use default drawing for mainmenu top items }
    if IsInTopMainMenu(AMenuItem) then
    begin
      DefaultDraw := True;
      Exit;
    end;
    with ACanvas do
    begin
      R := ARect;
      if odSelected in State then
      begin
        { draw frame and selection gradient }
        Brush.Color := clGray;
        FrameRect(R);
        InflateRect(R, -2, -2);

        DrawGradient(ACanvas, R, clWhite, AMenuItem.Tag, gsDiagonalLeftRight);        
        DrawCheckedPattern(False);

        { adjust rect so that text will be aligned to right }
//        R.Left := R.Right - TextWidth(AMenuItem.Caption) - 5; mccs
        Inc(R.Left, 56);                                   //mccs

        Font.Color := clBlack; // caption color  
      end else
      begin
        { draw background gradient }
        DrawGradient(ACanvas, R, clWhite, clGray, gsHorizontal);
        DrawCheckedPattern(True);
        { leave space for menuitem image }
        Inc(R.Left, 56);  {ideal 58 - mccs}
        Font.Color := clBlack; // caption color
      end;
      if (odDisabled in State) or (odGrayed in State) then
        Font.Color := clGrayText;

      { draw caption }
      InflateRect(R, 0, -(
        (R.Bottom - R.Top - TextHeight(AMenuItem.Caption) - 1)
         div 2));
      Brush.Style := bsClear;
      DrawText(Handle,
        PChar(AMenuItem.Caption), Length(AMenuItem.Caption),
        R, 0);

      { draw menuitem image }
      with AMenuItem do
      begin
        ImageList := GetImageList;
        if (ImageIndex <> -1) and Assigned(ImageList) then
          ImageList.Draw(ACanvas, ARect.Left + 11,
            ARect.Top + (ARect.Bottom - ARect.Top - ImageList.Height) div 2, ImageIndex);
      end;
    end;
  end;
end;

procedure TfrmIconClassic.BcCustomDrawModule1MeasureMenuItem(
  Sender: TObject; AMenuItem: TMenuItem; ACanvas: TCanvas; var Width,
  Height: Integer; ABarVisible: Boolean; var DefaultMeasure: Boolean);
begin
    if not IsInTopMainMenu(AMenuItem) then
    begin
        DefaultMeasure := False;
        if not (AMenuItem.Caption = cLineCaption) then
        begin
            Height := 26; // 34;
            Width := Width + 32;
        end;
    end;
end;

function TfrmIconClassic.GetDrawBuffer: TBitmap;
begin
    if not Assigned(FDrawBuffer) then
        FDrawBuffer := TBitmap.Create;
    Result := FDrawBuffer;
end;

procedure TfrmIconClassic.pmFileMeasureMenuItem(Sender: TObject;
  AMenuItem: TMenuItem; ACanvas: TCanvas; var Width, Height: Integer;
  ABarVisible: Boolean; var DefaultMeasure: Boolean);
begin
    if (GetMenuBarMenusIntf(TMenu(Sender)).UseMenuStyle = msWindowsXP) then
        Height := Height + 2;
end;

procedure TfrmIconClassic.actCaptureDesktopExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.CaptureDesktop;
end;

procedure TfrmIconClassic.actCaptureMultDesktopExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.CaptureWholeDesktop;
end;

procedure TfrmIconClassic.actCaptureSelectAreaExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.CaptureSelection;
end;

procedure TfrmIconClassic.actCaptureSelectAreaConfigExecute(
  Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.CaptureSpecificSizeSelection;
end;

procedure TfrmIconClassic.actCaptureFreeHandExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.CapturePolygon;
end;

procedure TfrmIconClassic.actCaptureActiveWindowExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.CaptureActiveWindow;
end;

procedure TfrmIconClassic.actCaptureIconExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.CaptureIcon;
end;

procedure TfrmIconClassic.actCaptureObjectExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.CaptureObject;
end;

procedure TfrmIconClassic.actMaskRectangleExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.DrawClipRectangle;
end;

procedure TfrmIconClassic.actMaskCircleExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.DrawClipEllipse;
end;

procedure TfrmIconClassic.actMaskFreeHandExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.DrawClipPencil;
end;

procedure TfrmIconClassic.actMaskPolygonExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.DrawClipPolygon;
end;

procedure TfrmIconClassic.actMaskModeNormalExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.ClipModes := cmRGN_AND;
end;

procedure TfrmIconClassic.actMaskModeAddExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.ClipModes := cmRGN_OR;
end;

procedure TfrmIconClassic.actMaskModeSubExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.ClipModes := cmRGN_DIFF;
end;

procedure TfrmIconClassic.actMaskClearExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.ClearClips;
end;

procedure TfrmIconClassic.OnSelectedShape(Sender: TObject;
  AShape: TmccsShape);
begin
    ImgViewIcon.Picture.Assign(TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.BitmapBackground);
    ImgViewIcon.Invalidate;
end;

procedure TfrmIconClassic.acToolSelectExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.DrawSelect;
end;

procedure TfrmIconClassic.acToolSelect2Execute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.DrawSelect;
end;

procedure TfrmIconClassic.acToolPencilExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.DrawPencil;
end;

procedure TfrmIconClassic.acToolPaintExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.DrawBrush(MccsPaletteColor1.ForegroundColor, True);
end;

procedure TfrmIconClassic.acToolLineExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.DrawLine;
end;

procedure TfrmIconClassic.acToolRectangleExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.DrawRectangle;
end;

procedure TfrmIconClassic.acToolElipseExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.DrawEllipse;
end;

procedure TfrmIconClassic.acToolPolygonExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.DrawPolygon;
end;

procedure TfrmIconClassic.acToolLabelExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.DrawLabel;
end;

procedure TfrmIconClassic.acToolArcExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.DrawArc;
end;

procedure TfrmIconClassic.acToolDropsExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.DrawDrop;
end;

procedure TfrmIconClassic.acToolPieExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.DrawPie;
end;

procedure TfrmIconClassic.acToolRectRoundExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.DrawRoundRect;
end;

procedure TfrmIconClassic.acToolChordExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.DrawChord;
end;

procedure TfrmIconClassic.cbxGalleryChange(Sender: TObject);
begin
    mccsIconGrid.IconImageList.Clear;
    mccsIconGrid.FileNames.Clear;
    case TComboBox(Sender).ItemIndex of
        0: mccsIconGrid.FileNames.Add(GetApplicationPath + 'icl\Road.icl');
        1: mccsIconGrid.FileNames.Add(GetApplicationPath + 'icl\HouseItems.icl');
        2: mccsIconGrid.FileNames.Add(GetApplicationPath + 'icl\Arrows.icl');
        3: mccsIconGrid.FileNames.Add(GetApplicationPath + 'icl\AMC.icl');
        4: mccsIconGrid.FileNames.Add(GetApplicationPath + 'icl\BeOS.icl');
        5: mccsIconGrid.FileNames.Add(GetApplicationPath + 'icl\BigGreen.icl');
        6: mccsIconGrid.FileNames.Add(GetApplicationPath + 'icl\Gnome.icl');
        7: mccsIconGrid.FileNames.Add(GetApplicationPath + 'icl\KDE32.icl');
        8: mccsIconGrid.FileNames.Add(GetApplicationPath + 'icl\KDE48.icl');
        9: mccsIconGrid.FileNames.Add(GetApplicationPath + 'icl\Mac OS7.icl');
        10: mccsIconGrid.FileNames.Add(GetApplicationPath + 'icl\Mac OS8.icl');
        11: mccsIconGrid.FileNames.Add(GetApplicationPath + 'icl\Mac OSX.icl');
        12: mccsIconGrid.FileNames.Add(GetApplicationPath + 'icl\Next32.icl');
        13: mccsIconGrid.FileNames.Add(GetApplicationPath + 'icl\Next48.icl');
        14: mccsIconGrid.FileNames.Add(GetApplicationPath + 'icl\Office2000.icl');
        15: mccsIconGrid.FileNames.Add(GetApplicationPath + 'icl\XP.icl');
        16: mccsIconGrid.FileNames.Add(GetApplicationPath + 'icl\ZIP.icl');
    end;
end;

function TfrmIconClassic.GetApplicationPath: String;
begin
    Result := TmccsCommons.GetApplicationPath;
end;

procedure TfrmIconClassic.acEffectGradientExecute(Sender: TObject);
var
    I, J: Integer;
    mvpbs: TmccsViewPaintBoxShapes;
begin
    mvpbs := nil;
    mvpbs := TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes;
    if Assigned(mvpbs) then
    begin
        with mvpbs.GradientDialog do
        begin
            // Obter cores para o DialogGradient
            for I := 0 to Pred(mvpbs.LayersContainer.Count) do
            begin
                for J := 0 to Pred(mvpbs.LayersContainer.Items[I].Shapes.Count) do
                begin
                    if (mvpbs.LayersContainer.Items[I].Shapes.Items[J].Selected) then
                    begin
                        FromColor := mvpbs.LayersContainer.Items[I].Shapes.Items[J].Gradient.GradientColors.FromColor;
                        ToColor :=  mvpbs.LayersContainer.Items[I].Shapes.Items[J].Gradient.GradientColors.ToColor;
                        GradientDirection := mvpbs.LayersContainer.Items[I].Shapes.Items[J].Gradient.GradientDirection;
                        Break;
                    end;
                end;
            end;

            if Execute then
            begin
                for I := 0 to Pred(mvpbs.LayersContainer.Count) do
                begin
                    for J := 0 to Pred(mvpbs.LayersContainer.Items[I].Shapes.Count) do
                    begin
                        if (mvpbs.LayersContainer.Items[I].Shapes.Items[J].Selected) then
                        begin
                            mvpbs.LayersContainer.Items[I].Shapes.Items[J].Gradient.GradientDirection := GradientDirection;
                            mvpbs.LayersContainer.Items[I].Shapes.Items[J].Gradient.Visible := (GradientDirection <> dNone);
                            mvpbs.LayersContainer.Items[I].Shapes.Items[J].Gradient.GradientColors.FromColor := FromColor;
                            mvpbs.LayersContainer.Items[I].Shapes.Items[J].Gradient.GradientColors.ToColor := ToColor;
                            mvpbs.ForcePaint;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

procedure TfrmIconClassic.acEffectEffectExecute(Sender: TObject);
var
    I, J: Integer;
    mvpbs: TmccsViewPaintBoxShapes;
begin
    mvpbs := nil;
    mvpbs := TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes;
    if Assigned(mvpbs) then
    begin
        with mvpbs.FilterDialog do
        begin
            for I := 0 to Pred(mvpbs.LayersContainer.Count) do
            begin
                for J := 0 to Pred(mvpbs.LayersContainer.Items[I].Shapes.Count) do
                begin
                    if (mvpbs.LayersContainer.Items[I].Shapes.Items[J].Selected) then
                    begin
                        if Execute(mvpbs.LayersContainer.Items[I].Shapes.Items[J].Bitmap) then
                        begin
                            mvpbs.LayersContainer.Items[I].Shapes.Items[J].Picture.Bitmap.Assign(mvpbs.FilterDialog.BitmapResult);
                            mvpbs.ForcePaint;
                        end;
                        Break;
                    end;
                end;
            end;
        end;
    end;
end;

procedure TfrmIconClassic.acZoom100Execute(Sender: TObject);
begin
   TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.PixelSize := 1;
   sbtnZoom.Caption := TAction(Sender).Caption;
   TAction(Sender).Checked := True;
   ResizeView;
end;

procedure TfrmIconClassic.acZoom200Execute(Sender: TObject);
begin
   TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.PixelSize := 2;
   sbtnZoom.Caption := TAction(Sender).Caption;
   TAction(Sender).Checked := True;
   ResizeView;
end;

procedure TfrmIconClassic.acZoom400Execute(Sender: TObject);
begin
   TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.PixelSize := 4;
   sbtnZoom.Caption := TAction(Sender).Caption;
   TAction(Sender).Checked := True;
   ResizeView;
end;

procedure TfrmIconClassic.acZoom800Execute(Sender: TObject);
begin
   TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.PixelSize := 8;
   sbtnZoom.Caption := TAction(Sender).Caption;
   TAction(Sender).Checked := True;
   ResizeView;
end;

procedure TfrmIconClassic.acZoom1600Execute(Sender: TObject);
begin
   TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.PixelSize := 16;
   sbtnZoom.Caption := TAction(Sender).Caption;
   TAction(Sender).Checked := True;
   ResizeView;
end;

procedure TfrmIconClassic.acZoom3200Execute(Sender: TObject);
begin
   TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.PixelSize := 32;
   sbtnZoom.Caption := TAction(Sender).Caption;
   TAction(Sender).Checked := True;
   ResizeView;
end;

procedure TfrmIconClassic.acZoom6400Execute(Sender: TObject);
begin
   TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.PixelSize := 64;
   sbtnZoom.Caption := TAction(Sender).Caption;
   TAction(Sender).Checked := True;
   ResizeView;
end;

procedure TfrmIconClassic.acZoomCustomExecute(Sender: TObject);
var
    sPixel: String;
begin
    sPixel := IntToStr(TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.PixelSize);
    InputQuery('Valor do ponto',
        'Digite na caixa de texto abaixo o novo valor do ponto ' +
        'da grade.',
        sPixel);
    try
        if (StrToInt(sPixel) < 1) then
            sPixel := '1';
        if (StrToInt(sPixel) > 20) then
            sPixel := '20';

        with TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes do
        begin
            PixelSize := StrToInt(sPixel);
            sbtnZoom.Caption := IntToStr(StrToInt(sPixel) * 100) + '%';
        end;

        TAction(Sender).Checked := True;
        ResizeView;
    except
        with TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes do
        begin
            PixelSize := 8;
            sbtnZoom.Caption := '800%';
            ResizeView;
        end;
    end;
end;

procedure TfrmIconClassic.acBits1Execute(Sender: TObject);
begin
    icBit := ic1Bit;
    sbtnBits.Caption := TAction(Sender).Caption;
    TAction(Sender).Checked := True;
end;

procedure TfrmIconClassic.acBits4Execute(Sender: TObject);
begin
    icBit := ic4Bit;
    sbtnBits.Caption := TAction(Sender).Caption;
    TAction(Sender).Checked := True;
end;

procedure TfrmIconClassic.acBits8Execute(Sender: TObject);
begin
    icBit := ic8Bit;
    sbtnBits.Caption := TAction(Sender).Caption;
    TAction(Sender).Checked := True;
end;

procedure TfrmIconClassic.acBits16Execute(Sender: TObject);
begin
    icBit := ic16Bit;
    sbtnBits.Caption := TAction(Sender).Caption;
    TAction(Sender).Checked := True;
end;

procedure TfrmIconClassic.acBits24Execute(Sender: TObject);
begin
    icBit := ic24Bit;
    sbtnBits.Caption := TAction(Sender).Caption;
    TAction(Sender).Checked := True;
end;

procedure TfrmIconClassic.acBits32Execute(Sender: TObject);
begin
    icBit := ic32Bit;
    sbtnBits.Caption := TAction(Sender).Caption;
    TAction(Sender).Checked := True;
end;

procedure TfrmIconClassic.MenuItem61Click(Sender: TObject);
begin
    try
        cxDesktop.ActivePage.Destroy;
    except
    end;
end;

procedure TfrmIconClassic.MenuItem60Click(Sender: TObject);
begin
    try
        cxIconesDiversos.ActivePage.Destroy;
        if (cxIconesDiversos.PageCount < 1) then
            cxIconesDiversos.Visible := False;
    except
    end;
end;

procedure TfrmIconClassic.acFileSaveExecute(Sender: TObject);
type
    TRGBQuadArray = array[Word] of TRGBQuad;
    PRGBQuadArray = ^TRGBQuadArray;

    procedure RGBQuad(ABitmap: TBitmap);
    var
        RowQ: PRGBQuadArray;
        i, j: Integer;
    begin
        for j := 0 to Pred(ABitmap.Height) do
        begin
            RowQ := ABitmap.ScanLine[j];

            for i := 0 to Pred(ABitmap.Width) do
            begin
                RowQ[i].rgbReserved := tckbOpacity.Position;
{    Acredito ser somente para leitura!!!
                RowQ[i].rgbBlue := RowQ[i].rgbBlue * RowQ[i].rgbReserved div 255;
                RowQ[i].rgbGreen := RowQ[i].rgbGreen * RowQ[i].rgbReserved div 255;
                RowQ[i].rgbRed := RowQ[i].rgbRed * RowQ[i].rgbReserved div 255;
}
            end;
        end;
    end;

var
    jv: TIconConvert;
    NewBitmap: TBitmap;
    I, J: Integer;
begin
    if not Spd.Execute then
        Exit;

    NewBitmap := TBitmap.Create;
    try
        NewBitmap.Assign(TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.BitmapBackground);

        if (icBit = ic32Bit) then
        begin
            NewBitmap.PixelFormat := pf32bit;
            RGBQuad(NewBitmap);
        end;

        for I := 0 to Pred(NewBitmap.Width) do
            for J := 0 to Pred(NewBitmap.Height) do
            begin
                if (NewBitmap.Canvas.Pixels[I, J] = RGB(255, 254, 255)) then
                    NewBitmap.Canvas.Pixels[I, J] := RGB(250, 0, 250); // Transparência
                if ((NewBitmap.Canvas.Pixels[I, J] = RGB(255, 255, 255)) and (icBit = ic24bit)) then
                    NewBitmap.Canvas.Pixels[I, J] := RGB(255, 255, 254);
                if ((NewBitmap.Canvas.Pixels[I, J] = RGB(0, 0, 0)) and (icBit = ic24bit)) then
                    NewBitmap.Canvas.Pixels[I, J] := RGB(0, 0, 1);
            end;
        if ExtractFileExt(Spd.FileName)  = '.bmp' then
        begin
            NewBitmap.SaveToFile(Spd.FileName);
        end
        else
        begin
            jv := TIconConvert.Create(Self);
            jv.SaveAsIcon(NewBitmap, Spd.FileName, icBit);
            jv.Free;
        end;
    finally
        FreeAndNil(NewBitmap);
    end;
end;

procedure TfrmIconClassic.acFileSaveListExecute(Sender: TObject);
type
    TRGBQuadArray = array[Word] of TRGBQuad;
    PRGBQuadArray = ^TRGBQuadArray;

    procedure RGBQuad(ABitmap: TBitmap);
    var
        RowQ: PRGBQuadArray;
        i, j: Integer;
    begin
        for j := 0 to Pred(ABitmap.Height) do
        begin
            RowQ := ABitmap.ScanLine[j];

            for i := 0 to Pred(ABitmap.Width) do
            begin
                RowQ[i].rgbReserved := tckbOpacity.Position;
{    Acredito ser somente para leitura!!!
                RowQ[i].rgbBlue := RowQ[i].rgbBlue * RowQ[i].rgbReserved div 255;
                RowQ[i].rgbGreen := RowQ[i].rgbGreen * RowQ[i].rgbReserved div 255;
                RowQ[i].rgbRed := RowQ[i].rgbRed * RowQ[i].rgbReserved div 255;
}
            end;
        end;
    end;

var
    jv: TIconConvert;
    ArrNewBitmap: array of TBitmap;
    I, J, C: Integer;
begin
    if not Spd.Execute then
        Exit;

    SetLength(ArrNewBitmap, cxDesktop.PageCount-1); //-1 é a página web

    try
        for C := Low(ArrNewBitmap) to High(ArrNewBitmap) do
        begin
            ArrNewBitmap[C] := TBitmap.Create;

            ArrNewBitmap[C].Assign(TcxTabSheet(cxDesktop.Pages[C+1]).mccsViewPaintBoxShapes.BitmapBackground); //+1 é a página web
            ArrNewBitmap[C].PixelFormat := pf32bit;

            RGBQuad(ArrNewBitmap[C]);

            for I := 0 to Pred(ArrNewBitmap[C].Width) do
                for J := 0 to Pred(ArrNewBitmap[C].Height) do
                begin
                    if (ArrNewBitmap[C].Canvas.Pixels[I, J] = RGB(255, 254, 255)) then
                        ArrNewBitmap[C].Canvas.Pixels[I, J] := RGB(250, 0, 250); // Transparência
                    if ((ArrNewBitmap[C].Canvas.Pixels[I, J] = RGB(255, 255, 255)) and (icBit = ic24bit)) then
                        ArrNewBitmap[C].Canvas.Pixels[I, J] := RGB(255, 255, 254);
                    if ((ArrNewBitmap[C].Canvas.Pixels[I, J] = RGB(0, 0, 0)) and (icBit = ic24bit)) then
                        ArrNewBitmap[C].Canvas.Pixels[I, J] := RGB(0, 0, 1);
                end;
        end;
        jv := TIconConvert.Create(Self);
        jv.SaveAsIcons(ArrNewBitmap, Spd.FileName, icBit);
        jv.Free;
    finally
        for C := Low(ArrNewBitmap) to High(ArrNewBitmap) do
            FreeAndNil(ArrNewBitmap[C]);
    end;
end;

procedure TfrmIconClassic.acFileNewExecute(Sender: TObject);
var
    lfic_Temp: TFileIcon;
begin
    lfic_Temp := TFileIcon.Create;
    try
        lfic_Temp.FileName := '';
        lfic_Temp.PathFileName := '';
        lfic_Temp.IndexInFile := -1;
        lfic_Temp.Category := '';
        lfic_Temp.Icon := nil;
        OnDblClickSelectIcon(Sender, -1, lfic_Temp, nil, nil, nil);
    finally
        FreeAndNil(lfic_Temp);
    end;
end;



// WEB BROWSER - INÍCIO ********************************************************

procedure TfrmIconClassic.URLsClick(Sender: TObject);
begin
  FindAddress;
end;

procedure TfrmIconClassic.URLsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Return then
  begin
    FindAddress;
  end;
end;

procedure TfrmIconClassic.WebBrowser1BeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var
  NewIndex: Integer;
begin
  if (HistoryList.Count > 0) then
  begin
      NewIndex := HistoryList.IndexOf(URL);
      if NewIndex = -1 then
      begin
        { Remove entries in HistoryList between last address and current address }
        if (HistoryIndex >= 0) and (HistoryIndex < HistoryList.Count - 1) then
          while HistoryList.Count > HistoryIndex do
            HistoryList.Delete(HistoryIndex);
        HistoryIndex := HistoryList.Add(URL);
      end
      else
        HistoryIndex := NewIndex;
      if UpdateCombo then
      begin
        UpdateCombo := False;
        NewIndex := URLs.Items.IndexOf(URL);
        if NewIndex = -1 then
          URLs.Items.Insert(0, URL)
        else
          URLs.Items.Move(NewIndex, 0);
      end;
      URLs.Text := URL;
      Statusbar1.Panels[0].Text := URL;
  end;
end;

procedure TfrmIconClassic.WebBrowser1DownloadBegin(Sender: TObject);
begin
  { Turn the stop button dark red }
//  StopBtn.ImageIndex := 4;
end;

procedure TfrmIconClassic.WebBrowser1DownloadComplete(Sender: TObject);
begin
  { Turn the stop button grey }
//  StopBtn.ImageIndex := 2;
end;

procedure TfrmIconClassic.FindAddress;
var
  Flags: OLEVariant;
begin
  Flags := 0;
  UpdateCombo := True;
  WebBrowser1.Navigate(WideString(Urls.Text), Flags, Flags, Flags, Flags);
end;

procedure TfrmIconClassic.HomePageRequest(var message: tmessage);
begin
  URLs.Text := 'http://www.swsolucoestecnologicas.com.br';//'http://www.todosicones.com.br';
  FindAddress;
end;

procedure TfrmIconClassic.RxSpeedButton33Click(Sender: TObject);
begin
  URLs.Text := HistoryList[HistoryIndex - 1];
  FindAddress;
end;

procedure TfrmIconClassic.RxSpeedButton34Click(Sender: TObject);
begin
  URLs.Text := HistoryList[HistoryIndex + 1];
  FindAddress;
end;

procedure TfrmIconClassic.RxSpeedButton35Click(Sender: TObject);
begin
  WebBrowser1.Stop;
end;

procedure TfrmIconClassic.RxSpeedButton36Click(Sender: TObject);
begin
  FindAddress;
end;


// WEB BROWSER - FIM ***********************************************************


procedure TfrmIconClassic.acEditCutExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.CopyShape;
end;

procedure TfrmIconClassic.acEditCopyExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.CopyShape;
end;

procedure TfrmIconClassic.acEditPasteExecute(Sender: TObject);
begin
    TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.PasteShape;
end;

procedure TfrmIconClassic.acViewTestIconExecute(Sender: TObject);
begin
    TestarIcone(Self, TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.BitmapBackground);
end;

procedure TfrmIconClassic.acViewExtensionExecute(Sender: TObject);
begin
    ShellExtensao(Self);
end;

procedure TfrmIconClassic.rxBtnSairClick(Sender: TObject);
begin
    Close;
end;

procedure TfrmIconClassic.sbtnOcultarMenuClick(Sender: TObject);
begin
  if pnlLeft.Visible then
  begin
    pnlLeft.Visible := False;
    ResizeView;
  end;
end;

procedure TfrmIconClassic.sbtnExibirMenuClick(Sender: TObject);
begin
  if not pnlLeft.Visible then
  begin
    pnlLeft.Visible := True;
    ResizeView;
  end;
end;

procedure TfrmIconClassic.ResizeView;
var
    Wv, Hv, // View
    Ws, Hs: Integer; // Scroll
    mvpbs: TmccsViewPaintBoxShapes;
begin
    mvpbs := nil;
    mvpbs := TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes;
    if Assigned(mvpbs) and (mvpbs.Parent is TScrollBox) then
    begin
        Wv := ((mvpbs.Page.Layer.Width * mvpbs.PixelSize) + mvpbs.Indent);
        Hv := ((mvpbs.Page.Layer.Height * mvpbs.PixelSize) + mvpbs.Indent);
        Ws := TScrollBox(mvpbs.Parent).Width;
        Hs := TScrollBox(mvpbs.Parent).Height;

        // Configuração o mccsViewPaintBoxShapes
        if (Wv > Ws) or (Hv > Hs) then
        begin
            mvpbs.Align := alNone;
            if (Wv > Ws) then
                mvpbs.Width := Wv
            else
                mvpbs.Width := Ws;
            if (Hv > Hs) then
                mvpbs.Height := Hv
            else
                mvpbs.Height := Hs;
        end
        else
            mvpbs.Align := alClient;
    end;
end;

procedure TfrmIconClassic.FormResize(Sender: TObject);
begin
    ResizeView;
end;

procedure TfrmIconClassic.cbxExtensionChange(Sender: TObject);
begin
    case cbxExtension.ItemIndex of
        0: begin
               strExt := '.dll';
               efExt := EFdll;
           end;
        1: begin
               strExt := '.exe';
               efExt := EFexe;
           end;
        2: begin
               strExt := '.ico';
               efExt := EFico;
           end;
        3: begin
               strExt := '.ocx';
               efExt := EFocx;
           end;
        4: begin
               strExt := '.bmp';
               efExt := EFbmp;
           end;
        5: begin
               strExt := '.icl';
               efExt := EFicl;
           end;
        6: begin
               strExt := '.scr';
               efExt := EFscr;
           end;
    end;
end;

procedure TfrmIconClassic.sbtnSelectDirectorySearchClick(Sender: TObject);
var
  strFolder: String;
begin
  strFolder := SelectFolder(Handle, 'Selecione a pasta desejada:');
  if strFolder <> '' then
  begin
    if Copy(strFolder, Length(strFolder), Length(strFolder)) <> '\' then
    begin
      strFolder := strFolder + '\';
    end;
    strPath := strFolder;
    edtPesquisa.Text := strPath;
  end;
end;

procedure TfrmIconClassic.sbtnPesquisarClick(Sender: TObject);
var
    lcxts_Temp: TcxTabSheet;
begin
    dxTabDiversos.AutoHide := False;
    cxIconesDiversos.Visible := True;
    lcxts_Temp := TcxTabSheet.Create(cxIconesDiversos);
    try
        lcxts_Temp.Parent := cxIconesDiversos;
        lcxts_Temp.PageControl := cxIconesDiversos;
        lcxts_Temp.Color := $00E9E9E9;
        lcxts_Temp.ImageIndex := 0;
        lcxts_Temp.PopupMenu := pmCloseTabIcons;
        Randomize;
        lcxts_Temp.Name := 'lcxts_Temp_' + IntToStr(Random(High(Integer)));
        lcxts_Temp.Caption := 'Pesquisar: ''' + strExt + '''';
        cxIconesDiversos.ActivePage := lcxts_Temp;

        with TmccsResearchIcons.Create(lcxts_Temp) do
        begin
            Parent := lcxts_Temp;
            Align := alClient;
            Color := $00E9E9E9;
            Ext := efExt;
            Path := strPath;
            Compare := CheckBox1.Checked;
            OnDblClick := OnDblClickSelectIcon;
            OnClick := OnClickSelectIcon;
            Pesquisar;
        end;
    except
        FreeAndNil(lcxts_Temp);
    end;
end;

procedure TfrmIconClassic.pnlCaptureIEMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    fDraggingCaptureIE := True;
    XStart := X;
    YStart := Y;
end;

procedure TfrmIconClassic.pnlCaptureIEMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
    R: TRect;
begin
    if fDraggingCaptureIE then
    begin
        pnlCaptureIE.Paint;
        pnlCaptureIE.Brush.Style := bsClear;
        pnlCaptureIE.Canvas.Brush.Style := bsClear;
        pnlCaptureIE.Canvas.Brush.Color := clFuchsia;
        pnlCaptureIE.Canvas.Pen.Width := 1;
        pnlCaptureIE.Canvas.Pen.Style := psDot;
        pnlCaptureIE.Canvas.Pen.Mode := pmCopy;
        pnlCaptureIE.Canvas.Pen.Color := clFuchsia;
        R := Rect(XStart, YStart, X, Y);
        TmccsCommons.NormRect(R);
//        pnlCaptureIE.Canvas.Rectangle(R);
        pnlCaptureIE.Canvas.DrawFocusRect(R);
    end;
    Screen.Cursor := crCross;
    DrawZoomRegion(imgCaptureZoom);
end;

procedure TfrmIconClassic.pnlCaptureIEMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    lfic_Temp: TFileIcon;
    ScreenDC: HDC;
    Bit: TBitmap;
    R: TRect;
begin
    if fDraggingCaptureIE then
    begin
        fDraggingCaptureIE := False;
        Bit := TBitmap.Create;
        try
            Bit.PixelFormat := pf24bit;

            R := Rect(XStart, YStart, X, Y);
            TmccsCommons.NormRect(R);

            Bit.Width := (R.Right - R.Left);
            Bit.Height := (R.Bottom - R.Top);

            pnlCaptureIE.Paint; // Força a atualização para retirada do DrawFocus
            ScreenDC := GetDC(pnlCaptureIE.Handle);

            BitBlt(Bit.Canvas.Handle, 0, 0, R.Right, R.Bottom, ScreenDC,
                   R.Left, R.Top, srcCopy);

            pnlCaptureIE.SendToBack;

            lfic_Temp := TFileIcon.Create;
            try
                lfic_Temp.FileName := '';
                lfic_Temp.PathFileName := '';
                lfic_Temp.IndexInFile := -1;
                lfic_Temp.Category := '';
                lfic_Temp.Icon := nil;
                OnDblClickSelectIcon(acFileNew, -1, lfic_Temp, nil, nil, Bit);
            finally
                FreeAndNil(lfic_Temp);
            end;

        finally
            ReleaseDC(pnlCaptureIE.Handle, ScreenDC);
            FreeAndNil(Bit);
            Screen.Cursor := crDefault;
        end;
    end;
end;

procedure TfrmIconClassic.DrawZoomRegion(Dest: TImage);
const
    Zoom = 4;
var
    DesktopCanvas: TCanvas;
    SelRect, DestRect: TRect;
    ZoomX, ZoomY: Integer;
    MousePos,
    MiddlePos: TPoint;
    BMP: TBitMap;
begin
    BMP := TBitmap.Create;
    DesktopCanvas := TCanvas.Create;
    try
        GetCursorPos(MousePos); // Gets mouse position
        MiddlePos := Point((Dest.Width div 2), (Dest.Height div 2));

        DesktopCanvas.Handle := GetWindowDC(GetDesktopWindow);  // Get Desktop DC

        ZoomX  := (Dest.Width div Zoom) div 2; // Comppute X Zoom
        ZoomY  := (Dest.Height div Zoom) div 2;// Comppute Y Zoom

        // Calculate Selected region rect, with zoom influence
        SelRect := Rect(MousePos.X - ZoomX, MousePos.Y - ZoomY,
                        MousePos.X + ZoomX, MousePos.Y + ZoomY);

        // Claculate Destination rect (without an external border of 1 pixel)
        DestRect := Rect(1, 1, Dest.Width - 1, Dest.Height - 1);

        BMP.Height := Dest.Height;
        BMP.Width := Dest.Width;
        BMP.Canvas.Pen.Style := psSolid;
        BMP.Canvas.Pen.Color  := clBlack;
        BMP.Canvas.Rectangle(0, 0, Dest.Width, Dest.Height);    // Draw 1pt border
        BMP.Canvas.CopyRect(DestRect, DesktopCanvas, SelRect); // Draw Magnified picture

        // Draw Cross
        BMP.Canvas.Pen.Mode := pmXor;
        BMP.Canvas.Pen.Color  := clWhite;
        BMP.Canvas.MoveTo(MiddlePos.X - 10, MiddlePos.Y);
        BMP.Canvas.LineTo(MiddlePos.X + 10, MiddlePos.Y);
        BMP.Canvas.MoveTo(MiddlePos.X, MiddlePos.Y - 10);
        BMP.Canvas.LineTo(MiddlePos.X, MiddlePos.Y + 10);

        Dest.Canvas.Draw(0, 0, BMP);  // Draw the bitmap on canvas
    finally
        FreeAndNil(BMP);
        DesktopCanvas.Free;
    end;
end;

procedure TfrmIconClassic.sbtnCaptureIEClick(Sender: TObject);
var
    ScreenDC: HDC;
    Bit: TBitmap;
begin
    Bit := TBitmap.Create;
    try
        Bit.PixelFormat := pf24bit;
        Bit.Width := WebBrowser1.Width;
        Bit.Height := WebBrowser1.Height;
        ScreenDC := GetDC(WebBrowser1.Handle);
        BitBlt(Bit.Canvas.Handle, 0, 0, Bit.Width, Bit.Height, ScreenDC,
               0, 0, srcCopy);
        pnlCaptureIE.Transparent := True;
        pnlCaptureIE.Background.Assign(Bit);
        pnlCaptureIE.Paint;
        pnlCaptureIE.BringToFront;
    finally
        ReleaseDC(WebBrowser1.Handle, ScreenDC);
        FreeAndNil(Bit);
    end;
end;

procedure TfrmIconClassic.sal1Click(Sender: TObject);
type
    TRGBQuadArray = array[Word] of TRGBQuad;
    PRGBQuadArray = ^TRGBQuadArray;

    procedure RGBQuad(ABitmap: TBitmap);
    var
        RowQ: PRGBQuadArray;
        i, j: Integer;
    begin
        for j := 0 to Pred(ABitmap.Height) do
        begin
            RowQ := ABitmap.ScanLine[j];

            for i := 0 to Pred(ABitmap.Width) do
            begin
                RowQ[i].rgbReserved := tckbOpacity.Position;
            end;
        end;
    end;
var
  IC: TIcoFile;
  S: TStream;
  NewBitmap: TBitmap;
  I: TIcon;
  jv: TIconConvert;
begin
    NewBitmap := TBitmap.Create;
    try
        NewBitmap.Assign(TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.BitmapBackground);

        if (icBit = ic32Bit) then
        begin
            NewBitmap.PixelFormat := pf32bit;
            RGBQuad(NewBitmap);
        end;        

        I := TIcon.Create;
        jv := TIconConvert.Create(Self);
        I := jv.CreateIcon(NewBitmap, icBit);
        jv.Free;

        S := TMemoryStream.Create;
        I.SaveToStream(S);
        S.Position := 0;

        IC := TIcoFile.Create(Self);
        IC.loadFromStream(S);

        IC.saveAsPng(0, 'c:\temp\11111.png');
        //IC.ConvertToPNG();
        {
        if Ic.IsValidAlpha(0) then
            IC.draw(0, 0, 0, I.Handle, True, True, True);
        }
        Image2.Picture.Assign(I);
    finally
        FreeAndNil(NewBitmap);
    end;
end;

procedure TfrmIconClassic.SalvarMVPBS1Click(Sender: TObject);
begin
    with sd do
    begin
        DefaultExt := '.' + TypeFileShapes;
        Filter := 'MCCS Shapes Files (*.' + TypeFileShapes + ')|*.' + TypeFileShapes;
        if Execute then
        begin
            TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.SaveToFile(FileName, '');
        end;
    end;
end;

procedure TfrmIconClassic.AbrirMVPBS1Click(Sender: TObject);
var
    Demo: Boolean;
begin
    with od do
    begin
        DefaultExt := '.' + TypeFileShapes;
        Filter := 'MCCS Shapes Files (*.' + TypeFileShapes + ')|*.' + TypeFileShapes;
        if Execute then
        begin
            TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.LoadFromFile(FileName, '', Demo);
        end;
    end;
end;

procedure TfrmIconClassic.Importar3D1Click(Sender: TObject);
var
    mvpbs: TmccsViewPaintBoxShapes;
    lishp_Temp: TmccsShape;
    lipbxs_Temp: TmccsLayer;
    lbmp_Temp: TBitmap;
begin
    lbmp_Temp := TBitmap.Create;
    try
        lbmp_Temp := f3d(Self,
                         TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.Color,
                         TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.Page.Layer.Width,
                         TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.Page.Layer.Height);
        if not Assigned(lbmp_Temp) then
            Exit;

        mvpbs := TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes;

        if (mvpbs.LayersContainer.Count <= 0) then
            lipbxs_Temp := mvpbs.LayersContainer.Add
        else
            lipbxs_Temp := mvpbs.LayersContainer.Items[0];

        lishp_Temp := lipbxs_Temp.Shapes.Add;
        lishp_Temp.Vector := '005Mccs=0,0,1,1';
        lishp_Temp.Gradient.Visible := False;
        lishp_Temp.Shadow := False;
        lishp_Temp.Left := 0;//mvpbs.Indent div mvpbs.PixelSize;
        lishp_Temp.Top := 0;//mvpbs.Indent div mvpbs.PixelSize;
        lishp_Temp.Width := TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.Page.Layer.Width;//lbmp_Temp.Width;
        lishp_Temp.Height := TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.Page.Layer.Height;//lbmp_Temp.Height;
        lishp_Temp.Pen.Width := 0;
        lishp_Temp.Pen.Style := psClear;
        lishp_Temp.Opacity := 254;

        lishp_Temp.Picture.Assign(lbmp_Temp); // Para forçar a criação do objeto BITMAP

        lishp_Temp.Stretch := True;

        mvpbs.ForcePaint;

        imgViewIcon.Picture.Assign(mvpbs.BitmapBackground);
        imgViewIcon.Picture.Bitmap.TransparentColor := RGB(255, 254, 255);
        imgViewIcon.Picture.Bitmap.TransparentMode := tmFixed;
    finally
        FreeAndNil(lbmp_Temp);
    end;
end;

procedure TfrmIconClassic.Button2Click(Sender: TObject);
begin
image2.Picture.SaveToFile('c:\temp\11111.png');
end;

procedure TfrmIconClassic.ImportarGIS1Click(Sender: TObject);
var
    mvpbs: TmccsViewPaintBoxShapes;
    lishp_Temp: TmccsShape;
    lipbxs_Temp: TmccsLayer;
    lbmp_Temp: TBitmap;
begin
    lbmp_Temp := TBitmap.Create;
    try
        lbmp_Temp := fGis(Self,
                         TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.Color,
                         TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.Page.Layer.Width,
                         TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.Page.Layer.Height);
        if not Assigned(lbmp_Temp) then
            Exit;

        mvpbs := TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes;

        if (mvpbs.LayersContainer.Count <= 0) then
            lipbxs_Temp := mvpbs.LayersContainer.Add
        else
            lipbxs_Temp := mvpbs.LayersContainer.Items[0];

        lishp_Temp := lipbxs_Temp.Shapes.Add;
        lishp_Temp.Vector := '005Mccs=0,0,1,1';
        lishp_Temp.Gradient.Visible := False;
        lishp_Temp.Shadow := False;
        lishp_Temp.Left := 0;//mvpbs.Indent div mvpbs.PixelSize;
        lishp_Temp.Top := 0;//mvpbs.Indent div mvpbs.PixelSize;
        lishp_Temp.Width := TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.Page.Layer.Width;//lbmp_Temp.Width;
        lishp_Temp.Height := TcxTabSheet(cxDesktop.ActivePage).mccsViewPaintBoxShapes.Page.Layer.Height;//lbmp_Temp.Height;
        lishp_Temp.Pen.Width := 0;
        lishp_Temp.Pen.Style := psClear;
        lishp_Temp.Opacity := 254;

        lishp_Temp.Picture.Assign(lbmp_Temp); // Para forçar a criação do objeto BITMAP

        lishp_Temp.Stretch := True;

        mvpbs.ForcePaint;

        imgViewIcon.Picture.Assign(mvpbs.BitmapBackground);
        imgViewIcon.Picture.Bitmap.TransparentColor := RGB(255, 254, 255);
        imgViewIcon.Picture.Bitmap.TransparentMode := tmFixed;
    finally
        FreeAndNil(lbmp_Temp);
    end;
end;

end.
