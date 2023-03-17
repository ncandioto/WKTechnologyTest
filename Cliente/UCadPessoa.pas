unit UCadPessoa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DBXDataSnap, Data.DBXCommon,
  IPPeerClient, Data.DB, Data.SqlExpr, Vcl.StdCtrls, UMetodos,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  Datasnap.DBClient, FireDAC.Stan.StorageBin, UConsultaCEP, System.Threading,
  Vcl.Mask, Vcl.ExtCtrls, Vcl.DBCtrls;

type
  TfmCadPessoa = class(TForm)
    SQLConnection: TSQLConnection;
    DSDados: TDataSource;
    FDMemTable: TFDMemTable;
    btBuscarPessoa: TButton;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    FDUPdatePessoa: TFDMemTable;
    lblNomePessoa: TLabel;
    edtFiltroNmPessoa: TEdit;
    FDMemEndereco: TFDMemTable;
    dsEndereco: TDataSource;
    gpDadosPessoa: TGroupBox;
    edtNome: TDBEdit;
    lbNmPessoa: TLabel;
    lbSobrenome: TLabel;
    edtSobrenome: TDBEdit;
    lbDocumento: TLabel;
    edtDocumento: TDBEdit;
    lbDtRegistro: TLabel;
    DBEdit1: TDBEdit;
    gpEndereco: TGroupBox;
    lbCep: TLabel;
    btnCEP: TButton;
    DBGrid2: TDBGrid;
    pnBotoes: TPanel;
    btnExcluir: TButton;
    btnUdpate: TButton;
    btInserirLote: TButton;
    btnAtualizarEndereco: TButton;
    edtCEP: TEdit;
    FDUpdateEndereco: TFDMemTable;
    btnInsert: TButton;
    cbNatureza: TComboBox;
    CaminhoCSV: TOpenDialog;
    procedure btBuscarPessoaClick(Sender: TObject);
    procedure btnUdpateClick(Sender: TObject);
    procedure btnCEPClick(Sender: TObject);
    procedure btInserirLoteClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure edtCEPKeyPress(Sender: TObject; var Key: Char);
    procedure FDMemEnderecoAfterInsert(DataSet: TDataSet);
    procedure FDMemTableAfterInsert(DataSet: TDataSet);
    procedure btnInsertClick(Sender: TObject);
    procedure cbNaturezaChange(Sender: TObject);
    procedure btnAtualizarEnderecoClick(Sender: TObject);
  private
    procedure GetPessoa(const psFiltro: String);
    procedure Update;
    procedure UpdatePessoa;
    procedure UpdateEndereco;
    procedure Insert;
    procedure InsertPessoa;
  end;

var
  fmCadPessoa: TfmCadPessoa;

implementation

{$R *.dfm}

function CopyStream(const AStream: TStream): TMemoryStream;
var
  LBuffer: TBytes;
  LCount: Integer;
begin
  Result := TMemoryStream.Create;

  try
    SetLength(LBuffer, 1024 * 32);

    while True do
    begin
      LCount := AStream.Read(LBuffer, Length(LBuffer));
      Result.Write(LBuffer, LCount);

      if LCount < Length(LBuffer) then
        break;
    end;
  except
    Result.Free;
    raise;
  end;
end;

procedure TfmCadPessoa.btBuscarPessoaClick(Sender: TObject);
begin
  GetPessoa(edtFiltroNmPessoa.Text);
end;

procedure TfmCadPessoa.btnUdpateClick(Sender: TObject);
begin
  Update;
end;

procedure TfmCadPessoa.cbNaturezaChange(Sender: TObject);
begin
  if Not (FDMemTable.State in dsEditModes) then
    FDMemTable.Edit;

  FDMemTable.FieldByName('FLNATUREZA').AsInteger := cbNatureza.ItemIndex;
end;

procedure TfmCadPessoa.btnAtualizarEnderecoClick(Sender: TObject);
var
  Temp: TMetodos;
begin
  Temp := TMetodos.Create(sqlconnection.DBXConnection);

  try
    If Temp.AtualizarEnderecos Then
      ShowMessage('Endereços atualizados com sucesso.!')
    Else
      ShowMessage('Ocorreu um erro ao atualizar os endereços.');
  finally
    temp.Free;
  end;
end;

procedure TfmCadPessoa.btnCEPClick(Sender: TObject);
begin
  TTask.Run(
      procedure
      var
        cc: TConsultaCEP;
      begin
        cc := TConsultaCEP.Create;
        try
          cc.ConsultarCEP(edtCEP.Text, FDMemEndereco);
        finally
          cc.Free;
        end;
      end);
end;

procedure TfmCadPessoa.edtCEPKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ['a'..'z'] then
    Key := #0
end;

procedure TfmCadPessoa.FDMemEnderecoAfterInsert(DataSet: TDataSet);
begin
   Dataset.FieldByName('flInserido').ReadOnly := False;
   Dataset.FieldByName('flInserido').AsString := '1';
   Dataset.FieldByName('idPessoa').AsFloat := FDMemTable.FieldByName('idPessoa').AsFloat;
end;

procedure TfmCadPessoa.FDMemTableAfterInsert(DataSet: TDataSet);
begin
   Dataset.FieldByName('flInserido').ReadOnly := False;
   Dataset.FieldByName('flInserido').AsString := '1';
end;

procedure TfmCadPessoa.GetPessoa(const psFiltro: String);
var
  Temp: TMetodos;
  LMemStream: TMemoryStream;
  idPessoa: integer;
begin
  TEmp := TMetodos.Create(sqlconnection.DBXConnection);
   LMemStream := CopyStream(TEmp.GetPessoa(psFiltro));

  try
      LMemStream.Position := 0;

      FDMemTable.LoadFromStream(LMemStream);

      if FDMemTable.IsEmpty then
      Begin
        if MessageDlg('Pessoa não encontrada. Deseja inserir ?', mtConfirmation, [mbYes, mbNo],0) = mrNo then
        Begin
          btnInsert.Visible := False;
          btnUdpate.Visible := False;
          btnExcluir.Visible := False;

          FDMemTable.Close;
          FDMemEndereco.Close;
          edtFiltroNmPessoa.Clear;
          edtFiltroNmPessoa.SetFocus;
          Exit;
        End;

        FDMemTable.Append;
        btnInsert.Visible := True;
        btnUdpate.Visible := False;
        btnExcluir.Visible := False;
        edtNome.SetFocus;
        cbNatureza.ItemIndex := 0;
      End
      Else
      Begin
         btnInsert.Visible := False;
         btnUdpate.Visible := True;
         btnExcluir.Visible := True;
         edtNome.SetFocus;

         cbNatureza.ItemIndex := FDMemTable.FieldByName('FLNATUREZA').AsInteger;
      End;

      idPessoa := FDMemTable.FieldByName('idPessoa').AsInteger;
      LMemStream := CopyStream(Temp.GetEndereco(idPessoa));

      LMemStream.Position := 0;
      FDMemEndereco.LoadFromStream(LMemStream);

  finally
    temp.Free;
  end;
end;

procedure TfmCadPessoa.Insert;
begin
  InsertPessoa;
  UpdateEndereco;
end;

procedure TfmCadPessoa.InsertPessoa;
var
  Temp: TMetodos;
  LMemStream: TMemoryStream;
begin
  LMemStream := TMemoryStream.Create;

  FDUpdatePessoa.CopyDataSet(FDMemTable, [coStructure]);
  FDUpdatePessoa.Append;
  FDUpdatePessoa.CopyRecord(FDMemTable);
  FDUpdatePessoa.Post;

  Temp := TMetodos.Create(sqlconnection.DBXConnection);

  FDUpdatePessoa.SaveToStream(LMemStream);
  try
      LMemStream.Position := 0;

      if Not (FDMemTable.State in DsEditModes) then
        FDMemTable.Edit;

      FDMemTable.FieldByName('idpessoa').AsFloat := Temp.InsertPessoa(LMemStream);
  finally
    temp.Free;
  end;
end;

procedure TfmCadPessoa.Update;
begin
  UpdatePessoa;
  UpdateEndereco
end;

procedure TfmCadPessoa.UpdateEndereco;
var
  Temp: TMetodos;
  LMemStream: TMemoryStream;
begin
  LMemStream := TMemoryStream.Create;

  if NOt (FDMEmENdereco.State in DsEditMOdes) then
    FDMEmENdereco.Edit;
  FDMemEndereco.FieldByName('idPessoa').AsFloat := FDMemTable.FieldByName('idPessoa').AsFloat;
  FDMEmENdereco.Post;

  FDUpdateEndereco.CopyDataSet(FDMemEndereco, [coStructure]);
  FDUpdateEndereco.Append;
  FDUpdateEndereco.CopyRecord(FDMemEndereco);
  FDUpdateEndereco.Post;

  Temp := TMetodos.Create(sqlconnection.DBXConnection);

  FDUpdateEndereco.SaveToStream(LMemStream);
  try
      LMemStream.Position := 0;

      Temp.UpdateEndereco(LMemStream);
  finally
    temp.Free;
  end;
end;

procedure TfmCadPessoa.UpdatePessoa;
var
  Temp: TMetodos;
  LMemStream: TMemoryStream;
begin
  LMemStream := TMemoryStream.Create;

  FDUpdatePessoa.CopyDataSet(FDMemTable, [coStructure]);
  FDUpdatePessoa.Append;
  FDUpdatePessoa.CopyRecord(FDMemTable);
  FDUpdatePessoa.Post;

  Temp := TMetodos.Create(sqlconnection.DBXConnection);

  FDUpdatePessoa.SaveToStream(LMemStream);
  try
      LMemStream.Position := 0;

      Temp.UpdatePessoa(LMemStream);
  finally
    temp.Free;
  end;
end;

procedure TfmCadPessoa.btInserirLoteClick(Sender: TObject);
var
  Temp: TMetodos;
  sArquivo: String;
begin
  Temp := TMetodos.Create(sqlconnection.DBXConnection);

  try
    if Not (CaminhoCSV.Execute) then
      Exit;
    sArquivo:= CaminhoCSV.FileName;

    Temp.InserirEmLote(sArquivo);
  finally
    temp.Free;
  end;
end;

procedure TfmCadPessoa.btnExcluirClick(Sender: TObject);
var
  Temp: TMetodos;
  idPessoa: integer;
begin
  TEmp := TMetodos.Create(sqlconnection.DBXConnection);
  try
      idPessoa := FDMemTable.FieldByName('idPessoa').AsInteger;

      Temp.DeletePessoa(idPessoa);

      FDMemTable.Close;
      FDMemEndereco.Close;
      edtFiltroNmPessoa.Clear;
      cbNatureza.ItemIndex := 0;
      edtCEP.Clear;
      edtFiltroNmPessoa.SetFocus;
  finally
    temp.Free;
  end;
end;

procedure TfmCadPessoa.btnInsertClick(Sender: TObject);
begin
  Insert;

  btnInsert.Visible := False;
  btnUdpate.Visible := True;
  btnExcluir.Visible := True;
  edtNome.SetFocus;

  cbNatureza.ItemIndex := FDMemTable.FieldByName('FLNATUREZA').AsInteger;
end;

end.
