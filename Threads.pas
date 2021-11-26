unit Threads;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  System.SysUtils;

type
  CThread = Class(TThread)
  private
    FMilissegundos, FQuantidade: Integer;
    FProgressBar: TProgressBar;
    FMemo: TMemo;
  public
    procedure progressbar;
    procedure Execute; override;
    constructor criar(const Milissegundos, Quantidade: Integer;
      progressbar: TProgressBar; Memo: TMemo);

  protected
  End;

type
  TfThreads = class(TForm)
    edNumerosThreads: TEdit;
    edValorMilissegundos: TEdit;
    Button1: TButton;
    ProgressBar1: TProgressBar;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fThreads: TfThreads;

implementation

{$R *.dfm}

procedure TfThreads.Button1Click(Sender: TObject);
begin
  Memo1.Lines.clear;
  ProgressBar1.Position := 0;

  CThread.criar(StrToIntDef(edValorMilissegundos.Text, 1000),
    StrToIntDef(edNumerosThreads.Text, 1), ProgressBar1, Memo1);

end;

{ CThread }

constructor CThread.criar(const Milissegundos, Quantidade: Integer;
  progressbar: TProgressBar; Memo: TMemo);
begin
  create(False);
  FreeOnTerminate := True;

  FMilissegundos := Milissegundos;
  FQuantidade := Quantidade;

  FProgressBar := progressbar;
  FProgressBar.Min := 0;
  FProgressBar.Max := FQuantidade;

  FMemo := Memo;
  FMemo.Lines.Add(IntToStr(FMemo.tag) + ' - Incio de processamento');

end;

procedure CThread.Execute;
begin
  while not Terminated do
  begin
    Synchronize(progressbar);
    Sleep(10);
  end;

  FMemo.Lines.Add(IntToStr(FMemo.tag) + ' - Final de processamento');
  FMemo.tag := FMemo.tag + 1;
end;

procedure CThread.progressbar;
begin
  Sleep(FMilissegundos);
  FProgressBar.Position := FProgressBar.Position + 1;


  if FProgressBar.Position = FQuantidade then
    Terminate;
end;

end.
