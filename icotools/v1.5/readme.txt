IconTools

Version 1.5 (Old Version)

****************************************************************************
This version will be th last that bases on TMultiIcon. For more flexibility 
please use the new version 2.0 or higher. 
****************************************************************************


The unit IconTools was written by me because Delphi's TIcon class 
is unable to handle icons that hold multiple resolutions und colorless.
With the help of a documentation that explained the filestructure of 
ICO files and Icons that are included in EXE or DLL files I wrote the 
two main classes:

TFileIcon
TResourceIcon

The behavior of these two classes is a bit different to TIcon.
When you create one these classes you don't get direct an icon that you can 
display.
After creation you can check if the loading process was successful 
(property IconValid : Boolean) and how many subicons (icons that differs in 
resolution or colorless but are stored as one file, normally they show the 
same object) there are (property IconCount).
If you are searching for an icon that fits a special condition use the property
IconResInfo[..]. The first IconResInfo is the IconResInfo[0]. The Header for the last 
icon is the [IconCount-1].
The IconResInfo contains all information about an subicon. (See TIconResInfo record
in IconTools.pas).
Note: Icons with more than 256 colors has ColorCount=0. In this case use the
BitCount member for information about the colorless.

If you have found the right icon, use the Icon property (returns an TIcon) or
the IconHandle property (returns an IconHandle -> HIcon) or draw it direct
onto a Canvas with the procedure Draw.

**********************************
TFileIcon:

When you create a TFileIcon you can choose between to constructors:

constructor Create(Filename : String);
constructor CreateInMem(Filename : String);

The default constructor Create opens the icon file as stream. If you load an Icon
by the Icon[] or IconHandle[] property TFileIcon reads the data directly from file.

The second constructor CreateInMem loads the complete icon into memory. If you load
and Icon the data will be read from memory and not from disk.

**********************************
TResourceIcon:

TResourceIcon has two constructors, too.

constructor Create(AInstance : THandle;ResName : String);
constructor CreateFromID(AInstance : THandle;ResID : Integer);

For reading icons that are identified by a name you have to use Create. 
If the identifier is an ID (Word), use CreateFormID.

**********************************
Saving Icons:

For saving one subicon as ico-file use the SaveIconToFile(Filename,Index) method. 
This way of saving an icon does not reduce the resolution or the color depth.
For saving all subicons into one file, use the SaveToFile(Filename) method.
(SaveToFile makes only sense for TResourceIcon. With TFileIcon.SaveToFile you
create an exact copy of the original file...)

**********************************
Note:
Please do not try to use the TMultiIcon class directly. This is an abstract 
class that makes it possible to store a TFileIcon or a TResourceIcon in one
variable (like TStream and TFileStream, TMemoryStream, TResourceStream,...).

**********************************
THiResIcon

When using TIcon with icons of higher or lower resolution that the system default
(32x32 by default) you can use the third class that is implemented in IconTools.pas
THiResIcon.
THiResIcon is a descendant of TIcon. When you received an Icon by the Icon[] property 
of TFileIcon or TResourecIcon you get an THiResIcon by default. It is "down masked"
into TIcon but internally it works like THiResIcon (this is an advanced feature of 
classes. See you documentation about classes or write me if you have questions).
THiResIcon offers the ability of setting the Height or Width of an Icon (If you try 
this with TIcon you get an error) and it has it's own draw method that automatically 
uses the modifiable icon size. 

**********************************
TIconLibrary

This class gives you the ability to load icons from DLL and EXE files.
It has two constructors:

constructor Create(Filename : String);
constructor CreateSelf;

If you want to load a specific library, use Create.
CreateSelf uses the current process for reading the resources. 

All Icon-resources are loaded into the property IconList : TStringlist.
You can receive a TResourceIcon object when you use the 
IconRes[0..(IconCount-1)] property with the Iconindex, you want to receive.


Feel free to write bugs, hints, ideas and so on to 

Jan Peter Stotz
jpstotz@gmx.de
http://members.tripod.com/~JPStotz
