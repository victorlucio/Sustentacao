program Foo;

uses
  Vcl.Forms,
  Main in 'Main.pas' {fMain} ,
  DatasetLoop in 'DatasetLoop.pas' {fDatasetLoop} ,
  ClienteServidor in 'ClienteServidor.pas' {fClienteServidor} ,
  CException in 'Exception\CException.pas',
  Threads in 'Threads.pas' {fThreads};

{$R *.res}

begin
  Application.Initialize;
  ReportMemoryLeaksOnShutdown := True;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfDatasetLoop, fDatasetLoop);
  Application.CreateForm(TfClienteServidor, fClienteServidor);
  Application.CreateForm(TfThreads, fThreads);
  Application.Run;

end.
