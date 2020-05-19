unit uShellExtensao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ShellExt, StdCtrls, ExtCtrls, ShellAPI, JvComponent, JvBaseDlg,
  JvWinDialogs, ComCtrls;

type
  TfrmShellExtensao = class(TForm)
    ShellExt: TShellExt;
    btn_Ok: TButton;
    btn_Cancelar: TButton;
    Advanced: TShellExt;
    gbx_Principal: TGroupBox;
    gbx_Extensoes: TGroupBox;
    Bevel1: TBevel;
    btn_Todos: TButton;
    gbx_Detalhes: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    img_Icon: TImage;
    edt_AbrirCom: TEdit;
    btn_AbrirCom: TButton;
    lbl_Extensao: TLabel;
    btn_Restaurar: TButton;
    btn_AlterarIcone: TButton;
    IconDialog: TJvChangeIconDialog;
    ListView1: TListView;
    OpenWithDialog: TJvOpenWithDialog;
    Label4: TLabel;
    edt_ExtrairIconeDe: TEdit;
    procedure btn_TodosClick(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
    procedure btn_CancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListView1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btn_AlterarIconeClick(Sender: TObject);
    procedure btn_AbrirComClick(Sender: TObject);
  private
    { Private declarations }
    procedure AssociarExtensao;
    function ExtensaoAssociada(AExt: String): Boolean;
    function GetFileDescription(AExt: String): String;
    procedure GetExtInformation(AExt: String);
    function PermiteAssociarExt(AIndex: Integer): Boolean;
    procedure MarcarExtensao;
    procedure CarregarExtensao;
  public
    { Public declarations }
  end;

var
  frmShellExtensao: TfrmShellExtensao;

procedure ShellExtensao(AOwner: TComponent);

implementation

uses
    cTipos;

{$R *.dfm}

procedure ShellExtensao(AOwner: TComponent);
begin
    if TWinControl(AOwner).FindComponent('frmShellExtensao') <> nil then
        Exit;
    with TfrmShellExtensao.Create(AOwner) do
    begin
        MarcarExtensao;
        if (ShowModal = mrOK) then
        begin
            AssociarExtensao;
        end;
    end;
end;

procedure TfrmShellExtensao.btn_TodosClick(Sender: TObject);
var
    lint_Loop: Integer;
begin
    for lint_Loop := 0 to Pred(ListView1.Items.Count) do
        ListView1.Items.Item[lint_Loop].Checked := PermiteAssociarExt(lint_Loop);
end;

procedure TfrmShellExtensao.btn_OkClick(Sender: TObject);
begin
    ModalResult := mrOK;
end;

procedure TfrmShellExtensao.btn_CancelarClick(Sender: TObject);
begin
    ModalResult := mrCancel;
end;

procedure TfrmShellExtensao.AssociarExtensao;
// A chamada para desinstalar deverá ser chamada primeiro, pelo fato do componente
// retirar o registro de extensão 'IconClassicFile". Após a desisntalação devo
// verificar se existe alguma extensão a manter ou instalar.
var
    lint_Loop: Integer;
begin
    // Desinstalar
    for lint_Loop := 0 to Pred(ListView1.Items.Count) do
    begin
        if not ListView1.Items.Item[lint_Loop].Checked and (TExtChange[lint_Loop] = 1)
            and ExtensaoAssociada(TExtAbbreviated[lint_Loop]) then // Desinstalar somente se foi associado pelo Icon Classic
        begin
            ShellExt.Extension := TExtAbbreviated[lint_Loop];
            ShellExt.UnInstall;
        end;
    end;

    // Instalar
    for lint_Loop := 0 to Pred(ListView1.Items.Count) do
    begin
        if ListView1.Items.Item[lint_Loop].Checked and (TExtChange[lint_Loop] = 1) then
        begin
            ShellExt.Extension := TExtAbbreviated[lint_Loop];
            ShellExt.Install;
        end;
    end;
end;

function TfrmShellExtensao.ExtensaoAssociada(AExt: String): Boolean;
var
    lstr_Temp: String;
begin
    Result := True;
    try
        Advanced.Extension := AExt;

        if Advanced.GetShellExtension then
        begin
            lstr_Temp := Advanced.OpenWith;
            if (ExtractFileName(lstr_Temp) <> ExtractFileName(Application.ExeName)) then
                Result := False;
        end
        else
            Result := False;
    except
        Result := False;
    end;
end;

procedure TfrmShellExtensao.MarcarExtensao;
var
    lint_Loop: Integer;
    lcbx_Temp: TCheckBox;
begin
    CarregarExtensao;

    lcbx_Temp := nil;
    for lint_Loop := 0 to Pred(ListView1.Items.Count) do
    begin
        ListView1.OnChange := nil;
        ListView1.Items.Item[lint_Loop].Checked := ExtensaoAssociada(TExtAbbreviated[lint_Loop]);
        ListView1.OnChange := ListView1Change;
    end;
end;

procedure TfrmShellExtensao.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure TfrmShellExtensao.CarregarExtensao;
var
    lint_Loop: Integer;
    llti_Temp: TListItem;
begin
    for lint_Loop := Low(TExtAbbreviated) to High(TExtAbbreviated) do
    begin
        llti_Temp := ListView1.Items.Add;
        llti_Temp.Caption := TExtAbbreviated[lint_Loop];
        llti_Temp.SubItems.Add(GetFileDescription(TExtAbbreviated[lint_Loop]))
    end;

    if (ListView1.Items.Count > 0) then
        ListView1.ItemIndex := 0;
end;

function TfrmShellExtensao.GetFileDescription(AExt: String): String;
begin
    Result := 'Ícones';
    try
        Advanced.Extension := AExt;

        if Advanced.GetShellExtension then
            Result := Advanced.FileDescription;
    except
        Result := 'Ícones';
    end;
end;

procedure TfrmShellExtensao.ListView1Change(Sender: TObject;
  Item: TListItem; Change: TItemChange);
begin
    if (TListView(Sender).Selected <> nil) then
    begin
        if not PermiteAssociarExt(Item.Index) then
        begin
            ListView1.OnChange := nil;
            Item.Checked := False;
            // Selecionar o item quando o clicar no checkbox
            ListView1.ItemIndex := Item.Index;
            ListView1.OnChange := ListView1Change;
        end
        else
        begin
            ListView1.OnChange := nil;
            // Selecionar o item quando o clicar no checkbox
            ListView1.ItemIndex := Item.Index;
            ListView1.OnChange := ListView1Change;
        end;

        GetExtInformation(Item.Caption);
    end;
end;

procedure TfrmShellExtensao.GetExtInformation(AExt: String);
begin
    try
        Advanced.Extension := AExt;

        if Advanced.GetShellExtension then
        begin
            img_Icon.Picture.Icon.Assign(Advanced.Icon);
            lbl_Extensao.Caption := Advanced.Extension;
            edt_ExtrairIconeDe.Text := Advanced.FileIcon;
            edt_ExtrairIconeDe.Tag := Advanced.IconIndex;
            edt_AbrirCom.Text := Advanced.OpenWith + ' ' +
                Advanced.ParamString;
        end
        else
        begin
            img_Icon.Picture.Icon.Assign(nil);
            lbl_Extensao.Caption := '';
            edt_ExtrairIconeDe.Text := '';
            edt_ExtrairIconeDe.Tag := 0;
            edt_AbrirCom.Text := '';
        end;
        gbx_Detalhes.Refresh;
    except
    end;
end;

procedure TfrmShellExtensao.btn_AlterarIconeClick(Sender: TObject);
var
    licn_Temp: TIcon;
begin
    with IconDialog do
    begin
        FileName := edt_ExtrairIconeDe.Text;
        IconIndex := edt_ExtrairIconeDe.Tag;
        Execute;
        try
            if (FileName <> edt_ExtrairIconeDe.Text) or (IconIndex <> edt_ExtrairIconeDe.Tag) then
            begin
                licn_Temp := TIcon.Create;
                licn_Temp.Handle := ExtractIcon(hInstance, PChar(FileName), IconIndex);
                img_Icon.Picture.Assign(licn_Temp);
                edt_ExtrairIconeDe.Text := FileName;
                edt_ExtrairIconeDe.Tag := IconIndex;
            end;
        finally
            FreeAndNil(licn_Temp);
        end;
    end;
end;

function TfrmShellExtensao.PermiteAssociarExt(AIndex: Integer): Boolean;
begin
    Result := True;
    try
        Result := TExtChange[AIndex] = 1;
    except
        Result := False;
    end;
end;

procedure TfrmShellExtensao.btn_AbrirComClick(Sender: TObject);
begin
    with OpenWithDialog do
    begin
        Execute;
    end;
end;

end.
