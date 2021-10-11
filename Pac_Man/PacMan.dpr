program PacMan;

uses
  Forms,
  Main in 'MAIN.PAS' {Form1},
  Scores in 'Scores.pas' {Form2};

{$R *.RES}

begin
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
