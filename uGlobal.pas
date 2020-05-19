unit uGlobal;

interface

uses
    Windows, Types, Graphics, ShlObj,
    mccsCommons, mccsFillGradient;

    procedure ListDrawValuePen(const Value: string; Index: Integer;
      ACanvas: TCanvas; const ARect: TRect; ASelected, AViewCaption: Boolean);
    procedure ListDrawValueBrush(const Value: string; Index: Integer;
      ACanvas: TCanvas; const ARect: TRect; ASelected, AViewCaption: Boolean);

    procedure RotateText(ACanvas: TCanvas; AFont: TFont; const Text: String;
      X, Y, Angle: Integer; WH_To_XY: Boolean);

    function RedimensionarImagem(ABmp: TBitmap): TBitmap; overload;
    function RedimensionarImagem(ABmp: TBitmap; ASize: Integer): TBitmap; overload;

    function SelectFolder(wnd: HWND; Title: String): String;    

implementation

procedure DefaultPropertyListDrawValue(const Value: string; Canvas: TCanvas;
  const Rect: TRect; Selected: Boolean);
begin
  {DEsenha novamente o nome dos itens da lista}
  Canvas.TextRect(Rect, Rect.Left + 1, Rect.Top + 1, Value);
end;

procedure ListDrawValuePen(const Value: string; Index: Integer;
  ACanvas: TCanvas; const ARect: TRect; ASelected, AViewCaption: Boolean);
var
  Right, Top: Integer;
  OldPenColor, OldBrushColor: TColor;
  OldPenStyle: TPenStyle;
begin
  Right := (ARect.Bottom - ARect.Top) * 2 + ARect.Left;
  Top := (ARect.Bottom - ARect.Top) div 2 + ARect.Top;
  with ACanvas do
  begin
    // save off things
    OldPenColor := Pen.Color;
    OldBrushColor := Brush.Color;
    OldPenStyle := Pen.Style;

    // frame things
    Pen.Color := Brush.Color;
    Rectangle(ARect.Left, ARect.Top, Right, ARect.Bottom);

    // white out the background
    Pen.Color := clWindowText;
    Brush.Color := clWindow;
    Rectangle(ARect.Left + 1, ARect.Top + 1, Right - 1, ARect.Bottom - 1);

    // set thing up and do work
    Pen.Color := clWindowText;
    Pen.Style := TPenStyle(Index);
    MoveTo(ARect.Left + 1, Top);
    LineTo(Right - 1, Top);
    MoveTo(ARect.Left + 1, Top + 1);
    LineTo(Right - 1, Top + 1);

    // restore the things we twiddled with
    Brush.Color := OldBrushColor;
    Pen.Style := OldPenStyle;
    Pen.Color := OldPenColor;
    if AViewCaption then
        DefaultPropertyListDrawValue(Value, ACanvas, Rect(Right, ARect.Top,
            ARect.Right, ARect.Bottom), ASelected)
    else
        DefaultPropertyListDrawValue('', ACanvas, Rect(Right, ARect.Top,
            ARect.Right, ARect.Bottom), ASelected);
  end;
end;

procedure ListDrawValueBrush(const Value: string; Index: Integer;
  ACanvas: TCanvas; const ARect: TRect; ASelected, AViewCaption: Boolean);
var
  Right: Integer;
  OldPenColor, OldBrushColor: TColor;
  OldBrushStyle: TBrushStyle;
begin
  Right := (ARect.Bottom - ARect.Top) {* 2} + ARect.Left;
  with ACanvas do
  begin
    // save off things
    OldPenColor := Pen.Color;
    OldBrushColor := Brush.Color;
    OldBrushStyle := Brush.Style;

    // frame things
    Pen.Color := Brush.Color;
    Brush.Color := clWindow;
    Rectangle(ARect.Left, ARect.Top, Right, ARect.Bottom);

    // set things up
    Pen.Color := clWindowText;
    Brush.Style := TBrushStyle(Index);

    // bsClear hack
    if Brush.Style = bsClear then
    begin
      Brush.Color := clWindow;
      Brush.Style := bsSolid;
    end
    else
      Brush.Color := clWindowText;

    // ok on with the show
    Rectangle(ARect.Left + 1, ARect.Top + 1, Right - 1, ARect.Bottom - 1);

    // restore the things we twiddled with
    Brush.Color := OldBrushColor;
    Brush.Style := OldBrushStyle;
    Pen.Color := OldPenColor;
    if AViewCaption then
        DefaultPropertyListDrawValue(Value, ACanvas, Rect(Right, ARect.Top,
            ARect.Right, ARect.Bottom), ASelected)
    else
        DefaultPropertyListDrawValue('', ACanvas, Rect(Right, ARect.Top,
            ARect.Right, ARect.Bottom), ASelected);
  end;
end;

procedure RotateText(ACanvas: TCanvas; AFont: TFont; const Text: String;
  X, Y, Angle: Integer; WH_To_XY: Boolean);
var
  Lf : TLogFont;
  Tf : TFont;
  W, H: Integer;
begin
  with ACanvas do
  begin
    Font.Name := AFont.Name;
    Font.Size := AFont.Size;
    Font.Color := AFont.Color;
    Font.Style := AFont.Style;

    tf := TFont.Create;
    try
      tf.Assign(Font) ;
      GetObject(tf.Handle, sizeof(lf), @lf) ;
      lf.lfEscapement := Angle * 10;
      lf.lfOrientation := lf.lfEscapement;
      tf.Handle := CreateFontIndirect(lf) ;
      Font.Assign(tf) ;
    finally
      tf.Free;
    end;
    if WH_To_XY then
    begin
      W := (X div 2) + (TextWidth(Text) div 4);
      H := (Y div 2) + (TextHeight(Text) div 4);
    end
    else
    begin
      W := X;
      H := Y;
    end;
    TextOut(W, H, Text) ;
  end;
end;

function GetStretchRatio(CtrlWidth, CtrlHeight, PictureWidth,
    PictureHeight: Integer): TRect;
begin
    Result := rect(0, 0, CtrlWidth, CtrlHeight);
  
    if (PictureHeight > CtrlHeight) and (PictureWidth > CtrlWidth) then
    begin
        Result.Bottom := trunc(PictureHeight * (CtrlWidth / PictureWidth));
        if Result.Bottom > CtrlHeight then
        begin
           Result.right := trunc(Result.right * (CtrlHeight / Result.Bottom));
           Result.Bottom := CtrlHeight;
        end;
    end
    else
    if PictureHeight > CtrlHeight then
        Result.right := trunc(PictureWidth * (CtrlHeight / PictureHeight))
    else
    if PictureWidth > CtrlWidth then
        Result.Bottom := trunc(PictureHeight * (CtrlWidth / PictureWidth))
    else
        //Result := Rect(0, 0, PictureWidth, PictureHeight);
        Result := Rect(0, 0, CtrlWidth, CtrlHeight);
end;

function GetCenterView(CtrlRec, PictureRect: TRect): TRect;
var
    L_R : Integer;
begin
    L_R := PictureRect.Left;
    PictureRect.Left := CtrlRec.left +
        ((CtrlRec.right-CtrlRec.left)div 2) -
        ((PictureRect.right - PictureRect.left) div 2);
    PictureRect.Right := PictureRect.Left - L_R + PictureRect.Right;
    L_R := PictureRect.Top;
    PictureRect.Top := CtrlRec.top +
        ((CtrlRec.bottom-CtrlRec.top)div 2) -
        ((PictureRect.bottom - PictureRect.top) div 2);
    PictureRect.bottom := PictureRect.Top - L_R + PictureRect.bottom;
  
    Result := PictureRect;
end;

function StretchProport(ABmp: TBitmap; ARect: TRect; ACenter: Boolean): TBitmap;
var
    FDrawRect: TRect;
    Bmp: TBitmap;
begin
    Result := TBitmap.Create;
    Result.Width := ARect.Right;
    Result.Height := ARect.Bottom;
    try
        FDrawRect := ARect;

        FDrawRect := GetStretchRatio(ARect.Right - ARect.left,
            ARect.bottom - ARect.top,
            ABmp.width, ABmp.Height);

        if ACenter then
            FDrawRect := GetCenterView(ARect, FDrawRect);

        Bmp := TBitmap.Create;
        try
            Bmp.Width := Arect.Right;
            Bmp.Height := Arect.Bottom;
            Bmp.Canvas.StretchDraw(FDrawRect, ABmp);
            
            Result.Assign(Bmp);
        finally
            Bmp.Free;
        end;
    except
        Result.Assign(nil);
    end;
end;

function RedimensionarImagem(ABmp: TBitmap): TBitmap;
var
    W,
    H: Integer;
    Bmp: TBitmap;
begin
    try
        Result := TBitmap.Create;

        W := ABmp.Width;
        if (W <= 16) then
            W := 16
        else
        if (W <= 24) then
            W := 24
        else
        if (W <= 32) then
            W := 32
        else
        if (W <= 48) then
            W := 48
        else
        if (W <= 64) then
            W := 64
        else
            W := 128;

        H := ABmp.Height;
        if (H <= 16) then
            H := 16
        else
        if (H <= 24) then
            H := 24
        else
        if (H <= 32) then
            H := 32
        else
        if (H <= 48) then
            H := 48
        else
        if (H <= 64) then
            H := 64
        else
            H := 128;

        if (W <= H) then
            W := H
        else
            H := W;

        Bmp := TBitmap.Create;
        try
            Bmp.Width := W;
            Bmp.Height := H;
            Bmp.Assign(StretchProport(ABmp, Rect(0, 0, W, H), True));

            Result.Width := W;
            Result.Height := H;
            Result.Assign(Bmp);
        finally
            Bmp.Free;
        end;
    except
        Result := nil;
    end;
end;

function RedimensionarImagem(ABmp: TBitmap; ASize: Integer): TBitmap;
var
    W,
    H: Integer;
    Bmp: TBitmap;
begin
    try
        Result := TBitmap.Create;

        W := ASize;
        H := W;

        Bmp := TBitmap.Create;
        try
            Bmp.Width := W;
            Bmp.Height := H;
            Bmp.Assign(StretchProport(ABmp, Rect(0, 0, W, H), True));

            Result.Width := W;
            Result.Height := H;
            Result.Assign(Bmp);
        finally
            Bmp.Free;
        end;
    except
        Result := nil;
    end;
end;

function SelectFolder(wnd: HWND; Title: String): String;
var
  lpItemID: PItemIDList;
  BrowseInfo: TBrowseInfo;
  DisplayName: array[0..MAX_PATH] of char;
  TempPath: array[0..MAX_PATH] of char;
begin
  FillChar(BrowseInfo, sizeof(TBrowseInfo), #0);
  BrowseInfo.hwndOwner := wnd;
  BrowseInfo.pszDisplayName := @DisplayName;
  BrowseInfo.lpszTitle := PChar(Title);
  BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS;
  lpItemID := SHBrowseForFolder(BrowseInfo);
  if lpItemId <> nil then
  begin
    SHGetPathFromIDList(lpItemID, TempPath);
    Result := TempPath;
    GlobalFreePtr(lpItemID);
  end
  else
    Result := '';
end;
end.
