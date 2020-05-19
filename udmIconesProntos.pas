unit udmIconesProntos;

interface

uses
  SysUtils, Classes, ImgList, Controls;

type
  TdmIconesProntos = class(TDataModule)
    ILAjuda: TImageList;
    ILAnimal: TImageList;
    ILBandeira: TImageList;
    ILComputador: TImageList;
    ILEscritorio: TImageList;
    ILEscrita: TImageList;
    ILEmail: TImageList;
    ILComunicacao: TImageList;
    ILGrafico: TImageList;
    ILIndustria: TImageList;
    ILLixeira: TImageList;
    ILMiscelanea: TImageList;
    ILRelatorio: TImageList;
    ILProcurar: TImageList;
    ILNatureza: TImageList;
    ILMultimidia: TImageList;
    ILSeta: TImageList;
    ILTransito: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmIconesProntos: TdmIconesProntos;

implementation

{$R *.dfm}

end.
