program CodeBreaker;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  TimeOptions in 'TimeOptions.pas' {Form2},
  FiguresOptions in 'FiguresOptions.pas' {Form3},
  Scores in 'Scores.pas' {Form4},
  CodeBreakerProcedures in 'CodeBreakerProcedures.pas',
  NameInput in 'NameInput.pas' {Form5};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
