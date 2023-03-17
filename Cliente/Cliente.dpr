program Cliente;

uses
  Vcl.Forms,
  UCadPessoa in 'UCadPessoa.pas' {fmCadPessoa},
  UMetodos in 'UMetodos.pas',
  UConsultaCEP in 'UConsultaCEP.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmCadPessoa, fmCadPessoa);
  Application.Run;
end.
