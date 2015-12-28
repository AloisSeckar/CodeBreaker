unit CodeBreakerProcedures;

// procedury programu, které nevyužívají prkvy formuláøe => nejsou souèástí tøídy TForm1
// aby nepøekážely v Unit1, která je i tak dost dlouhá

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, ComCtrls, Unit1;

function CheckEnd: boolean;
function Statistics: boolean;
procedure InsertScore(index: byte; NewScore: TScore; var Top10: array of TScore);
procedure ScoresUpdate;
procedure FillDefaultScores;
procedure LoadScores;
procedure SaveScores;

implementation

uses NameInput;

function  CheckEnd: boolean;
// kontroluje, zda uživatl uhádl kód zcela pøesnì
begin
if (CheckedCode[1]=aExact)
and(CheckedCode[2]=aExact)
and(CheckedCode[3]=aExact)
and(CheckedCode[4]=aExact) then result:=true else result:=false;
end;

function Statistics: boolean;
// pokud uživatel nehrál s custom nastavením obtížnosti, vypoèítá skóre
// pokud byla nastavena nìkterá z pøeddefinovaných obtížností, provede výpoèet skóre vrací true
// pokud hrál uživatel s custom nastavením (a už èasu nebo poètu èíslic), nedìlá nic a vrací false
begin
Score:=0; // definovaní hodnoty
if (Config.TimeDif=dCustom)or(Config.FigureDif=dCustom) then result:=false // custom nastavení uživatele - program neumí vyhodnotit
else begin // vyhodnocování standardních nastavení
     result:=true; // informuje o probìhnutí statistik
     // vyhodnocení èasu - ve vìtší obtížnosti se zbylý èas víc násobí
     // vyhodnocení poètu èíslic - ve vìtší obtížnosti se zbylé pokusy víc násobí
     if Config.TimeDif=dEasy     then begin
                                      if Config.FigureDif=dEasy     then Score:=strtoint(Form1.TimeLeft.Caption)   +(10-RowIndex+1)*100 else
                                      if Config.FigureDif=dModerate then Score:=strtoint(Form1.TimeLeft.Caption)   +(10-RowIndex+1)*300 else
                                      if Config.FigureDif=dHard     then Score:=strtoint(Form1.TimeLeft.Caption)   +(10-RowIndex+1)*500;
                                      end else
     if Config.TimeDif=dModerate then begin
                                      if Config.FigureDif=dEasy     then Score:=strtoint(Form1.TimeLeft.Caption)*5 +(10-RowIndex+1)*100 else
                                      if Config.FigureDif=dModerate then Score:=strtoint(Form1.TimeLeft.Caption)*5 +(10-RowIndex+1)*300 else
                                      if Config.FigureDif=dHard     then Score:=strtoint(Form1.TimeLeft.Caption)*5 +(10-RowIndex+1)*500;
                                      end else
     if Config.TimeDif=dHard     then begin
                                      if Config.FigureDif=dEasy     then Score:=strtoint(Form1.TimeLeft.Caption)*15+(10-RowIndex+1)*100 else
                                      if Config.FigureDif=dModerate then Score:=strtoint(Form1.TimeLeft.Caption)*15+(10-RowIndex+1)*300 else
                                      if Config.FigureDif=dHard     then Score:=strtoint(Form1.TimeLeft.Caption)*15+(10-RowIndex+1)*500;
                                      end;
     end;
ScoresUpdate; // aktualizace nejlepších výsledkù
end;

procedure InsertScore(index: byte; NewScore: TScore; var Top10: array of TScore);
// vloží novì dosažené skóre na požadované místo a posune zbytek
var i: integer;
begin
// odsunutí zbytku pole
for i:=10 downto index do begin
                          Top10[i].Name:=Top10[i-1].Name;
                          Top10[i].Score:=Top10[i-1].Score;
                          end;
// vložení nové hodnoty
Top10[index-1].Name:=NewScore.Name;
Top10[index-1].Score:=NewScore.Score;
end;

procedure ScoresUpdate;
var i: integer;
    continue: boolean;
    NewScore: TScore;
begin
// inicializace
NewScore.Name:='xy';
NewScore.Score:=Score;
// porovnávání výsledkù
i:=0;
continue:=true;
if Config.OverallDif=dEasy     then begin
                                    // hledá, který výkon z top 10 hráèùv výsledek pøekonal
                                    repeat
                                    i:=i+1;
                                    if Score>EasyTop10[i].Score then begin
                                                                     // výzva pro uživatele k zadání jména
                                                                     Application.CreateForm(TForm5, Form5);
                                                                     Form5.ShowModal;
                                                                     if Form5.InputName.Text<>'' then NewScore.Name:=Form5.InputName.Text
                                                                                                 else NewScore.Name:='Anonymus';
                                                                     Form5.Free;
                                                                     // vložení záznamu do top 10
                                                                     InsertScore(i,NewScore,EasyTop10);
                                                                     ScoreMessage:='Congratulations! You''ve placed '+inttostr(i)+'. in Easy TOP 10';
                                                                     continue:=false;
                                                                     end;
                                    until (continue=false)or(i>=10);
                                    // pokud je dosažené skóre menší než top 10
                                    if i>=10 then ScoreMessage:='Unfortunately, you haven''t placed in the TOP 10 scores.';
                                    end else
if Config.OverallDif=dModerate then begin
                                    // hledá, který výkon z top 10 hráèùv výsledek pøekonal
                                    repeat
                                    i:=i+1;
                                    if Score>ModTop10[i].Score  then begin
                                                                     // výzva pro uživatele k zadání jména
                                                                     Application.CreateForm(TForm5, Form5);
                                                                     Form5.ShowModal;
                                                                     if Form5.InputName.Text<>'' then NewScore.Name:=Form5.InputName.Text
                                                                                                 else NewScore.Name:='Anonymus';
                                                                     Form5.Free;
                                                                     // vložení záznamu do top 10
                                                                     InsertScore(i,NewScore,ModTop10);
                                                                     ScoreMessage:='Congratulations! You''ve placed '+inttostr(i)+'. in Moderate TOP 10';
                                                                     continue:=false;
                                                                     end;
                                    until (continue=false)or(i>=10);
                                    // pokud je dosažené skóre menší než top 10
                                    if i>=10 then ScoreMessage:='Unfortunately, you haven''t placed in the TOP 10 scores.';
                                    end else
if Config.OverallDif=dHard     then begin
                                    // hledá, který výkon z top 10 hráèùv výsledek pøekonal
                                    repeat
                                    i:=i+1;
                                    if Score>HardTop10[i].Score then begin
                                                                     // výzva pro uživatele k zadání jména
                                                                     Application.CreateForm(TForm5, Form5);
                                                                     Form5.ShowModal;
                                                                     if Form5.InputName.Text<>'' then NewScore.Name:=Form5.InputName.Text
                                                                                                 else NewScore.Name:='Anonymus';
                                                                     Form5.Free;
                                                                     // vložení záznamu do top 10
                                                                     InsertScore(i,NewScore,HardTop10);
                                                                     ScoreMessage:='Congratulations! You''ve placed '+inttostr(i)+'. in Hard TOP 10';
                                                                     continue:=false;
                                                                     end;
                                    until (continue=false)or(i>=10);
                                    // pokud je dosažené skóre menší než top 10
                                    if i>=10 then ScoreMessage:='Unfortunately, you haven''t placed in the TOP 10 scores.';
                                    end;
end;

procedure FillDefaultScores;
// 1. pouze pokud je datový soubor scores.cbd poškozen nebo chybí úplnì...což se mùže teoreticky stát
// 2. pro reset dosaženách výsledkù
var i: integer;
begin
for i:=1 to 10 do begin
                  EasyTop10[i].Name:='Anonymus';
                  EasyTop10[i].Score:=((11-i)*100);
                  ModTop10[i].Name:='Anonymus';
                  ModTop10[i].Score:=((11-i)*100);
                  HardTop10[i].Name:='Anonymus';
                  HardTop10[i].Score:=((11-i)*100);
                  end;
end;

procedure LoadScores;
// naète ze souboru dosažená skóre
var source: file of TScore;
    i: integer;
begin
AssignFile(source,'scores.cbd');
// blok, který hlídá, zda datový soubor není poškozen, nebo nechybí úplnì
try
Reset(source);
for i:=1 to 10 do read(source,EasyTop10[i]);
for i:=1 to 10 do read(source,ModTop10[i]);
for i:=1 to 10 do read(source,HardTop10[i]);
// soubor by mìl být zavøen, i kdyby pøi naèítání došlo k chybì
// pokud chyba ovšem nastane døíve (soubor tøeba neexistuje) nastala by taky chyba...proto tento blok
except
ShowMessage('Information : My High Scores file (scores.cbd) missing or is harmed. Loading default data.');
FillDefaultScores;
end;
try
CloseFile(source);
except
Application.ProcessMessages; // pokud soubor není otevøen, není tøeba dìlat prakticky nic...
end;
end;

procedure SaveScores;
// uloží novì získané informace o nejlepších výsledcích do souboru
var source: file of TScore;
    i: integer;
begin
AssignFile(source,'scores.cbd');
Rewrite(source);
for i:=1 to 10 do write(source,EasyTop10[i]);
for i:=1 to 10 do write(source,ModTop10[i]);
for i:=1 to 10 do write(source,HardTop10[i]);
CloseFile(source);
end;


end.
 