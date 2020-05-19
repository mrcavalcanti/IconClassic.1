// ??? ???, ??? ???????? ?????????? ?????? ? ????
// ??? ? ????? ??????, ??????? ?? ????? ???? ????? ????? ???? ? ?? ??????? ?????.
// ??? ???????? ??? ????????? "?????????" ?????? ?? ?????, ??? ???????? ??????????????? ?
// ????? ????? ??????, ??? ???????? ?????? ????? ?????? ?? ??????, ??? ???????? ??????
// ?????? ? ????, ??? ??????????????? ?????? ? png, ??? ?????????, ???? ?? ? ?????? alpha-?????,
// ? ??? ??????????????? ?????? ?? 32 ???? ? true color ??? ???????????.
//
// ???? ???????? ?????, ? ??? ????? ?????? ?????????, ?? ? ????? ??????? ???????????
// ? ?????? ??? ?? ??? 
// ???? ????????? ?????? ?????? ????? ??, ?? http://janych.selfip.com/examples/delphi/icons/
//
unit UIcoFiles;

interface
 uses Classes,Graphics,windows;

 type
  TBits=array of Byte;
  TIconData= // ?????? ?? ????????? ??????
   packed record
    Info:TIconRec; // ????????? ?? ????? ??? ????????? ?? ??????
    BitmapInfo, // ????????? ??????, ?????????????? ? ??? ?????????
    MaskBitmapInfo:PBitmapInfo; // ????????? ????? - ? ???? ?? ???????????, ????????? needMaskBitmapInfo
    ImageLineWidth, // ???????????? ? IsValidAlpha ? ConvertToPNG
    MaskLineWidth:Integer; // ???????????? ? ConvertToPNG
    ImageBits:TBits; // ???? ???????????
    MaskBits:TBits; // ???? ?????
    iRgbTable:integer; // ?????? ???????, ?????????? ? BitmapInfo
   end;
  TIcons=array of TIconData; // ????? "?????????" ??????? ?? ?????? ?????
 type
  TIcoFile=
   class(TComponent)
     private
    FIcons:TIcons;
     public
    destructor Destroy;override;
    procedure loadFromStream(Stream:TStream);
    procedure loadFromHandle(h:hicon);
    procedure saveTrueColorFrom32(icoNo:integer;var IconData:TIconData);
    procedure saveToStream(Stream:TStream);
    procedure check;
    procedure draw(icoNo,x,y:integer;dest:hdc;drawMask,drawImage,drawAlpha:boolean);overload;
    procedure draw(IconData:TIconData;x,y:integer;dest:hdc;drawMask,drawImage,drawAlpha:boolean);overload;
    function IsValidAlpha(icoNo:integer):boolean; // ?????????, ???? ?? ?????-?????
    property Icons:TIcons read FIcons write FIcons;
    procedure ConvertToPNG(icoNo:integer;Stream:TStream);
    procedure saveAsPng(icoNo:integer;fn:string);
    procedure Add(IconData:TIconData);
    procedure AddCopy(IconData:TIconData);
   end;
 function getIconHandleForFile(fn:string;large:boolean):hicon;
implementation
 uses sysUtils,
  ShellAPI, // ???????????? ?????? ??? getIconHandleForFile
  pngimage; // ???????????? ?????? ??? ConvertToPNG/saveAsPng, ????? ??????, ???? ?? ?????????
 type
  TRGBQuadArray=array[byte] of TRGBQuad;
  PRGBQuadArray=^TRGBQuadArray;

{ TIcoFile }

    destructor TIcoFile.Destroy;
     var
      i:integer;
     begin
      for i:=low(FIcons) to high(FIcons) do
       with FIcons[i] do
        begin
         if BitmapInfo<>nil
          then
           FreeMem(BitmapInfo,sizeof(BITMAPINFOHEADER)+iRgbTable);
         if MaskBitmapInfo<>nil
          then
           FreeMem(MaskBitmapInfo,sizeof(BITMAPINFOHEADER)+sizeof(RGBQUAD)*2);
         BitmapInfo:=nil;
         MaskBitmapInfo:=nil;
        end;
      inherited;
     end;

    procedure TIcoFile.loadFromStream(Stream:TStream);
     var
      FileHeader:TCursorOrIcon;
      i,Size:integer;
     begin
      Stream.ReadBuffer(FileHeader,SizeOf(FileHeader)); // ?????? ?????????
      if (FileHeader.Reserved<>0) or not (FileHeader.wType in [RC3_ICON,RC3_CURSOR])
       then
        raise Exception.Create('Invalid icon');
      SetLength(FIcons,FileHeader.Count); // ??????? ?????? ??????. ??? ?????? ?? ?????? Stream ?????? 1 ???????
      for i:=0 to FileHeader.Count-1 do // ?????? ????????? ????????? ?????? ????? ?? ??????? ????-???? ?? ?????
       with FIcons[i] do
        Stream.ReadBuffer(Info,SizeOf(TIconRec));
      for i:=0 to FileHeader.Count-1 do
       begin
        with FIcons[i] do
         begin
          Stream.Position:=Info.DIBOffset;

          getMem(BitmapInfo,SizeOf(BitmapInfo^.bmiHeader));
          Stream.ReadBuffer(BitmapInfo^.bmiHeader,SizeOf(BitmapInfo^.bmiHeader)); // ?????? ????????? ???????

          with BitmapInfo^.bmiHeader do
           begin
            if biBitCount>16
             then
              iRgbTable:=0
             else
              if (biBitCount<16)
               then
                iRgbTable:=(1 shl biBitCount)*sizeof(RGBQUAD)
               else
                Assert(false); // ? ?????? ??????? ???????? ?? ????????
           end;

          BitmapInfo:=ReallocMemory(BitmapInfo,sizeof(BITMAPINFOHEADER)+iRgbTable);

          if iRgbTable<>0
           then
            Stream.ReadBuffer(BitmapInfo^.bmiColors,iRgbTable);
          with BitmapInfo^.bmiHeader do
           begin
            ImageLineWidth:=BytesPerScanline(biWidth,biBitCount,32); // ?? ???? ?????????? ?????? ?????

            Assert((biWidth*biBitCount+31) div 32*4=ImageLineWidth);

            Size:=(biHeight div 2)*ImageLineWidth; // ? ?????? ????? ???????
            SetLength(ImageBits,Size); // ???? ???????????
            Stream.ReadBuffer(ImageBits[0],Size); // ??????
            MaskLineWidth:=BytesPerScanline(biWidth,1,32);
            Size:=(biHeight div 2)*MaskLineWidth; // ?????? ????? (1-??????)
            Assert((biWidth+31) div 32*4*(biHeight div 2)=Size);
           end;
          SetLength(MaskBits,Size);
          Stream.ReadBuffer(MaskBits[0],Size); // ??????
         end;
       end;
     end;



 function InternalGetDIB(Bitmap:HBITMAP;var iRgbTable:integer;var BitmapInfo:PBitmapInfo;var Bits:TBits):Boolean;
  var
   DC:HDC;
   DS:TDIBSection;
   Bytes:Integer;
  begin
   iRgbTable:=0;
   getMem(BitmapInfo,SizeOf(BitmapInfo^.bmiHeader));
   try
    FillChar(BitmapInfo^.bmiHeader,sizeof(BitmapInfo^.bmiHeader),0);
    with BitmapInfo^ do
     begin
      DS.dsbmih.biSize:=0;
      Bytes:=GetObject(Bitmap,SizeOf(DS),@DS);
      Assert(Bytes<>0);
      if (Bytes>=(sizeof(DS.dsbm)+sizeof(DS.dsbmih))) and
         (DS.dsbmih.biSize>=DWORD(sizeof(DS.dsbmih)))
       then
        bmiHeader:=DS.dsbmih
       else
        begin
         bmiHeader.biSize:=SizeOf(bmiHeader);
         bmiHeader.biWidth:=DS.dsbm.bmWidth;
         bmiHeader.biHeight:=DS.dsbm.bmHeight;
         bmiHeader.biBitCount:=DS.dsbm.bmBitsPixel;
         bmiHeader.biPlanes:=DS.dsbm.bmPlanes;
        end;
      if bmiHeader.biClrImportant>bmiHeader.biClrUsed
       then
        bmiHeader.biClrImportant:=bmiHeader.biClrUsed;
      if bmiHeader.biSizeImage=0
       then
        bmiHeader.biSizeImage:=BytesPerScanLine(bmiHeader.biWidth,bmiHeader.biBitCount,32)*Abs(bmiHeader.biHeight);


      Assert(bmiHeader.biBitCount<>16);
      Assert(bmiHeader.biCompression=0);
      if bmiHeader.biBitCount>16
       then
        iRgbTable:=0
       else
        if bmiHeader.biClrUsed=0
         then
          iRgbTable:=SizeOf(TRGBQuad)*(1 shl bmiHeader.biBitCount)
         else
          iRgbTable:=SizeOf(TRGBQuad)*bmiHeader.biClrUsed;
      if iRgbTable>0
       then
        BitmapInfo:=ReallocMemory(BitmapInfo,SizeOf(TBitmapInfoHeader)+iRgbTable);

      setLength(Bits,bmiHeader.biSizeImage);
     end;

    DC:=CreateCompatibleDC(0);
    try
     Result:=GetDIBits(DC,Bitmap,0,BitmapInfo^.bmiHeader.biHeight,@Bits[0],BitmapInfo^,DIB_RGB_COLORS)<>0;
    finally
     DeleteDC(DC);
    end;
   except
    freeMem(BitmapInfo,SizeOf(BitmapInfo^.bmiHeader)+iRgbTable);
    raise;
   end;
  end;

    procedure TIcoFile.loadFromHandle(h:hicon);
     var
      IconInfo:TIconInfo;
      Size:Cardinal;
      i:integer;
     begin
      try
       setLength(FIcons,length(FIcons)+1);
       with FIcons[high(FIcons)] do
        begin
         Assert(GetIconInfo(h,IconInfo));

         InternalGetDIB(IconInfo.hbmColor,iRgbTable,BitmapInfo,ImageBits);
         InternalGetDIB(IconInfo.hbmMask,i,MaskBitmapInfo,MaskBits);
// MaskBitmapInfo ????? ???????????? ?????? ??? ?????????, ??? ?????????? ? ???? ??? ?? ?????}

         with Info do
          begin
           Colors:=0;
           Width:=BitmapInfo^.bmiHeader.biWidth;
           Height:=BitmapInfo^.bmiHeader.biHeight;
           Reserved1:=MaskBitmapInfo^.bmiHeader.biBitCount;
           Reserved2:=BitmapInfo^.bmiHeader.biBitCount;
           DIBSize:=MaskBitmapInfo^.bmiHeader.biSizeImage+DWORD(iRgbTable)+BitmapInfo^.bmiHeader.biSize+BitmapInfo^.bmiHeader.biSizeImage;
           DIBOffset:=-1; // ???? ?????????? ??? ??????????.
          end;

         with BitmapInfo^.bmiHeader do
          begin
           ImageLineWidth:=BytesPerScanline(biWidth,biBitCount,32); // ?? ???? ?????????? ?????? ?????

           Assert((biWidth*biBitCount+31) div 32*4=ImageLineWidth);
           Size:=biHeight*ImageLineWidth; // ? ?????? ?????????? ?????? ????? ???????
           Assert(Size=biSizeImage);

           biHeight:=biHeight*2; // ??? ?????? ???? ????? ??-?? ??????? ?????
          end;

         with MaskBitmapInfo^.bmiHeader do
          begin
           MaskLineWidth:=BytesPerScanline(biWidth,biBitCount,32);

           Assert((biWidth+31) div 32*4=MaskLineWidth); // ????????
           Size:=biHeight*MaskLineWidth; // ?????? ????? (1-??????)
           Assert(Size=biSizeImage);
          end;
        end;
      except
       setLength(FIcons,length(FIcons)-1);
      end;
     end;

    procedure TIcoFile.saveTrueColorFrom32(icoNo:integer;var IconData:TIconData);
     var
      useAlpha:boolean;
      Bitmap1,Bitmap2:Graphics.TBitmap;
      Size:integer;
     procedure setNewBitmap(h:HBITMAP);
      begin
       with IconData do
        begin
         if BitmapInfo<>nil
          then
           freeMem(BitmapInfo,sizeOf(BitmapInfo^.bmiHeader)+iRgbTable);
         InternalGetDIB(h,iRgbTable,BitmapInfo,ImageBits);

         with Info do
          begin
           Colors:=0;
           Width:=BitmapInfo^.bmiHeader.biWidth;
           Height:=BitmapInfo^.bmiHeader.biHeight;
           Reserved1:=MaskBitmapInfo^.bmiHeader.biBitCount;
           Reserved2:=BitmapInfo^.bmiHeader.biBitCount;
           DIBSize:=MaskBitmapInfo^.bmiHeader.biSizeImage+DWORD(iRgbTable)+BitmapInfo^.bmiHeader.biSize+BitmapInfo^.bmiHeader.biSizeImage;
           DIBOffset:=-1; // ???? ?????????? ??? ??????????.
          end;
         with BitmapInfo^.bmiHeader do
          begin
           ImageLineWidth:=BytesPerScanline(biWidth,biBitCount,32); // ?? ???? ?????????? ?????? ?????

           Assert((biWidth*biBitCount+31) div 32*4=ImageLineWidth);
           Size:=biHeight*ImageLineWidth; // ????????? ?????? ????? ???????
           Assert(Size=biSizeImage);

           biHeight:=biHeight*2;
          end;

        end;
      end;
     begin
      useAlpha:=FIcons[icoNo].BitmapInfo.bmiHeader.biBitCount=32;
      if useAlpha
       then
        useAlpha:=IsValidAlpha(icoNo);
      try
       IconData:=FIcons[high(FIcons)];

       Bitmap1:=Graphics.TBitmap.Create;
       Bitmap2:=Graphics.TBitmap.Create;
       try

        with IconData do
         begin
          MaskBits:=copy(FIcons[high(FIcons)].MaskBits);
          getMem(MaskBitmapInfo,sizeof(BITMAPINFOHEADER)+sizeof(RGBQUAD)*2);
          move(FIcons[high(FIcons)].MaskBitmapInfo^,MaskBitmapInfo^,sizeof(BITMAPINFOHEADER)+sizeof(RGBQUAD)*2);

          with MaskBitmapInfo^.bmiHeader do
           begin
            Assert(MaskLineWidth=BytesPerScanline(biWidth,biBitCount,32));

            MaskLineWidth:=BytesPerScanline(biWidth,biBitCount,32);
            Assert((biWidth+31) div 32*4=MaskLineWidth);
            Size:=biHeight*MaskLineWidth;

            Assert(Size=biSizeImage);
           end;
          BitmapInfo:=nil; // ??? ????? ???? ????? ??????, ? ?? ????? ?????

          with FIcons[high(FIcons)] do
           begin

            Bitmap2.Width:=Info.Width;
            Bitmap2.Height:=Info.Height;
            Bitmap2.PixelFormat:=pf24bit;

            if useAlpha
             then
              begin
               Bitmap1.Width:=Info.Width;
               Bitmap1.Height:=Info.Height;
               Bitmap1.PixelFormat:=pf24bit;
               Bitmap1.Canvas.Brush.Color:=clWhite;
               Bitmap1.Canvas.FillRect(Rect(0,0,Bitmap1.Width,Bitmap1.Height));

// ?????? ? Bitmap1 ?????? ??? ?? ????? ?????

               setNewBitmap(Bitmap1.Handle);

               Bitmap2.Canvas.Brush.Color:=clWhite;
               Bitmap2.Canvas.FillRect(Rect(0,0,Bitmap2.Width,Bitmap2.Height));
               draw(IconData,0,0,Bitmap2.Canvas.Handle,true,true,false);

// ?????? ?? ?????? ??????? - ????? ??? ?? ????? ?????

               draw(IcoNo,0,0,Bitmap2.Canvas.Handle,true,true,useAlpha);
              end
             else
              begin
// ???? ??? ???????????, ?? ?????? ??????? ?? ?????? ????
               Bitmap2.Canvas.Brush.Color:=clBlack;
               Bitmap2.Canvas.FillRect(Rect(0,0,Bitmap2.Width,Bitmap2.Height));
               draw(IcoNo,0,0,Bitmap2.Canvas.Handle,true,true,useAlpha);
              end;

            setNewBitmap(Bitmap2.Handle);
           end;
         end;
       finally
        Bitmap1.Free;
        Bitmap2.Free;
       end;
      except
       setLength(FIcons,length(FIcons)-1);
      end;
     end;
    procedure TIcoFile.saveToStream(Stream:TStream);
     var
      FileHeader:TCursorOrIcon;
      i:integer;
      offset:integer;
     begin
      FileHeader.Reserved:=0;
      FileHeader.wType:=RC3_ICON;
      FileHeader.Count:=length(FIcons);
      Stream.WriteBuffer(FileHeader,SizeOf(FileHeader));
      offset:=Stream.Position+length(FIcons)*SizeOf(TIconRec); // ??????? ???????? ?????
      for i:=low(FIcons) to high(FIcons) do
       with FIcons[i] do
        begin
         Info.DIBOffset:=offset;
         Stream.WriteBuffer(Info,SizeOf(TIconRec));
         offset:=offset+SizeOf(BitmapInfo^.bmiHeader)+iRgbTable+length(ImageBits)+length(MaskBits);
        end;
      for i:=low(FIcons) to high(FIcons) do
       with FIcons[i] do
        begin
         Stream.WriteBuffer(BitmapInfo^.bmiHeader,SizeOf(BitmapInfo^.bmiHeader)+iRgbTable);
         Stream.WriteBuffer(ImageBits[0],length(ImageBits));
         Stream.WriteBuffer(MaskBits[0],length(MaskBits));
        end;
     end;
    procedure TIcoFile.check;
     var
      i:integer;
     begin
// ??? ????? ?????????, ??? ? ????????? ???????, ??? ? ????. 
// ????? ????? ?????????, ????? ????????? ???????????? ???????? ? ?????? ?? ?????? ??????
// ????? ???????? ?????.
// "????????? - ??? ???????? ? ????."
      for i:=low(FIcons) to high(FIcons) do
       with FIcons[i] do
        begin
         Assert((Info.Reserved1=0)=(Info.Reserved2=0)); // ????? ???? ?????? ????????????
         Assert((Info.Colors<>0) or (Info.Reserved1<>0));
         Assert(Info.Reserved1 in [0,1]);
         with BitmapInfo^.bmiHeader do
          begin
           Assert(biSize=sizeOf(BitmapInfo^.bmiHeader));
           Assert(Info.Width=biWidth);
           Assert(Info.Height*2=biHeight);
           Assert(biPlanes=1);
           Assert(Info.Reserved2 in [0,biBitCount]);
           Assert(biBitCount in [1,4,8,16,24,32]);
           Assert(biCompression=BI_RGB{=0});
           Assert(biXPelsPerMeter=0);
           Assert(biYPelsPerMeter=0);
          end;
        end;
     end;

    procedure TIcoFile.draw(icoNo,x,y:integer;dest:hdc;drawMask,drawImage,drawAlpha:boolean);
     begin
      draw(Icons[icoNo],x,y,dest,drawMask,drawImage,drawAlpha);
     end;
    procedure TIcoFile.draw(IconData:TIconData;x,y:integer;dest:hdc;drawMask,drawImage,drawAlpha:boolean);
     var
      h,hdcColor,hdcMask:hdc;
      pcolorBits:pointer;
      colorBitmap,hOldC,maskBitmap,hOldM:HBITMAP;
      pmaskBits:pointer;
      blend:BLENDFUNCTION;
     procedure needMaskBitmapInfo(var IconData:TIconData);
      begin
       with IconData do
        begin
         if MaskBitmapInfo<>nil
          then
           exit;
// ??? ??? ?????????? ? ???? ?? ????? ?????????
         getMem(MaskBitmapInfo,sizeof(BITMAPINFOHEADER)+sizeof(RGBQUAD)*2);
         FillChar(MaskBitmapInfo^,sizeof(BITMAPINFOHEADER)+sizeof(RGBQUAD)*2,0);

         with MaskBitmapInfo^ do
          begin
           bmiHeader.biSize:=sizeof(BITMAPINFOHEADER);
           bmiHeader.biWidth:=BitmapInfo^.bmiHeader.biWidth;
           bmiHeader.biHeight:=BitmapInfo^.bmiHeader.biHeight;
           bmiHeader.biPlanes:=1;
           bmiHeader.biBitCount:=1;
           bmiHeader.biSizeImage:=length(MaskBits);
           bmiColors[0].rgbReserved:=0;
           bmiColors[0].rgbRed:=0;
           bmiColors[0].rgbBlue:=0;
           bmiColors[0].rgbGreen:=0;
           with PRGBQuadArray(@bmiColors)^[1] do
            begin
             rgbReserved:=0;
             rgbRed:=255;
             rgbBlue:=255;
             rgbGreen:=255;
            end;
          end;
        end;
      end;
     begin
      h:=GetDC(0);
      pcolorBits:=nil;
      colorBitmap:=CreateDIBSection(h,IconData.BitmapInfo^,DIB_RGB_COLORS,pcolorBits,0,0);
      hdcColor:=CreateCompatibleDC(h);
      ReleaseDC(0,h);
      hOldC:=SelectObject(hdcColor,colorBitmap);
      with IconData do
       begin
        if not drawAlpha
         then
          begin
           needMaskBitmapInfo(IconData);
           pmaskBits:=nil;
           maskBitmap:=CreateDIBSection(0,MaskBitmapInfo^,DIB_RGB_COLORS,pmaskBits,0,0);
           hdcMask:=CreateCompatibleDC(0);
           hOldM:=SelectObject(hdcMask,maskBitmap);
           SetDIBitsToDevice(hdcMask,0,0,Info.Width,Info.Height,0,0,0,Info.Height,MaskBits,MaskBitmapInfo^,DIB_RGB_COLORS);
           if drawMask
            then
             BitBlt(dest,0,0,Info.Width,Info.Height,hdcMask,0,0,SRCAND);
          end
         else
          begin // ????????? ????? ???????????
           hdcMask:=0;
           maskBitmap:=0;
           hOldM:=0;
          end;
        SetDIBitsToDevice(hdcColor,0,0,Info.Width,Info.Height,0,0,0,Info.Height,ImageBits,BitmapInfo^,DIB_RGB_COLORS);

        if drawImage
         then
          if not drawAlpha
           then
            BitBlt(dest,0,0,Info.Width,Info.Height,hdcColor,0,0,SRCINVERT)
           else
            begin
// ?????????????? ????????? ??? ????? ?????-?????? ???????
             blend.BlendOp:=AC_SRC_OVER;
             blend.BlendFlags:=0;
             blend.SourceConstantAlpha:=255;
             blend.AlphaFormat:=AC_SRC_ALPHA;
             windows.AlphaBlend(dest,0,0,Info.Width,Info.Height,hdcColor,0,0,Info.Width,Info.Height,blend);
            end;
       end;

//??????????? ??????????????? ??????? GDI ? ?????????? ???????????? ???????, ????? ???????? ?????? ????????, ?????????? ???????? ?????? ??????????.

      SelectObject(hdcColor,hOldC);
      if not drawAlpha
       then
        begin
         SelectObject(hdcMask,hOldM);
         DeleteObject(hdcMask);
         DeleteObject(maskBitmap);
        end;
      DeleteObject(hdcColor);
      DeleteObject(colorBitmap);
     end;
    function TIcoFile.IsValidAlpha(icoNo:integer):boolean;
    var
        X,Y:integer;
        Line32:PRGBQuadArray;
    begin
        Result := False;
        with Icons[icoNo] do
        begin
            if BitmapInfo.bmiHeader.biBitCount<=24 then
                exit;

            for Y:=0 to Info.Height-1 do
            begin
                Line32:=@ImageBits[Y*ImageLineWidth];
                for X:=0 to Info.Width-1 do // ?????? shGetFileInfo ?????????? ?????? ? ?????? ?????-???????
                begin
                    if not (Line32[X].rgbReserved=0) then
                    begin
                        result:=true;
                        break;
                    end;
                end;
                if (Result) then
                    break;
            end;
        end;
    end;
 function getIconHandleForFile(fn:string;large:boolean):hicon;
  var
   shfi:TShFileInfo;
   flag:integer;
  begin
   fillChar(shfi,SizeOf(TShFileInfo),0);
   if large
    then
     flag:=SHGFI_LARGEICON
    else
     flag:=SHGFI_SMALLICON;
   shGetFileInfo(pchar(fn),0,shfi,SizeOf(shfi),SHGFI_ICON or flag or SHGFI_SYSICONINDEX);
   result:=shfi.hIcon;
  end;
 type
  TChunkIHDRHack=
   class(TChunkIHDR);

 procedure Convert(const PNG:TPNGObject;const IconData:TIconData);
  var
   X,Y,Y2,BitCount:Integer;
   BitBuf:Byte;
   Line32:PRGBQuadArray;
   PNGLine:pRGBLine;
   Alpha:PByteArray;
   Mask:PByte;
   OnlyAlpha:boolean;
  begin
   with
    IconData do
    begin

     PNG.Header.Width:=Info.Width;
     PNG.Header.Height:=Info.Height;
     PNG.Header.BitDepth:=8;
     PNG.Header.ColorType:=COLOR_RGBALPHA;
     TChunkIHDRHack(PNG.Header).PrepareImageData;
     BitBuf:=0;
     onlyAlpha:=true;
     for Y:=0 to Info.Height-1 do
      begin
       Line32:=@ImageBits[Y*ImageLineWidth];
       for X:=0 to Info.Width-1 do
        if Line32[X].rgbReserved=0
         then
          begin
           onlyAlpha:=false;
           break;
          end;
       if not onlyAlpha
        then
         break;
      end;
     for Y:=0 to Info.Height-1 do
      begin
       Line32:=@ImageBits[Y*ImageLineWidth];
       Mask:=@MaskBits[Y*MaskLineWidth];
       Y2:=Info.Height-Y-1;
       Alpha:=PNG.AlphaScanline[Y2];
       PNGLine:=PNG.ScanLine[Y2];
       BitCount:=0;
       for X:=0 to Info.Width-1 do
        begin
         if BitCount=0
          then
           begin
            BitCount:=8;
            BitBuf:=Mask^;
            Inc(Mask);
           end;
         if BitBuf and $80=0
          then
           with PNGLine[X],Line32[X] do
            begin
             rgbtRed:=rgbRed;
             rgbtGreen:=rgbGreen;
             rgbtBlue:=rgbBlue;
             if not onlyAlpha
              then
               Alpha[X]:=rgbReserved
              else
               Alpha[X]:=$FF;
            end
          else
           with PNGLine[X] do
            begin
             rgbtRed:=0;
             rgbtGreen:=0;
             rgbtBlue:=0;
             Alpha[X]:=0;
            end;
         BitBuf:=BitBuf shl 1;
         Dec(BitCount);
        end;
      end;
    end;
  end;

    procedure TIcoFile.ConvertToPNG(icoNo:integer;Stream:TStream);
     var
      PNG:TPNGObject;
      C:TChunkIHDR;
     begin
      with
       Icons[icoNo] do
       begin
        Assert(BitmapInfo.bmiHeader.biBitCount>=24);
        if IsValidAlpha(icoNo)
         then
         begin                     //mrcavalcanti - 10/11/2008
          PNG:=TPNGObject.Create; //CreateBlank(COLOR_RGBALPHA,8,Info.Width,Info.Height)

  {Important chunks}
  RegisterChunk(TChunkIEND);
  RegisterChunk(TChunkIHDR);
  RegisterChunk(TChunkIDAT);
  RegisterChunk(TChunkPLTE);
  RegisterChunk(TChunkgAMA);
  RegisterChunk(TChunktRNS);

  {Not so important chunks}
  RegisterChunk(TChunktIME);
  RegisterChunk(TChunktEXt);
  RegisterChunk(TChunkzTXt);


         end
         else
          PNG:=TPNGObject.Create;// CreateBlank(COLOR_RGB,8,Info.Width,Info.Height);
          C := TChunkIHDR.Create(PNG);
          PNG.Chunks.Add(TChunkClass(C));
          //PNG.Header.ColorType := COLOR_RGB;
          //PNG.Header.BitDepth := 8;
          //PNG.Width := Info.Width;
          //PNG.Height := Info.Height;
        try
         Convert(PNG,Icons[icoNo]);
         PNG.CompressionLevel:=9;
         PNG.SaveToStream(Stream);
        finally
         PNG.Free;
        end;
       end;
     end;

    procedure TIcoFile.saveAsPng(icoNo:integer;fn:string);
     var
      Stream:TStream;
     begin
      Stream:=TFileStream.Create(fn,fmCreate);
      try
       ConvertToPNG(icoNo,Stream);
      finally
       Stream.Free;
      end;
     end;

    procedure TIcoFile.Add(IconData:TIconData);
     begin
      setLength(FIcons,length(FIcons)+1);
      Icons[high(FIcons)]:=IconData;
     end;

    procedure TIcoFile.AddCopy(IconData:TIconData);
     begin
      setLength(FIcons,length(FIcons)+1);

      Icons[high(FIcons)]:=IconData;
      with Icons[high(FIcons)] do
       begin
        ImageBits:=copy(IconData.ImageBits);
        MaskBits:=copy(IconData.MaskBits);
        getMem(BitmapInfo,sizeof(BITMAPINFOHEADER)+iRgbTable);
        getMem(MaskBitmapInfo,sizeof(BITMAPINFOHEADER)+sizeof(RGBQUAD)*2);
        move(IconData.BitmapInfo^,BitmapInfo^,sizeof(BITMAPINFOHEADER)+iRgbTable);
        move(IconData.MaskBitmapInfo^,MaskBitmapInfo^,sizeof(BITMAPINFOHEADER)+sizeof(RGBQUAD)*2);
       end;
     end;
end.
