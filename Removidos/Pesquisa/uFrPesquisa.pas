unit uFrPesquisa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, ImgList, ShellAPI, SyncObjs,
  cTipos;

type
  TThrPesquisa = class(TThread)
  private
      IntIcone: Integer;
      IntDel: Integer;
      FExt: String;
      FPathSearch: String;
      FCompareIcon: Boolean;
      FCancelSearch: Boolean;
      FileIcon: array of TFileIcon;
      FlblDeletado,
      FlblDirectory: TLabel;
      FlblFileName,
      FlblIconName: TLabel;
      FstbBarra: TStatusBar;
      FimglIcones: TImageList;
      FlstvIcones: TListView;
      FpnlPesquisa: TPanel;
      FprgbPercentual: TProgressBar;
      FimgIcone: TImage;
      FCriticalSection: TCriticalSection;
      procedure SearchIcon(nFile: String);
      procedure FindExt;
      function IconEqual(const Icon1, Icon2:  TIcon):  Boolean;
  protected
      procedure Execute; override;
  public
      constructor Create(CreateSuspended: Boolean; Albl_Deletado, Albl_Directory,
          Astb_Barra, Aimgl_Icones, Alstv_Icones, Apnl_Pesquisa, Albl_FileName,
          Aprgb_Percentual, Albl_IconName, Aimg_Icone: Pointer);

      property Ext: String read FExt write FExt;
      property PathSearch: String read FPathSearch write FPathSearch;
      property CompareIcon: Boolean read FCompareIcon write FCompareIcon;
      property CancelSearch: Boolean read FCancelSearch write FCancelSearch;
  end;

  TfFrPesquisa = class(TFrame)
    pnlPesquisa: TPanel;
    Image1: TImage;
    Label1: TLabel;
    lblDeletado: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblDirectory: TLabel;
    lblFileName: TLabel;
    ProgressBar1: TProgressBar;
    pnlIcones: TPanel;
    Panel2: TPanel;
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    imgList: TImageList;
    ListView1: TListView;
    StatusBar1: TStatusBar;
    lblIconName: TLabel;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
    ThrPesquisa: TThrPesquisa;
  public
    { Public declarations }
    procedure PesquisarIcones(Extensao, Path: String;
        Compare: Boolean);
  end;

implementation

{$R *.dfm}

{ TfFrPesquisa }

procedure TfFrPesquisa.PesquisarIcones(Extensao, Path: String;
  Compare: Boolean);
begin
    pnlPesquisa.BringToFront;
    lblDeletado.Visible := Compare;
    ThrPesquisa := TThrPesquisa.Create(True, lblDeletado, lblDirectory,
        StatusBar1, ImgList, ListView1, pnlPesquisa, lblFileName, ProgressBar1,
        lblIconName, Image1);
    ThrPesquisa.Ext := Extensao;
    ThrPesquisa.PathSearch := Path;
    ThrPesquisa.CompareIcon := Compare;
    ThrPesquisa.Priority := tpHigher;
    ThrPesquisa.Resume;
end;

procedure TfFrPesquisa.BitBtn1Click(Sender: TObject);
begin
    ThrPesquisa.CancelSearch := True;
end;

{ TThrPesquisa }

constructor TThrPesquisa.Create(CreateSuspended: Boolean; Albl_Deletado,
    Albl_Directory, Astb_Barra, Aimgl_Icones, Alstv_Icones, Apnl_Pesquisa,
    Albl_FileName, Aprgb_Percentual, Albl_IconName, Aimg_Icone: Pointer);
begin
    FCriticalSection := TCriticalSection.Create;
    inherited Create(CreateSuspended);
    FreeOnTerminate := True;
    IntDel := 0;
    FlblDeletado := Albl_Deletado;
    FlblDirectory := Albl_Directory;
    FstbBarra := Astb_Barra;
    FimglIcones := Aimgl_Icones;
    FlstvIcones := Alstv_Icones;
    FpnlPesquisa := Apnl_Pesquisa;
    FlblFileName := Albl_FileName;
    FprgbPercentual := Aprgb_Percentual;
    FlblIconName := Albl_IconName;
    FimgIcone := Aimg_Icone;
end;

procedure TThrPesquisa.Execute;
begin
//    Self.Synchronize(FindExt);
    FindExt
end;

procedure TThrPesquisa.FindExt;

  procedure ProcessMessages;
  var
      Msg: TMsg;
  begin
      Sleep(1); // Para não ocupar a CPU em 100%
      while PeekMessage(Msg, 0, 0, 0, PM_REMOVE) do
      begin
          TranslateMessage(Msg);
          DispatchMessage(Msg);
      end;
  end;

  procedure ScanDirectory(FromDir: string);
  var
    SearchRec: TSearchRec;
    SearchResult: integer;
  begin
    if FromDir[Length(FromDir)] <> '\' then
        FromDir := FromDir + '\';

    SearchResult := FindFirst(FromDir + '*.*', faAnyFile, SearchRec);

    while (SearchResult = 0) do
    begin
        FCriticalSection.Enter;
        try
            ProcessMessages;

            if fCancelSearch then
                Break;

            if (SearchRec.Attr and faDirectory) = faDirectory then
            begin
                if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then  // Para entrar em todos os sub-diretórios
                    ScanDirectory(FromDir + SearchRec.Name)
            end
            else if CompareText(ExtractFileExt(SearchRec.Name), Ext) = 0 then  // Extensão dos arquivos que estão sendo procurados
            begin
                SearchIcon(FromDir + SearchRec.Name);
            end;

            FlblDirectory.Caption := FromDir;

            SearchResult := FindNext(SearchRec);
        finally
            FCriticalSection.Leave;
        end;
    end;
    FindClose(SearchRec);
  end;

begin
    fCancelSearch := False;

    try
        try
            ScanDirectory(PathSearch);
        except
            raise exception.Create('Erro na pesquisa!');
        end;
    finally
        if fCancelSearch then
            Application.MessageBox('Pesquisa interrompida!', 'Pesquisar...', MB_OK)
        else
            Application.MessageBox('Pesquisa concluída!', 'Pesquisar...', MB_OK);

        FstbBarra.Panels[0].Text := 'Total de ícones: ' + IntToStr(FimglIcones.Count);

        FlstvIcones.Align := alClient;
        FlstvIcones.Repaint;
        FlstvIcones.ViewStyle := vsIcon;
        FpnlPesquisa.SendToBack;

        Terminate;
    end;
end;

function TThrPesquisa.IconEqual(const Icon1, Icon2: TIcon): Boolean;
var
    m1: TMemoryStream;
    m2: TMemoryStream;
begin
    Result := False;
    m1 := TMemoryStream.Create;
    try
        Icon1.SaveToStream(m1);
        m2 := TMemoryStream.Create;
        try
            Icon2.SaveToStream(m2);
            if (m1.Size = m2.Size) then
                Result := CompareMem(m1.Memory, m2.Memory, m1.Size)
        finally
            m2.Free
        end;
    finally
        m1.Free
    end;

    if Result then
    begin
        Inc(IntDel);
        FlblDeletado.Caption := 'Deletado: ' + IntToStr(intDel);
    end;
end;


procedure TThrPesquisa.SearchIcon(nFile: String);
var
    I, J: Integer;
    Icon, IconMain: TIcon;
    ADD: Boolean;
    Item: TListItem;
begin
    if FileExists(nFile) then
    begin
        Icon := TIcon.Create;
        IconMain := TIcon.Create;
        try
            FlblFileName.Caption := ExtractFilePath(nFile);
            {$IFDEF WIN32}
            IntIcone := ExtractIcon(HInstance, PChar(nFile), $FFFFFFFF);
            {$ELSE}
            IntIcone := ExtractIcon(HInstance, PChar(nFile), $FFFF);
            {$ENDIF}

            if IntIcone > 0 then
            begin
                FprgbPercentual.Min := 0;
                FprgbPercentual.Max := IntIcone;

                for I := 0 to Pred(IntIcone) do
                begin
                    try
                        ADD := True;

                        Icon.Assign(nil);
                        Icon.Handle := ExtractIcon(HInstance, PChar(nFile), I);
                        if (FimglIcones.Count > 0) then
                        begin
                            if CompareIcon then // Não adiciona ícones repetidos
                                for J := 0 to Pred(FimglIcones.Count) do
                                begin
                                    try
                                        Application.ProcessMessages;
                                        FimglIcones.GetIcon(J, IconMain);
                                        if IconEqual(IconMain, Icon) then
                                        begin
                                            ADD := False;
                                            Break;
                                        end;
                                    except
                                        Continue;
                                    end;
                                end;
                        end
                        else
                        begin
                            ADD := False;
                            FimglIcones.AddIcon(Icon);
                            SetLength(FileIcon, FimglIcones.Count);
                            FlblIconName.Caption := ExtractFileName(nFile);
                            FimgIcone.Picture.Icon := Icon;
                            FprgbPercentual.Position := I + 1;
                            FileIcon[Pred(FimglIcones.Count)].FileName := ExtractFileName(nFile);
                            FileIcon[Pred(FimglIcones.Count)].Index := I;
                            FileIcon[Pred(FimglIcones.Count)].Category := 'Teste';
                            Item := FlstvIcones.Items.Add;
                            Item.Caption := FileIcon[Pred(FimglIcones.Count)].FileName;
                            Item.ImageIndex := Pred(FimglIcones.Count);
                        end;

                        if ADD then
                        begin
                            FimglIcones.AddIcon(Icon);
                            SetLength(FileIcon, FimglIcones.Count);
                            FlblIconName.Caption := ExtractFileName(nFile);
                            FimgIcone.Picture.Icon := Icon;
                            FprgbPercentual.Position := I + 1;
                            FileIcon[Pred(FimglIcones.Count)].FileName := ExtractFileName(nFile);
                            FileIcon[Pred(FimglIcones.Count)].Index := I;
                            FileIcon[Pred(FimglIcones.Count)].Category := 'Teste';
                            Item := FlstvIcones.Items.Add;
                            Item.Caption := FileIcon[Pred(FimglIcones.Count)].FileName;
                            Item.ImageIndex := Pred(FimglIcones.Count);
                        end;

                        if fCancelSearch then
                            Break;

                        Application.ProcessMessages;
                    except;
                        Continue;
                    end;
                end;
          end;

        finally
            Icon.Free;
            IconMain.Free;
        end;
    end;

    FprgbPercentual.Position := 0;
end;

end.
