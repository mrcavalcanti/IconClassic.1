unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IconImage, IconLibrary, StdCtrls, ExtCtrls, ShellApi, Menus, IconTools,
  AdvancedIcon, Grids;

type
  TMyAdvancedIcon = class(TAdvancedIcon);

  TForm1 = class(TForm)
    LIBListBox: TListBox;
    ICOOpenDialog: TOpenDialog;
    LIBOpenDialog: TOpenDialog;
    ICOSaveDialog: TSaveDialog;
    LIBSaveDialog: TSaveDialog;
    MainMenu1: TMainMenu;
    MenuFile: TMenuItem;
    LoadICO: TMenuItem;
    SaveICO: TMenuItem;
    N1: TMenuItem;
    LoadLIB: TMenuItem;
    SaveLIB: TMenuItem;
    Panel: TPanel;
    ButtonSaveIcon: TButton;
    ButtonLoadIcon: TButton;
    ButtonLoadLibrary: TButton;
    ButtonSaveLibrary: TButton;
    ButtonClearLibrary: TButton;
    Button1: TButton;
    ButtonDeleteLIBIcon: TButton;
    PanelIcon: TPanel;
    ICOListBox: TListBox;
    ICOCountLabel: TPanel;
    LIBNameLabel: TPanel;
    ButtonDeleteIconImage: TButton;
    ButtonSizeSort: TButton;
    ButtonColorSort: TButton;
    DoChange: TCheckBox;
    Button2: TButton;
    Image1: TImage;
    OpenDialog: TOpenDialog;
    pnlQuadros: TPanel;
    pnlTituloQuadros: TPanel;
    strgQuadros: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LoadLIBClick(Sender: TObject);
    procedure LIBListBoxClick(Sender: TObject);
    procedure ICOListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure LoadICOClick(Sender: TObject);
    procedure ButtonSaveIconClick(Sender: TObject);
    procedure SaveLIBClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ICOListBoxMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure ButtonClearLibraryClick(Sender: TObject);
    procedure ButtonDeleteLIBIconClick(Sender: TObject);
    procedure ButtonDeleteIconImageClick(Sender: TObject);
    procedure ButtonSizeSortClick(Sender: TObject);
    procedure ButtonColorSortClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ICOListBoxClick(Sender: TObject);
    procedure strgQuadrosSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure strgQuadrosDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    Icon : TAdvancedIcon;
    IconLib : TIconLibrary;
    P : Pointer;
    Lista: TStringList;
    FCol: Integer;
    FPosIconStringGrid: Integer;    
    procedure LibraryLoaded;
    procedure IconLoaded;
    procedure LIBIconSelected;
    procedure ApplyChanges;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
{$R Icons.res}

procedure TForm1.FormCreate(Sender: TObject);
begin
  Icon:=TAdvancedIcon.Create;
  IconLib:=TIconLibrary.Create;
  Lista := TStringList.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Icon.Free;
  IconLib.free;
  FreeAndNil(Lista);
end;

procedure TForm1.LibraryLoaded;
begin
  LIBListBox.Items.assign(IconLib.Icons);
  LibNameLabel.caption:=' Library: '+IconLib.Filename;
  IF LIBListBox.Items.Count>0 Then begin
    LIBListBox.ItemIndex:=0;
    LibIconSelected;
  end;
end;

procedure TForm1.IconLoaded;
Var
  I : Integer;
  Image : TIconImage;
begin
  With ICOListBox, Lista Do begin
    Items.Clear;
    Clear;
    ICOCountLabel.Caption:=Format('Number of Subicons: %d',[Icon.Images.Count]);
    Items.BeginUpdate;
    BeginUpdate;
    try
      FOR I:=1 TO Icon.Images.Count DO begin
        Image:=Icon.Images.Image[I-1];
        Items.AddObject(InttoStr(I),Image);
        AddObject(InttoStr(I),Image);
      end;
    finally
      Items.EndUpdate;
      EndUpdate;
    end;
    IF Count>0 Then ICOListBox.ItemIndex:=0;
  end;
end;

procedure TForm1.ApplyChanges;
Var
  I : TAdvancedIcon;
begin
  IF NOT DoChange.Checked then exit;
  With LIBListBox do begin
    IF (ItemIndex<0) OR (ItemIndex>=IconLib.Icons.Count) then exit;
    I:=TAdvancedIcon(Items.Objects[ItemIndex]);
    I.Assign(Icon);
  end;  
end;

procedure TForm1.LIBIconSelected;
Var
  I : TAdvancedIcon;
begin
  IF LIBListBox.ItemIndex<0 then exit;
  I:=TAdvancedIcon(LIBListBox.Items.Objects[LIBListBox.ItemIndex]);
  IF NOT Assigned(I) Then exit;
  IF NOT (I is TAdvancedIcon) Then exit;
  Icon.Assign(I);
  IconLoaded;
end;

procedure TForm1.LIBListBoxClick(Sender: TObject);
begin
  LIBIconSelected;
end;

procedure TForm1.ICOListBoxMeasureItem(Control: TWinControl; Index: Integer; var Height: Integer);
Var
  Image : TIconImage;
begin
  With ICOListBox DO begin
    IF Index<0 Then exit;
    IF Index>=Icon.Images.Count Then exit;
    Image:=Icon.Images.Image[Index];
    IF NOT Assigned(Image) then exit;
    IF NOT (Image is TIconImage) Then exit;
  end;
  Height:=Image.Info.Height+4;
end;

procedure TForm1.ICOListBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
Var
  S : String;
  Image : TIconImage;
begin
  With ICOListBox DO begin
    IF Index<0 Then exit;
    IF Index>=Icon.Images.Count Then exit;
    Image:=Icon.Images.Image[Index];
    IF NOT Assigned(Image) then exit;
    IF NOT (Image is TIconImage) Then exit;
    With Canvas DO begin
      With Image.Info DO begin
        FillRect(Rect);
        IF rect.Left=0 Then Image.Draw(Canvas,Rect.Left+((60-Width)DIV 2),Rect.Top+2);
        S:=(Control as TListBox).Items[Index];
        TextOut(Rect.Left+100, Rect.Top+2+((Height-TextExtent(S).cy) DIV 2),S);
//        IF (odSelected in State) Then InvertRect(Canvas.Handle,Classes.Rect(Rect.Left+H+2,Rect.Top,Rect.Right,Rect.Bottom) );
      end;
    end;
  end;
end;

procedure TForm1.LoadICOClick(Sender: TObject);
begin
  IF NOT ICOOpenDialog.Execute Then exit;
  Icon.LoadFromFile(ICOOpenDialog.Filename);
  IconLib.Icons.Clear;
  LibraryLoaded;
  IconLoaded;
end;

procedure TForm1.ButtonSaveIconClick(Sender: TObject);
begin
  IF Icon.Images.Count=0 Then exit;
  IF NOT ICOSaveDialog.Execute Then exit;
  Icon.SaveToFile(ICOSaveDialog.Filename);
end;

procedure TForm1.LoadLIBClick(Sender: TObject);
begin
  IF NOT LIBOpenDialog.Execute Then exit;
  IconLib.LoadFromFile(LIBOpenDialog.Filename);
  LibraryLoaded;
  LIBListBox.Enabled:=True;
end;

procedure TForm1.SaveLIBClick(Sender: TObject);
begin
  IF IconLib.Icons.Count=0 Then exit;
  IF NOT LIBSaveDialog.Execute Then exit;
  IconLib.SaveToFile(LIBSaveDialog.Filename);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  IconLib.LoadSelf;
  LibraryLoaded;
end;



procedure TForm1.ButtonClearLibraryClick(Sender: TObject);
begin
  IconLib.Icons.Clear;
  Icon.Images.Clear;
  LibraryLoaded;
  IconLoaded;
end;

procedure TForm1.ButtonDeleteLIBIconClick(Sender: TObject);
begin
  With LIBListBox DO begin
    IF (ItemIndex<0) OR (ItemIndex>IconLib.Icons.Count) Then exit;
    IconLib.Icons.Delete(ItemIndex);
    LibraryLoaded;
  end;  
end;


procedure TForm1.ButtonDeleteIconImageClick(Sender: TObject);
begin
  With ICOListBox, Lista DO begin
    IF (ItemIndex<0) OR (ItemIndex>Icon.Images.Count) OR (Icon.Images.Count<=1) Then exit;
    Icon.Images.Delete(ItemIndex);
    IconLoaded;
  end;
  ApplyChanges;
end;



procedure TForm1.ButtonSizeSortClick(Sender: TObject);
begin
  Icon.Images.SortByResolution;
  IconLoaded;
  ApplyChanges;
end;

procedure TForm1.ButtonColorSortClick(Sender: TObject);
begin
  Icon.Images.SortByColor;
  IconLoaded;
  ApplyChanges;
end;

procedure TForm1.Button1Click(Sender: TObject);
Var
 Icon : TAdvancedIcon;
begin
  IF NOT ICOOpenDialog.Execute Then exit;
  Icon:=TAdvancedicon.Create;
  Icon.LoadFromFile(ICOOpenDialog.Filename);
  IconLib.Icons.addIcon('',Icon);
  LibraryLoaded;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Stream: TFileStream;
  IconCount: Word;
  I, J: Integer;
  Image: TIconImage;
begin
  IF NOT OpenDialog.Execute Then
    exit;

  for I := 0 to Pred(OpenDialog.Files.Count) do
  begin
      Stream := TFileStream.Create(OpenDialog.Files.Strings[I], fmOpenRead or fmShareDenyWrite);
      with Stream do
      try
        if not TMyAdvancedIcon(Icon).LoadHeader(Stream, IconCount) then
          exit;
        for J := 1 to IconCount do
        begin
          Image := TFileIconImage.Create(Stream);
          if Assigned(Image) then
            Icon.Images.add(Image);
        end;
      finally
        Free;
      end;
  end;
  LibraryLoaded;
  IconLoaded;
end;

procedure TForm1.ICOListBoxClick(Sender: TObject);
begin
    image1.Picture.Assign(Icon.Images.Image[ICOListBox.ItemIndex].Icon);
end;

procedure TForm1.strgQuadrosSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
    if (Lista.Count > 0) then
    begin
        FPosIconStringGrid := (FCol * ARow) + ACol;
        if (FPosIconStringGrid < Lista.Count) then
            CanSelect := True
        else
          CanSelect := False;
    end;
end;

procedure TForm1.strgQuadrosDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
    licn_Temp: TIconImage;
    lbmp_Temp: TBitmap;
    L_Icn, T_Icn, // Left - Top do Ícone
    L_Txt, T_Txt: Integer; // Left - Top do Text
    lrct_Text,
    lrct_Icone,
    lrct_Origem,
    lrct_Destino: TRect;
    lstr_Temp: String;
begin
    licn_Temp := TIconImage.Create;
    try
        if not (gdSelected in State) then
        begin
            strgQuadros.Canvas.Brush.Style := bsSolid;
            strgQuadros.Canvas.Brush.Color := $00F0EEEF;
            strgQuadros.Canvas.Pen.Style := psSolid;
            strgQuadros.Canvas.Pen.Width := 1;
            strgQuadros.Canvas.Pen.Color := clGray;
        end
        else
        begin
            strgQuadros.Canvas.Brush.Style := bsSolid;
            strgQuadros.Canvas.Brush.Color := clWhite;
            strgQuadros.Canvas.Pen.Style := psSolid;
            strgQuadros.Canvas.Pen.Width := 1;
            strgQuadros.Canvas.Pen.Color := clGray;
        end;

        // Cálculo do Retângulo onde dicará o ícone
        lrct_Icone.Left := Rect.Left + 2;
        lrct_Icone.Right := Rect.Right - 2;
        lrct_Icone.Top := Rect.Top + 2;
        lrct_Icone.Bottom := Rect.Bottom - 2;

        licn_Temp := Icon.Images.Image[(FCol * ARow) + ACol];
        if not Assigned(licn_Temp) then
            exit;
        if not (licn_Temp is TIconImage) then
            exit;

        // Cálculo da posição do ícone
        L_Icn := (Rect.Right - licn_Temp.Icon.Width) div 2;
        T_Icn := (Rect.Top + 4);

        strgQuadros.Canvas.FillRect(lrct_Icone);
        if (licn_Temp.Icon.Width >= 32) or (licn_Temp.Icon.Height >= 32) then
        begin
            lbmp_Temp := TBitmap.Create;
            try
                lbmp_Temp.Width := licn_Temp.Icon.Width;
                lbmp_Temp.Height := licn_Temp.Icon.Height;
                licn_Temp.Draw(lbmp_Temp.Canvas, 0, 0);
                lrct_Destino.Left := L_Icn;
                lrct_Destino.Top := T_Icn;
                lrct_Destino.Right := L_Icn + 32;
                lrct_Destino.Bottom := T_Icn + 32;
                lrct_Origem.Left := 0;
                lrct_Origem.Top := 0;
                lrct_Origem.Right := lbmp_Temp.Width;
                lrct_Origem.Bottom := lbmp_Temp.Height;
                strgQuadros.Canvas.BrushCopy(
                    lrct_Destino,
                    lbmp_Temp,
                    lrct_Origem,
                    clfuchsia);
            finally
                FreeAndNil(lbmp_Temp);
            end;
        end
        else
            licn_Temp.Draw(strgQuadros.Canvas, L_Icn, T_Icn);

        lstr_Temp := Lista.Strings[(FCol * ARow) + ACol];

        if not (gdSelected in State) then
        begin
            strgQuadros.Canvas.Brush.Style := bsSolid;
            strgQuadros.Canvas.Brush.Color := clSilver;
            strgQuadros.Canvas.Pen.Style := psSolid;
            strgQuadros.Canvas.Pen.Color := clGray;
            strgQuadros.Canvas.Pen.Width := 1;
            strgQuadros.Canvas.Font.Color := clBlack;
            strgQuadros.Canvas.Font.Style := [fsBold];
        end
        else
        begin
            strgQuadros.Canvas.Brush.Style := bsSolid;
            strgQuadros.Canvas.Brush.Color := clGray;
            strgQuadros.Canvas.Pen.Style := psSolid;
            strgQuadros.Canvas.Pen.Color := clGray;
            strgQuadros.Canvas.Pen.Width := 1;
            strgQuadros.Canvas.Font.Color := clBlack;
            strgQuadros.Canvas.Font.Style := [fsBold];
        end;

        // Cálculo do Retângulo onde ficará o texto
        lrct_Text.Left := Rect.Left + 2;
        lrct_Text.Right := Rect.Right - 2;
        lrct_Text.Top := Rect.Bottom - (((Rect.Bottom - Rect.Top) div 4));
        lrct_Text.Bottom := Rect.Bottom - 2;

        // Cálculo da posição do texto
        L_Txt := (Rect.Right - strgQuadros.Canvas.TextWidth(lstr_Temp)) div 2;
        T_Txt := lrct_Text.Top + 1;

        strgQuadros.Canvas.TextRect(lrct_Text, L_Txt, T_Txt, lstr_Temp);
    finally
        FreeAndNil(licn_Temp);
    end;
end;

end.
