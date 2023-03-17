unit uConsultaCEP;

interface

uses
  FireDAC.Comp.Client;

type
  TConsultaCEP = class
  public
    function ConsultarCEP(const CEP: string; var FDEndereco: TFDMemTable): string;
  end;

implementation

uses
 System.SysUtils, REST.Client, REST.Types, System.Json, IPPeerClient, Data.DB;

{ TConsultaCEP }

function TConsultaCEP.ConsultarCEP(const CEP: string; var FDEndereco: TFDMemTable): string;
var
  RESTClient: TRESTClient;
  RESTRequest: TRESTRequest;
  RESTResponse: TRESTResponse;
  JSONObject: TJSONObject;
  JSONValue: TJSONValue;
begin
  RESTClient := TRESTClient.Create(Format('https://viacep.com.br/ws/%s/json', [CEP]));
  RESTResponse := TRESTResponse.Create(nil);
  RESTRequest := TRESTRequest.Create(nil);
  JSONObject := TJSONObject.Create;
  try
    RESTRequest.Client := RESTClient;
    RESTRequest.Response := RESTResponse;
    RESTRequest.Method := rmGET;

    try
      RESTRequest.Execute;
    Except
      ON E: exception do
        Result := e.Message;
    End;

    JSONObject.Parse(TEncoding.ASCII.GetBytes(RESTResponse.JSONValue.ToString), 0);
    Result := Result + JSONObject.GetValue('logradouro').Value;

    If Not (FDEndereco.State in dsEditModes) Then
      FDEndereco.Edit;

    if Assigned(FDEndereco.FindField('DSCEP')) then
      FDEndereco.FieldByName('DSCEP').AsString := JSONObject.GetValue('cep').Value;
    FDEndereco.FieldByName('NMLOGRADOURO').AsString := JSONObject.GetValue('logradouro').Value;
    FDEndereco.FieldByName('DSUF').AsString := JSONObject.GetValue('uf').Value;
    FDEndereco.FieldByName('NMCIDADE').AsString := JSONObject.GetValue('localidade').Value;
    FDEndereco.FieldByName('NMBAIRRO').AsString := JSONObject.GetValue('bairro').Value;
    FDEndereco.FieldByName('DSCOMPLEMENTO').AsString := JSONObject.GetValue('complemento').Value;
    FDEndereco.Post;
  finally
    RESTRequest.Free;
    RESTResponse.Free;
    RESTClient.Free;
  end;
end;

end.
