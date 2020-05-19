unit IconConvert;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TIconCores = (ic0Bit, ic1Bit, ic4Bit, ic8Bit, ic16Bit, ic24Bit, ic32Bit);

  TCursors = array of TIcon;

  TIconConvert = class(TComponent)
  private
    { Private declarations }
    procedure WriteIcon(Stream: TStream; Icon: HICON; WriteLength: Boolean;
        ABit: TIconCores);
    procedure WriteCursor(Stream: TStream; ArrCursor: TCursors; ABit: TIconCores);
    function BytesPerScanline(PixelsPerScanline, BitsPerPixel,
      Alignment: Integer): Longint;
    procedure CheckBool(Result: Bool);
    procedure InitializeBitmapInfoHeader(Bitmap: HBITMAP;
      var BI: TBitmapInfoHeader; ABit: TIconCores);
    function InternalGetDIB(Bitmap: HBITMAP; Palette: HPALETTE;
      var BitmapInfo; var Bits; ABit: TIconCores): Boolean;
    procedure InternalGetDIBSizesA(Bitmap: HBITMAP; var InfoHeaderSize,
      ImageSize: DWORD; ABit: TIconCores);
    procedure InvalidBitmap;
    procedure InvalidGraphic(const Str: string);
    procedure WinError;
  protected
    { Protected declarations }
  public
    { Public declarations }
    function CreateIcon(ABitmap: TBitmap): TIcon;
    function CreateCursor(ArrBitmaps: array of TBitmap): TCursors;
    procedure SaveAsIcon(ABitmap: TBitmap; AFile: String; ABit: TIconCores);
    procedure SaveAsCursor(ArrBitmap: array of TBitmap; AFile: String; ABit: TIconCores);
    procedure SaveToFile(AIcon: Ticon; AFile: String; ABit: TIconCores); overload;
    procedure SaveToFile(ArrCursor: TCursors; AFile: String; ABit: TIconCores); overload;
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('MCCS', [TIconConvert]);
end;


resourcestring
  SInvalidBitmap = 'A imagem não é um bitmap válido!';

const
  rc3_Icon = 1;
  rc3_Cursor = 2;

type
  EInvalidGraphic = class(Exception);

procedure TIconConvert.SaveToFile(AIcon: Ticon; AFile: String; ABit: TIconCores);
var
    fs: TFileStream;
begin
    fs := TFileStream.Create (AFile, fmCreate or fmOpenWrite);
    WriteIcon(fs, AIcon.handle, false, ABit);
    fs.Free;
end;


function TIconConvert.CreateIcon(ABitmap: TBitmap): TIcon;
var
  IconSizeX: Integer;
  IconSizeY: Integer;
  XOrMask: TBitmap;
  MonoMask: TBitmap;
  BlackMask: TBitmap;
  IconInfo: TIconInfo;
  R: TRect;
  transcolor: Tcolor;
begin
 {Get the icon size}
//  IconSizeX := GetSystemMetrics(SM_CXICON);
//  IconSizeY := GetSystemMetrics(SM_CYICON);

  IconSizeX := ABitmap.Width;
  IconSizeY := ABitmap.Height;
  R := Rect(0, 0, IconSizeX, IconSizeY);


 {Create the "XOr" mask}
  XOrMask := TBitmap.Create;
  XOrMask.Width := IconSizeX;
  XOrMask.Height := IconSizeY;

  {stretchdraw mypaint}
  XorMask.canvas.draw(0, 0, Abitmap);
  transcolor := RGB(250,0,250);// XorMask.Canvas.Pixels [0,IconSizeY-1]; mccs mudei para a cor preta ficar em transparent

 {Create the Monochrome mask}
  MonoMask := TBitmap.Create;
  MonoMask.Width := IconSizeX;
  MonoMask.Height := IconSizeY;
  MonoMask.Canvas.Brush.Color := Clwhite;
  MonoMask.Canvas.FillRect(R);

 {Create the Black mask}
  BlackMask := TBitmap.Create;
  BlackMask.Width := IconSizeX;
  BlackMask.Height := IconSizeY;


 {if black is not the transcolor we must replace black
  with a temporary color}
  if transcolor <> clblack then
  begin
   BlackMask.Canvas.Brush.Color := $F8F9FA;
   BlackMask.Canvas.FillRect(R);
   BlackMask.canvas.BrushCopy(R, XorMask, R, clblack);
   XorMask.Assign (BlackMask);
   end;

  {now make the black mask}
  BlackMask.Canvas.Brush.Color := clBlack;
  BlackMask.Canvas.FillRect(R);

 {draw the XorMask with brushcopy}
  BlackMask.canvas.BrushCopy(R, XorMask, R, transcolor);
//  XorMask.Assign (BlackMask); // Marcelo Cavalcanti - 05/11/2006 - Troca de posição

 {Assign and draw the mono mask}
  XorMask.Transparent := true;
  XorMask.TransparentColor := transcolor;

  MonoMask.Canvas.draw(0, 0, XorMask);
//  MonoMask.canvas.copymode := cmsrcinvert; // Marcelo Cavalcanti - 05/11/2006 - PAra pegar somente a máscara
//  MonoMask.canvas.CopyRect(R, XorMask.canvas, R); // Marcelo Cavalcanti - 05/11/2006 - PAra pegar somente a máscara
  MonoMask.monochrome := true;

  XorMask.Assign (BlackMask); // Marcelo Cavalcanti - 05/11/2006
  XorMask.transparent := false;

  {restore the black color in the image}
  BlackMask.Canvas.Brush.Color := clBlack;
  BlackMask.Canvas.FillRect(R);
  BlackMask.canvas.BrushCopy(R, XorMask, R, $F8F9FA);

  XorMask.Assign (BlackMask);

 {Create a icon}
  result := TIcon.Create;
  IconInfo.fIcon := true;
  IconInfo.xHotspot := 0;
  IconInfo.yHotspot := 0;

  IconInfo.hbmMask := MonoMask.Handle;
  IconInfo.hbmColor := XOrMask.Handle;
  
  result.Handle := CreateIconIndirect(IconInfo);

 {Destroy the temporary bitmaps}
  XOrMask.Free;
  MonoMask.free;
  BlackMask.free;
end;


procedure TIconConvert.WinError;
begin
end;



procedure TIconConvert.CheckBool(Result: Bool);
begin
  if not Result then WinError;
end;

function TIconConvert.BytesPerScanline(PixelsPerScanline, BitsPerPixel, Alignment: Longint): Longint;
begin
  Dec(Alignment);
  Result := ((PixelsPerScanline * BitsPerPixel) + Alignment) and not Alignment;
  Result := Result div 8;
end;

procedure TIconConvert.InvalidGraphic(const Str: string);
begin
  raise EInvalidGraphic.Create(Str);
end;

procedure TIconConvert.InvalidBitmap;
begin
  InvalidGraphic(SInvalidBitmap);
end;


procedure TIconConvert.InitializeBitmapInfoHeader(Bitmap: HBITMAP; var BI: TBitmapInfoHeader;
  ABit: TIconCores);
var
  DS: TDIBSection;
  Bytes: Integer;
begin
  DS.dsbmih.biSize := 0;
  Bytes := GetObject(Bitmap, SizeOf(DS), @DS);
  if Bytes = 0 then InvalidBitmap
  else if (Bytes >= (sizeof(DS.dsbm) + sizeof(DS.dsbmih))) and
    (DS.dsbmih.biSize >= DWORD(sizeof(DS.dsbmih))) then
    BI := DS.dsbmih
  else
  begin
    FillChar(BI, sizeof(BI), 0);
    with BI, DS.dsbm do
    begin
      biSize := SizeOf(BI);
      biWidth := bmWidth;
      biHeight := bmHeight;
    end;
  end;
  if ABit <> ic0Bit then
    case ABit of
      ic1Bit  : BI.biBitCount := 1;
      ic4Bit  : BI.biBitCount := 4;
      ic8Bit  : BI.biBitCount := 8;
      ic16Bit : BI.biBitCount := 16;
      ic24Bit : BI.biBitCount := 24;
      ic32Bit : BI.biBitCount := 32;
    end
  else BI.biBitCount := DS.dsbm.bmBitsPixel * DS.dsbm.bmPlanes;
  BI.biPlanes := 1;
  if BI.biSizeImage = 0 then
    BI.biSizeImage := BytesPerScanLine(BI.biWidth, BI.biBitCount, 32) * Abs(BI.biHeight);
end;



procedure TIconConvert.InternalGetDIBSizesA(Bitmap: HBITMAP; var InfoHeaderSize: DWORD;
  var ImageSize: DWORD; ABit: TIconCores);
var
  BI: TBitmapInfoHeader;
begin
  InitializeBitmapInfoHeader(Bitmap, BI, ABit);
  if BI.biBitCount > 8 then
  begin
    InfoHeaderSize := SizeOf(TBitmapInfoHeader);
    if (BI.biCompression and BI_BITFIELDS) <> 0 then
      Inc(InfoHeaderSize, 12);
  end
  else
    InfoHeaderSize := SizeOf(TBitmapInfoHeader) + SizeOf(TRGBQuad) *
      (1 shl BI.biBitCount);
  ImageSize := BI.biSizeImage;
end;

function TIconConvert.InternalGetDIB(Bitmap: HBITMAP; Palette: HPALETTE;
  var BitmapInfo; var Bits; ABit: TIconCores): Boolean;
var
  OldPal: HPALETTE;
  DC: HDC;
begin
  InitializeBitmapInfoHeader(Bitmap, TBitmapInfoHeader(BitmapInfo), ABit);
  OldPal := 0;
  DC := CreateCompatibleDC(0);
  try
    if Palette <> 0 then
    begin
      OldPal := SelectPalette(DC, Palette, False);
      RealizePalette(DC);
    end;
    Result := GetDIBits(DC, Bitmap, 0, TBitmapInfoHeader(BitmapInfo).biHeight, @Bits,
      TBitmapInfo(BitmapInfo), DIB_RGB_COLORS) <> 0;
  finally
    if OldPal <> 0 then SelectPalette(DC, OldPal, False);
    DeleteDC(DC);
  end;
end;


procedure TIconConvert.WriteIcon(Stream: TStream; Icon: HICON;
    WriteLength: Boolean; ABit: TIconCores);
type
  TCursorOrIcon = packed record
    wReserved: Word;
    wType: Word;
    wCount: Word;
  end;

  TIconResInfo = packed record
    Width        : Byte;          // Width, in pixels, of the image
    Height       : Byte;          // Height, in pixels, of the image
    ColorCount   : Byte;          // Number of colors in image (0 if >=8bpp)
    Reserved     : byte;          // Reserved ( must be 0)
    Planes       : Word;          // Color Planes
    BitCount     : Word;          // Bits per pixel
    BytesInRes   : DWord;         // How many bytes in this resource?
  end;

  TFileIconResInfo = packed record
    ResInfo       : TIconResInfo;
    dwImageOffset : DWord;         // Where in the file is this image?
  end;
var
  IconInfo: TIconInfo;
  MonoInfoSize, ColorInfoSize: DWORD;
  MonoBitsSize, ColorBitsSize: DWORD;
  MonoInfo, MonoBits, ColorInfo, ColorBits: Pointer;
  CI: TCursorOrIcon;
  List: TFileIconResInfo;//TIconRec;
  Length: Longint;
  StartPos, StreamPos: DWord;
begin
  StartPos := Stream.Position;
  
  FillChar(CI, SizeOf(CI), 0);
  FillChar(List, SizeOf(List), 0);
  CheckBool(GetIconInfo(Icon, IconInfo));
  try
    InternalGetDIBSizesA(IconInfo.hbmMask, MonoInfoSize, MonoBitsSize, ic1Bit);
    InternalGetDIBSizesA(IconInfo.hbmColor, ColorInfoSize, ColorBitsSize, ABit);
    MonoInfo := nil;
    MonoBits := nil;
    ColorInfo := nil;
    ColorBits := nil;
    try
      MonoInfo := AllocMem(MonoInfoSize);
      MonoBits := AllocMem(MonoBitsSize);
      ColorInfo := AllocMem(ColorInfoSize);
      ColorBits := AllocMem(ColorBitsSize);
      InternalGetDIB(IconInfo.hbmMask, 0, MonoInfo^, MonoBits^, ic1Bit);
      InternalGetDIB(IconInfo.hbmColor, 0, ColorInfo^, ColorBits^, ABit);
      if WriteLength then
      begin
        Length := SizeOf(CI) + SizeOf(List) + ColorInfoSize +
          ColorBitsSize + MonoBitsSize;
        Stream.Write(Length, SizeOf(Length));
      end;
      with CI do
      begin
        CI.wReserved := 0;
        CI.wType := RC3_ICON;
        CI.wCount := 1;
      end;
      Stream.Write(CI, SizeOf(CI));
      with List, PBitmapInfoHeader(ColorInfo)^ do
      begin
        ResInfo.Width        := biWidth;
        ResInfo.Height       := biHeight;
        ResInfo.ColorCount   := (biPlanes * biBitCount);
//ColorCount (1 byte), Number of colors, either 0 for 24 bit or higher, 2 for monochrome or 16 for 16 color images.
        ResInfo.Reserved     := 0;
        ResInfo.Planes       := 1;
        ResInfo.BitCount     := biBitCount;
//BitCount (2 bytes), number of bits per pixel (1 for monochrome, 4 for 16 colors, 8 for 256 colors, 24 for true colors, 32 for true colors + alpha channel)
        ResInfo.BytesInRes   := ColorInfoSize + ColorBitsSize + MonoBitsSize;
        dwImageOffset := 0;
      end;
      Stream.Write(List, SizeOf(List));

      StreamPos := Stream.Position - StartPos;
      Stream.Position := SizeOf(CI) + (1 * SizeOf(List)) - SizeOf(DWord); //1 Total de Imagens
      Stream.Write(StreamPos, SizeOf(StreamPos));
      Stream.Position := StreamPos;

      with PBitmapInfoHeader(ColorInfo)^ do
        Inc(biHeight, biHeight); { color height includes mono bits }
      Stream.Write(ColorInfo^, ColorInfoSize);
      Stream.Write(ColorBits^, ColorBitsSize);
      Stream.Write(MonoBits^, MonoBitsSize);
    finally
      FreeMem(ColorInfo, ColorInfoSize);
      FreeMem(ColorBits, ColorBitsSize);
      FreeMem(MonoBits, MonoBitsSize);
    end;
  finally
    DeleteObject(IconInfo.hbmColor);
    DeleteObject(IconInfo.hbmMask);
  end;
end;



procedure TIconConvert.SaveAsIcon(ABitmap: TBitmap; AFile: string;
    ABit: TIconCores);
var
    ic: Ticon;
begin
    ic := CreateIcon(ABitmap);
    SaveToFile(ic, AFile, ABit);
    ic.free;
end;

function TIconConvert.CreateCursor(ArrBitmaps: array of TBitmap): TCursors;
var
  IconSizeX: Integer;
  IconSizeY: Integer;
  XOrMask: TBitmap;
  MonoMask: TBitmap;
  BlackMask: TBitmap;
  IconInfo: TIconInfo; //TCURSORSHAPE
  R: TRect;
  transcolor: Tcolor;
  I, J, C: Integer;
begin

  for I := Low(ArrBitmaps) to High(ArrBitmaps) do
  begin
     {Get the icon size}
      IconSizeX := GetSystemMetrics(SM_CXICON);
      IconSizeY := GetSystemMetrics(SM_CYICON);

      R := Rect(0, 0, IconSizeX, IconSizeY);

     {Create the "XOr" mask}
      XOrMask := TBitmap.Create;
      XOrMask.Width := IconSizeX;
      XOrMask.Height := IconSizeY;

      {stretchdraw mypaint}
      XorMask.canvas.draw(0, 0, Arrbitmaps[I]);
      transcolor := RGB(250,0,250);

     {Create the Monochrome mask}
      MonoMask := TBitmap.Create;
      MonoMask.Width := IconSizeX;
      MonoMask.Height := IconSizeY;
      MonoMask.Canvas.Brush.Color := Clwhite;
      MonoMask.Canvas.FillRect(R);

     {Create the Black mask}
      BlackMask := TBitmap.Create;
      BlackMask.Width := IconSizeX;
      BlackMask.Height := IconSizeY;


     {if black is not the transcolor we must replace black
      with a temporary color}
      if transcolor <> clblack then
      begin
       BlackMask.Canvas.Brush.Color := $F8F9FA;
       BlackMask.Canvas.FillRect(R);
       BlackMask.canvas.BrushCopy(R, XorMask, R, clblack);
       XorMask.Assign (BlackMask);
       end;

      {now make the black mask}
      BlackMask.Canvas.Brush.Color := clBlack;
      BlackMask.Canvas.FillRect(R);

     {draw the XorMask with brushcopy}
      BlackMask.canvas.BrushCopy(R, XorMask, R, transcolor);
    //  XorMask.Assign (BlackMask); // Marcelo Cavalcanti - 05/11/2006 - Troca de posição

     {Assign and draw the mono mask}
      XorMask.Transparent := true;
      XorMask.TransparentColor := transcolor;

      MonoMask.Canvas.draw(0, 0, XorMask);
    //  MonoMask.canvas.copymode := cmsrcinvert; // Marcelo Cavalcanti - 05/11/2006 - PAra pegar somente a máscara
    //  MonoMask.canvas.CopyRect(R, XorMask.canvas, R); // Marcelo Cavalcanti - 05/11/2006 - PAra pegar somente a máscara
      MonoMask.monochrome := true;

      XorMask.Assign (BlackMask); // Marcelo Cavalcanti - 05/11/2006
      XorMask.transparent := false;

      {restore the black color in the image}
      BlackMask.Canvas.Brush.Color := clBlack;
      BlackMask.Canvas.FillRect(R);
      BlackMask.canvas.BrushCopy(R, XorMask, R, $F8F9FA);

      XorMask.Assign (BlackMask);

     {Create a icon}
      if (High(Result) < 0) then
      begin
        SetLength(Result, 1);
        C := 0;
      end
      else
      begin
        SetLength(Result, Succ(High(Result) + 1));
        C := High(Result);
      end;
      Result[C] := TIcon.Create;

      IconInfo.fIcon := True;
      IconInfo.xHotspot := 0;
      IconInfo.yHotspot := 0;
      IconInfo.hbmMask := MonoMask.Handle;
      IconInfo.hbmColor := XOrMask.Handle;

      Result[C].Handle := CreateIconIndirect(IconInfo);

     {Destroy the temporary bitmaps}
      XOrMask.Free;
      MonoMask.free;
      BlackMask.free;
  end;
end;

procedure TIconConvert.SaveAsCursor(ArrBitmap: array of TBitmap; AFile: String;
  ABit: TIconCores);
var
    ic: TCursors;
    i: Integer;
begin
    ic := CreateCursor(ArrBitmap);
    SaveToFile(ic, AFile, ABit);
    for i := Low(ic) to High(ic) do
      ic[i].free;
end;

procedure TIconConvert.WriteCursor(Stream: TStream;
  ArrCursor: TCursors; ABit: TIconCores);
type
  TCursorOrIcon = packed record
    wReserved: Word;
    wType: Word;
    wCount: Word;
  end;

  TIconResInfo = packed record
    Width        : Byte;          // Width, in pixels, of the image
    Height       : Byte;          // Height, in pixels, of the image
    ColorCount   : Byte;          // Number of colors in image (0 if >=8bpp)
    Reserved     : byte;          // Reserved ( must be 0)
    Planes       : Word;          // Color Planes
    BitCount     : Word;          // Bits per pixel
    BytesInRes   : DWord;         // How many bytes in this resource?
  end;

  TFileIconResInfo = packed record
    ResInfo       : TIconResInfo;
    dwImageOffset : DWord;         // Where in the file is this image?
  end;

var
  IconInfo: TIconInfo;
  MonoInfoSize, ColorInfoSize: DWORD;
  MonoBitsSize, ColorBitsSize: DWORD;
  MonoInfo, MonoBits, ColorInfo, ColorBits: Pointer;
  CI: TCursorOrIcon;
  List: TFileIconResInfo;//TIconRec;
  Length: Longint;
  StartPos, StreamPos: DWord;
  I: Integer;
begin
  StartPos := Stream.Position;

  FillChar(CI, SizeOf(CI), 0);
  FillChar(List, SizeOf(List), 0);

  with CI do
  begin
    wReserved := 0;
    wType := rc3_Cursor;//rc3_Icon;
    wCount := Succ(High(ArrCursor));
  end;
  Stream.Write(CI, SizeOf(CI));

  for I := Low(ArrCursor) to High(ArrCursor) do
  begin
      CheckBool(GetIconInfo(ArrCursor[I].Handle, IconInfo));

      try
        InternalGetDIBSizesA(IconInfo.hbmMask, MonoInfoSize, MonoBitsSize, ic1Bit);
        InternalGetDIBSizesA(IconInfo.hbmColor, ColorInfoSize, ColorBitsSize, ABit);
        MonoInfo := nil;
        MonoBits := nil;
        ColorInfo := nil;
        ColorBits := nil;
        try
          MonoInfo := AllocMem(MonoInfoSize);
          MonoBits := AllocMem(MonoBitsSize);
          ColorInfo := AllocMem(ColorInfoSize);
          ColorBits := AllocMem(ColorBitsSize);
          InternalGetDIB(IconInfo.hbmMask, 0, MonoInfo^, MonoBits^, ic1Bit);
          InternalGetDIB(IconInfo.hbmColor, 0, ColorInfo^, ColorBits^, ABit);


          with List, PBitmapInfoHeader(ColorInfo)^ do
          begin
            ResInfo.Width        := biWidth;
            ResInfo.Height       := biHeight;
            ResInfo.ColorCount   := (biPlanes * biBitCount);
            ResInfo.Reserved     := 0;
            ResInfo.Planes       := biPlanes; //IconInfo.xHotspot;;
            ResInfo.BitCount     := biBitCount; //IconInfo.yHotspot;
            ResInfo.BytesInRes   := ColorInfoSize + ColorBitsSize + MonoBitsSize;
            dwImageOffset := 0;
          end;
          Stream.Write(List, SizeOf(List));

        finally
          FreeMem(ColorInfo, ColorInfoSize);
          FreeMem(ColorBits, ColorBitsSize);
          FreeMem(MonoBits, MonoBitsSize);
        end;
      finally
        DeleteObject(IconInfo.hbmColor);
        DeleteObject(IconInfo.hbmMask);
      end;
  end;

  for I := Low(ArrCursor) to High(ArrCursor) do
  begin
      CheckBool(GetIconInfo(ArrCursor[I].Handle, IconInfo));
      try
        InternalGetDIBSizesA(IconInfo.hbmMask, MonoInfoSize, MonoBitsSize, ic1Bit);
        InternalGetDIBSizesA(IconInfo.hbmColor, ColorInfoSize, ColorBitsSize, ABit);
        MonoInfo := nil;
        MonoBits := nil;
        ColorInfo := nil;
        ColorBits := nil;
        try
          MonoInfo := AllocMem(MonoInfoSize);
          MonoBits := AllocMem(MonoBitsSize);
          ColorInfo := AllocMem(ColorInfoSize);
          ColorBits := AllocMem(ColorBitsSize);
          InternalGetDIB(IconInfo.hbmMask, 0, MonoInfo^, MonoBits^, ic1Bit);
          InternalGetDIB(IconInfo.hbmColor, 0, ColorInfo^, ColorBits^, ABit);

          StreamPos := Stream.Position - StartPos;
          Stream.Position := SizeOf(CI) + (Succ(I) * SizeOf(List)) - SizeOf(DWord); //1 Total de Imagens
          Stream.Write(StreamPos, SizeOf(StreamPos));
          Stream.Position := StreamPos;

          with PBitmapInfoHeader(ColorInfo)^ do
            Inc(biHeight, biHeight); { color height includes mono bits }
          Stream.Write(ColorInfo^, ColorInfoSize);
          Stream.Write(ColorBits^, ColorBitsSize);
          Stream.Write(MonoBits^, MonoBitsSize);

        finally
          FreeMem(ColorInfo, ColorInfoSize);
          FreeMem(ColorBits, ColorBitsSize);
          FreeMem(MonoBits, MonoBitsSize);
        end;
      finally
        DeleteObject(IconInfo.hbmColor);
        DeleteObject(IconInfo.hbmMask);
      end;
  end;
end;

procedure TIconConvert.SaveToFile(ArrCursor: TCursors;
  AFile: String; ABit: TIconCores);
var
    fs: TFileStream;
begin
    fs := TFileStream.Create (AFile, fmCreate or fmOpenWrite);
    WriteCursor(fs, ArrCursor, ABit);
    fs.Free;
end;

end.
