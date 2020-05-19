program IconToolsTest;

uses
  Forms,
  IconToolsTestUnit in 'IconToolsTestUnit.pas' {FormIconTest},
  IconTools in 'IconTools.pas',
  IconLibrary in 'IconLibrary.pas',
  IconTypes in 'IconTypes.pas';
{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormIconTest, FormIconTest);
  Application.Run;
end.
