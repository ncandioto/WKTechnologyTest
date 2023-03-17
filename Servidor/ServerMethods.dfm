object DSServerModule1: TDSServerModule1
  Height = 221
  Width = 389
  object FDConnection: TFDConnection
    Params.Strings = (
      'Database=WKTechnologyTest'
      'User_Name=postgres'
      'Password=masterdb'
      'DriverID=PG')
    Connected = True
    LoginPrompt = False
    Left = 96
    Top = 88
  end
  object FDPhysPgDriverLink: TFDPhysPgDriverLink
    VendorLib = 'C:\Program Files (x86)\PostgreSQL\psqlODBC\bin\libpq.dll'
    Left = 216
    Top = 88
  end
  object FDQuery: TFDQuery
    Connection = FDConnection
    SchemaAdapter = FDSchemaAdapter
    SQL.Strings = (
      'select * from pessoa')
    Left = 120
    Top = 160
  end
  object FDSchemaAdapter: TFDSchemaAdapter
    Left = 208
    Top = 152
  end
  object FDStanStorageBinLink: TFDStanStorageBinLink
    Left = 128
    Top = 16
  end
  object FDAtualizar: TFDQuery
    Connection = FDConnection
    Left = 272
    Top = 56
  end
end
