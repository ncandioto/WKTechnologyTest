unit UMetodos;

interface

uses System.JSON, Data.DBXCommon, Data.DBXClient, Data.DBXDataSnap,
     Data.DBXJSON, Datasnap.DSProxy, System.Classes, System.SysUtils, Data.DB,
     Data.SqlExpr, Data.DBXDBReaders, Data.DBXCDSReaders, Data.DBXJSONReflect,
     System.Variants;

type
  TMetodos = class(TDSAdminClient)
  private
    FSumCommand: TDBXCommand;
  public
    constructor Create(ADBXConnection: TDBXConnection); overload;
    constructor Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean); overload;
    destructor Destroy; override;
    function GetPessoa(pNmPessoa: String): TSTream;
    procedure UpdatePessoa(StreamPessoa: TStream);
    function GetEndereco(pIdPessoa: integer): TStream;
    procedure DeletePessoa(pIdPessoa: integer);
    function InsertPessoa(StreamPessoa: TStream): Double;
    procedure UpdateEndereco(StreamEndereco: TStream);
    procedure InserirEmLote(psCaminhoCSV: String);
    function AtualizarEnderecos: Boolean;
  end;

implementation

procedure TMetodos.UpdateEndereco(StreamEndereco: TStream);
var
  UpdateEnderecoCommand: TDBXCommand;
begin
  UpdateEnderecoCommand := FDBXConnection.CreateCommand;
  UpdateEnderecoCommand.CommandType := TDBXCommandTypes.DSServerMethod;
  UpdateEnderecoCommand.Text := 'TDSServerModule1.UpdateEndereco';
  UpdateEnderecoCommand.Prepare;

  UpdateEnderecoCommand.Parameters[0].Value.SetStream(StreamEndereco, False);
  UpdateEnderecoCommand.ExecuteUpdate;
end;

procedure TMetodos.UpdatePessoa(StreamPessoa: TStream);
var
   UpdatePessoaCommand: TDBXCommand;
begin
  UpdatePessoaCommand := FDBXConnection.CreateCommand;
  UpdatePessoaCommand.CommandType := TDBXCommandTypes.DSServerMethod;
  UpdatePessoaCommand.Text := 'TDSServerModule1.UpdatePessoa';
  UpdatePessoaCommand.Prepare;

  UpdatePessoaCommand.Parameters[0].Value.SetStream(StreamPessoa, False);
  UpdatePessoaCommand.ExecuteUpdate;
end;

constructor TMetodos.Create(ADBXConnection: TDBXConnection);
begin
  inherited Create(ADBXConnection);
end;

function TMetodos.AtualizarEnderecos: Boolean;
var
  GetAttEnderecoCommand: TDBXCommand;
begin
  GetAttEnderecoCommand := FDBXConnection.CreateCommand;
  GetAttEnderecoCommand.CommandType := TDBXCommandTypes.DSServerMethod;
  GetAttEnderecoCommand.Text := 'TDSServerModule1.AtualizarEnderecos';
  GetAttEnderecoCommand.Prepare;

  GetAttEnderecoCommand.ExecuteUpdate;

  Result := GetAttEnderecoCommand.Parameters[0].Value.GetBoolean;
end;

constructor TMetodos.Create(ADBXConnection: TDBXConnection; AInstanceOwner: Boolean);
begin
  inherited Create(ADBXConnection, AInstanceOwner);
end;

procedure TMetodos.DeletePessoa(pIdPessoa: integer);
var
   DeletePessoaCommand: TDBXCommand;
begin
  DeletePessoaCommand := FDBXConnection.CreateCommand;
  DeletePessoaCommand.CommandType := TDBXCommandTypes.DSServerMethod;
  DeletePessoaCommand.Text := 'TDSServerModule1.DeletePessoa';
  DeletePessoaCommand.Prepare;

  DeletePessoaCommand.Parameters[0].Value.SetInt32(pIdPessoa);
  DeletePessoaCommand.ExecuteUpdate;
end;

destructor TMetodos.Destroy;
begin
  FSumCommand.DisposeOf;
  inherited;
end;

function TMetodos.GetEndereco(pIdPessoa: integer): TStream;
var
   GetPessoaEndereco: TDBXCommand;
begin
  GetPessoaEndereco := FDBXConnection.CreateCommand;
  GetPessoaEndereco.CommandType := TDBXCommandTypes.DSServerMethod;
  GetPessoaEndereco.Text := 'TDSServerModule1.GetEndereco';
  GetPessoaEndereco.Prepare;

  GetPessoaEndereco.Parameters[0].Value.SetInt32(pIdPessoa);
  GetPessoaEndereco.ExecuteUpdate;

  Result := GetPessoaEndereco.Parameters[1].Value.GetStream;
end;

function TMetodos.GetPessoa(pNmPessoa: String): TStream;
var
   GetPessoaCommand: TDBXCommand;
begin
  GetPessoaCommand := FDBXConnection.CreateCommand;
  GetPessoaCommand.CommandType := TDBXCommandTypes.DSServerMethod;
  GetPessoaCommand.Text := 'TDSServerModule1.GetPessoa';
  GetPessoaCommand.Prepare;

  GetPessoaCommand.Parameters[0].Value.SetString(pNmPessoa);
  GetPessoaCommand.ExecuteUpdate;

  Result := GetPessoaCommand.Parameters[1].Value.GetStream;
end;

procedure TMetodos.InserirEmLote(psCaminhoCSV: String);
var
   GetLoteCommand: TDBXCommand;
begin
  GetLoteCommand := FDBXConnection.CreateCommand;
  GetLoteCommand.CommandType := TDBXCommandTypes.DSServerMethod;
  GetLoteCommand.Text := 'TDSServerModule1.InserirEmlote';
  GetLoteCommand.Prepare;

  GetLoteCommand.Parameters[0].Value.SetString(psCaminhoCSV);
  GetLoteCommand.ExecuteUpdate;
end;

function TMetodos.InsertPessoa(StreamPessoa: TStream): DOuble;
var
   UpdatePessoaCommand: TDBXCommand;
begin
  UpdatePessoaCommand := FDBXConnection.CreateCommand;
  UpdatePessoaCommand.CommandType := TDBXCommandTypes.DSServerMethod;
  UpdatePessoaCommand.Text := 'TDSServerModule1.InsertPessoa';
  UpdatePessoaCommand.Prepare;

  UpdatePessoaCommand.Parameters[0].Value.SetStream(StreamPessoa, False);

  UpdatePessoaCommand.ExecuteUpdate;

  Result := UpdatePessoaCommand.Parameters[1].Value.GetDouble;
end;

end.
