//                    ____               ______            __
//                   /  _/________  ____/_  __/___  ____  / /____
//                   / // ___/ __ \/ __ \/ / / __ \/ __ \/ / ___/
//                 _/ // /__/ /_/ / / / / / / /_/ / /_/ / (__  )
//                /___/\___/\____/_/ /_/_/  \____/\____/_/____/
//

(*******************************************************************************
* IconTools                                                                    *
*                                                                              *
*                    (c) 1999 Jan Peter Stotz                                  *
*                                                                              *
*         This file is part of the IconTools 2.0 class library                 *
*                            SHAREWARE                                         *
*                                                                              *
********************************************************************************
*                                                                              *
* If you find bugs, has ideas for missing featurs, feel free to contact me     *
*                           jpstotz@gmx.de                                     *
*                                                                              *
* The latest version of TShelltree can be found at:                            *
*     http://members.tripod.com/~JPStotz/IconTools/IconTools.html              *
********************************************************************************
* Date last modified:   May 22, 1999                                           *
*******************************************************************************)

unit IconTools;

interface

uses
  SysUtils, Windows, Graphics;

type
  THiResIcon = class(TIcon)
  private
    FHeight : Integer;
    FWidth : Integer;
    FIconChanged : Boolean;
  protected
    procedure GetIconSizeInfo; virtual;
    procedure Changed(Sender: TObject); override;
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
    function GetHeight : Integer; override;
    function GetWidth : Integer; override;
  public
    constructor Create; override;
//    procedure SaveToStream(Stream : TStream); override;
  end;

implementation

//********************************************************************
//  THiResIcon
//********************************************************************

constructor THiresIcon.Create;
begin
  inherited;
  FHeight:=GetSystemMetrics(SM_CYICON);
  FWidth :=GetSystemMetrics(SM_CXICON);
  FIconChanged:=False;
end;

procedure THiResIcon.Changed(Sender: TObject);
begin
  inherited;
  FIconChanged:=True;
end;

procedure THiResIcon.Draw(ACanvas: TCanvas; const Rect: TRect);
var
  DC : HDC;
begin
  with Rect.TopLeft do
  begin
    GetIconSizeInfo;
    DC:=ACanvas.Handle;
    IF (DC<>0) Then begin
      DrawIconEx(DC, X, Y, Handle,Width,Height,0,0,DI_NORMAL);
    end;
  end;
end;

procedure THiResIcon.GetIconSizeInfo;
Var
  IconInfo : TIconInfo;
  Bitmap : windows.TBitmap;
  Res : Integer;
begin
  IF NOT FIconChanged Then exit;
  FIconChanged:=False;
  IF NOT GetIconInfo(Handle,IconInfo) Then exit;
  Res:=GetObject(IconInfo.hbmColor,SizeOf(Bitmap),@Bitmap);
  IF Res=0 Then Res:=GetObject(IconInfo.hbmMask,SizeOf(Bitmap),@Bitmap);
  IF Res=0 Then exit;
  DeleteObject(IconInfo.hbmColor);
  DeleteObject(IconInfo.hbmMask);
  FWidth :=Bitmap.bmWidth;
  FHeight:=Bitmap.bmWidth;
end;

function THiResIcon.GetHeight: Integer;
begin
  GetIconSizeInfo;
  Result := FHeight;
end;

function THiResIcon.GetWidth: Integer;
begin
  GetIconSizeInfo;
  Result := FWidth;
end;

(*
procedure THiResIcon.SaveToStream(Stream : TStream);
Var
  IconInfo : TIconInfo;
  ColorBmp ,MaskBmp  : Windows.TBitmap;
  ColorSize,MaskSize : Cardinal;
  ColorRead,MaskRead : Cardinal;
  ColorBits,MaskBits : pointer;
  BitmapInfo : TBitmapInfoHeader;
  Header : TIconHeader;
  ResInfo : TFileIconResInfo;
  Size : TSize;
begin
  With Header do begin
    wType:=1;
    wReserved:=0;
    wCount:=1;
  end;
  GetIconInfo(Handle,IconInfo);
  MaskBmp.bmBits:=nil;
  GetObject(IconInfo.hbmColor,SizeOf(ColorBmp),@ColorBmp);
  GetObject(IconInfo.hbmMask ,SizeOf(MaskBmp) ,@MaskBmp);
  ColorSize:=ColorBmp.bmWidthBytes*ColorBmp.bmHeight;
  MaskSize :=MaskBmp.bmWidthBytes *MaskBmp.bmHeight;
  IF GetBitmapDimensionEx(IconInfo.hbmColor,Size) Then begin
    ShowMessagefmt('%d %d',[Size.cx,Size.cy]);
  end;
  With ColorBmp DO begin
    With BitmapInfo DO begin
      biSize          :=0;
      biWidth         :=bmWidth;
      biHeight        :=bmHeight;
      biPlanes        :=bmPlanes;
      biBitCount      :=bmBitsPixel;
      biCompression   :=0;
      biSizeImage     :=0;
      biXPelsPerMeter :=0;
      biYPelsPerMeter :=0;
      biClrUsed       :=0;
      biClrImportant  :=0;

//      ShowMessage(InttoStr(biBitCount));

    end;
  end;
//  Stream.Write(Header,SizeOf(Header));
  FillChar(ResInfo,SizeOf(ResInfo),#0);
  Resinfo.dwImageOffset:=SizeOf(Header)+SizeOf(ResInfo);
  With Resinfo do begin
    ResInfo.Width:=BitmapInfo.biWidth;
    Resinfo.Height:=BitmapInfo.biHeight;
    ResInfo.Planes:=1;
  end;
{  Stream.Write(ResInfo,SizeOf(ResInfo));

  Stream.Write(BitmapInfo,SizeOf(BitmapInfo));}

  GetMem(ColorBits,ColorSize+5);
  GetMem(MaskBits, MaskSize+5);
  try
    ColorRead:=GetBitmapBits(IconInfo.hbmColor,ColorSize+5,ColorBits);
    MaskRead :=GetBitmapBits(IconInfo.hbmMask, MaskSize+5, MaskBits);
    IF (ColorRead=ColorSize) AND (MaskRead=MaskSize) Then begin
      Stream.Write(ColorBits^,ColorSize);
      Stream.Write(MaskBits^, MaskSize);
    end;
  finally
    Freemem(ColorBits,ColorSize);
    Freemem(MaskBits, MaskSize);
  end;
{  Resinfo.ResInfo.BytesInRes:=Stream.Position-SizeOf(Header)-SizeOf(ResInfo);
  Stream.Position:=SizeOf(Header)+SizeOf(ResInfo);
  Stream.Write(ResInfo,SizeOf(ResInfo));}
end;*)

end.
