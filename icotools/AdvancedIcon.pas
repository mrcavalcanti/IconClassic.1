//         ___       __                                ______
//        /   | ____/ /   ______ _____  ________  ____/ /  _/________  ____
//       / /| |/ __  / | / / __ `/ __ \/ ___/ _ \/ __  // // ___/ __ \/ __ \
//      / ___ / /_/ /| |/ / /_/ / / / / /__/  __/ /_/ // // /__/ /_/ / / / /
//     /_/  |_\__,_/ |___/\__,_/_/ /_/\___/\___/\__,_/___/\___/\____/_/ /_/
//

(*******************************************************************************
* AdvancedIcon                                                                 *
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

unit AdvancedIcon;

interface

uses
  Windows, SysUtils, Classes, Graphics, IconTypes, IconImage;

type
  TAdvancedIcon = class;
  TIconImageList = class;

  TAdvancedIcon = class
  private
    FImages : TIconImageList;
  protected
    function LoadHeader(Stream : TStream;Var IconCount : Word) : Boolean;
  public
    function LoadFromFile(Filename : String) : Boolean;
    function LoadFromResource(Instance : THandle;ResourceName : PChar) : Boolean;
    function LoadFromResourceID(Instance : THandle;ResourceID : Integer) : Boolean;
    function LoadFromResourceName(Instance : THandle;ResourceName : String) : Boolean;

    procedure SaveToStream(Stream : TStream);
    procedure SaveToFile(Filename : String);
    procedure Assign(Source : TAdvancedIcon); virtual;

    constructor Create; virtual;
    destructor Destroy; override;

    property Images : TIconImageList read FImages;
  end;

  TIconImageList = class
  private
    FList     : PPointerList;
    FCount    : Word;
    FCapacity : Word;
    function GetIconImage(Index : Word) : TIconImage;
    procedure SetCapacity(Value : Word);
  protected
    procedure DeleteImage(Index : Word;FreeImage : Boolean);
  public
    procedure Add(IconImage : TIconImage);
    procedure Delete(Index : Word);
    procedure AddFromIconImageList(IconSource : TAdvancedIcon;Index : Word);
    //Moves the IconImage at Index in IconSource into this IconImageList   

    procedure Clear;
    procedure SortByResolution; //Sort IconImages by their size (width and height)
    procedure SortByColor;      //Sort IconImages by their colordepth

    constructor Create;
    destructor Destroy; override;

    property Count : Word read FCount;
    property Image[Index : Word] : TIconImage read GetIconImage;
    property Capacity : Word read FCapacity write SetCapacity;
  end;


implementation

function IconImageColorSort(Item1, Item2: TIconImage): Integer;
Var
  A,B : Integer;
begin
  A:=Item1.Info.BitCount;
  B:=Item2.Info.BitCount;
  IF A=B Then begin
    A:=Item1.Info.Width;
    B:=Item2.Info.Width;
    IF A=B Then begin
     Result:=0;
    end else
      Result:=(2*Integer(A>B))-1;
  end else
    Result:=(2*Integer(A>B))-1;
end;

function IconImageResolutionSort(Item1, Item2: TIconImage): Integer;
Var
  A,B : Integer;
begin
  A:=Item1.Info.Width;
  B:=Item2.Info.Width;
  IF A=B Then begin
    A:=Item1.Info.BitCount;
    B:=Item2.Info.BitCount;
    IF A=B Then begin
     Result:=0;
    end else
      Result:=(2*Integer(A>B))-1;
  end else
    Result:=(2*Integer(A>B))-1;
end;

procedure QuickSort(SortList: PPointerList; L, R: Integer;
  SCompare: TListSortCompare);
var
  I, J: Integer;
  P, T: Pointer;
begin
  repeat
    I := L;
    J := R;
    P := SortList^[(L + R) shr 1];
    repeat
      while SCompare(SortList^[I], P) < 0 do Inc(I);
      while SCompare(SortList^[J], P) > 0 do Dec(J);
      if I <= J then
      begin
        T := SortList^[I];
        SortList^[I] := SortList^[J];
        SortList^[J] := T;
        Inc(I);
        Dec(J);
      end;
    until I > J;
    if L < J then QuickSort(SortList, L, J, SCompare);
    L := I;
  until I >= R;
end;

procedure TIconImageList.SortByResolution;
begin
  QuickSort(FList,0,Count-1,TListSortCompare(@IconImageResolutionSort));
end;

procedure TIconImageList.SortByColor;
begin
  QuickSort(FList,0,Count-1,TListSortCompare(@IconImageColorSort));
end;

constructor TAdvancedIcon.Create;
begin
  FImages:=TIconImageList.Create;
end;

destructor TAdvancedIcon.Destroy;
begin
  FImages.Free;
end;
constructor TIconImageList.Create;
begin
  FList:=nil;
  FCount:=0;
  FCapacity:=0;
end;

procedure TIconImageList.SetCapacity(Value : Word);
begin
  IF Value<FCount Then Value:=FCount;
  ReallocMem(FList,Value * SizeOf(Pointer));
  FCapacity:=Value;
end;

procedure TIconImageList.Add(IconImage : TIconImage);
begin
  INC(FCount);
  IF FCount>FCapacity Then SetCapacity(FCount);
  FList^[FCount-1] := IconImage;
end;

procedure TIconImageList.Delete(Index : Word);
begin
  DeleteImage(Index,True);
end;

procedure TIconImagelist.DeleteImage(Index : Word;FreeImage : Boolean);
begin
  IF Index>=FCount Then exit;
  IF FreeImage Then TIconImage(FList^[Index]).Free;
  Dec(FCount);  if Index < FCount then System.Move(FList^[Index + 1], FList^[Index],(FCount - Index) * SizeOf(Pointer));
end;

procedure TIconImageList.AddFromIconImageList(IconSource : TAdvancedIcon;Index : Word);
Var
  Image : TIconImage;
begin
  IF NOT Assigned(IconSource) Then exit;
  Image:=IconSource.Images.Image[Index];
  IF NOT Assigned(Image) Then exit;
  IconSource.Images.DeleteImage(Index,False);
  Add(Image);
end;

function TIconImageList.GetIconImage(Index : Word) : TIconImage;
begin
  Result:=nil;
  IF Index>FCapacity Then exit;
  Result:=FList^[Index];
end;

procedure TIconImageList.Clear;
Var
  I : Integer;
begin
  IF Assigned(FList) Then begin
    FOR I:=1 TO FCount DO TIconImage(FList^[I-1]).free;
    Freemem(FList);
    FList:=nil;
  end;
  FCapacity:=0;
  FCount:=0;
end;

destructor TIconImageList.Destroy;
begin
  Clear;
  inherited;
end;

procedure TAdvancedIcon.Assign(Source : TAdvancedIcon);
Var
  I : Integer;
  SourceImage,DestImage : TIconImage;
begin
  Images.Clear;
  Images.Capacity:=Source.Images.Count;
  FOR I:=1 TO Source.Images.Count DO begin
    SourceImage:=Source.Images.Image[I-1];
    IF Assigned(SourceImage) Then begin
      DestImage:=TIconImage.CreateCopy(SourceImage);
      Images.Add(DestImage);
    end;
  end;  
end;

function TAdvancedIcon.LoadHeader(Stream : TStream;Var IconCount : Word) : Boolean;
Var
  Header : TIconHeader;
begin
  Result:=false;
  with Stream DO begin
    Read(Header,SizeOf(Header));
    IF NOT ((Header.wReserved=0) AND (Header.wType=1)) Then exit;
    IconCount:=Header.wCount;
    Images.Capacity:=IconCount;
    Result:=True;
  end;
end;

function TAdvancedIcon.LoadFromResource(Instance : THandle;ResourceName : PChar) : Boolean;
Var
  Stream : TResourceStream;
  I      : Integer;
  Image  : TIconImage;
  IconCount : Word;
begin
  Result:=false;
  IF IsBadStringPtr(ResourceName,63) Then
    Stream:=TResourceStream.CreateFromID(Instance,Integer(Resourcename),RT_Group_Icon)
  else
    Stream:=TResourceStream.Create(Instance,Resourcename,RT_Group_Icon);
  with Stream DO
  try
    IF NOT LoadHeader(Stream,IconCount) Then exit;
    FOR I:=1 TO IconCount DO begin
      Image:=TResourceIconImage.Create(Stream,Instance);
      IF Assigned(Image) Then Images.add(Image);
    end;         
    Result:=True;
  finally
    Stream.Free;
  end;
end;

function TAdvancedIcon.LoadFromResourceID(Instance : THandle;ResourceID : Integer) : Boolean;
begin
  Result:=LoadFromResource(Instance,MakeIntResource(ResourceID));
end;

function TAdvancedIcon.LoadFromResourceName(Instance : THandle;ResourceName : String) : Boolean;
begin
  Result:=LoadFromResource(Instance,PChar(ResourceName));
end;

function TAdvancedIcon.LoadFromFile(Filename : String) : Boolean;
Var
  Stream    : TFileStream;
  IconCount : Word;
  I         : Integer;
  Image     : TIconImage;
begin
  Result:=False;
  Images.Clear;
  Stream:=TFileStream.Create(Filename,fmOpenRead or fmShareDenyWrite);
  with Stream do
  try
    IF NOT LoadHeader(Stream,IconCount) Then exit;
    FOR I:=1 TO IconCount DO begin
      Image:=TFileIconImage.Create(Stream);
      IF Assigned(Image) Then Images.add(Image);
    end;
    Result:=True;  
  finally
    Free;
  end;
end;

procedure TAdvancedIcon.SaveToStream(Stream : TStream);
Var
  Header : TIconHeader;
  ResInfo : TFileIconResInfo;
  I : Integer;
  StartPos,StreamPos : DWord;
begin
  IF Images.Count=0 Then exit;
  With Header do begin
    wReserved:=0;
    wType    :=1;
    wCount   :=Images.Count;
  end;
  With Stream do begin
    StartPos:=Position;
    Write(Header,SizeOf(Header));
    FOR I:=1 TO Images.Count DO begin
      ResInfo.ResInfo:=Images.Image[I-1].Info;
      ResInfo.dwImageOffset:=0;
      Write(ResInfo,SizeOf(ResInfo));
    end;
    FOR I:=1 TO Images.Count DO begin
      StreamPos:=Position-StartPos;
      Position:=SizeOf(Header)+(I*SizeOf(ResInfo))-SizeOf(DWord);
      Write(StreamPos,SizeOf(StreamPos));
      Position:=StreamPos;
      Images.Image[I-1].WriteIconDataToStream(Stream);
    end;
  end;
end;

procedure TAdvancedIcon.SaveToFile(Filename : String);
Var
  Stream : TMemoryStream;
begin
  Stream:=TMemoryStream.Create;
  try
    SaveToStream(Stream);
    IF Stream.Size>0 Then Stream.SaveToFile(Filename);
  finally
    Stream.Free;
  end;
end;

end.
