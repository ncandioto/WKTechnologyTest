program Servidor;

uses
  Vcl.Forms,
  UServidor in 'UServidor.pas' {fmServidor},
  UClasses in 'UClasses.pas',
  ServerMethods in 'ServerMethods.pas' {DSServerModule1: TDSServerModule},
  UConsultaCEP in '..\Cliente\UConsultaCEP.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfmServidor, fmServidor);
  Application.Run;
end.
