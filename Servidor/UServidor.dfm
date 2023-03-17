object fmServidor: TfmServidor
  Left = 0
  Top = 0
  Caption = 'Servidor'
  ClientHeight = 177
  ClientWidth = 403
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object DSServer: TDSServer
    Left = 184
    Top = 32
  end
  object DSServerClass: TDSServerClass
    OnGetClass = DSServerClassGetClass
    Server = DSServer
    Left = 312
    Top = 32
  end
  object DSTCPServerTransport: TDSTCPServerTransport
    Server = DSServer
    Filters = <>
    Left = 56
    Top = 32
  end
end
