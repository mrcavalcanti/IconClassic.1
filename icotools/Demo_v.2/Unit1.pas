unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  IconImage, IconLibrary, StdCtrls, ExtCtrls, ShellApi, Menus, IconTools,
  AdvancedIcon, Grids, mccsIconGrid, IconConvert, Gradient;

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
    Panel1: TPanel;
    Panel2: TPanel;
    mccsIconGrid1: TmccsIconGrid;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    Gradient1: TGradient;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure LoadLIBClick(Sender: TObject);
    procedure LIBListBoxClick(Sender: TObject);
    procedure LoadICOClick(Sender: TObject);
    procedure ButtonSaveIconClick(Sender: TObject);
    procedure SaveLIBClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButtonClearLibraryClick(Sender: TObject);
    procedure ButtonDeleteLIBIconClick(Sender: TObject);
    procedure ButtonDeleteIconImageClick(Sender: TObject);
    procedure ButtonSizeSortClick(Sender: TObject);
    procedure ButtonColorSortClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure strgQuadrosSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure strgQuadrosDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure strgQuadrosClick(Sender: TObject);
    procedure pnlQuadrosResize(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure mccsIconGrid1ClickIcon(Sender: TObject; IndexIcon: Integer;
      AFileIcon: TFileIcon; AIcon: TIcon; AIconAdv: TAdvancedIcon;
      ABitmap: TBitmap);
    procedure mccsIconGrid1DblClickIcon(Sender: TObject;
      IndexIcon: Integer; AFileIcon: TFileIcon; AIcon: TIcon;
      AIconAdv: TAdvancedIcon; ABitmap: TBitmap);
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
  Icon := TAdvancedIcon.Create;
  IconLib := TIconLibrary.Create;
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
  With Lista Do begin
    Clear;
    ICOCountLabel.Caption := Format('Number of Subicons: %d', [Icon.Images.Count]);
    BeginUpdate;
    try
      FOR I := 1 TO Icon.Images.Count DO
      begin
        Image:=Icon.Images.Image[I-1];
        AddObject(InttoStr(I), Image);
      end;
    finally
      EndUpdate;
      pnlQuadros.OnResize(Self);
      strgQuadros.Refresh;
    end;
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
  With Lista DO begin
    IF (FPosIconStringGrid > Icon.Images.Count) OR (Icon.Images.Count<=1) Then exit;
    Icon.Images.Delete(FPosIconStringGrid);
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
    RGN, RGN2: Cardinal;
begin
    if (((FCol * ARow) + ACol) >= Lista.Count) then
        Exit;
        
    if not (gdSelected in State) then
    begin
        strgQuadros.Canvas.Brush.Style := bsSolid;
        strgQuadros.Canvas.Brush.Color := clSilver;
    end
    else
    begin
        strgQuadros.Canvas.Brush.Style := bsSolid;
        strgQuadros.Canvas.Brush.Color := $00C1D6FF;
    end;

    // Cálculo do Retângulo onde dicará o ícone
    lrct_Icone.Left := Rect.Left + 2;
    lrct_Icone.Right := Rect.Right - 2;
    lrct_Icone.Top := Rect.Top + 2;
    lrct_Icone.Bottom := Rect.Bottom - 2;

    licn_Temp := TIconImage(Lista.Objects[(FCol * ARow) + ACol]);
    if not Assigned(licn_Temp) then
        exit;
    if not (licn_Temp is TIconImage) then
        exit;

    RGN := CreateRoundRectRgn(lrct_Icone.Left, lrct_Icone.Top,
        lrct_Icone.Right, lrct_Icone.Bottom,
        15, 15);
    SelectClipRgn(strgQuadros.Canvas.Handle, RGN);
    strgQuadros.Canvas.FillRect(lrct_Icone);
    SelectClipRgn(strgQuadros.Canvas.Handle, 0);
    DeleteObject(RGN);

    strgQuadros.Canvas.Brush.Style := bsSolid;
    strgQuadros.Canvas.Brush.Color := clWhite;

    RGN := CreateRoundRectRgn(lrct_Icone.Left + 1, lrct_Icone.Top + 1,
        lrct_Icone.Right - 1, lrct_Icone.Bottom - 1,
        15, 15);
    SelectClipRgn(strgQuadros.Canvas.Handle, RGN);
    strgQuadros.Canvas.FillRect(lrct_Icone);
    SelectClipRgn(strgQuadros.Canvas.Handle, 0);
    DeleteObject(RGN);

    if (licn_Temp.Icon.Width > 48) or (licn_Temp.Icon.Height > 48) then
    begin
        lbmp_Temp := TBitmap.Create;
        try
            // Cálculo da posição do ícone
            L_Icn := (Rect.Right - 48) div 2;
            T_Icn := (Rect.Top + 4);

            lbmp_Temp.Width := licn_Temp.Icon.Width;
            lbmp_Temp.Height := licn_Temp.Icon.Height;
            licn_Temp.Draw(lbmp_Temp.Canvas, 0, 0);

            lrct_Destino.Left := L_Icn;
            lrct_Destino.Top := T_Icn;
            lrct_Destino.Right := L_Icn + 48;
            lrct_Destino.Bottom := T_Icn + 48;

            lrct_Origem.Left := 0;
            lrct_Origem.Top := 0;
            lrct_Origem.Right := lbmp_Temp.Width;
            lrct_Origem.Bottom := lbmp_Temp.Height;

//            lbmp_Temp.TransparentColor := clWhite;
//            lbmp_Temp.TransparentMode := tmFixed;
//            lbmp_Temp.Transparent := True;
            strgQuadros.Canvas.StretchDraw(lrct_Destino, lbmp_Temp);
{
            strgQuadros.Canvas.BrushCopy(
                lrct_Destino,
                lbmp_Temp,
                lrct_Origem,
                clWhite);
}
        finally
            FreeAndNil(lbmp_Temp);
        end;
    end
    else
    begin
        // Cálculo da posição do ícone
        L_Icn := (Rect.Right - licn_Temp.Icon.Width) div 2;
        T_Icn := (Rect.Top + 4);
        licn_Temp.Draw(strgQuadros.Canvas, L_Icn, T_Icn);
    end;

    lstr_Temp := IntToStr(licn_Temp.Info.Width) + 'x' + IntToStr(licn_Temp.Info.Height) +
        ' - ' + IntToStr(licn_Temp.Info.BitCount) + ' Bit';

    if not (gdSelected in State) then
    begin
        strgQuadros.Canvas.Brush.Style := bsSolid;
        strgQuadros.Canvas.Brush.Color := clGray;
        strgQuadros.Canvas.Font.Color := clBlack;
        strgQuadros.Canvas.Font.Style := [];
    end
    else
    begin
        strgQuadros.Canvas.Brush.Style := bsSolid;
        strgQuadros.Canvas.Brush.Color := $006496FF;
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

    RGN := CreateRoundRectRgn(lrct_Text.Left, lrct_Text.Top,
        lrct_Text.Right, lrct_Text.Bottom,
        13, 13);
    RGN2 := CreateRectRgn(lrct_Text.Left, lrct_Text.Top,
        lrct_Text.Right - 1, lrct_Text.Bottom - (((lrct_Text.Bottom - lrct_Text.Top) div 3) * 2));

    CombineRgn(RGN, RGN, RGN2, RGN_OR);
    DeleteObject(RGN2);
    SelectClipRgn(strgQuadros.Canvas.Handle, RGN);
    strgQuadros.Canvas.FillRect(lrct_Text);
    SelectClipRgn(strgQuadros.Canvas.Handle, 0);
    DeleteObject(RGN);

    strgQuadros.Canvas.TextOut(L_Txt, T_Txt, lstr_Temp);
end;

procedure TForm1.strgQuadrosClick(Sender: TObject);
begin
    try
        image1.Picture.Assign(TIconImage(Lista.Objects[FPosIconStringGrid]).Icon);
    except
    end;
end;

procedure TForm1.pnlQuadrosResize(Sender: TObject);
begin
    FCol := Trunc(strgQuadros.Width / strgQuadros.DefaultColWidth);

    strgQuadros.ColCount := FCol;
    strgQuadros.RowCount := Trunc((Lista.Count / strgQuadros.ColCount)) + 1;
end;


procedure TForm1.Button3Click(Sender: TObject);
begin
    if OpenDialog1.Execute then
        mccsIconGrid1.FileNames.Assign(OpenDialog1.Files);
end;

procedure TForm1.mccsIconGrid1ClickIcon(Sender: TObject;
  IndexIcon: Integer; AFileIcon: TFileIcon; AIcon: TIcon;
  AIconAdv: TAdvancedIcon; ABitmap: TBitmap);
var
  Stream: TStream;//TFileStream;
  IconCount: Word;
  I, J: Integer;
  Image: TIconImage;
  licn_Temp: TIcon;
  lstr_Temp: String;
  jv: TIconConvert;
  NewBitmap: TBitmap;
begin

    if (IndexIcon = -1) then
        Exit;

    jv := TIconConvert.Create(Self);
    NewBitmap := TBitmap.Create;
    licn_Temp := TIcon.Create;
    Stream := TMemoryStream.Create;
    try
        NewBitmap.Assign(ABitmap);
        for I := 0 to Pred(NewBitmap.Width) do
            for J := 0 to Pred(NewBitmap.Height) do
                if (NewBitmap.Canvas.Pixels[I, J] = clWhite) then
                    NewBitmap.Canvas.Pixels[I, J] := RGB(250, 0, 250);

        licn_Temp.Assign(jv.CreateIcon(NewBitmap));

        licn_Temp.SaveToStream(Stream);
        Stream.Seek(0, soBeginning);
        if not TMyAdvancedIcon(Icon).LoadHeader(Stream, IconCount) then
            exit;
        for J := 1 to IconCount do
        begin
            Image := TFileIconImage.Create(Stream);
            if Assigned(Image) then
                Icon.Images.add(Image);
        end;
    finally
        Stream.Free;
        FreeAndNil(licn_Temp);
        FreeAndNil(NewBitmap);
        jv.Free;
    end;
    IconLoaded;
end;

procedure TForm1.mccsIconGrid1DblClickIcon(Sender: TObject;
  IndexIcon: Integer; AFileIcon: TFileIcon; AIcon: TIcon;
  AIconAdv: TAdvancedIcon; ABitmap: TBitmap);
var
  Stream: TMemoryStream;
  IconCount: Word;
  I, J: Integer;
  Image: TIconImage;
  lIcon : TAdvancedIcon;
begin
    if (IndexIcon = -1) then
        Exit;

    lIcon := TAdvancedicon.Create;

    Stream := TMemoryStream.Create;
    with Stream do
    try
        AIcon.SaveToStream(Stream);
        Stream.Seek(0, soBeginning);
        if not TMyAdvancedIcon(Icon).LoadHeader(Stream, IconCount) then
          exit;
        for J := 1 to IconCount do
        begin
          Image := TFileIconImage.Create(Stream);
          if Assigned(Image) then
          begin
            lIcon.Images.Add(Image);
            Icon.Assign(lIcon);
          end;
        end;
      finally
        Free;
    end;
    IconLoaded;
end;

end.
