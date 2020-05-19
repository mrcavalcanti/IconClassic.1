program IconClassic;

uses
  Windows,
  Messages,
  SysUtils,
  Forms,
  uIconClassic in 'uIconClassic.pas' {frmIconClassic},
  uAvaliacao in 'uAvaliacao.pas' {frmAvaliacao},
  cFavorites in 'cFavorites.pas',
  cTipos in 'cTipos.pas',
  uGlobal in 'uGlobal.pas',
  udmIconesProntos in 'udmIconesProntos.pas' {dmIconesProntos: TDataModule},
  uTestarIcone in 'TestarIcone\uTestarIcone.pas' {frmTestarIcone},
  uFrArrastar in 'Pesquisa\uFrArrastar.pas' {fFrArrastar: TFrame},
  uShellExtensao in 'ShellExtensao\uShellExtensao.pas' {frmShellExtensao},
  uFrWebBrowser in 'Pesquisa\uFrWebBrowser.pas' {fFrWebBrowser: TFrame},
  UIcoFiles in 'UIcoFiles.pas',
  u3d in 'Formatos\3D\u3d.pas' {frm3d},
  uGis in 'Formatos\GIS\uGis.pas' {frmGis};

{$R *.res}

var
    hwnd: THandle;
    cds: CopyDataStruct;
    lstr_Temp: String;
    lint_Loop: Integer;

begin
    hwnd := FindWindow('TfrmIconClassic', 'Icon Classic - 2007');
    if (hwnd = 0) then
    begin
        Application.Initialize;
        Application.Title := 'Icon Classic - 2009';
  Application.CreateForm(TdmIconesProntos, dmIconesProntos);
  Application.CreateForm(TfrmIconClassic, frmIconClassic);
  Application.Run;
    end
    else
    begin
        lstr_Temp := '';

        for lint_Loop := 1 to ParamCount do
        begin
            if (lint_Loop = 1) then
                lstr_Temp := ExtractShortPathName(ParamStr(lint_Loop))
            else
            begin
                if (ExtractShortPathName(ParamStr(lint_Loop)) <> '') then
                    lstr_Temp := lstr_Temp + ' ' + ExtractShortPathName(ParamStr(lint_Loop))
                else
                    lstr_Temp := lstr_Temp + ' ' + ParamStr(lint_Loop);
            end;
        end;

        if (lstr_Temp <> '') then
        begin
            cds.dwData := 0;
            cds.cbData := Length(lstr_Temp);
            cds.lpData := PChar(lstr_Temp);
        end;

        SetForegroundWindow(hwnd);

        SendMessage(hwnd, wm_CopyData, 0, Integer(@cds));
    end;
end.
