unit CException;

interface

uses
  SysUtils, Forms, System.Classes;

type
  TException = class
    private
      FLogFile : String;
    public
      constructor Create;
      procedure ThrowException(Sender: TObject; E : Exception);
      procedure GravarLog(Value : String);
  end;

implementation

uses
  Vcl.Dialogs;

{ TException }

constructor TException.Create;
begin
  FLogFile := ChangeFileExt(ParamStr(0), '.log');
  Application.OnException := ThrowException;
end;

procedure TException.GravarLog(Value: String);
var
  txtLog : TextFile;
begin
  AssignFile(txtLog, FLogFile);
  if FileExists(FLogFile) then
    Append(txtLog)
  else
    Rewrite(txtLog);
  Writeln(txtLog, FormatDateTime('dd/mm/YYYY hh:nn:ss - ', Now) + Value);
  CloseFile(txtLog);
end;

procedure TException.ThrowException(Sender: TObject; E : Exception);
begin
  GravarLog('===========================================');
  if TComponent(Sender) is TForm then
  begin
    GravarLog('Form: ' + TForm(Sender).Name);
    GravarLog('Caption: ' + TForm(Sender).Caption);
    GravarLog('Erro:' + E.ClassName);
    GravarLog('Erro:' + E.Message);
  end
  else
  begin
    GravarLog('Form: ' + TForm(TComponent(Sender).Owner).Name);
    GravarLog('Caption: ' + TForm(TComponent(Sender).Owner).Caption);
    GravarLog('Erro:' + E.ClassName);
    GravarLog('Erro:' + E.Message);
  end;
  ShowMessage(E.Message);
end;

var
  MinhaException : TException;

initialization
  MinhaException := TException.Create;

finalization
  MinhaException.Free;

end.
