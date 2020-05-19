unit u3d;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Placemnt, ActnList, Menus, ImgList, ToolWin, ComCtrls, GLMisc,
  GLScene, GLWin32Viewer, GLVectorFileObjects, GLObjects, VectorGeometry,
  GLTexture, OpenGL1x, GLContext, ExtDlgs, StdCtrls, ExtCtrls, Buttons,
  GLCadencer, AsyncTimer, Spin, Misc, ThumbObject, GLBehaviours;

type
  // Hidden line shader (specific implem for the viewer, *not* generic)
  THiddenLineShader = class (TGLShader)
    private
      BackgroundColor : TColorVector;
      PassCount : Integer;
    public
      procedure DoApply(var rci : TRenderContextInfo; Sender : TObject); override;//(var rci : TRenderContextInfo); override;
      function DoUnApply(var rci : TRenderContextInfo) : Boolean; override;
  end;

  Tfrm3d = class(TForm)
    MainMenu: TMainMenu;
    ActionList: TActionList;
    ImageList: TImageList;
    ToolBar: TToolBar;
    MIFile: TMenuItem;
    ACOpen: TAction;
    ACExit: TAction;
    Open1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    ToolButton1: TToolButton;
    StatusBar: TStatusBar;
    GLSceneViewer: TGLSceneViewer;
    GLScene: TGLScene;
    MIOptions: TMenuItem;
    MIAntiAlias: TMenuItem;
    MIAADefault: TMenuItem;
    MIAA2x: TMenuItem;
    MIAA4X: TMenuItem;
    ACSaveAs: TAction;
    ACZoomIn: TAction;
    ACZoomOut: TAction;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    MIView: TMenuItem;
    ZoomIn1: TMenuItem;
    ZoomOut1: TMenuItem;
    FreeForm: TGLFreeForm;
    OpenDialog: TOpenDialog;
    GLLightSource: TGLLightSource;
    GLMaterialLibrary: TGLMaterialLibrary;
    CubeExtents: TGLCube;
    ACResetView: TAction;
    Resetview1: TMenuItem;
    ToolButton5: TToolButton;
    ACShadeSmooth: TAction;
    ACFlatShading: TAction;
    ACWireframe: TAction;
    ACHiddenLines: TAction;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    N2: TMenuItem;
    Smoothshading1: TMenuItem;
    Flatshading1: TMenuItem;
    Hiddenlines1: TMenuItem;
    Wireframe1: TMenuItem;
    ToolButton10: TToolButton;
    ACCullFace: TAction;
    Faceculling1: TMenuItem;
    N3: TMenuItem;
    MIBgColor: TMenuItem;
    ColorDialog: TColorDialog;
    MITexturing: TMenuItem;
    ACTexturing: TAction;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    OpenPictureDialog: TOpenPictureDialog;
    MIPickTexture: TMenuItem;
    DCTarget: TGLDummyCube;
    GLCamera: TGLCamera;
    DCAxis: TGLDummyCube;
    Panel1: TPanel;
    BUSnapShot: TButton;
    BURenderToBitmap: TButton;
    BUBitmapx2: TButton;
    BUBitmap600: TButton;
    BUBitmap300: TButton;
    BUViewerSnapShot: TButton;
    pnlBottom: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Bevel1: TBevel;
    GLCadencer1: TGLCadencer;
    MIAANone: TMenuItem;
    pnlViewXYZ: TPanel;
    pnlX: TPanel;
    pnlZ: TPanel;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    pnlY: TPanel;
    GLSceneViewer1: TGLSceneViewer;
    GLSceneViewer2: TGLSceneViewer;
    GLSceneViewer3: TGLSceneViewer;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    GLCameraX: TGLCamera;
    GLCameraY: TGLCamera;
    GLCameraZ: TGLCamera;
    Splitter3: TSplitter;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    pnlAnimation: TPanel;
    tmanim: TAsyncTimer;
    pnlAnimControl: TPanel;
    Panel2: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblXX: TLabel;
    lblXY: TLabel;
    lblXZ: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblYX: TLabel;
    lblYY: TLabel;
    lblYZ: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    lblZX: TLabel;
    lblZY: TLabel;
    lblZZ: TLabel;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    pnlAnimScroll: TPanel;
    pnlAnimMsg: TPanel;
    Panel9: TPanel;
    sedtCaptureAnim: TSpinEdit;
    Label4: TLabel;
    sbtnStartAnim: TSpeedButton;
    sbtnStopAnim: TSpeedButton;
    sbtnViewAnim: TSpeedButton;
    pnlView: TPanel;
    imgView: TImage;
    tmView: TTimer;
    Panel10: TPanel;
    SpeedButton2: TSpeedButton;
    Panel13: TPanel;
    sedtAnim: TSpinEdit;
    Label5: TLabel;
    cbxAnimAutomatic: TCheckBox;
    GLLightSource1: TGLLightSource;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ACAxes: TAction;
    procedure FormCreate(Sender: TObject);
    procedure ACOpenExecute(Sender: TObject);
    procedure GLSceneViewerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewerMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure GLSceneViewerMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ACZoomInExecute(Sender: TObject);
    procedure ACZoomOutExecute(Sender: TObject);
    procedure ACExitExecute(Sender: TObject);
    procedure ACShadeSmoothExecute(Sender: TObject);
    procedure GLSceneViewerBeforeRender(Sender: TObject);
    procedure MIAADefaultClick(Sender: TObject);
    procedure GLSceneViewerAfterRender(Sender: TObject);
    procedure ACResetViewExecute(Sender: TObject);
    procedure ACCullFaceExecute(Sender: TObject);
    procedure MIBgColorClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure GLMaterialLibraryTextureNeeded(Sender: TObject;
      var textureFileName: String);
    procedure ACTexturingExecute(Sender: TObject);
    procedure MIPickTextureClick(Sender: TObject);
    procedure MIFileClick(Sender: TObject);
    procedure BUViewerSnapShotClick(Sender: TObject);
    procedure BUSnapShotClick(Sender: TObject);
    procedure BURenderToBitmapClick(Sender: TObject);
    procedure BUBitmapx2Click(Sender: TObject);
    procedure BUBitmap300Click(Sender: TObject);
    procedure BUBitmap600Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure GLSceneViewer1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure GLSceneViewer2MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer2MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure GLSceneViewer3MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GLSceneViewer3MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure sbtnStartAnimClick(Sender: TObject);
    procedure sbtnStopAnimClick(Sender: TObject);
    procedure tmanimTimer(Sender: TObject);
    procedure sbtnViewAnimClick(Sender: TObject);
    procedure tmViewTimer(Sender: TObject);
    procedure sedtAnimChange(Sender: TObject);
    procedure ACAxesExecute(Sender: TObject);
  private
    { Private declarations }
    md, nthShow : Boolean;
    mx, my,
    mxx, myx,
    mxy, myy,
    mxz, myz : Integer;
    hlShader : TGLShader;
    lastFileName : String;
    lastLoadWithTextures : Boolean;
    Thumb: TThumbObject;
    ExportBitmap: TBitmap;

    ArrExportBitmap: array of TBitmap;
    CountView: Integer;

    procedure DoResetCamera;
    procedure ApplyShadeModeToMaterial(aMaterial : TGLMaterial);
    procedure ApplyShadeMode;
    procedure ApplyFSAA;
    procedure ApplyFaceCull;
    procedure ApplyBgColor;
    procedure ApplyTexturing;

    procedure DoOpen(const FileName: String);

    procedure RenderToBitmap(Scale: Single); overload;
    procedure RenderToBitmap(Scale: Single; ABitmap: TBitmap); overload;
    procedure ChangePosViewXYZ;

  public
    { Public declarations }

  end;

var
  frm3d: Tfrm3d;

function f3d(AOwner: TComponent; ABackgroundColor: TColor; AWidth, AHeight: Integer): TBitmap;

implementation

{$R *.dfm}

uses GLFileObj, KeyBoard, GraphicEx, Registry,
     // Exibir a imagem bitmap
     GLFile3DS, GLFileB3D, GLFileGL2, GLFileGTS, GLFileLWO, GLFileMD2, GLFileMD3,
     GLFileMD5, GLFileMDC, GLFileMS3D, GLFileNMF, GLFileNurbs, GLFileOCT, GLFilePLY,
     GLFileQ3BSP, GLFileSMD, GLFileSTL, GLFileTIN, GLFileVRML, 
     Jpeg, GLCrossPlatform, GLGraphics;


function f3d(AOwner: TComponent; ABackgroundColor: TColor; AWidth, AHeight: Integer): TBitmap;
var
  Hd, Wd: Double;
  H, W: Integer;
begin
  if (TWinControl(AOwner).FindComponent('frm3d') <> nil) then
    Exit;

  with Tfrm3d.Create(AOwner) do
  begin
    GLSceneViewer.Buffer.BackgroundColor := ABackgroundColor;
    if (ShowModal = mrOk) then
    begin
        Wd := (((ExportBitmap.Width / AWidth) * 100) / AWidth);
        Hd := (((ExportBitmap.Height / AHeight) * 100) / AHeight);

        W := Ceil(Wd);
        H := Ceil(Hd);

        W := ExportBitmap.Width;
        H := ExportBitmap.Height;

        Result := TBitmap.Create;
        Result.Width := W;
        Result.Height := H;
        Result.PixelFormat := pf24bit;

        Result.Canvas.CopyRect(Rect(0, 0, W, H),
            ExportBitmap.Canvas,
            Rect(0, 0, ExportBitmap.Width, ExportBitmap.Height));
        //Result.Assign(ExportBitmap);
    end
    else
      Result := nil;
  end;
end;

{ THiddenLineShader }

procedure THiddenLineShader.DoApply(var rci : TRenderContextInfo; Sender : TObject);//(var rci : TRenderContextInfo);
begin
   PassCount:=1;
   rci.GLStates.SetGLPolygonMode(GL_FRONT_AND_BACK, GL_FILL);
   glPushAttrib(GL_CURRENT_BIT+GL_ENABLE_BIT);
   glColor3fv(@BackgroundColor);
   glDisable(GL_TEXTURE_2D);
   glEnable(GL_POLYGON_OFFSET_FILL);
   glPolygonOffset(1, 2);
end;

function THiddenLineShader.DoUnApply(var rci : TRenderContextInfo) : Boolean;
begin
   case PassCount of
      1 : begin
         PassCount:=2;
         rci.GLStates.SetGLPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
         glPopAttrib;
         Result:=True;
      end;
      2 :  Result:=False;
   else
      // doesn't hurt to be cautious
      Assert(False);
      Result:=False;
   end;
end;

{ Tfrm3d }

procedure Tfrm3d.FormCreate(Sender: TObject);
begin
//www.profcardy.com
   Caption := Application.Title;
   PageControl.ActivePageIndex := 0;

   CountView := 0;

   Thumb := TThumbObject.Create(pnlAnimScroll);
   Thumb.Parent := pnlAnimScroll;
   Thumb.Align := alClient;
   Thumb.MaxWidth := 90;
   Thumb.MaxHeight := 90;
   Thumb.ThumbGap := 1;
   Thumb.VertScrollBar.Visible := False;
   Thumb.ScrollMode := SMHorizontal;


   // instantiate our specific hidden-lines shader
   hlShader := THiddenLineShader.Create(Self);

   FreeForm.IgnoreMissingTextures:=True;

   ExportBitmap := TBitmap.Create;
   ExportBitmap.PixelFormat := pf24Bit;

   ChangePosViewXYZ;
end;

procedure Tfrm3d.FormShow(Sender: TObject);
var
   i : Integer;
begin
   if not nthShow then begin

      OpenDialog.Filter:=VectorFileFormatsFilter;
      with ActionList do for i:=0 to ActionCount-1 do
         if Actions[i] is TCustomAction then
            with TCustomAction(Actions[i]) do Hint:=Caption;
      ApplyFSAA;
      ApplyFaceCull;
      ApplyBgColor;

      if ParamCount>0 then
         DoOpen(ParamStr(1));

      nthShow:=True;
   end;
end;

procedure Tfrm3d.GLSceneViewerBeforeRender(Sender: TObject);
begin
   THiddenLineShader(hlShader).BackgroundColor:=ConvertWinColor(GLSceneViewer.Buffer.BackgroundColor);
{
   if not GL_ARB_multisample then begin
      MIAANone.Checked := True;
      //MIAADefault.Checked:=True;
      MIAADefault.Enabled:=False;
      MIAA2x.Enabled:=False;
      MIAA4X.Enabled:=False;
   end;
}   
end;

procedure Tfrm3d.GLSceneViewerAfterRender(Sender: TObject);
begin
   ApplyFSAA;
   Screen.Cursor:=crDefault;
end;

procedure Tfrm3d.DoResetCamera;
var
   objSize : Single;
begin
   DCTarget.Position.AsVector:=NullHmgPoint;
   GLCamera.Position.SetPoint(7, 3, 5);
   GLCameraX.Position.SetPoint(7, 0, 5);
   GLCameraY.Position.SetPoint(0, 3, 5);
   GLCameraZ.Position.SetPoint(0, 0, 5);
   FreeForm.Position.AsVector:=NullHmgPoint;
   FreeForm.Up.Assign(DCAxis.Up);
   FreeForm.Direction.Assign(DCAxis.Direction);

   objSize:=FreeForm.BoundingSphereRadius;
   if objSize>0 then
   begin
      GLCamera.AdjustDistanceToTarget(objSize*0.25);
      GLCamera.DepthOfView:=2*GLCamera.DistanceToTarget+objSize*2;
      
      GLCameraX.AdjustDistanceToTarget(objSize*0.25);
      GLCameraX.DepthOfView:=GLCamera.DepthOfView;
      GLCameraX.Position.Y := 0;
      GLCameraX.Position.Z := 0;

      GLCameraY.AdjustDistanceToTarget(objSize*0.25);
      GLCameraY.DepthOfView:=GLCamera.DepthOfView;
      GLCameraY.Position.X := 0;
      //GLCameraY.Position.Z := 0;

      GLCameraZ.AdjustDistanceToTarget(objSize*0.25);
      GLCameraZ.DepthOfView:=GLCamera.DepthOfView;
   end;
end;

procedure Tfrm3d.ApplyShadeModeToMaterial(aMaterial : TGLMaterial);
begin
   with aMaterial do begin
      if ACShadeSmooth.Checked then begin
         GLSceneViewer.Buffer.Lighting:=True;
         GLSceneViewer.Buffer.ShadeModel:=smSmooth;
         aMaterial.FrontProperties.PolygonMode:=pmFill;
         aMaterial.BackProperties.PolygonMode:=pmFill;
      end else if ACFlatShading.Checked then begin
         GLSceneViewer.Buffer.Lighting:=True;
         GLSceneViewer.Buffer.ShadeModel:=smFlat;
         aMaterial.FrontProperties.PolygonMode:=pmFill;
         aMaterial.BackProperties.PolygonMode:=pmFill;
      end else if ACHiddenLines.Checked then begin
         GLSceneViewer.Buffer.Lighting:=False;
         GLSceneViewer.Buffer.ShadeModel:=smSmooth;
         aMaterial.FrontProperties.PolygonMode:=pmLines;
         aMaterial.BackProperties.PolygonMode:=pmLines;
      end else if ACWireframe.Checked then begin
         GLSceneViewer.Buffer.Lighting:=False;
         GLSceneViewer.Buffer.ShadeModel:=smSmooth;
         aMaterial.FrontProperties.PolygonMode:=pmLines;
         aMaterial.BackProperties.PolygonMode:=pmLines;
      end;
   end;
end;

procedure Tfrm3d.ApplyShadeMode;
var
   i : Integer;
begin
   with GLMaterialLibrary.Materials do for i:=0 to Count-1 do begin
      ApplyShadeModeToMaterial(Items[i].Material);
      if ACHiddenLines.Checked then
         Items[i].Shader:=hlShader
      else Items[i].Shader:=nil;
   end;
   FreeForm.StructureChanged;
end;

procedure Tfrm3d.ApplyFSAA;
begin
   with GLSceneViewer.Buffer do begin
      if MIAADefault.Checked then
         AntiAliasing:=aaDefault
      else if MIAA2X.Checked then
         AntiAliasing:=aa2x
      else if MIAA4X.Checked then
         AntiAliasing:=aa4x
      else if MIAANone.Checked then
         AntiAliasing := aaNone;
   end;
end;

procedure Tfrm3d.ApplyFaceCull;
begin
   with GLSceneViewer.Buffer do begin
      if ACCullFace.Checked then begin
         FaceCulling:=True;
         ContextOptions:=ContextOptions-[roTwoSideLighting];
      end else begin
         FaceCulling:=False;
         ContextOptions:=ContextOptions+[roTwoSideLighting];
      end;
   end;
end;

procedure Tfrm3d.ApplyBgColor;
var
   bmp : TBitmap;
   col : TColor;
begin
   bmp:=TBitmap.Create;
   try
      bmp.Width:=16;
      bmp.Height:=16;
      col:=ColorToRGB(ColorDialog.Color);
      GLSceneViewer.Buffer.BackgroundColor:=col;
      with bmp.Canvas do begin
         Pen.Color:=col xor $FFFFFF;
         Brush.Color:=col;
         Rectangle(0, 0, 16, 16);
      end;
      MIBgColor.Bitmap:=bmp;
   finally
      bmp.Free;
   end;
end;

procedure Tfrm3d.ApplyTexturing;
var
   i : Integer;
begin
   with GLMaterialLibrary.Materials do for i:=0 to Count-1 do begin
      with Items[i].Material.Texture do begin
         if Enabled then
            Items[i].Tag:=Integer(True);
         Enabled:=Boolean(Items[i].Tag) and ACTexturing.Checked;
      end;
   end;
   FreeForm.StructureChanged;
end;

procedure Tfrm3d.DoOpen(const FileName: String);
var
   i : Integer;
   min, max : TAffineVector;
   libMat : TGLLibMaterial;
begin
   if not FileExists(fileName) then Exit;

   Screen.Cursor:=crHourGlass;

   Caption := Application.Title + ' - '+ExtractFileName(fileName);

   FreeForm.MeshObjects.Clear;
   GLMaterialLibrary.Materials.Clear;

   FreeForm.LoadFromFile(fileName);
   with GLMaterialLibrary do begin
      if Materials.Count=0 then begin
         FreeForm.Material.MaterialLibrary:=GLMaterialLibrary;
         libMat:=Materials.Add;
         FreeForm.Material.LibMaterialName:=libMat.Name;
         libMat.Material.FrontProperties.Diffuse.Red:=0;
      end;
      for i:=0 to Materials.Count-1 do
         with Materials[i].Material do BackProperties.Assign(FrontProperties);
   end;
   ApplyShadeMode;
   ApplyTexturing;

   StatusBar.Panels[0].Text:=IntToStr(FreeForm.MeshObjects.TriangleCount)+' triângulo(s)';//tris';
   StatusBar.Panels[1].Text:=fileName;
   lastFileName:=fileName;
   lastLoadWithTextures:=ACTexturing.Enabled;

   FreeForm.GetExtents(min, max);
   with CubeExtents do begin
      CubeWidth:=max[0]-min[0];
      CubeHeight:=max[1]-min[1];
      CubeDepth:=max[2]-min[2];
      Position.AsAffineVector:=VectorLerp(min, max, 0.5);
   end;

   DoResetCamera;
end;

procedure Tfrm3d.ACOpenExecute(Sender: TObject);
begin
   if OpenDialog.Execute then
      DoOpen(OpenDialog.FileName);

    ChangePosViewXYZ;      
end;

procedure Tfrm3d.GLSceneViewerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   mx:=x; my:=y;
   md:=True;

   if (sbtnStartAnim.Down) then
       tmAnim.Enabled := True;
end;

procedure Tfrm3d.GLSceneViewerMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
   d : Single;
begin
   if md and (Shift<>[]) then
   begin
      if ssLeft in Shift then
         GLCamera.MoveAroundTarget(my-y, mx-x)
      else if ssRight in Shift then
      begin
         d:=GLCamera.DistanceToTarget*0.01*(x-mx+y-my);
         if IsKeyDown('x') then
            FreeForm.Translate(d, 0, 0)
         else if IsKeyDown('y') then
            FreeForm.Translate(0, d, 0)
         else if IsKeyDown('z') then
            FreeForm.Translate(0, 0, d)
         else
         begin
             GLCamera.RotateObject(FreeForm, my-y, mx-x);
             GLCameraX.RotateObject(FreeForm, my-y, mx-x);
             GLCameraY.RotateObject(FreeForm, my-y, mx-x);
             GLCameraZ.RotateObject(FreeForm, my-y, mx-x);
         end;
      end;
      mx:=x; my:=y;
   end;
   ChangePosViewXYZ;
end;

procedure Tfrm3d.GLSceneViewerMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   md:=False;
   if tmAnim.Enabled then
   begin
       tmAnim.Enabled := False;
       pnlAnimMsg.Caption := 'Arraste o mouse para a área gráfica e movimente o objeto';
   end;
end;

procedure Tfrm3d.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
   if FreeForm.MeshObjects.Count>0 then
   begin
      GLCamera.AdjustDistanceToTarget(Power(1.05, WheelDelta/120));
      GLCamera.DepthOfView:=2*GLCamera.DistanceToTarget+2*FreeForm.BoundingSphereRadius;

      GLCameraX.AdjustDistanceToTarget(Power(1.05, WheelDelta/120));
      GLCameraX.DepthOfView:= GLCamera.DepthOfView;
      GLCameraX.Position.Y := 0;
      GLCameraX.Position.Z := 0;

      GLCameraY.AdjustDistanceToTarget(Power(1.05, WheelDelta/120));
      GLCameraY.DepthOfView:= GLCamera.DepthOfView;
      GLCameraY.Position.X := 0;
//      GLCameraY.Position.Z := 0;
      
      GLCameraZ.AdjustDistanceToTarget(Power(1.05, WheelDelta/120));
      GLCameraZ.DepthOfView:= GLCamera.DepthOfView;
   end;
   Handled:=True;
end;

procedure Tfrm3d.ACZoomInExecute(Sender: TObject);
var
   h : Boolean;
begin
   FormMouseWheel(Self, [], -120*4, Point(0, 0), h);
end;

procedure Tfrm3d.ACZoomOutExecute(Sender: TObject);
var
   h : Boolean;
begin
   FormMouseWheel(Self, [], 120*4, Point(0, 0), h);
end;

procedure Tfrm3d.ACExitExecute(Sender: TObject);
begin
   Close;
end;

procedure Tfrm3d.ACShadeSmoothExecute(Sender: TObject);
begin
   ApplyShadeMode;
end;

procedure Tfrm3d.MIAADefaultClick(Sender: TObject);
begin
   (Sender as TMenuItem).Checked:=True;
   ApplyFSAA;
end;

procedure Tfrm3d.ACResetViewExecute(Sender: TObject);
begin
   DoResetCamera;
end;

procedure Tfrm3d.ACCullFaceExecute(Sender: TObject);
begin
   ACCullFace.Checked:=not ACCullFace.Checked;
   ApplyFaceCull;
end;

procedure Tfrm3d.MIBgColorClick(Sender: TObject);
begin
   if ColorDialog.Execute then
      ApplyBgColor;
end;

procedure Tfrm3d.GLMaterialLibraryTextureNeeded(Sender: TObject;
  var textureFileName: String);
begin
   if not ACTexturing.Enabled then
      textureFileName:='';
end;

procedure Tfrm3d.ACTexturingExecute(Sender: TObject);
begin
   ACTexturing.Checked:=not ACTexturing.Checked;
   if ACTexturing.Checked then
      if lastLoadWithTextures then
         ApplyTexturing
      else begin
         DoOpen(lastFileName);
      end
   else ApplyTexturing;
end;

procedure Tfrm3d.MIFileClick(Sender: TObject);
begin
   MIPickTexture.Enabled:=(GLMaterialLibrary.Materials.Count>0);
end;

procedure Tfrm3d.MIPickTextureClick(Sender: TObject);
begin
   if OpenPictureDialog.Execute then with GLMaterialLibrary.Materials do begin
      with Items[Count-1] do begin
         Tag:=1;
         Material.Texture.Image.LoadFromFile(OpenPictureDialog.FileName);
         Material.Texture.Enabled:=True;
      end;
      ApplyTexturing;
   end;
end;












//--------------------------------------------------------------------------------


procedure Tfrm3d.RenderToBitmap(Scale: Single);
var
   bmp : TBitmap;
   pt : Int64;
   delta : Double;
begin
   pt:=StartPrecisionTimer;
   // Rendering to a bitmap requires an existing bitmap,
   // so we create and size a new one
   bmp:=TBitmap.Create;
   // Don't forget to specify a PixelFormat, or current screen pixel format
   // will be used, which may not suit your purposes!
   bmp.PixelFormat:=pf24bit;
   bmp.Width:=Round(GLSceneViewer.Width*Scale);
   bmp.Height:=Round(GLSceneViewer.Height*Scale);
   // Here we just request a render
   // The second parameter specifies DPI (Dots Per Inch), which is
   // linked to the bitmap's scaling
   // "96" is the "magic" DPI scale of the screen under windows
   GLSceneViewer.Buffer.RenderToBitmap(bmp, Round(96*Scale));
   delta:=StopPrecisionTimer(pt);

   ExportBitmap.Assign(bmp);
{
   ViewBitmap(bmp, Format('RenderToBitmap %dx%d - %.1f ms',
                          [bmp.Width, bmp.Height, delta*1000]));
}
   bmp.Free;
end;

procedure Tfrm3d.RenderToBitmap(Scale: Single; ABitmap: TBitmap);
var
    bmp: TBitmap;
begin
    bmp := TBitmap.Create;

    bmp.PixelFormat := pf24bit;
    bmp.Width := Round(GLSceneViewer.Width * Scale);
    bmp.Height := Round(GLSceneViewer.Height * Scale);

    GLSceneViewer.Buffer.RenderToBitmap(bmp, Round(96 * Scale));

    if Assigned(ABitmap) then
        ABitmap.Assign(bmp);

    bmp.Free;
end;

procedure Tfrm3d.ChangePosViewXYZ;
begin
      lblXX.Caption := FloatToStr(GLCameraX.Position.X);
      lblXY.Caption := FloatToStr(GLCameraX.Position.Y);
      lblXZ.Caption := FloatToStr(GLCameraX.Position.Z);

      lblYX.Caption := FloatToStr(GLCameraY.Position.X);
      lblYY.Caption := FloatToStr(GLCameraY.Position.Y);
      lblYZ.Caption := FloatToStr(GLCameraY.Position.Z);

      lblZX.Caption := FloatToStr(GLCameraZ.Position.X);
      lblZY.Caption := FloatToStr(GLCameraZ.Position.Y);
      lblZZ.Caption := FloatToStr(GLCameraZ.Position.Z);
end;

procedure Tfrm3d.BUViewerSnapShotClick(Sender: TObject);
var
   pt : Int64;
   bmp : TBitmap;
   delta : Double;
begin
   pt:=StartPrecisionTimer;
   // Create a snapshot directly from the viewer content
   bmp:=GLSceneViewer.CreateSnapShotBitmap;
   delta:=StopPrecisionTimer(pt);
   // Display the bitmap for the user to see and gaze in everlasting awe...
   ExportBitmap.Assign(bmp);
{
   ViewBitmap(bmp, Format('SnapShot %dx%d - %.3f ms',
                          [bmp.Width, bmp.Height, delta*1000]));
}
   // Release the bitmap
   bmp.Free;
end;

procedure Tfrm3d.BUSnapShotClick(Sender: TObject);
var
   bmp32 : TGLBitmap32;
   bmp : TBitmap;
   pt : Int64;
   delta : Double;
begin
   pt:=StartPrecisionTimer;
   // CreateSnapShot returns a TGLBitmap32, which is a low-level data buffer.
   // However TGLBitmap32 can spawn a regular TBitmap, which we use here
   bmp32:=GLSceneViewer.Buffer.CreateSnapShot;
   bmp:=bmp32.Create32BitsBitmap;
   delta:=StopPrecisionTimer(pt);
   // Display the bitmap for the user to see and gaze in everlasting awe...
   ExportBitmap.Assign(bmp);
{
   ViewBitmap(bmp, Format('SnapShot %dx%d - %.3f ms',
                          [bmp.Width, bmp.Height, delta*1000]));
}                          
   // Don't forget to free your TGLBitmap32 and TBitmap!
   bmp.Free;
   bmp32.Free;
end;

procedure Tfrm3d.BURenderToBitmapClick(Sender: TObject);
begin
   // Render at viewer resolution (scale = 1, DPI = 96)
   RenderToBitmap(1);
end;

procedure Tfrm3d.BUBitmapx2Click(Sender: TObject);
begin
   // Render at twice viewer resolution (scale = 2, DPI = 192 = 96x2)
   RenderToBitmap(2);
end;

procedure Tfrm3d.BUBitmap300Click(Sender: TObject);
begin
   // Screen is "magic" 96 dpi, this gives us our scale
   RenderToBitmap(300/96);
end;

procedure Tfrm3d.BUBitmap600Click(Sender: TObject);
begin
   // Screen is "magic" 96 dpi, this gives us our scale
   RenderToBitmap(600/96);
end;

procedure Tfrm3d.FormDestroy(Sender: TObject);
begin
    if Assigned(ExportBitmap) then
        FreeandNil(ExportBitmap);
end;

procedure Tfrm3d.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure Tfrm3d.BitBtn1Click(Sender: TObject);
var
   pt : Int64;
   bmp : TBitmap;
   delta : Double;
begin
   // Screen is "magic" 96 dpi, this gives us our scale
   RenderToBitmap(1);
   ModalResult := mrOk;
   Exit;


(*
   pt:=StartPrecisionTimer;
   // Create a snapshot directly from the viewer content
   bmp:=GLSceneViewer.CreateSnapShotBitmap;
   delta:=StopPrecisionTimer(pt);
   // Display the bitmap for the user to see and gaze in everlasting awe...
   ExportBitmap.Assign(bmp);
{
   ViewBitmap(bmp, Format('SnapShot %dx%d - %.3f ms',
                          [bmp.Width, bmp.Height, delta*1000]));
}
   // Release the bitmap
   bmp.Free;

   ModalResult := mrOk;
   *)
end;

procedure Tfrm3d.GLSceneViewer1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    mxx := x;
    myx := y;
end;

procedure Tfrm3d.GLSceneViewer1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
      if ssLeft in Shift then
         GLCameraX.MoveAroundTarget(myx-y, mxx-x);

      mxx := x;
      myx := y;

      ChangePosViewXYZ;
end;

procedure Tfrm3d.GLSceneViewer2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    mxy := x;
    myy := y;
end;

procedure Tfrm3d.GLSceneViewer2MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
      if ssLeft in Shift then
         GLCameraY.MoveAroundTarget(myy-y, mxy-x);

      mxy := x;
      myy := y;

      ChangePosViewXYZ;
end;

procedure Tfrm3d.GLSceneViewer3MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    mxz := x;
    myz := y;
end;

procedure Tfrm3d.GLSceneViewer3MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
      if ssLeft in Shift then
         GLCameraZ.MoveAroundTarget(myz-y, mxz-x);

      mxz := x;
      myz := y;

      ChangePosViewXYZ;
end;

procedure Tfrm3d.sbtnStartAnimClick(Sender: TObject);
var
    I: Integer;
    img: TImage;
begin
    for I := High(ArrExportBitmap) downto 0 do
        FreeAndNil(ArrExportBitmap[I]);

    SetLength(ArrExportBitmap, 0);

    thumb.EmptyList;
{
    for I := Pred(sbox.ComponentCount) downto 0 do
    begin
        img := TImage(sbox.Components[I]);
        FreeAndNil(img);
    end;
}
    tmAnim.Interval := sedtCaptureAnim.Value;
    sedtCaptureAnim.Enabled := False;
    pnlAnimMsg.Caption := 'Arraste o mouse para a área gráfica e movimente o objeto';

    if Assigned(DCTarget.Behaviours[0]) and (cbxAnimAutomatic.Checked) then
    begin
        if (sbtnStartAnim.Down) then
            tmAnim.Enabled := True;
        TGLBInertia(DCTarget.Behaviours[0]).TurnSpeed := 10;
    end;
end;

procedure Tfrm3d.sbtnStopAnimClick(Sender: TObject);
begin
    if Assigned(DCTarget.Behaviours[0]) and (cbxAnimAutomatic.Checked) then
    begin
        tmAnim.Enabled := False;
        TGLBInertia(DCTarget.Behaviours[0]).TurnSpeed := 0;
    end;

    if (pnlView.Visible) then
        sbtnViewAnim.OnClick(Self);

    sedtCaptureAnim.Enabled := True;
    pnlAnimMsg.Caption := '';
end;

procedure Tfrm3d.tmanimTimer(Sender: TObject);
var
    img_Temp: TImage;
    bmp: TBitmap;
begin
    pnlAnimMsg.Caption := '';

    img_Temp := TImage.Create(Self);
    img_Temp.Parent := Self;
    img_Temp.Visible := False;
    img_Temp.Anchors := [akLeft, akTop, akBottom];
    img_Temp.Height := 90;
    img_Temp.Width := 90;
    img_Temp.Top := 0;
    img_Temp.Left := 0;
    img_Temp.Proportional := True;
    img_Temp.Center := True;

    Thumb.AddFromObject(img_Temp);

    bmp := TBitmap.Create;
    try
        bmp.PixelFormat := pf24bit;
        RenderToBitmap(1, bmp);

        SetLength(ArrExportBitmap, Length(ArrExportBitmap)+1);
        ArrExportBitmap[High(ArrExportBitmap)] := TBitmap.Create;
        ArrExportBitmap[High(ArrExportBitmap)].PixelFormat := pf24Bit;
        ArrExportBitmap[High(ArrExportBitmap)].Assign(bmp);

        //img_Temp.Left := (img_Temp.Width + 2) * High(ArrExportBitmap);
        img_Temp.Picture.Assign(bmp);
    finally
        FreeAndNil(bmp);
        img_Temp.Visible := True;
    end;
end;

procedure Tfrm3d.sbtnViewAnimClick(Sender: TObject);
begin
    CountView := 0;
    pnlView.Visible := not pnlView.Visible;
    tmView.Enabled := pnlview.Visible;
end;

procedure Tfrm3d.tmViewTimer(Sender: TObject);
var
    I: Integer;
    bmp: TBitmap;
begin
    bmp := TBitmap.Create;
    try
        bmp.PixelFormat := pf24Bit;
        bmp.Width := ArrExportBitmap[CountView].Width;
        bmp.Height := ArrExportBitmap[CountView].Height;
        bmp.Assign(ArrExportBitmap[CountView]);
        imgView.Picture.Assign(bmp);
//        imgView.Invalidate;

        if (CountView = High(ArrExportBitmap)) then
            CountView := 0
        else
            inc(CountView);

        Thumb.Selected := CountView;
    finally
        FreeAndnil(bmp);
    end;
end;

procedure Tfrm3d.sedtAnimChange(Sender: TObject);
begin
    if (tmView.Enabled) then
        tmView.Interval := sedtAnim.Value;
end;

procedure Tfrm3d.ACAxesExecute(Sender: TObject);
begin
    ACAxes.Checked := not ACAxes.Checked;
    dcAxis.ShowAxes := ACAxes.Checked;
    CubeExtents.Visible := ACAxes.Checked;
    GLSceneViewer.Repaint;
end;

end.
