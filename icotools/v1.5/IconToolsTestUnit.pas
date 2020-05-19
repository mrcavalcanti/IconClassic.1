unit IconToolsTestUnit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IconTools, StdCtrls, Spin, ExtCtrls, Menus, IconLibrary, IconTypes;

type
  TFormIconTest = class(TForm)
    IconListBox: TListBox;
    OpenDialog1: TOpenDialog;
    CountLabel: TPanel;
    Panel2: TPanel;
    Panel1: TPanel;
    Image1: TImage;
    ShowSingleIcon: TButton;
    IconIndex: TSpinEdit;
    LoadIcoFile: TButton;
    CloseButton: TButton;
    LoadResIco: TButton;
    PopupMenu1: TPopupMenu;
    WorldIco: TMenuItem;
    HelpIco: TMenuItem;
    Main: TMenuItem;
    IconInfo: TListBox;
    SaveSubIcon: TButton;
    SaveDialog1: TSaveDialog;
    SaveIcon: TButton;
    LibraryIcons: TListBox;
    OpenDialog2: TOpenDialog;
    LoadICLLibrary: TButton;
    SaveICLLibrary: TButton;
    SaveDialog2: TSaveDialog;
    AddIconToLib: TButton;
    EmptyLibrary: TButton;
    procedure ShowSingleIconClick(Sender: TObject);
    procedure IconListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LoadIcoFileClick(Sender: TObject);
    procedure IconInfoClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure MainClick(Sender: TObject);
    procedure LoadResIcoClick(Sender: TObject);
    procedure IconListBoxDblClick(Sender: TObject);
    procedure SaveSubIconClick(Sender: TObject);
    procedure SaveIconClick(Sender: TObject);
    procedure LibraryIconsClick(Sender: TObject);
    procedure LoadICLLibraryClick(Sender: TObject);
    procedure SaveICLLibraryClick(Sender: TObject);
    procedure AddIconToLibClick(Sender: TObject);
    procedure EmptyLibraryClick(Sender: TObject);
  private
    { Private declarations }
  public
    Ico : TMultiIcon;
    ICL : TIconLibrary;
    procedure FreeIco;
    procedure IconLoaded;
    procedure LoadDefaultIcon;
    procedure ListIcons;
    procedure LibraryLoaded;
  end;

var
  FormIconTest: TFormIconTest;

implementation

{$R *.DFM}
{$R Icons.res}

procedure TFormIconTest.LoadDefaultIcon;
begin
  Ico:=TResourceIcon.Create(HInstance,'WORLD');
  IconLoaded;
end;

procedure TFormIconTest.ShowSingleIconClick(Sender: TObject);
Var
  H : TIcon;
begin
  H:=Ico.Icon[IconIndex.Value-1];
{  Image1.Picture:=nil;
  Image1.Canvas.Draw(0,0,H);}
  Image1.Picture.Icon:=H;
end;

procedure TFormIconTest.IconLoaded;
begin

  CountLabel.Caption:=Format('Number of Subicons: %d',[Ico.IconCount]);
  IconIndex.MaxValue:=Ico.IconCount;
  IconIndex.Enabled:=(Ico.IconCount>1);
  IF Ico.IconValid Then IconIndex.Value:=1 else
    IconIndex.Value:=0;
  ListIcons;
  IconInfoClick(nil);
end;

procedure TFormIconTest.FreeIco;
begin
  IF Assigned(Ico) Then Ico.Free;
  Ico:=nil;
end;

procedure TFormIconTest.ListIcons;
Var
  I : Integer;
  H : Integer;
begin
  IconListBox.Items.Clear;
  IconListBox.Items.BeginUpdate;
  H:=0;
  FOR I:=1 TO Ico.IconCount DO begin
    IconListBox.Items.Add(InttoStr(I));
    With Ico.IconResInfo[I-1] DO begin
      IF Height>H Then H:=Height;
      IF Width>H  Then H:=Width;
    end;
  end;
  IconListBox.ItemHeight:=H;
  IconListBox.Items.EndUpdate;
  IF IconListBox.Items.Count>0 Then IconListBox.ItemIndex:=0;
  IconInfo.Enabled:=(IconListBox.Items.Count>0)
end;

procedure TFormIconTest.IconListBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
Var
  H : Integer;
  S : String;
  P : TSize;
begin
  IF NOT Assigned(Ico) Then exit;
  With TListBox(Control) DO begin
    H:=ItemHeight;
    With Canvas DO begin
      With Ico.IconResInfo[Index] DO begin
        FillRect(Rect);
        IF rect.Left=0 Then Ico.Draw(Canvas,Rect.Left+((H-Width)DIV 2),Rect.Top+((H-Height)DIV 2),Index);
        S:=(Control as TListBox).Items[Index];
        P:=TextExtent(S);
        TextOut(Rect.Left + H+7, Rect.Top+((H-P.cy) DIV 2),S);
//        IF (odSelected in State) Then InvertRect(Canvas.Handle,Classes.Rect(Rect.Left+H+2,Rect.Top,Rect.Right,Rect.Bottom) );
      end;
    end;
  end;

end;

procedure TFormIconTest.FormShow(Sender: TObject);
begin
  LoadDefaultIcon;
end;

procedure TFormIconTest.FormDestroy(Sender: TObject);
begin
  IF Assigned(ICL) Then ICL.Free;
  FreeIco;
end;

procedure TFormIconTest.LoadIcoFileClick(Sender: TObject);
Var
  I : TMultiIcon;
begin
  IF OpenDialog1.Execute Then begin
    I:=TFileIcon.Create(OpenDialog1.Filename);
    IF I.IconValid Then begin
      FreeIco;
      Ico:=I;
      IconLoaded;
    end else begin
      I.Free;
      ShowMessage('Error Loading Ico');
    end;
  end;
end;




procedure TFormIconTest.IconInfoClick(Sender: TObject);
const
  Co : ARRAY[1..7] OF String =
  ('SubIconnumber: %d','Width: %d','Height: %d',
   'ColorCount: %d','Planes: %d','BitCount: %d',
   'Size in bytes: %d');

Var
  Header : TIconResInfo;
  C : Cardinal;
begin
  Header:=Ico.IconResInfo[IconListBox.ItemIndex];
  IconInfo.Items.Beginupdate;
  try
    IF Header.BitCount>0 Then
      C:=2 shl (Header.BitCount-1)
    else C:=Header.ColorCount;
    IconInfo.Items.Clear;
    IconInfo.Items.Add(Format(Co[1],[IconListBox.ItemIndex+1]));
    IconInfo.Items.Add(Format(Co[2],[Header.Width]));
    IconInfo.Items.Add(Format(Co[3],[Header.Height]));
    IconInfo.Items.Add(Format(Co[4],[Header.ColorCount]));
    IconInfo.Items.Add(Format(Co[5],[Header.Planes]));
    IconInfo.Items.Add(Format(Co[6],[Header.BitCount]));
    IconInfo.Items.Add(Format(Co[7],[Header.BytesInRes]));

    IconInfo.Items.Add(Format('Colors: %d',[C]));
  finally
    IconInfo.Items.EndUpdate;
  end;
end;

procedure TFormIconTest.CloseButtonClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFormIconTest.MainClick(Sender: TObject);
begin
  FreeIco;
  Ico:=TResourceIcon.Create(HInstance,TMenuItem(Sender).Caption);
  IconLoaded;
end;

procedure TFormIconTest.LoadResIcoClick(Sender: TObject);
Var
  P : TPoint;
begin
  P.X:=LoadResIco.Top;
  P.Y:=LoadResIco.Left;
  P:=LoadResIco.ClientToScreen(P);
  PopupMenu1.Popup(P.X,P.Y);
end;

procedure TFormIconTest.IconListBoxDblClick(Sender: TObject);
begin
  IconInfoClick(nil);
end;

procedure TFormIconTest.SaveSubIconClick(Sender: TObject);
begin
  IF IconListBox.ItemIndex<0 Then begin
    beep;
    exit;
  end;
  IF SaveDialog1.Execute Then begin
    Ico.SaveIconToFile(SaveDialog1.Filename,IconListBox.ItemIndex);
  end;
end;

procedure TFormIconTest.SaveIconClick(Sender: TObject);
begin
  IF SaveDialog1.Execute Then begin
    Ico.SaveToFile(SaveDialog1.Filename);
  end;
end;

procedure TFormIconTest.LibraryLoaded;
begin
  IF Assigned(ICL) Then begin
    LibraryIcons.Items.Assign(ICL.Icons);
    IF LibraryIcons.Items.Count>0 Then begin
      LibraryIcons.ItemIndex:=0;
      LibraryIconsClick(nil);
    end;
  end;
end;

procedure TFormIconTest.LibraryIconsClick(Sender: TObject);
Var
  Index : Integer;
begin
  Index:=LibraryIcons.ItemIndex;
  IF (Index<0) OR (Index>=ICL.Icons.Count) Then exit;
  Ico:=TMultiIcon(ICL.Icons.Objects[Index]);
  IconLoaded;
end;

procedure TFormIconTest.LoadICLLibraryClick(Sender: TObject);
Var
  NewICL : TIconLibrary;
begin
  IF OpenDialog2.Execute Then begin
    NewICL:=TIconLibrary.Create;
    NewICL.LoadFromFile(OpenDialog2.Filename);
    IF NewICL.Icons.Count>0 Then begin
      IF Assigned(ICL) Then ICL.Free;
      ICL:=nil;
      ICL:=NewICL;
      LibraryLoaded;
    end;
  end;
end;

procedure TFormIconTest.SaveICLLibraryClick(Sender: TObject);
begin
  IF NOT Assigned(ICL) Then begin
    beep;
    exit;
  end;
  IF SaveDialog2.Execute Then ICL.SaveToFile(SaveDialog2.Filename);
end;

procedure TFormIconTest.AddIconToLibClick(Sender: TObject);
Var
  I : TMultiIcon;
begin
  IF NOT Assigned(ICL) Then begin
    beep;
    exit;
  end;
  IF OpenDialog1.Execute Then begin
    I:=TFileIcon.Create(OpenDialog1.Filename);
    IF I.IconValid Then begin
      ICL.Icons.addObject(ExtractFilename(OpenDialog1.Filename),I);
      LibraryLoaded;
    end else begin
      I.Free;
      beep;
    end;
  end;
end;


procedure TFormIconTest.EmptyLibraryClick(Sender: TObject);
begin
  ICL:=TIconLibrary.Create;
  LibraryLoaded;
end;

end.
