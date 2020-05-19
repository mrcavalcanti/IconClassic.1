//                ____               ______
//               /  _/________  ____/_  __/_  ______  ___  _____
//               / // ___/ __ \/ __ \/ / / / / / __ \/ _ \/ ___/
//             _/ // /__/ /_/ / / / / / / /_/ / /_/ /  __(__  )
//            /___/\___/\____/_/ /_/_/  \__, / .___/\___/____/
//                                     /____/_/

(*******************************************************************************
* IconTypes                                                                    *
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
* Date last modified:   May 12, 1999                                           *
*******************************************************************************)

unit IconTypes;

interface

Uses
  Windows;

const
  Win3 = $30000;

type
//**********************************************************
//**                    IconTools                         **
//**********************************************************

  TIconHeader = packed record
    wReserved: Word;      //    Currently zero
    wType: Word;          //    1 for icons
    wCount: Word;         //    Number of components
  end;

  PIconResInfo = ^TIconResInfo;
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

  TResourceIconResInfo = packed record
    ResInfo       : TIconResInfo;
    ID            : Word;          // the ID
  end;

  PResourceIconDirList = ^TResourceIconDirList;
  TResourceIconDirList = ARRAY[0..0] OF TResourceIconResInfo;

  PFileIconDirList = ^TFileIconDirList;
  TFileIconDirList = ARRAY[0..0] OF TFileIconResInfo;

  PIconHandleList = ^TIconHandleList;
  TIconHandleList = ARRAY[0..0] OF HIcon;

//**********************************************************
//**                   IconLibrary                        **
//**********************************************************

  PNameRec = ^TNameRec;
  TNameRec = packed record
    rnOffset : WORD;
    rnLength : WORD;
    rnFlags  : WORD;
    rnID     : WORD;
    rnHandle : WORD;
    rnUsage  : WORD;
  end;

  PNameRecArray = ^TNamerecArray;
  TNameRecArray = ARRAY[0..0] OF TNameRec;

  PPointerArray = ^TPointerArray;
  TPointerArray = ARRAY[0..0] OF Pointer;

  TTypeRec = packed record
    rtTypeID        : WORD;
    rtResourceCount : WORD;
    rtReserved      : DWORD;
  end;

  PNameInfo = ^TNameInfo;
  TNameInfo = ARRAY[0..0] OF TNameRec;

  TTypeInfo = packed record
    TypeInfo : TTypeRec;
    NameInfo : Pointer;
  end;

  PDWordArray = ^TDWordArray;
  TDWordArray = ARRAY[0..0] Of DWord;

implementation

end.
