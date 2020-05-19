unit uFrArrastar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, ExtCtrls, ImgList, ShlObj, ShellAPI;

type
  TOnClickArrastar = procedure(Sender: TObject; IndexIcon: Integer;
                    AFileName: String; AIcon: TIcon; ABitmap: TBitmap) of Object;

  TfFrArrastar = class(TFrame)
    pnlIcones: TPanel;
    ListView1: TListView;
    StatusBar1: TStatusBar;
    ImageList1: TImageList;
    ProgressBar1: TProgressBar;
    procedure ListView1Click(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
  private
    { Private declarations }
    Pic: TPicture;    
    Fname : String;
    TempFile: array[0..255] of Char;
    Drop : THandle; {Handle for Msg.wParam}

    FOnClickArrastar: TOnClickArrastar;
    FOnDblClickArrastar: TOnClickArrastar;

    procedure SetOnClickArrastar(Value: TOnClickArrastar);
    procedure SetOnDblClickArrastar(Value: TOnClickArrastar);
  public
    { Public declarations }
    procedure WMDrop(var Msg: TMessage);

    property OnClick: TOnClickArrastar read FOnClickArrastar write SetOnClickArrastar;
    property OnDblClick: TOnClickArrastar read FOnDblClickArrastar write SetOnDblClickArrastar;
  end;

implementation

{$R *.dfm}

{ TfFrArrastar }

procedure TfFrArrastar.SetOnClickArrastar(Value: TOnClickArrastar);
begin
  FOnClickArrastar := Value;
end;

procedure TfFrArrastar.SetOnDblClickArrastar(Value: TOnClickArrastar);
begin
  FOnDblClickArrastar := Value;
end;

procedure TfFrArrastar.WMDrop(var Msg: TMessage);
var
  i,K,
  NumFiles, NameLength : integer;
  nIconsInFile : word;
  nTotal : word;
  NewItem: TListItem;
  Img: TBitmap;
begin
  try
    screen.cursor := crHourglass;
    ImageList1.Clear;
    ListView1.Items.clear;
    Drop := Msg.wParam;
    nTotal := 0;
    ProgressBar1.Position := 0;
    {Query how many files were dropped on the app}
    {$IFDEF WIN32}
      NumFiles := DragQueryFile(Msg.wParam, $FFFFFFFF, Nil, 0);
    {$ELSE}
      NumFiles := DragQueryFile(Msg.wParam, $FFFF, Nil, 0);
    {$ENDIF}
    for i := 0 to (NumFiles-1) do
    begin
      NameLength := DragQueryFile(Msg.wParam, i, Nil , 0);
      DragQueryFile(Msg.wParam, i, TempFile, NameLength+1);
      FName := StrPas(TempFile);
      { ShowMessage(FName);}

      {Query how many icons exist in the file (-1)}
      {$IFDEF WIN32}
        nIconsInFile := ExtractIcon(HInstance, TempFile, $FFFFFFFF);
      {$ELSE}
        nIconsInFile := ExtractIcon(HInstance, TempFile, $FFFF);
      {$ENDIF}
      nTotal := nTotal + nIconsInFile;

      ProgressBar1.Max := nIconsInFile;
      ProgressBar1.Visible := True;

      for K := 0 to nIconsInFile-1 do
      begin
        {Extract the icon}
        Application.MainForm.Icon.Handle := ExtractIcon(HInstance, TempFile, K);

        {Create a TPicture instance}
        Pic := TPicture.Create;
        {Assign the icon.handle to the Pic.icon property}
        Pic.Icon := Application.MainForm.Icon;

        {Add the Filename and icon to the ListView}
        ImageList1.AddIcon(Pic.Icon);
        ListView1.LargeImages := ImageList1;
        NewItem := ListView1.Items.Add;
        NewItem.Caption := '';
        NewItem.Caption := ExtractFileName(FName);
        NewItem.ImageIndex := K;

        if nIconsInFile <> 0 then
          ProgressBar1.Position := ProgressBar1.Position + 1;
      end;  {For K}
    end;  {For I}

    if nTotal = 0 then
    begin
      StatusBar1.Panels[1].Text := 'Total de ícones: 0';
      Application.MainForm.Icon.Handle := Application.Icon.Handle;
    end
    else
      StatusBar1.Panels[1].Text := 'Total de ícones: ' + IntToStr(nTotal);
      
    Application.MainForm.Icon.Handle := Application.Icon.Handle;
  finally
    screen.cursor := crDefault;
    ProgressBar1.Position := 0;
    ProgressBar1.Visible := False;
    Application.MainForm.Icon.Handle := 0;
    Img := TBitmap.Create;
    ImageList1.GetBitmap(0, Img);
//    ImgIconEditor1.Bitmap := Img;
//    ImgIconEditor1.Paint;
//    DefineIcone;
    Img.Destroy;
  end; {main begin}
end;

procedure TfFrArrastar.ListView1Click(Sender: TObject);
var
    aicn_Icon: TIcon;
    abmp_Bitmap: TBitmap;
    aint_Index: Integer;
begin
    try
        aint_Index := -1;

        if (Sender is TListView) and Assigned(TListView(Sender).Selected) then
            aint_Index := TListView(Sender).Selected.ImageIndex;

        if (aint_Index > -1) then
        begin
            aicn_Icon := TIcon.Create;
            abmp_Bitmap := TBitmap.Create;
            try
                imageList1.GetIcon(aint_Index, aicn_Icon);
                imageList1.GetBitmap(aint_Index, abmp_Bitmap);

                if Assigned(Self.FOnClickArrastar) then
                    Self.FOnClickArrastar(Self, aint_Index, '', aicn_Icon, abmp_Bitmap);
            finally
                FreeAndNil(aicn_Icon);
                FreeAndNil(abmp_Bitmap);
            end;
        end
        else
            if Assigned(Self.FOnClickArrastar) then
                Self.FOnClickArrastar(Self, -1, '', nil, nil);
    except
        if Assigned(Self.FOnClickArrastar) then
            Self.FOnClickArrastar(Self, -1, '', nil, nil);
    end;
end;

procedure TfFrArrastar.ListView1DblClick(Sender: TObject);
var
    aicn_Icon: TIcon;
    abmp_Bitmap: TBitmap;
    aint_Index: Integer;
begin
    try
        aint_Index := -1;

        if (Sender is TListView) and Assigned(TListView(Sender).Selected) then
            aint_Index := TListView(Sender).Selected.ImageIndex;

        if (aint_Index > -1) then
        begin
            aicn_Icon := TIcon.Create;
            abmp_Bitmap := TBitmap.Create;
            try
                imageList1.GetIcon(aint_Index, aicn_Icon);
                imageList1.GetBitmap(aint_Index, abmp_Bitmap);

                if Assigned(Self.FOnDblClickArrastar) then
                    Self.FOnDblClickArrastar(Self, aint_Index, '', aicn_Icon, abmp_Bitmap);
            finally
                FreeAndNil(aicn_Icon);
                FreeAndNil(abmp_Bitmap);
            end;
        end
        else
            if Assigned(Self.FOnDblClickArrastar) then
                Self.FOnDblClickArrastar(Self, -1, '', nil, nil);
    except
        if Assigned(Self.FOnDblClickArrastar) then
            Self.FOnDblClickArrastar(Self, -1, '', nil, nil);
    end;
end;

end.
