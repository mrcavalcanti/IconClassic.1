//                ____                 ____
//               /  _/________  ____  /  _/___ ___  ____ _____ ____
//               / // ___/ __ \/ __ \ / // __ `__ \/ __ `/ __ `/ _ \
//             _/ // /__/ /_/ / / / // // / / / / / /_/ / /_/ /  __/
//            /___/\___/\____/_/ /_/___/_/ /_/ /_/\__,_/\__, /\___/
//                                                     /____/

(*******************************************************************************
* IconImage                                                                    *
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

unit IconImage;

interface

uses
  Windows, SysUtils, Classes, Graphics, Icontypes, IconTools;

type
  TIconImage = class
  private

  protected
    FHandle      : HIcon;
    FInfo        : TIconResInfo;
    FIconData    : Pointer;
    function GetHandle : HIcon; virtual;
    function GetIcon : TIcon; virtual;
    procedure CorrectIconSize;
  public
    constructor Create;
    constructor CreateCopy(Source : TIconImage); virtual;
    destructor Destroy; override;

    procedure Draw(Canvas : TCanvas;X,Y : Integer);
    procedure WriteIconDataToStream(Stream : TStream);

    property Handle     : HIcon read GetHandle;
    property Icon       : TIcon read GetIcon; //returns a THiResIcon as TIcon
    property Info       : TIconResInfo read FInfo;
  end;

  TFileIconImage = class(TIconImage)
  public
    constructor Create(Stream : TStream);
  end;

  TResourceIconImage = class(TIconImage)
  public
    constructor Create(GroupIconStream : TStream;Instance : Thandle);
  end;

implementation


constructor TResourceIconImage.Create(GroupIconStream : TStream;Instance : Thandle);
Var
  Stream : TResourceStream;
  ResInfo : TResourceIconResInfo;
begin
  inherited Create;
  GroupIconStream.Read(ResInfo,SizeOf(ResInfo));
  FInfo:=ResInfo.ResInfo;
  Stream:=TResourceStream.CreateFromID(Instance,ResInfo.ID,RT_Icon);
  try
    GetMem(FIconData,Stream.Size);
    Stream.Read(FIcondata^,Stream.Size);
  finally
    Stream.free;
  end;
  CorrectIconSize;
end;

constructor TFileIconImage.Create(Stream : TStream);
Var
  ResInfo : TFileIconResInfo;
  OldPos : Cardinal;
begin
  inherited Create;
  Stream.Read(ResInfo,SizeOf(ResInfo));
  OldPos:=Stream.Position;
  FInfo:=ResInfo.ResInfo;
  Stream.Position:=ResInfo.dwImageOffset;
  try
    GetMem(FIconData,ResInfo.ResInfo.BytesInRes);
    Stream.Read(FIconData^,ResInfo.ResInfo.BytesInRes);
  finally
    Stream.Position:=OldPos;
  end;
  CorrectIconSize;
end;


constructor TIconImage.Create;
begin
  FHandle:=0;
  FIconData:=nil;
end;

constructor TIconImage.CreateCopy(Source : TIconImage);
begin
  Create;
  FInfo:=Source.Info;
  Getmem(FIcondata,FInfo.BytesInRes);
  IF Assigned(Source.FIconData) Then
    System.Move(Source.FIconData^,FIconData^,FInfo.BytesInRes);
  IF (Source.handle<>0) Then FHandle:=CopyIcon(Source.Handle);
  CorrectIconSize;
end;

procedure TIconImage.CorrectIconSize;
Var
  X,Y : Integer;
  BInfo : PBitMapInfoHeader;
begin
  Binfo:=PBitmapInfoHeader(FIconData);
  X:=BInfo^.biWidth;
  Y:=BInfo^.biHeight shr 1;
  IF (X<Y) Then Y:=X else X:=Y;
  FInfo.Width:=X;
  FInfo.Height:=X;
end;

function TIconImage.GetHandle : HIcon;
begin
  IF (FHandle=0) Then begin
    With Info Do
      IF Assigned(FIconData) Then
        FHandle:=CreateIconFromResourceEx(
          FIconData,BytesInRes,True,Win3,Width,Height,LR_DEFAULTCOLOR);
  end;
  Result:=FHandle
end;

procedure TIconImage.WriteIconDataToStream(Stream : TStream);
begin
  IF NOT Assigned(FIcondata) Then exit;
  Stream.Write(FIconData^,Info.BytesInRes);
end;

function TIconImage.GetIcon : TIcon;
begin
  Result:=THiResIcon.Create;
  Result.Handle:=GetHandle;
end;

procedure TIconImage.Draw(Canvas : TCanvas;X,Y : Integer);
begin
  DrawIconEx(Canvas.Handle,X,Y,Handle,Info.Height,Info.Width,0,0,DI_NORMAL);
end;

destructor TIconImage.Destroy;
begin
  DestroyIcon(FHandle);
  IF Assigned(FIconData) Then begin
    Freemem(FIconData,Info.BytesInRes);
  end;
end;

end.
