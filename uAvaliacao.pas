unit uAvaliacao;

interface

uses
  Windows, Messages, SysUtils, StdCtrls, Controls, Classes,
  Graphics, Forms, Dialogs, ExtCtrls, uIconClassic;

type
  TfrmAvaliacao = class(TForm)
    btnSend: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    memRateDescrip: TMemo;
    rgRate: TRadioGroup;
    Bevel1: TBevel;
    procedure rgRateChange(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
  end;

var
  frmAvaliacao: TfrmAvaliacao;

implementation

uses
  ShellAPI;

{$R *.dfm}

procedure TfrmAvaliacao.rgRateChange(
  Sender: TObject);
begin
  if rgRate.ItemIndex  <> -1 then
    btnSend.Enabled := True;
end;

procedure TfrmAvaliacao.btnSendClick(Sender: TObject);
var
  ABody, ASubj: string;
  procedure AdjustMessageBody(ASearchStr, AReplaceStr: string);
  var
    APos: integer;
  begin
    APos := Pos(ASearchStr,ABody);
    while APos <> 0 do
    begin
      Delete(ABody,APos, Length(ASearchStr));
      Insert(AReplaceStr,ABody, APos);
      APos := Pos(ASearchStr,ABody);
    end;
  end;
begin
  Screen.Cursor := crHourGlass;
  try
    ASubj := ChangeFileExt(ExtractFileName(Application.ExeName),'')+' - 2006 (BETA)';
    ABody := 'Pontuação: ' + IntToStr(rgRate.ItemIndex + 1);
    if memRateDescrip.Text <> '' then
      ABody := ABody + #13#10#13#10 +'Descrição:'#13#10 + memRateDescrip.Text;
    AdjustMessageBody('%', '$prc$');
    AdjustMessageBody('$prc$', '%25');
    AdjustMessageBody(#13#10, '%0D%0A');
    AdjustMessageBody('&', '%26');
    AdjustMessageBody(' ', '%20');
    ShellExecute(Handle, PChar('OPEN'), PChar('mailto:' + frmIconClassic.MccsAboutDinamic.Email + '?subject=' +
      ASubj + '&body=' + ABody) , nil, nil, SW_SHOWMAXIMIZED);
  finally
    Screen.Cursor := crDefault;
    Close;
  end;
end;

end.
