//                  ____               ______            __
//                 /  _/________  ____/_  __/___  ____  / /____
//                 / // ___/ __ \/ __ \/ / / __ \/ __ \/ / ___/
//               _/ // /__/ /_/ / / / / / / /_/ / /_/ / (__  )
//              /___/\___/\____/_/ /_/_/  \____/\____/_/____/

(*******************************************************************************
* IconTools 1.5                                                                *
*                                                                              *
* This file is part of the IconTools class library                             *
*                                                                              *
********************************************************************************
*                                                                              *
* If you find bugs, has ideas for missing featurs, feel free to contact me     *
*                           jpstotz@gmx.de                                     *
*                                                                              *
* The latest version of TShelltree can be found at:                            *
*     http://members.tripod.com/~JPStotz/IconTools/IconTools.html              *
********************************************************************************
* Date last modified:   May 12, 1999                                           *
*******************************************************************************)

unit IconTools;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IconTypes;

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
    procedure SaveToStream(Stream : TStream); override;
  end;

  TMultiIcon = class//(TPersistent)
  private
    FIconValid : Boolean;
    FIconCount : Word;
    function GetIcon(Index : Word) : TIcon;
  protected
    HandleListlen  : Dword;
    DirListlen     : DWord;
    IconHandleList : PIconHandleList;
    IconDirList    : Pointer;
    function CreateIconFromStream(Stream : TStream;Size : DWord;Var ResInfo : TIconResInfo) : HIcon;
    function GetHIcon(Index : Word) : HIcon; virtual; abstract;
    function GetIconSize(Index : Word) : TSize; virtual; abstract;
    function GetIconResInfo(Index : Word) : TIconResInfo; virtual; abstract;
    procedure LoadIconResInfos(Stream : TStream;Var Valid : Boolean;Var Count : Word); virtual; abstract;
    procedure InitHeaders(Stream : TStream);
    procedure CreateDefaults; virtual;
  public
    destructor Destroy; override;
    procedure WriteIconDataToStream(Stream : TStream;Index : Integer); virtual; abstract;
    procedure Draw(Canvas : TCanvas;X,Y : Integer;Index : Word); virtual;
    procedure SaveIconToFile(Filename : String;Index : Word);
    procedure SaveIconToStream(Stream : TStream;Index : Word);
    procedure SaveToFile(Filename : String);
    procedure SaveToStream(Stream : TStream);
    property IconValid : Boolean read FIconValid;
    property IconCount : Word read FIconCount;
    property IconHandle[Index : Word] : HIcon read GetHIcon;
    property Icon[Index : Word] : TIcon read GetIcon;
    property IconResInfo[Index : Word] : TIconResInfo read GetIconResInfo;
  end;

  TFileIcon = class(TMultiIcon)
  private
    function GetFileIconResInfo(Index : Word) : TFileIconResInfo;
  protected
    FileStream : TStream;
    function GetHIcon(Index : Word) : HIcon; override;
    function GetIconSize(Index : Word) : TSize; override;
    procedure LoadIconResInfos(Stream : TStream;Var Valid : Boolean;Var Count : Word);override;
    function GetIconResInfo(Index : Word) : TIconResInfo; override;
  public
    procedure WriteIconDataToStream(Stream : TStream;Index : Integer); override;
    constructor Create(Filename : String);
    constructor CreateInMem(Filename : String);
    destructor Destroy; override;
    property FileIconResInfo[Index : Word] : TFileIconResInfo read GetFileIconResInfo;
  end;

  TResourceIcon = class (TMultiIcon)
  private
    function GetResourceIconResInfo(Index : Word) : TResourceIconResInfo;
  protected
    Instance : THandle;
    function GetHIcon(Index : Word) : HIcon; override;
    function GetIconSize(Index : Word) : TSize; override;
    function GetIconResInfo(Index : Word) : TIconResInfo; override;
    procedure LoadIconResInfos(Stream : TStream;Var Valid : Boolean;Var Count : Word);override;
    constructor CreateAssign(DataSource : TResourceIcon);
  public
    procedure WriteIconDataToStream(Stream : TStream;Index : Integer); override;
    constructor Create(AInstance : THandle;ResName : String);
    constructor CreateFromID(AInstance : THandle;ResID : Integer);
    property ResourceIconResInfo[Index : Word] : TResourceIconResInfo read GetResourceIconResInfo;
  end;


function CreateIconFromResourceEx2(presbits: PByte; dwResSize: DWORD; fIcon: BOOL): HICON; stdcall;

implementation

{$R-}

uses Consts;

function CreateIconFromResourceEx2(presbits: PByte; dwResSize: DWORD; fIcon: BOOL): HICON; stdcall;
Var
  PBitmapInfo : PBitmapInfoHeader;
begin
  PBitmapInfo:=PBitmapInfoHeader(presbits);
  Result:=CreateIconFromResourceEx(presbits,dwResSize,fIcon,Win3,PBitmapInfo^.biWidth,PBitmapInfo^.biWidth,LR_DEFAULTCOLOR);
end;

//********************************************************************
//  TFileicon
//********************************************************************

constructor TFileIcon.Create(Filename : String);
begin
  CreateDefaults;
  FileStream:=TFileStream.Create(Filename,fmOpenRead or fmShareDenyWrite);
  InitHeaders(FileStream);
end;

constructor TFileIcon.CreateInMem(Filename : String);
begin
  CreateDefaults;
  FileStream:=TMemoryStream.Create;
  TMemoryStream(FileStream).LoadFromFile(Filename);
  InitHeaders(FileStream);
end;

function TFileIcon.GetFileIconResInfo(Index : Word) : TFileIconResInfo;
begin
  IF Index>=IconCount Then exit;
  Result:=PFileIconDirList(IconDirList)^[Index];
end;

function TFileIcon.GetHIcon(Index : Word) : HIcon;
begin
  Result:=0;
  IF Index>=IconCount Then exit;
  IF IconHandleList^[Index]=0 Then begin
    with FileIconResInfo[Index] do begin
      FileStream.Position:=dwImageOffset;
      Result:=CreateIconFromStream(FileStream,ResInfo.BytesInRes,ResInfo);
      IconHandleList^[Index]:=Result;
    end;
  end else
    Result:=IconHandleList^[Index];
end;

procedure TFileIcon.WriteIconDataToStream(Stream : TStream;Index : Integer);
begin
  IF Index>=IconCount Then exit;
  with FileIconResInfo[Index] do begin
    FileStream.Position:=dwImageOffset;
    Stream.CopyFrom(FileStream,ResInfo.BytesInres);
  end;
end;

function TFileIcon.GetIconSize(Index : Word) : TSize;
begin
  with IconResInfo[Index] do begin
    Result.cx:=Width;
    Result.cy:=Height;
  end;
end;

procedure TFileIcon.LoadIconResInfos(Stream : TStream;Var Valid : Boolean;Var Count : Word);
Var
  I          : Word;
  StartHeader : TIconHeader;
begin
  With Stream DO begin
    Read(StartHeader,sizeOf(StartHeader));
    Valid:=((StartHeader.wReserved=0) AND (StartHeader.wType=1));
    IF NOT Valid Then exit;
    Count:=StartHeader.wCount;
    DirListLen   :=Count*SizeOf(TFileIconResInfo);
    HandleListLen:=Count*SizeOf(HIcon);
    IconDirList   :=AllocMem(DirListlen);
    IconHandleList:=AllocMem(HandleListlen);
    ReadBuffer(IconDirList^,Count*SizeOf(TFileIconResInfo));
    FOR I:=1 TO IconCount DO begin
      IconHandleList^[I-1]:=0;
      With PFileIconDirList(IconDirList)^[I-1].ResInfo do Height:=Width;
    end;
  end;
end;

function TFileIcon.GetIconResInfo(Index : Word) : TIconResInfo;
begin
  IF Index>=IconCount Then exit;
  Result:=PFileIconDirList(IconDirList)^[Index].ResInfo;
end;

destructor TFileIcon.Destroy;
begin
  FileStream.Free;
  inherited;
end;

//********************************************************************
//  TResourceIcon
//********************************************************************

constructor TResourceIcon.CreateAssign(DataSource : TResourceIcon);
begin
  CreateDefaults;
  Instance     :=DataSource.Instance;
  FIconValid   :=DataSource.FIconValid;
  FIconCount   :=DataSource.FIconCount;
  HandleListlen:=DataSource.HandleListlen;
  DirListlen   :=DataSource.DirListlen;
  GetMem(IconHandleList,HandleListLen);
  GetMem(IconDirList,DirListLen);
  FillChar(IconHandleList^,HandleListLen,Chr(0));
  system.Move(DataSource.IconDirList^,IconDirList^,DirListlen);
end;

constructor TResourceIcon.Create(AInstance : THandle;ResName : String);
Var
  GroupStream : TResourceStream;
begin
  CreateDefaults;
  Instance:=AInstance;
  GroupStream:=TResourceStream.Create(Instance,ResName,RT_GROUP_ICON);
  try
    InitHeaders(GroupStream);
  finally
    GroupStream.Free;
  end;
end;

constructor TResourceIcon.CreateFromID(AInstance : THandle;ResID : Integer);
Var
  GroupStream : TResourceStream;
begin
  CreateDefaults;
  Instance:=AInstance;
  GroupStream:=TResourceStream.CreateFromID(Instance,ResID,RT_GROUP_ICON);
  try
    InitHeaders(GroupStream);
  finally
    GroupStream.Free;
  end;
end;

procedure TResourceIcon.LoadIconResInfos(Stream : TStream;Var Valid : Boolean;Var Count : Word);
Var
  I          : Word;
  StartHeader : TIconHeader;
begin
  With Stream DO begin
    Read(StartHeader,sizeOf(StartHeader));
    Valid:=((StartHeader.wReserved=0) AND (StartHeader.wType=1));
    IF NOT Valid Then exit;
    Count:=StartHeader.wCount;
    DirListLen   :=Count*SizeOf(TResourceIconResInfo);
    HandleListLen:=Count*SizeOf(HIcon);
    IconDirList   :=AllocMem(DirListlen);
    IconHandleList:=AllocMem(HandleListlen);
    ReadBuffer(IconDirList^,Count*SizeOf(TResourceIconResInfo));
    FOR I:=1 TO IconCount DO begin
      IconHandleList^[I-1]:=0;
      With PResourceIconDirList(IconDirList)^[I-1].ResInfo do Height:=Width;
    end;
  end;
end;

function TResourceIcon.GetIconSize(Index : Word) : TSize;
begin
  with IconResInfo[Index] do begin
    Result.cx:=Width;
    Result.cy:=Height;
  end;
end;

function TResourceIcon.GetResourceIconResInfo(Index : Word) : TResourceIconResInfo;
begin
  IF Index>=IconCount Then exit;
  Result:=PResourceIconDirList(IconDirList)^[Index];
end;

function TResourceIcon.GetIconResInfo(Index : Word) : TIconResInfo;
begin
  IF Index>=IconCount Then exit;
  Result:=PResourceIconDirList(IconDirList)^[Index].ResInfo;
end;

function TResourceIcon.GetHIcon(Index : Word) : HIcon;
Var
  IconStream : TResourceStream;
begin
  Result:=0;
  IF Index>=IconCount Then exit;
  IF IconHandleList^[Index]=0 Then begin
    with ResourceIconResInfo[Index] do begin
      IconStream:=TResourceStream.CreateFromID(Instance,ID,RT_ICON);
      try
        Result:=CreateIconFromStream(IconStream,IconStream.Size,ResInfo);
      finally
        IconStream.Free;
      end;
      IconHandleList^[Index]:=Result;
    end;
  end else
    Result:=IconHandleList^[Index];
end;

procedure TResourceIcon.WriteIconDataToStream(Stream : TStream;Index : Integer);
Var
  IconStream : TResourceStream;
begin
  IF Index>=IconCount Then exit;
  with ResourceIconResInfo[Index] do begin
    IconStream:=TResourceStream.CreateFromID(Instance,ID,RT_ICON);
    try
      Stream.CopyFrom(IconStream,IconStream.Size);
    finally
      IconStream.Free;
    end;
  end;
end;

//********************************************************************
//  TMultiIcon
//********************************************************************

procedure TMultiIcon.CreateDefaults;
begin
  DirListLen:=0;
  HandleListLen:=0;
  IconDirList:=nil;
  IconHandleList:=nil;
  FIconCount:=0;
  FIconValid:=false;
end;

destructor TMultiIcon.Destroy;
Var
  I : Word;
begin
  IF Assigned(IconDirList) Then begin
    FreeMem(IconDirList,DirListLen);
    DirListlen:=0;
  end;
  IF Assigned(IconHandleList) Then begin
    FOR I:=1 TO IconCount DO DestroyIcon(IconHandleList^[I-1]);
    FreeMem(IconHandleList,HandleListLen);
    HandleListlen:=0;
  end;
  inherited;
end;

procedure TMultiIcon.InitHeaders(Stream : TStream);
begin
  LoadIconResInfos(Stream,FIconValid,FIconCount);
end;

function TMultiIcon.CreateIconFromStream(Stream : TStream;Size : DWord;Var ResInfo : TIconResInfo) : HIcon;
Var
  PIcon      : Pointer;
  BitmapInfo : PBitmapInfoHeader;
  IconSize   : TPoint;
begin
  INC(Size,5);
  PIcon := AllocMem(Size);
  try
    Stream.Read(PIcon^, Size);
    BitmapInfo:=PIcon;
    IconSize:=Point(BitmapInfo^.biWidth,BitmapInfo^.biHeight);
    ResInfo.Height:=Iconsize.x;
    ResInfo.Width:=Iconsize.y;
    Result:=CreateIconFromResourceEx(PIcon,Size,True,Win3,IconSize.x,IconSize.y,LR_DEFAULTCOLOR);
  finally
    Freemem(PIcon,Size);
  end;
end;

procedure TMultiIcon.Draw(Canvas : TCanvas;X,Y : Integer;Index : Word);
Var
  IconHandle : HIcon;
  IconSize   : TSize;
begin
  IF Index>=IconCount Then exit;
  IconHandle:=GetHIcon(Index);
  IconSize:=GetIconSize(Index);
  DrawIconEx(Canvas.Handle,X,Y,IconHandle,IconSize.cx,IconSize.cy,0,0,DI_NORMAL);
end;

procedure TMultiIcon.SaveToFile(Filename : String);
Var
  IconFile : TMemoryStream;
begin
  IF IconCount=0 Then exit;
  IconFile:=TMemoryStream.Create;
  try
    SaveToStream(IconFile);
    IconFile.SaveToFile(Filename);
  finally
    IconFile.free;
  end;
end;

procedure TMultiIcon.SaveToStream(Stream : TStream);
Var
  Header : TIconHeader;
  ResInfo : TFileIconResInfo;
  I : Integer;
  StartPos,StreamPos : DWord;
begin
  IF IconCount=0 Then exit;
  StartPos:=Stream.Position;
  Header.wReserved:=0;
  Header.wType:=1;
  Header.wCount:=IconCount;
  Stream.Write(Header,SizeOf(Header));
  FOR I:=1 TO IconCount DO begin
    ResInfo.ResInfo:=IconResInfo[I-1];
    ResInfo.dwImageOffset:=0;
    Stream.Write(ResInfo,SizeOf(ResInfo));
  end;
  FOR I:=1 TO IconCount DO begin
    StreamPos:=Stream.Position-StartPos;
    Stream.Position:=SizeOf(Header)+(I*SizeOf(ResInfo))-SizeOf(DWord);
    Stream.Write(StreamPos,SizeOf(StreamPos));
    Stream.Position:=StreamPos;
    WriteIconDataToStream(Stream,I-1);
  end;
end;

procedure TMultiIcon.SaveIconToStream(Stream : TStream;Index : Word);
Var
  Header : TIconHeader;
  ResInfo : TFileIconResInfo;
begin
  IF Index>=IconCount Then exit;
  Header.wReserved:=0;
  Header.wType:=1;
  Header.wCount:=1;
  ResInfo.ResInfo:=IconResInfo[Index];
  ResInfo.dwImageOffset:=SizeOf(Header)+SizeOf(ResInfo);
  Stream.Write(Header,SizeOf(Header));
  Stream.Write(ResInfo,SizeOf(ResInfo));
  WriteIconDataToStream(Stream,Index);
end;

procedure TMultiIcon.SaveIconToFile(Filename : String;Index : Word);
Var
  IconFile : TMemoryStream;
begin
  IF Index>=IconCount Then exit;
  IconFile:=TMemoryStream.Create;
  try
    SaveIconToStream(IconFile,Index);
    IconFile.SaveToFile(Filename);
  finally
    IconFile.free;
  end;
end;

function TMultiIcon.GetIcon(Index : Word) : TIcon;
Var
  Handle : HIcon;
begin
  Result:=nil;
  Handle:=GetHIcon(Index);
  IF handle=0 Then exit;
  Result:=THiResIcon.Create;
  Result.Handle:=CopyIcon(Handle);
end;

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

procedure THiResIcon.SaveToStream(Stream : TStream);
Var
  IconInfo : TIconInfo;
  ColorBmp ,MaskBmp  : Windows.TBitmap;
  ColorSize,MaskSize : Cardinal;
  ColorRead,MaskRead : Cardinal;
  ColorBits,MaskBits : pointer;
  BitmapInfo : TBitmapInfoHeader;
begin
  GetIconInfo(Handle,IconInfo);
  MaskBmp.bmBits:=nil;
  GetObject(IconInfo.hbmColor,SizeOf(ColorBmp),@ColorBmp);
  GetObject(IconInfo.hbmMask ,SizeOf(MaskBmp) ,@MaskBmp);
  ColorSize:=ColorBmp.bmWidthBytes*ColorBmp.bmHeight;
  MaskSize :=MaskBmp.bmWidthBytes *MaskBmp.bmHeight;
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
  Stream.Write(BitmapInfo,SizeOf(BitmapInfo));

  GetMem(ColorBits,ColorSize+5);
  GetMem(MaskBits, MaskSize+5);
  try
    ColorRead:=GetBitmapBits(IconInfo.hbmColor,ColorSize+5,ColorBits);
    MaskRead :=GetBitmapBits(IconInfo.hbmMask, MaskSize+5, MaskBits);
    IF (ColorRead=ColorSize) AND (MaskRead=MaskSize) Then begin
      Stream.Write(ColorBits^,ColorSize);
      Stream.Write(MaskBits^, MaskSize);
    end else
      beep;
  finally
    Freemem(ColorBits,ColorSize);
    Freemem(MaskBits, MaskSize);
  end;
end;

end.
