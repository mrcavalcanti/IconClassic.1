unit uGis;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ToolWin, ImgList, GISReadWrite, SVOLegend, ExtCtrls, GISShape,
  GISImage, Db, DBTables, Datafields, Grids, SVODataGrid, StdCtrls, Menus, Math,
  Buttons;

type
  TfrmGis = class(TForm)
    SVOGISImage1: TSVOGISImage;
    spLeft: TSplitter;
    SVOLegend: TSVOLegend;
    OpenDialog1: TOpenDialog;
    SVOGISReadWrite1: TSVOGISReadWrite;
    ImageList1: TImageList;
    ToolBar1: TToolBar;
    ToolButtonExit: TToolButton;
    ToolButton13: TToolButton;
    ToolButtonOpenGIS: TToolButton;
    ToolButtonCloseGIS: TToolButton;
    ToolButtonGrid: TToolButton;
    ToolButton11: TToolButton;
    ToolButtonDefault: TToolButton;
    ToolButtonShapeInfo: TToolButton;
    ToolButtonGrab: TToolButton;
    ToolButtonZoomIn: TToolButton;
    ToolButtonZoomOut: TToolButton;
    ToolButtonFullExtent: TToolButton;
    spRight: TSplitter;
    pnlShapeInfo: TPanel;
    pnlMain: TPanel;
    spBottom: TSplitter;
    pnlDataGrid: TPanel;
    SVODataGrid1: TSVODataGrid;
    PopupMenu1: TPopupMenu;
    BlinkShape1: TMenuItem;
    HighlightShape1: TMenuItem;
    UnhighlightShape1: TMenuItem;
    ZoomToSelection1: TMenuItem;
    Memo: TMemo;
    pnlBottom: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    procedure ToolButtonOpenGISClick(Sender: TObject);
    procedure ToolButtonCloseGISClick(Sender: TObject);
    procedure ToolButtonExitClick(Sender: TObject);
    procedure ToolButtonShapeInfoClick(Sender: TObject);
    procedure ToolButtonZoomInClick(Sender: TObject);
    procedure ToolButtonZoomOutClick(Sender: TObject);
    procedure ToolButtonGrabClick(Sender: TObject);
    procedure ToolButtonFullExtentClick(Sender: TObject);
    procedure ToolButtonDefaultClick(Sender: TObject);
    procedure SVOGISImage1ShapeID(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; var Handled: Boolean);
    procedure SVOGISReadWrite1ReadShape(Sender: TObject;
      ShapeIndex: Integer);
    procedure ZoomToSelection1Click(Sender: TObject);
    procedure HighlightShape1Click(Sender: TObject);
    procedure UnhighlightShape1Click(Sender: TObject);
    procedure BlinkShape1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SVOLegendSelectItem(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y, Index: Integer; Data: TSVOGISObject;
      Item: TlegendItem);
    procedure BitBtn1Click(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
  private
    { Private declarations }
    FCnt : Integer;
    FExportBitmap: TBitmap;
    procedure ShowShapeInfo;
  public
    { Public declarations }
  end;

var
  frmGis: TfrmGis;

function fGis(AOwner: TComponent; ABackgroundColor: TColor; AWidth, AHeight: Integer): TBitmap;  

implementation

{$R *.DFM}

function fGis(AOwner: TComponent; ABackgroundColor: TColor; AWidth, AHeight: Integer): TBitmap;
var
  Hd, Wd: Double;
  H, W: Integer;
begin
  if (TWinControl(AOwner).FindComponent('frmGis') <> nil) then
    Exit;

  with TfrmGis.Create(AOwner) do
  begin
    SVOGISImage1.Color := ABackgroundColor;
    if (ShowModal = mrOk) then
    begin        
        Wd := (((FExportBitmap.Width / AWidth) * 100) / AWidth);
        Hd := (((FExportBitmap.Height / AHeight) * 100) / AHeight);

        W := Ceil(Wd);
        H := Ceil(Hd);

        W := FExportBitmap.Width;
        H := FExportBitmap.Height;

        Result := TBitmap.Create;
        Result.Width := W;
        Result.Height := H;
        Result.PixelFormat := pf24bit;

        Result.Canvas.CopyRect(Rect(0, 0, W, H),
            FExportBitmap.Canvas,
            Rect(0, 0, FExportBitmap.Width, FExportBitmap.Height));
        //Result.Assign(FExportBitmap);
    end
    else
      Result := nil;
  end;
end;

procedure TfrmGis.ToolButtonOpenGISClick(Sender: TObject);
var
  ContinueToOpen : Boolean;
  i : Integer;
  NewShapeList : TSVOShapeList;
begin
  IF OpenDialog1.InitialDir = '' THEN
    OpenDialog1.InitialDir := ExtractFileDir(Application.ExeName);
  ContinueToOpen := True;
  IF OpenDialog1.Execute THEN BEGIN
    FCnt := 0;
    Application.ProcessMessages;
    IF ContinueToOpen THEN BEGIN
      FOR i := 0 TO OpenDialog1.Files.Count - 1 DO BEGIN
        NewShapeList := TSVOShapeList.Create;
        SVOGISReadWrite1.ShapeList := NewShapeList;
        SVOGISReadWrite1.ImportFileName := OpenDialog1.Files[i];
        SVOGISReadWrite1.ReadFile;
        IF SVOGISReadWrite1.FileType IN [sftDatabase, sftText] THEN
          Break; // Only open a sigle database or text file at one time.
      END;
      ToolButtonDefault.Down := True;
      SVOGISImage1.Mode := moDefault;
      OpenDialog1.InitialDir := ExtractFileDir(OpenDialog1.FileName);
      SVOLegend.ItemIndex := 0;
      SVOLegend.OnSelectItem(SVOLegend, mbLeft, [ssShift], 1, 1, 0, nil, liCaption);
      SVODataGrid1.Visible := True;
    END;
  END;
end;

procedure TfrmGis.SVOGISImage1ShapeID(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; var Handled: Boolean);
var
  AShapeList : TSVOShapeList;
begin
  IF Not Assigned(SVOLegend.SelectedShapes) THEN Exit; // No shape selected
  AShapeList := SVOLegend.SelectedShapes;
  ShowShapeInfo;
//  SVOGISImage1.SelectedShape.GraphicStyles.Brush.Color := clred;
//  SvoGisImage1.SelectedShape.Draw(SvoGisImage1.Canvas, SvoGisImage1.ScaleParams);
end;

procedure TfrmGis.ShowShapeInfo;
// Start Sub Procedure to add data to the memo
  procedure AddData(ShapeIndex: Integer; AShapeList: TSVOShapeList);
  var
    j : Integer;
    AField, AValue : String;
  begin
    AShapeList.DataFields.RecordNum := ShapeIndex;
    FOR j := 0 TO AShapeList.DataFields.Count - 1 DO BEGIN
      AField := AShapeList.DataFields.FieldNames[j];
      AValue := AShapeList.DataFields.Items[j].AsString;
      Memo.Lines.Add(AField + ' : ' + AValue);
    END;
    Memo.Lines.Add('');
  end;
// End Sub Procedure
var
  i, ShapeIndex : Integer;
  AShapeList: TSVOShapeList;
begin
  AShapeList := SVOGisImage1.SelectedShapeList;
  Memo.Lines.Clear;
  Memo.Lines.Add('Informações do shape:');
  Memo.Lines.Add('');
  IF AShapeList.SelectedShapes.Count > 0 THEN
    BEGIN
      FOR i := 0 TO AShapeList.SelectedShapes.count - 1 DO BEGIN
        ShapeIndex := AShapeList.IndexOfShape(AShapeList.SelectedShapes[i]);
        AddData(ShapeIndex, AShapeList);
      END;
    END
  ELSE
    BEGIN
      ShapeIndex := AShapeList.IndexOfShape(SVOGISImage1.SelectedShape);
      AddData(ShapeIndex, AShapeList);
    END;
end;

procedure TfrmGis.ToolButtonCloseGISClick(Sender: TObject);
begin
  IF Not Assigned(SVOLegend.SelectedPanel) THEN Exit;
  SVOLegend.SelectedPanel.Free;
  SVOLegend.Repaint;
  SVOGISImage1.Draw;
end;

procedure TfrmGis.ToolButtonExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmGis.ToolButtonShapeInfoClick(Sender: TObject);
begin
  SVOGisImage1.Mode := moIDShape;
end;

procedure TfrmGis.ToolButtonZoomInClick(Sender: TObject);
begin
  SVOGisImage1.Mode := moZoomIn;
end;

procedure TfrmGis.ToolButtonZoomOutClick(Sender: TObject);
begin
  SVOGisImage1.Mode := moZoomOut;
end;

procedure TfrmGis.ToolButtonGrabClick(Sender: TObject);
begin
  SVOGisImage1.Mode := moOpenHand;
end;

procedure TfrmGis.ToolButtonFullExtentClick(Sender: TObject);
begin
  SVOGISImage1.UpdateCanvas;
end;

procedure TfrmGis.ToolButtonDefaultClick(Sender: TObject);
begin
  SVOGisImage1.Mode := moDefault;
end;         

procedure TfrmGis.SVOGISReadWrite1ReadShape(Sender: TObject;
  ShapeIndex: Integer);
var
  AShape : TSVOShapeObject;
begin
  AShape := SVOGISReadWrite1.ShapeList[ShapeIndex];
  IF ShapeIndex = 0 THEN
    SVOGISImage1.Boundary := SVOGISReadWrite1.BoundaryFromFile
  ELSE
    SVOGISImage1.Boundary := CombineBoundaryBoxes(SVOGISImage1.Boundary, AShape.BoundaryBox);
  AShape.Draw(SVOGISImage1.DrawBitmap.Canvas, SVOGISImage1.ScaleParams);
  IF FCnt MOD 10 = 0 THEN
    SVOGISImage1.Canvas.Draw(0,0, SVOGISImage1.DrawBitmap);
  Inc(FCnt);
  Application.Processmessages;
end;

procedure TfrmGis.ZoomToSelection1Click(Sender: TObject);
var
  CurrentRecord : TSVODataRecord; // in DataFields.pas unit
  AShape : TSVOShapeObject;
  AShapeList : TSVOShapeList;
begin
  CurrentRecord := SVODataGrid1.CurrentRecord;
  IF Assigned(CurrentRecord.Shape) THEN BEGIN
    AShape := (CurrentRecord.Shape AS TSVOShapeObject);
    AShapeList := AShape.GisOwner As TSVOShapeList;
    IF AShapeList.ImageCanvas IS TSVOGisImage THEN BEGIN
      TSVOGisImage(AShapeList.ImageCanvas).ZoomTo(AShape.BoundaryBox);
      AShapeList.ImageCanvas.Draw;
    END;
  END;
end;

procedure TfrmGis.HighlightShape1Click(Sender: TObject);
var
  CurrentRecord : TSVODataRecord; // in DataFields.pas unit
  AShape : TSVOShapeObject;
  AShapeList : TSVOShapeList;
begin
  CurrentRecord := SVODataGrid1.CurrentRecord;
  IF Assigned(CurrentRecord.Shape) THEN BEGIN
    AShape := (CurrentRecord.Shape AS TSVOShapeObject);
    AShapeList := AShape.GisOwner As TSVOShapeList;
    AShapeList.PickShapeObject(AShape);
    IF Assigned(AShapeList.ImageCanvas) THEN
      AShapeList.ImageCanvas.Draw;
  END;
end;

procedure TfrmGis.UnhighlightShape1Click(Sender: TObject);
var
  CurrentRecord : TSVODataRecord; // in DataFields.pas unit
  AShape : TSVOShapeObject;
  AShapeList : TSVOShapeList;
begin
  CurrentRecord := SVODataGrid1.CurrentRecord;
  IF Assigned(CurrentRecord.Shape) THEN BEGIN
    AShape := (CurrentRecord.Shape AS TSVOShapeObject);
    AShapeList := AShape.GisOwner As TSVOShapeList;
    AShapeList.UnPickShapeObject(AShape);
    IF Assigned(AShapeList.ImageCanvas) THEN
      AShapeList.ImageCanvas.Draw;
  END;
end;

procedure TfrmGis.BlinkShape1Click(Sender: TObject);
const
  BlinkCount = 3;
  BlinkRate = 200; // milliseconds between blinks
  BlinkThenPersist = False;
var
  ShapeIndex : Integer;
  CurrentRecord : TSVODataRecord; // in DataFields.pas unit
  AShape : TSVOShapeObject;
  AShapeList : TSVOShapeList;
begin
  CurrentRecord := SVODataGrid1.CurrentRecord;
  IF Assigned(CurrentRecord.Shape) THEN BEGIN
    AShape := (CurrentRecord.Shape AS TSVOShapeObject);
    AShapeList := AShape.GisOwner As TSVOShapeList;
    ShapeIndex := AShapeList.IndexOfShape(AShape);
    AShapeList.BlinkShape(ShapeIndex, BlinkCount, BlinkRate, BlinkThenPersist);
  END;
end;

procedure TfrmGis.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;

   FExportBitmap := TBitmap.Create;
   FExportBitmap.PixelFormat := pf24Bit;
end;

procedure TfrmGis.FormDestroy(Sender: TObject);
begin
  if Assigned(FExportBitmap) then
    FreeandNil(FExportBitmap);
end;

procedure TfrmGis.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmGis.SVOLegendSelectItem(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y, Index: Integer;
  Data: TSVOGISObject; Item: TlegendItem);
begin
//  IF Not Assigned(SVOLegend.SelectedShapes) THEN Exit;
  SVODataGrid1.DataFields := SVOLegend.SelectedShapes.DataFields;
end;

procedure TfrmGis.BitBtn1Click(Sender: TObject);
begin
  FExportBitmap.Assign(SVOGISImage1.CopyImage);
  ModalResult := mrOk;
  Exit;
end;

procedure TfrmGis.ToolButton1Click(Sender: TObject);
begin
  SVOGisImage1.Mode := moPick;
end;

procedure TfrmGis.ToolButton2Click(Sender: TObject);
begin
  SVOGisImage1.Undo;
end;

end.
