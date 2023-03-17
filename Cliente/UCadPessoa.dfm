object fmCadPessoa: TfmCadPessoa
  Left = 0
  Top = 0
  Caption = 'Cadastro de Pessoa'
  ClientHeight = 553
  ClientWidth = 848
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object lblNomePessoa: TLabel
    Left = 24
    Top = 16
    Width = 116
    Height = 15
    Caption = 'Filtro (Nome pessoa) :'
  end
  object btBuscarPessoa: TButton
    Left = 384
    Top = 36
    Width = 75
    Height = 25
    Caption = 'Buscar'
    TabOrder = 1
    OnClick = btBuscarPessoaClick
  end
  object edtFiltroNmPessoa: TEdit
    Left = 24
    Top = 37
    Width = 345
    Height = 23
    TabOrder = 0
  end
  object gpDadosPessoa: TGroupBox
    Left = 24
    Top = 97
    Width = 820
    Height = 152
    Caption = ' Dados principais'
    TabOrder = 2
    object lbNmPessoa: TLabel
      Left = 16
      Top = 87
      Width = 78
      Height = 15
      Caption = 'Nome pessoa :'
    end
    object lbSobrenome: TLabel
      Left = 216
      Top = 87
      Width = 67
      Height = 15
      Caption = 'Sobrenome :'
    end
    object lbDocumento: TLabel
      Left = 560
      Top = 87
      Width = 69
      Height = 15
      Caption = 'Documento :'
    end
    object lbDtRegistro: TLabel
      Left = 16
      Top = 34
      Width = 67
      Height = 15
      Caption = 'Dt. Registro :'
    end
    object edtNome: TDBEdit
      Left = 16
      Top = 105
      Width = 177
      Height = 23
      DataField = 'NMPRIMEIRO'
      DataSource = DSDados
      TabOrder = 0
    end
    object edtSobrenome: TDBEdit
      Left = 216
      Top = 105
      Width = 331
      Height = 23
      DataField = 'NMSEGUNDO'
      DataSource = DSDados
      TabOrder = 1
    end
    object edtDocumento: TDBEdit
      Left = 560
      Top = 104
      Width = 177
      Height = 23
      DataField = 'DSDOCUMENTO'
      DataSource = DSDados
      TabOrder = 2
    end
    object DBEdit1: TDBEdit
      Left = 16
      Top = 54
      Width = 177
      Height = 23
      DataField = 'DTREGISTRO'
      DataSource = DSDados
      Enabled = False
      TabOrder = 3
    end
    object cbNatureza: TComboBox
      Left = 216
      Top = 54
      Width = 145
      Height = 23
      ItemIndex = 0
      TabOrder = 4
      Text = 'F'#237'sica'
      OnChange = cbNaturezaChange
      Items.Strings = (
        'F'#237'sica'
        'Jur'#237'dica')
    end
  end
  object gpEndereco: TGroupBox
    Left = 24
    Top = 255
    Width = 820
    Height = 242
    Caption = 'Endere'#231'o'
    TabOrder = 3
    object lbCep: TLabel
      Left = 16
      Top = 34
      Width = 27
      Height = 15
      Caption = 'CEP :'
    end
    object btnCEP: TButton
      Left = 98
      Top = 54
      Width = 90
      Height = 25
      Caption = 'Buscar CEP...'
      TabOrder = 0
      OnClick = btnCEPClick
    end
    object DBGrid2: TDBGrid
      Left = 16
      Top = 98
      Width = 793
      Height = 129
      DataSource = dsEndereco
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'DSCEP'
          Title.Caption = 'Cep'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NMLOGRADOURO'
          Title.Caption = 'Logradouro'
          Width = 267
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NMBAIRRO'
          Title.Caption = 'Bairro'
          Width = 122
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DSUF'
          Title.Caption = 'UF'
          Width = 29
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NMCIDADE'
          Title.Caption = 'Cidade'
          Width = 89
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DSCOMPLEMENTO'
          Title.Caption = 'Complemento'
          Width = 159
          Visible = True
        end>
    end
    object btnAtualizarEndereco: TButton
      Left = 640
      Top = 16
      Width = 147
      Height = 33
      Caption = 'Atualizar Endere'#231'os...'
      TabOrder = 2
      OnClick = btnAtualizarEnderecoClick
    end
    object edtCEP: TEdit
      Left = 16
      Top = 55
      Width = 76
      Height = 23
      TabOrder = 3
      OnKeyPress = edtCEPKeyPress
    end
  end
  object pnBotoes: TPanel
    Left = 0
    Top = 512
    Width = 848
    Height = 41
    Align = alBottom
    TabOrder = 4
    ExplicitTop = 511
    ExplicitWidth = 844
    object btnExcluir: TButton
      Left = 231
      Top = 1
      Width = 115
      Height = 39
      Align = alLeft
      Caption = 'Excluir'
      TabOrder = 0
      Visible = False
      OnClick = btnExcluirClick
    end
    object btnUdpate: TButton
      Left = 1
      Top = 1
      Width = 115
      Height = 39
      Align = alLeft
      Caption = 'Update'
      TabOrder = 1
      Visible = False
      OnClick = btnUdpateClick
    end
    object btInserirLote: TButton
      Left = 670
      Top = 1
      Width = 177
      Height = 39
      Align = alRight
      Caption = 'Inserir registros em lote'
      TabOrder = 2
      OnClick = btInserirLoteClick
      ExplicitLeft = 666
    end
    object btnInsert: TButton
      Left = 116
      Top = 1
      Width = 115
      Height = 39
      Align = alLeft
      Caption = 'Insert'
      TabOrder = 3
      Visible = False
      OnClick = btnInsertClick
    end
  end
  object SQLConnection: TSQLConnection
    DriverName = 'DataSnap'
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DBXDataSnap'
      'HostName=localhost'
      'Port=211'
      'CommunicationProtocol=tcp/ip'
      'DatasnapContext=datasnap/'
      
        'DriverAssemblyLoader=Borland.Data.TDBXClientDriverLoader,Borland' +
        '.Data.DbxClientDriver,Version=24.0.0.0,Culture=neutral,PublicKey' +
        'Token=91d62ebb5b0d1b1b')
    Connected = True
    Left = 680
    Top = 16
    UniqueId = '{5015804B-219D-467C-A64B-BC0E3F72928F}'
  end
  object DSDados: TDataSource
    DataSet = FDMemTable
    Left = 632
    Top = 128
  end
  object FDMemTable: TFDMemTable
    AfterInsert = FDMemTableAfterInsert
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 630
    Top = 72
  end
  object FDStanStorageBinLink1: TFDStanStorageBinLink
    Left = 560
    Top = 16
  end
  object FDUPdatePessoa: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 704
    Top = 72
  end
  object FDMemEndereco: TFDMemTable
    AfterInsert = FDMemEnderecoAfterInsert
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 536
    Top = 72
  end
  object dsEndereco: TDataSource
    DataSet = FDMemEndereco
    Left = 536
    Top = 128
  end
  object FDUpdateEndereco: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 696
    Top = 129
  end
  object CaminhoCSV: TOpenDialog
    Left = 416
    Top = 280
  end
end
