unit ClienteServidor;

interface

uses
  Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Datasnap.DBClient, Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TServidor = class
  private
    FPath: String;
    procedure DeletaArquivos(qtd: integer);

  public
    constructor Create;
    // Tipo do parâmetro não pode ser alterado
    function SalvarArquivos(AData: Olevariant; i: integer = 0): Boolean;
  end;

  TfClienteServidor = class(TForm)
    ProgressBar: TProgressBar;
    btEnviarSemErros: TButton;
    btEnviarComErros: TButton;
    btEnviarParalelo: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btEnviarSemErrosClick(Sender: TObject);
    procedure btEnviarComErrosClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btEnviarParaleloClick(Sender: TObject);
  private
    FPath: String;
    FServidor: TServidor;

    function InitDataset: TClientDataSet;
    procedure SalvarThread(AData: Olevariant; i: integer);
  public
  end;

var
  fClienteServidor: TfClienteServidor;

const
  QTD_ARQUIVOS_ENVIAR = 100;

implementation

uses
  IOUtils, CException;

{$R *.dfm}

procedure TfClienteServidor.btEnviarComErrosClick(Sender: TObject);
var
  cds: TClientDataSet;
  i: integer;
begin
  cds := InitDataset;
  ProgressBar.Max := QTD_ARQUIVOS_ENVIAR;
  try
    try
      for i := 0 to QTD_ARQUIVOS_ENVIAR do
      begin

        cds.Append;
        TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);
        cds.Post;
        ProgressBar.Position := i;

        {$REGION Simulação de erro, não alterar}
        if i = (QTD_ARQUIVOS_ENVIAR / 2) then
          FServidor.SalvarArquivos(NULL);
        {$ENDREGION}
        FServidor.SalvarArquivos(cds.Data, i);
        cds.EmptyDataSet;
      end;
    except
      if ProgressBar.Position <> QTD_ARQUIVOS_ENVIAR then
      begin
        FServidor.DeletaArquivos(ProgressBar.Position);
      end;
      exit;
    end;

  finally
    ProgressBar.Position := 0;
    FreeAndNil(cds);
  end;

end;

procedure TfClienteServidor.btEnviarParaleloClick(Sender: TObject);
var
  ThrSalvar: TThread;
  cds: TClientDataSet;
begin

  ThrSalvar := TThread.CreateAnonymousThread(
    procedure
    begin
      ProgressBar.Max := QTD_ARQUIVOS_ENVIAR;
      for var i := 0 to QTD_ARQUIVOS_ENVIAR do
      begin
        cds := InitDataset;
        cds.Append;
        TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);
        cds.Post;
        ProgressBar.Position := i;

        SalvarThread(cds.Data, i);
        cds.EmptyDataSet;
        FreeAndNil(cds);

        if ProgressBar.Position = QTD_ARQUIVOS_ENVIAR then
          ProgressBar.Position := 0;

      end;

    end);
  ThrSalvar.start;

end;

procedure TfClienteServidor.btEnviarSemErrosClick(Sender: TObject);
var
  cds: TClientDataSet;
begin
  cds := InitDataset;
  try
    ProgressBar.Max := QTD_ARQUIVOS_ENVIAR;

    for var i := 0 to QTD_ARQUIVOS_ENVIAR do
    begin
      cds.Append;
      TBlobField(cds.FieldByName('Arquivo')).LoadFromFile(FPath);
      cds.Post;
      ProgressBar.Position := i;
      FServidor.SalvarArquivos(cds.Data, i);
      cds.EmptyDataSet;
    end;

  finally
    ProgressBar.Position := 0;
    FreeAndNil(cds);
  end;
end;

procedure TfClienteServidor.FormCreate(Sender: TObject);
begin
  inherited;
  FPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) +
    'pdf.pdf';

  FServidor := TServidor.Create;
end;

procedure TfClienteServidor.FormDestroy(Sender: TObject);
begin
  FServidor.Free;
end;

function TfClienteServidor.InitDataset: TClientDataSet;
begin
  Result := TClientDataSet.Create(nil);
  Result.FieldDefs.Add('Arquivo', ftBlob);
  Result.CreateDataSet;
end;

procedure TfClienteServidor.SalvarThread(AData: Olevariant; i: integer);
begin
  TThread.CreateAnonymousThread(
    procedure
    begin

      FServidor.SalvarArquivos(AData, i);

    end).start;
end;

{ TServidor }

constructor TServidor.Create;
begin
  FPath := ExtractFilePath(ParamStr(0)) + 'Servidor\';

  if not DirectoryExists(FPath) then
    ForceDirectories(FPath);
end;

function TServidor.SalvarArquivos(AData: Olevariant; i: integer): Boolean;
var
  cds: TClientDataSet;
  FileName: string;
begin
  Result := false;
  try
    try
      cds := TClientDataSet.Create(nil);
      cds.Data := AData;

      {$REGION Simulação de erro, não alterar}
      if cds.RecordCount = 0 then
        exit;

      {$ENDREGION}
      cds.First;
      while not cds.Eof do
      begin
        FileName := FPath + IntToStr(i) + '.pdf';
        if TFile.Exists(FileName) then
          TFile.Delete(FileName);

        TBlobField(cds.FieldByName('Arquivo')).SaveToFile(FileName);
        cds.Next;
      end;
      Result := True;
    except
      Result := false;
    end;
  finally
    FreeAndNil(cds);
    if Not Result then
      raise Exception.Create('Erro ao tentar savar arquivos no Servidor');
  end;
end;

procedure TServidor.DeletaArquivos(qtd: integer);
var
  FileName: string;
begin

  for var i := 0 to qtd do
  begin
    FileName := FPath + IntToStr(i) + '.pdf';
    if TFile.Exists(FileName) then
      TFile.Delete(FileName);
  end;
end;

end.
