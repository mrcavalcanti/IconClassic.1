Welcome to the new version 2.01 of IconTools

SHAREWARE (free for non-commercial users)

**********************************************************

Note for user of previous version of IconTools 
(Version 1 to 1.5):

This new IconTools package is incompatible to TMultiIcon.

Only THiResIcon has not changed. 
It is part of all version of IconTools

**********************************************************

                Jan Peter Stotz (Germany)

To contact me please write to      JPStotz@gmx.de

**********************************************************

Now IconTools consits of only three classes that the user
had to know :


	TAdvancedIcon
	TIconImage (formerly called subicon)
	TIconImageList

	TIconLibrary.


TAdvancedIcon (AdvancedIcon.pas):
==================================

	function LoadFromFile(Filename : String) : Boolean;
	function LoadFromResource(Instance : THandle;ResourceName : PChar) : Boolean;
	function LoadFromResourceID(Instance : THandle;ResourceID : Integer) : Boolean;
	function LoadFromResourceName(Instance : THandle;ResourceName : String) : Boolean;

	procedure SaveToFile(Filename : String);
	procedure Assign(Source : TAdvancedIcon); virtual;

	property Images : TIconImageList;


TIconImageList (AdvancedIcon.pas):
==================================

	procedure Add(IconImage : TIconImage);
	procedure Delete(Index : Word);
	procedure AddFromIconImageList(IconSource : TAdvancedIcon;Index : Word);
	procedure Clear;
	procedure SortByResolution;
	procedure SortByColor;

	property Count : Word;
	property Image[Index : Word] : TIconImage;



TIconImage (IconImage.pas):
===========================



	constructor CreateCopy(Source : TIconImage);

	procedure Draw(Canvas : TCanvas;X,Y : Integer);

	property Handle     : HIcon;
	property Icon       : TIcon; //returns a THiResIcon as TIcon
	property Info       : TIconResInfo;

	TIconResInfo (IconTypes.pas)
		Width        : Byte;    // Width, in pixels, of the image
		Height       : Byte;    // Height, in pixels, of the image
		ColorCount   : Byte;    // Number of colors in image (0 if >=8bpp)
		Reserved     : byte;    // Reserved ( must be 0)
		Planes       : Word;    // Color Planes
		BitCount     : Word;    // Bits per pixel
		BytesInRes   : DWord;   // How many bytes in this resource?



