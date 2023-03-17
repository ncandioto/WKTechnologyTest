unit UClasses;

interface

uses
   Classes, Vcl.Dialogs;

type
  {$METHODINFO ON}
  TClasses = class(TComponent)
    function GetPessoa(idPessoa: integer): OleVariant;

  end;
  {$METHODINFO OFF}

implementation

{ TClasses }

function TClasses.GetPessoa(idPessoa: integer): OleVariant;
begin

end;

end.
