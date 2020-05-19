unit uTestarIcone;

interface

uses
    Windows, Forms, StdCtrls, RxCombos, Controls, ExtCtrls, Graphics, Classes,
    Messages;

type
  TfrmTestarIcone = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    ColorComboBox1: TColorComboBox;
    Button1: TButton;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Image1: TImage;
    Label6: TLabel;
    Image6: TImage;
    imgFundo: TImage;

    procedure Button1Click(Sender: TObject);
    procedure ColorComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure imgFundoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgFundoMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure imgFundoMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
    XOriginal, YOriginal,
    XAreaClick, YAreaClick: Integer;
    procedure WMEraseBkgnd(var Msg: TWMEraseBkgnd); message WM_ERASEBKGND;

  public
    { Public declarations }
    Capturing: Bool;
    MouseX, MouseY: Integer;
    procedure CarregaImagem;

  end;

procedure TestarIcone(AOwner: TComponent; Img: TGraphic);

implementation


{$R *.DFM}

procedure TestarIcone(AOwner: TComponent; Img: TGraphic);
begin
  if TWinControl(AOwner).FindComponent('frmTestarIcone') <> nil then
    Exit;
  with TfrmTestarIcone.Create(AOwner) do
  begin
    Image1.Picture.Assign(nil);
    Image1.Picture.Graphic := Img;
    MouseX := 108;
    MouseY := 58;
    carregaImagem;
    ColorComboBox1.ColorValue := clWhite;
    ShowModal;
  end;
end;

// API utilizada para não permitir que a Image fique piscando
procedure TfrmTestarIcone.WMEraseBkgnd(var Msg : TWMEraseBkgnd);
begin
  Msg.Result := LRESULT(False);
end;


procedure TfrmTestarIcone.CarregaImagem;
begin
  ImgFundo.Canvas.Draw(0, 0, Image6.Picture.Graphic);
  ImgFundo.Canvas.Brush.Style := bsClear;
  ImgFundo.Canvas.Draw(25, 0, Image2.Picture.Graphic);
  ImgFundo.Canvas.TextOut(0, 33, Label2.Caption);
  ImgFundo.Canvas.Draw(25, 58, Image3.Picture.Graphic);
  ImgFundo.Canvas.TextOut(1, 92, Label3.Caption);
  ImgFundo.Canvas.Draw(25, 115, Image4.Picture.Graphic);
  ImgFundo.Canvas.TextOut(25, 149, Label4.Caption);
  ImgFundo.Canvas.Draw(108, 0, Image5.Picture.Graphic);
  ImgFundo.Canvas.TextOut(88, 33, Label5.Caption);
  ImgFundo.Canvas.StretchDraw(Rect(MouseX, MouseY, MouseX + 32, MouseY + 32),
      Image1.Picture.Graphic);
  ImgFundo.Canvas.TextOut(MouseX - 14, MouseY + 34, Label6.Caption);
end;

procedure TfrmTestarIcone.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmTestarIcone.ColorComboBox1Change(Sender: TObject);
begin
  Color := ColorComboBox1.ColorValue;
  Image6.Canvas.Pen.Color := clNone;
  Image6.Canvas.Pen.Style := psClear;
  Image6.Canvas.Brush.Color := Color;
  Image6.Canvas.Rectangle(Rect(0, 0, 389, 192));
  CarregaImagem;
  ImgFundo.Update;
  if Color = clBlack then
  begin
    Label2.Font.Color := clWhite;
    Label3.Font.Color := clWhite;
    Label4.Font.Color := clWhite;
    Label5.Font.Color := clWhite;
    Label6.Font.Color := clWhite;
  end
  else
  begin
    Label2.Font.Color := clBlack;
    Label3.Font.Color := clBlack;
    Label4.Font.Color := clBlack;
    Label5.Font.Color := clBlack;
    Label6.Font.Color := clBlack;
  end;
end;

procedure TfrmTestarIcone.FormCreate(Sender: TObject);
begin
  MouseX := 108;
  MouseY := 58;
  XAreaClick := 108;
  YAreaClick := 58;
  Image2.Picture.Bitmap.TransparentColor := clWhite;
  CarregaImagem;
  ImgFundo.Update;
end;

procedure TfrmTestarIcone.imgFundoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (((X >= XAreaClick) and (X <= (XAreaClick + 32))) and
    ((Y >= YAreaClick) and (Y <= (YAreaClick + 32)))) then
  begin
    Capturing := True;
    XOriginal := X - MouseX;
    YOriginal := Y - MouseY;
  end;
end;

procedure TfrmTestarIcone.imgFundoMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (((X - XOriginal) - 14 <= 0) or ((X - XOriginal) + 46 >= imgFundo.Width) or
    ((Y - YOriginal) <= 0) or ((Y - YOriginal) + 45 >= imgFundo.Height)) then
  begin
    if ((X - XOriginal) - 14 <= 0) then
    begin
      X := XOriginal + 14;
      if ((Y - YOriginal) <= 0) then
        Y := YOriginal
      else
      if ((Y - YOriginal) + 45 >= imgFundo.Height) then
        Y := imgFundo.Height - 32;
    end
    else
    if ((Y - YOriginal) <= 0) then
    begin
      Y := YOriginal;
      if ((X - XOriginal) - 14 <= 0) then
        X := XOriginal + 14
      else
      if ((X - XOriginal) + 46 >= imgFundo.Width) then
        X := imgFundo.Width - 32;
    end
    else
    if ((X - XOriginal) + 46 >= imgFundo.Width) then
    begin
      X := imgFundo.Width - 32;
      if ((Y - YOriginal) <= 0) then
        Y := YOriginal
      else
      if ((Y - YOriginal) + 45 >= imgFundo.Height) then
        Y := imgFundo.Height - 32;
    end
    else
    if ((Y - YOriginal) + 45 >= imgFundo.Height) then
    begin
      Y := imgFundo.Height - 32;
      if (X - XOriginal) - 14 <= 0 then
        X := XOriginal + 14
      else
      if ((X - XOriginal) + 46 >= imgFundo.Width) then
        X := imgFundo.Width - 32;
    end;

  end;
  if Capturing then
  begin
    MouseX := X - XOriginal;
    MouseY := Y - YOriginal;
    XAreaClick := MouseX;
    YAreaClick := MouseY;
    CarregaImagem;
  end;
end;

procedure TfrmTestarIcone.imgFundoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Capturing := False;
  ImgFundo.Update;
end;

procedure TfrmTestarIcone.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
