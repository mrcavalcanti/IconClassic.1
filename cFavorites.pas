unit cFavorites;

interface

uses
  cTipos,
  Windows,
  SysUtils,
  Dialogs,
  Forms;

var
  FileFavorites: array of TIconFavorites;

procedure LoadFavorites;
procedure SaveFavorites;

implementation

procedure LoadFavorites;
var
  F: file of TIconFavorites;
  FavoritesAtual: TIconFavorites;
  I: Integer;
begin
  if FileExists(ExtractFilePath(Application.ExeName) + FileIconFavorites) then
  begin
    AssignFile(F, ExtractFilePath(Application.ExeName) + FileIconFavorites);
    {$I-}
    Reset(F);
    {$I+}
    if IOResult <> 0 then
    begin
      MessageDlg('Erro ao ler arquivo de ícones favoritos.',
        mtError, [mbOK], 0);
      Exit;
    end;
    I := 1;
    if FileSize(F) <> 0 then
    begin
      repeat
        Read(F, FavoritesAtual);
        SetLength(FileFavorites, I);
        FileFavorites[Pred(I)] := FavoritesAtual;
        Inc(I);
      until eof(f);
    end;
    CloseFile(F);
  end;
end;

procedure SaveFavorites;
var
  F: file of TIconFavorites;
  I: Integer;
begin
  AssignFile(F, ExtractFilePath(Application.ExeName) + FileIconFavorites);
  ReWrite(F);
  for I := Low(FileFavorites) to High(FileFavorites) do
    Write(F, FileFavorites[I]);
  CloseFile(F);
end;

initialization

  LoadFavorites;

finalization

  SaveFavorites;
  
end.
