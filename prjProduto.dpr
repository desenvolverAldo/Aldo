program prjProduto;

uses
  Forms,
  untProduto in 'untProduto.pas' {frmProduto},
  DM in 'DM.pas' {DMPrincipal: TDataModule},
  untCadProduto in 'untCadProduto.pas' {frmCadProduto};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmProduto, frmProduto);
  Application.CreateForm(TDMPrincipal, DMPrincipal);
  Application.CreateForm(TfrmCadProduto, frmCadProduto);
  Application.Run;
end.
