unit uDataGrid;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, SVODataGrid, Menus, GisImage;

type
  TfrmDataGrid = class(TForm)
    SVODataGrid1: TSVODataGrid;
    PopupMenu1: TPopupMenu;
    ZoomToSelection1: TMenuItem;
    BlinkShape1: TMenuItem;
    HighlightShape1: TMenuItem;
    UnhighlightShape1: TMenuItem;
    procedure ZoomToSelection1Click(Sender: TObject);
    procedure HighlightShape1Click(Sender: TObject);
    procedure BlinkShape1Click(Sender: TObject);
    procedure UnhighlightShape1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    AGisImage : TSVOGisImage;
  end;

var
  frmDataGrid: TfrmDataGrid;

implementation

{$R *.DFM}

// These methods show how the SVODataGrid can interact directly with any shape
// in the record list.  Shapes are actually stored as an object in each record
// as the records "Shape" property.  Records without shapes have a Shape property
// of nil.

uses DataFields, GisShape;

procedure TFormGrid.ZoomToSelection1Click(Sender: TObject);
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

procedure TFormGrid.HighlightShape1Click(Sender: TObject);
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

procedure TFormGrid.UnhighlightShape1Click(Sender: TObject);
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

procedure TFormGrid.BlinkShape1Click(Sender: TObject);
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

end.
