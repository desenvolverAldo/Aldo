unit untProduto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls, DM, untCadProduto;

type
  TfrmProduto = class(TForm)
    Panel1: TPanel;
    btnIncluir: TBitBtn;
    btnAlterar: TBitBtn;
    btnExcluir: TBitBtn;
    dbgrdProduto: TDBGrid;
    btnFechar: TBitBtn;
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure prcCadastroProduto(sTipo: string); // Abrir a tela do Cadastro de Prouto sendo Tipo I -> botão Incluir e A -> botão Alterar
    procedure prcAtualizarGrid;
    procedure prcValidarEscolha;
  public
    { Public declarations }
  end;

var
  frmProduto: TfrmProduto;

implementation

uses DB, ADODB;

{$R *.dfm}

procedure TfrmProduto.btnIncluirClick(Sender: TObject);
begin
  prcCadastroProduto('I');
end;

procedure TfrmProduto.btnAlterarClick(Sender: TObject);
begin
  prcValidarEscolha;

  prcCadastroProduto('A');
end;

procedure TfrmProduto.prcCadastroProduto(sTipo: string);
begin
  frmCadProduto := TfrmCadProduto.Create(Application);

  with frmCadProduto do
  begin
    sTpCadastro := sTipo;
    prcLimparCampos;

    if sTipo = 'A' then
    begin
      sCodigo        := DMPrincipal.qryGridProdutocod_Produto.AsString;
      edtCodigo.Text := sCodigo;
    end;

    ShowModal;
    prcAtualizarGrid;
  end;
end;

procedure TfrmProduto.btnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmProduto.prcValidarEscolha;
begin
  if (DMPrincipal.qryGridProduto.IsEmpty) or (DMPrincipal.qryGridProdutocod_Produto.IsNull) then
  begin
    ShowMessage('Informe um produto para ser alterado');
    Abort;
  end;
end;

procedure TfrmProduto.btnExcluirClick(Sender: TObject);
begin
  prcValidarEscolha;

  if MessageDlg('Deeja realmente excluir o produto ' + DMPrincipal.qryGridProdutonm_produto.AsString + '?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
  begin
    Abort;
  end;

  try
    with DMPrincipal.qrySQL do
    begin
      Close;
      SQL.Clear;

      SQL.Add('delete from TAB_PRODUTO');
      SQL.Add('where cod_Produto = ' + DMPrincipal.qryGridProdutocod_Produto.AsString);

      ExecSQL;
    end;

    ShowMessage('Produto foi excluído com sucesso.');
    prcAtualizarGrid;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao fazer a exclusão do produto. ' + E.Message);
    end;
  end;
end;

procedure TfrmProduto.prcAtualizarGrid;
begin
  with DMPrincipal.qryGridProduto do
  begin
    Close;

    SQL.Clear;
    SQL.Add('select cod_Produto, nm_Produto, ds_Produto, qt_Produto, vl_Produto, ck_Ativo, dt_Cadastro from TAB_PRODUTO');

    Open;
  end;
end;

procedure TfrmProduto.FormShow(Sender: TObject);
begin
  prcAtualizarGrid;
end;

end.
