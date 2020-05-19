unit uFrWebBrowser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, OleCtrls, SHDocVw, Buttons, ExtCtrls, StdCtrls, ComCtrls;

const
  CM_HOMEPAGEREQUEST = WM_USER + $1000;
    
type
  TfFrWebBrowser = class(TFrame)
    WebBrowser1: TWebBrowser;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    StopBtn: TSpeedButton;
    SpeedButton4: TSpeedButton;
    URLs: TComboBox;
    StatusBar1: TStatusBar;
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure URLsClick(Sender: TObject);
    procedure URLsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure WebBrowser1BeforeNavigate2(Sender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure WebBrowser1DownloadBegin(Sender: TObject);
    procedure WebBrowser1DownloadComplete(Sender: TObject);
  private
    { Private declarations }
    HistoryIndex: Integer;
    HistoryList: TStringList;
    UpdateCombo: Boolean;
    procedure FindAddress;
    procedure HomePageRequest(var message: tmessage); message CM_HOMEPAGEREQUEST;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

constructor TfFrWebBrowser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  HistoryIndex := -1;
  HistoryList := TStringList.Create;
  { Find the home page - needs to be posted because HTML control hasn't been
    registered yet. }
  PostMessage(Handle, CM_HOMEPAGEREQUEST, 0, 0);
end;

destructor TfFrWebBrowser.Destroy;
begin
  HistoryList.Free;
end;

procedure TfFrWebBrowser.FindAddress;
var
  Flags: OLEVariant;

begin
  Flags := 0;
  UpdateCombo := True;
  WebBrowser1.Navigate(WideString(Urls.Text), Flags, Flags, Flags, Flags);
end;

procedure TfFrWebBrowser.HomePageRequest(var message: tmessage);
begin
  URLs.Text := 'http://www.mogai.com.br';
  FindAddress;
end;

procedure TfFrWebBrowser.SpeedButton1Click(Sender: TObject);
begin
  URLs.Text := HistoryList[HistoryIndex - 1];
  FindAddress;
end;

procedure TfFrWebBrowser.SpeedButton2Click(Sender: TObject);
begin
  URLs.Text := HistoryList[HistoryIndex + 1];
  FindAddress;
end;

procedure TfFrWebBrowser.StopBtnClick(Sender: TObject);
begin
  WebBrowser1.Stop;
end;

procedure TfFrWebBrowser.SpeedButton4Click(Sender: TObject);
begin
  FindAddress;
end;

procedure TfFrWebBrowser.URLsClick(Sender: TObject);
begin
  FindAddress;
end;

procedure TfFrWebBrowser.URLsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Return then
  begin
    FindAddress;
  end;
end;

procedure TfFrWebBrowser.WebBrowser1BeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var
  NewIndex: Integer;
begin
  NewIndex := HistoryList.IndexOf(URL);
  if NewIndex = -1 then
  begin
    { Remove entries in HistoryList between last address and current address }
    if (HistoryIndex >= 0) and (HistoryIndex < HistoryList.Count - 1) then
      while HistoryList.Count > HistoryIndex do
        HistoryList.Delete(HistoryIndex);
    HistoryIndex := HistoryList.Add(URL);
  end
  else
    HistoryIndex := NewIndex;
  if UpdateCombo then
  begin
    UpdateCombo := False;
    NewIndex := URLs.Items.IndexOf(URL);
    if NewIndex = -1 then
      URLs.Items.Insert(0, URL)
    else
      URLs.Items.Move(NewIndex, 0);
  end;
  URLs.Text := URL;
  Statusbar1.Panels[0].Text := URL;
end;

procedure TfFrWebBrowser.WebBrowser1DownloadBegin(Sender: TObject);
begin
  { Turn the stop button dark red }
//  StopBtn.ImageIndex := 4;
end;

procedure TfFrWebBrowser.WebBrowser1DownloadComplete(Sender: TObject);
begin
  { Turn the stop button grey }
//  StopBtn.ImageIndex := 2;
end;

end.
