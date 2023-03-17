unit ServerMethods;

interface

uses
  System.SysUtils, System.Classes, Datasnap.DSServer, 
  Datasnap.DSAuth, Datasnap.DSProviderDataModuleAdapter, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Stan.StorageBin, DataSnap.DBClient,
  UConsultaCEP, System.Threading;

type
{$METHODINFO ON}
  TDSServerModule1 = class(TDSServerModule)
    FDConnection: TFDConnection;
    FDPhysPgDriverLink: TFDPhysPgDriverLink;
    FDQuery: TFDQuery;
    FDSchemaAdapter: TFDSchemaAdapter;
    FDStanStorageBinLink: TFDStanStorageBinLink;
    FDAtualizar: TFDQuery;
  private
    function GetProximoId(const psTabela, psCampo: string): Double;
  public
    function GetPessoa(pNmPessoa: String): TStream;
    function GetEndereco(pIdPessoa: Integer): TStream;
    procedure DeletePessoa(idPessoa: integer);
    procedure UpdatePessoa(StreamPessoa: TStream);
    procedure UpdateEndereco(StreamEndereco: TStream);
    function InsertPessoa(StreamPessoa: TStream): Double;
    procedure InserirEmLote(psCaminhoCSV: String);
    function AtualizarEnderecos: Boolean;
  end;
  {$METHODINFO OFF}

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDSServerModule1 }

function TDSServerModule1.AtualizarEnderecos: Boolean;
var
  FieldCep: TField;
begin
  Result := False;

    FDAtualizar.Open('SELECT EI.*, E.DSCEP FROM ENDERECO_INTEGRACAO EI' +
      ' JOIN ENDERECO E ON E.IDENDERECO = EI.IDENDERECO' +
      ' WHERE E.DSCEP <> '''' ');

    FDAtualizar.First;
    FieldCep := FDATualizar.FindField('DSCEP');

    while not FDAtualizar.eof do
    Begin
      TTask.Run(
        procedure
        var
          cc: TConsultaCEP;
        begin
          cc := TConsultaCEP.Create;
          try
            cc.ConsultarCEP(FieldCep.AsString, TFDMemTable(FDAtualizar));
          finally
            cc.Free;
          end;
        end);

      FDAtualizar.Next;
    End;

   // FDAtualizar.ApplyUpdates;

    Result := True;
end;

procedure TDSServerModule1.DeletePessoa(idPessoa: integer);
begin
   FDQuery.Close;
   FDQuery.ExecSQL('DELETE FROM PESSOA WHERE IDPESSOA = ' + idPessoa.ToString)
end;

function TDSServerModule1.GetEndereco(pIdPessoa: Integer): TStream;
var
   Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;

  FDQuery.Close;
  FDQuery.Open('SELECT E.DSCEP, E.IDPESSOA, EI.*, 0 as FLINSERIDO FROM ENDERECO_INTEGRACAO EI' +
    ' JOIN ENDERECO E ON E.IDENDERECO = EI.IDENDERECO' +
    ' WHERE IDPESSOA = ' + pIdPessoa.ToString);
  FDQuery.SaveToStream(Stream);
  Stream.Position := 0;

  Result := Stream;
end;

function TDSServerModule1.GetPessoa(pNmPessoa: String): TStream;
var
   Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;

  FDQuery.Close;
  FDQuery.Open('SELECT P.*, 0 AS FLINSERIDO FROM PESSOA P  WHERE UPPER(P.NMPRIMEIRO) LIKE ''%' + UpperCase(pNmPessoa) + '%'' Limit 1');
  FDQuery.SaveToStream(Stream);
  Stream.Position := 0;

  Result := Stream;
end;

function TDSServerModule1.GetProximoId(const psTabela, psCampo: string): Double;
var
  FDQryProximoId: TFDQuery;
begin
  FDQryProximoId := TFDQuery.Create(FDConnection);
  try
     FDQryProximoId.Connection := FDConnection;

     FDQryProximoId.Open('SELECT COALESCE( MAX(' + psCampo + '), 0) + 1 as ProximoID FROM ' + psTabela);

     result := FDQryProximoId.FieldByName('ProximoID').AsFloat;
  finally
    FreeAndNil(FDQryProximoId);
  end;
end;

procedure TDSServerModule1.InserirEmLote(psCaminhoCSV: String);
var
  lStringListFile: TStringList;
  lStringListLine: TStringList;
  lCounter: integer;
  SQLCommand: STring;
  iDPessoa: Double;
begin
  lStringListFile := TStringList.Create;
  lStringListLine := TStringList.Create;
  try
    lStringListFile.LoadFromFile(psCaminhoCSV);

    SQLCommand := 'INSERT INTO PESSOA (IDPESSOA, DSDOCUMENTO, FLNATUREZA, NMPRIMEIRO, NMSEGUNDO, DTREGISTRO) ' +
       ' VALUES ( ' +
       ' :IDPESSOA, ' +
       ' :DSDOCUMENTO, ' +
       ' :FLNATUREZA,  ' +
       ' :NMPRIMEIRO,  ' +
       ' :NMSEGUNDO,   ' +
       ' :DTREGISTRO)   ';

    FDQuery.SQL.Text := SQLCommand;
    FDQuery.Params.ArraySize := lStringListFile.Count;

    iDPessoa := GetProximoId('PESSOA', 'IDPESSOA');

    for lCounter := 0 to Pred(lStringListFile.Count) do
    begin
      lStringListLine.StrictDelimiter := True;
      lStringListLine.CommaText := lStringListFile[lCounter];

      FDQuery.ParamByName('idPessoa').AsFloats[lCounter] := IDPessoa;
      FDQuery.ParamByName('flNatureza').AsIntegers[lCounter] := StrToInt(lStringListLine[0]);
      FDQuery.ParamByName('dsdocumento').AsStrings[lCounter] := lStringListLine[1];
      FDQuery.ParamByName('nmprimeiro').AsStrings[lCounter] := lStringListLine[2];
      FDQuery.ParamByName('nmsegundo').AsStrings[lCounter] := lStringListLine[3];
      FDQuery.ParamByName('dtregistro').AsDateTimes[lCounter] := StrToDateTime(lStringListLine[4]);

     IDPessoa := IDPEssoa + 1;
    end;
    FDQuery.Execute(lStringListFile.Count, 0);
  finally
    lStringListLine.Free;
    lStringListFile.Free;
  end;
end;

function TDSServerModule1.InsertPessoa(StreamPessoa: TStream): Double;
var
  FDQUerySTream: TFDMemTable;
  SQLCommand: STring;
  IdPessoa: Double;
begin
   FDQUerySTream := TFDMemTable.Create(nil);

   try
     StreamPessoa.Position := soFromBeginning;
     FDQUerySTream.LoadFromStream(StreamPessoa);

     SQLCommand := 'INSERT INTO PESSOA (IDPESSOA, DSDOCUMENTO, FLNATUREZA, NMPRIMEIRO, NMSEGUNDO, DTREGISTRO) ' +
        ' VALUES ( ' +
       ' :IDPESSOA, ' +
       ' :DSDOCUMENTO, ' +
       ' :FLNATUREZA,  ' +
       ' :NMPRIMEIRO,  ' +
       ' :NMSEGUNDO,   ' +
       ' :DTREGISTRO)   ';

     FDQUery.SQL.Text := SQLCommand;

     IdPessoa := GetProximoId('pessoa', 'idpessoa');
     FDQuery.ParamByName('IDPESSOA').AsFloat := IdPessoa;
     FDQuery.ParamByName('DSDOCUMENTO').AsString := FDQUerySTream.FieldByName('DSDOCUMENTO').AsString;
     FDQuery.ParamByName('FLNATUREZA').AsInteger := FDQUerySTream.FieldByName('FLNATUREZA').AsInteger;
     FDQuery.ParamByName('NMPRIMEIRO').AsString := FDQUerySTream.FieldByName('NMPRIMEIRO').AsString;
     FDQuery.ParamByName('NMSEGUNDO').AsString := FDQUerySTream.FieldByName('NMSEGUNDO').AsString;
     FDQuery.ParamByName('DTREGISTRO').AsDateTime := Now;
     FDQUery.ExecSQL;

     Result := IdPessoa;
   finally
     FreeAndNil(FDQueryStream);
   end;
end;

procedure TDSServerModule1.UpdateEndereco(StreamEndereco: TStream);
var
  FDQUerySTream: TFDMemTable;
  SQLCommand: STring;
  idEndereco: Double;
begin
   FDQUerySTream := TFDMemTable.Create(nil);

   try
     StreamEndereco.Position := soFromBeginning;
     FDQUerySTream.LoadFromStream(StreamEndereco);

     FDQUerySTream.First;
     while Not FDQUerySTream.eof do
     Begin
       if FDQueryStream.FieldByName('FLINSERIDO').AsString = '1' then
       Begin
         SQLCommand := 'INSERT INTO ENDERECO (IDENDERECO, IDPESSOA, DSCEP) VALUES (:IDENDERECO, :IDPESSOA, :DSCEP) ';

         FDQUery.SQL.Text := SQLCommand;

         idEndereco := GetProximoId('ENDERECO', 'IDENDERECO');
         FDQuery.ParamByName('IDENDERECO').AsFloat := idEndereco;
         FDQuery.ParamByName('IDPESSOA').AsInteger := FDQUerySTream.FieldByName('IDPESSOA').AsInteger;
         FDQuery.ParamByName('DSCEP').AsString := FDQUerySTream.FieldByName('DSCEP').AsString;
         FDQUery.ExecSQL;

         SQLCommand := 'INSERT INTO ENDERECO_INTEGRACAO (IDENDERECO, DSUF, NMCIDADE, NMBAIRRO, NMLOGRADOURO, DSCOMPLEMENTO) ' +
           ' VALUES (:IDENDERECO, :DSUF, :NMCIDADE, :NMBAIRRO, :NMLOGRADOURO, :DSCOMPLEMENTO) ';

         FDQUery.SQL.Text := SQLCommand;

         FDQuery.ParamByName('IDENDERECO').AsFloat := idEndereco;
         FDQuery.ParamByName('DSUF').AsString := FDQUerySTream.FieldByName('DSUF').AsString;
         FDQuery.ParamByName('NMCIDADE').AsString := FDQUerySTream.FieldByName('NMCIDADE').AsString;
         FDQuery.ParamByName('NMBAIRRO').AsString := FDQUerySTream.FieldByName('NMBAIRRO').AsString;
         FDQuery.ParamByName('NMLOGRADOURO').AsString := FDQUerySTream.FieldByName('NMLOGRADOURO').AsString;
         FDQuery.ParamByName('DSCOMPLEMENTO').AsString := FDQUerySTream.FieldByName('DSCOMPLEMENTO').AsString;
         FDQUery.ExecSQL;
       End
       Else
       Begin
         SQLCommand := 'UPDATE ENDERECO SET DSCEP = :DSCEP ' +
           ' WHERE IDPESSOA = :IDPESSOA AND IDENDERECO = :IDENDERECO';

         FDQUery.SQL.Text := SQLCommand;

         FDQuery.ParamByName('DSCEP').AsString := FDQUerySTream.FieldByName('DSCEP').AsString;
         FDQuery.ParamByName('IDENDERECO').AsInteger := FDQUerySTream.FieldByName('IDENDERECO').AsInteger;
         FDQUery.ExecSQL;

         SQLCommand := 'UPDATE ENDERECO_INTEGRACAO SET ' +
            'DSUF = :DSUF, ' +
            'NMCIDADE = :NMCIDADE, ' +
            'NMBAIRRO = :NMBAIRRO, ' +
            'NMLOGRADOURO = :NMLOGRADOURO, ' +
            'DSCOMPLEMENTO = :DSCOMPLEMENTO ' +
           ' WHERE IDENDERECO = :IDENDERECO';

         FDQUery.SQL.Text := SQLCommand;

         FDQuery.ParamByName('DSUF').AsString := FDQUerySTream.FieldByName('DSUF').AsString;
         FDQuery.ParamByName('NMCIDADE').AsString := FDQUerySTream.FieldByName('NMCIDADE').AsString;
         FDQuery.ParamByName('NMBAIRRO').AsString := FDQUerySTream.FieldByName('NMBAIRRO').AsString;
         FDQuery.ParamByName('NMLOGRADOURO').AsString := FDQUerySTream.FieldByName('NMLOGRADOURO').AsString;
         FDQuery.ParamByName('DSCOMPLEMENTO').AsString := FDQUerySTream.FieldByName('DSCOMPLEMENTO').AsString;
         FDQuery.ParamByName('IDENDERECO').AsInteger := FDQUerySTream.FieldByName('IDENDERECO').AsInteger;
         FDQUery.ExecSQL;
       End;

       FDQUerySTream.Next
     End;
   finally
     FreeAndNil(FDQueryStream);
   end;
end;

procedure TDSServerModule1.UpdatePessoa(StreamPessoa: TStream);
var
  FDQUerySTream: TFDMemTable;
  SQLCommand: STring;
begin
   FDQUerySTream := TFDMemTable.Create(nil);

   try
     StreamPessoa.Position := soFromBeginning;
     FDQUerySTream.LoadFromStream(StreamPessoa);

     SQLCommand := 'UPDATE PESSOA SET DSDOCUMENTO = :DSDOCUMENTO, ' +
       ' FLNATUREZA = :FLNATUREZA, ' +
       ' NMPRIMEIRO = :NMPRIMEIRO, ' +
       ' NMSEGUNDO =  :NMSEGUNDO  ' +
       ' WHERE IDPESSOA = :IDPESSOA';

     FDQUery.SQL.Text := SQLCommand;

     FDQuery.ParamByName('DSDOCUMENTO').AsString := FDQUerySTream.FieldByName('DSDOCUMENTO').AsString;
     FDQuery.ParamByName('FLNATUREZA').AsInteger := FDQUerySTream.FieldByName('FLNATUREZA').AsInteger;
     FDQuery.ParamByName('NMPRIMEIRO').AsString := FDQUerySTream.FieldByName('NMPRIMEIRO').AsString;
     FDQuery.ParamByName('NMSEGUNDO').AsString := FDQUerySTream.FieldByName('NMSEGUNDO').AsString;
     FDQuery.ParamByName('IDPESSOA').AsInteger := FDQUerySTream.FieldByName('IDPESSOA').AsInteger;
     FDQUery.ExecSQL;

   finally
     FreeAndNil(FDQueryStream);
   end;
end;

end.

