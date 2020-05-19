program IconTools_2;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  IconTypes in '..\Icontypes.pas',
  IconLibrary in '..\IconLibrary.pas',
  IconImage in '..\IconImage.pas',
  AdvancedIcon in '..\AdvancedIcon.pas',
  IconTools in '..\IconTools.pas',
  IconConvert in '..\..\..\IconClassic.1\Tools\IconConvert.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
