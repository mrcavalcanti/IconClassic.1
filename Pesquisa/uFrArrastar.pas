unit uFrArrastar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ComCtrls, ExtCtrls, ImgList, ShlObj, ShellAPI, Grids,
  mccsIconGrid;

type
  TfFrArrastar = class(TFrame)
    pnlIcones: TPanel;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    IconGrid: TmccsIconGrid;
  private
    { Private declarations }
    Pic: TPicture;    
    Fname : String;
    TempFile: array[0..255] of Char;
    Drop : THandle; {Handle for Msg.wParam}

    FOnClickArrastar: TNotifyEventIconGrid;
    FOnDblClickArrastar: TNotifyEventIconGrid;

    procedure SetOnClickArrastar(Value: TNotifyEventIconGrid);
    procedure SetOnDblClickArrastar(Value: TNotifyEventIconGrid);
  public
    { Public declarations }
    procedure WMDrop(var Msg: TMessage);

    property OnClick: TNotifyEventIconGrid read FOnClickArrastar write SetOnClickArrastar;
    property OnDblClick: TNotifyEventIconGrid read FOnDblClickArrastar write SetOnDblClickArrastar;
  end;

implementation

{$R *.dfm}

{ TfFrArrastar }

procedure TfFrArrastar.SetOnClickArrastar(Value: TNotifyEventIconGrid);
begin
  FOnClickArrastar := Value;
  if Assigned(FOnClickArrastar) then
      IconGrid.OnClickIcon := FOnClickArrastar;
end;

procedure TfFrArrastar.SetOnDblClickArrastar(Value: TNotifyEventIconGrid);
begin
  FOnDblClickArrastar := Value;
  if Assigned(FOnDblClickArrastar) then
      IconGrid.OnDblClickIcon := FOnDblClickArrastar;
end;

procedure TfFrArrastar.WMDrop(var Msg: TMessage);
var
  i,
  NumFiles, NameLength : integer;
begin
  try
    screen.cursor := crHourglass;
    IconGrid.IconImageList.Clear;
    Drop := Msg.wParam;

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

      IconGrid.FileNames.Add(FName)
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

end.
