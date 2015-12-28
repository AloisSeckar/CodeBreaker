unit CodeBreakerProcedures;

// procedury programu, kter� nevyu��vaj� prkvy formul��e => nejsou sou��st� t��dy TForm1
// aby nep�ek�ely v Unit1, kter� je i tak dost dlouh�

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
// kontroluje, zda u�ivatl uh�dl k�d zcela p�esn�
begin
if (CheckedCode[1]=aExact)
and(CheckedCode[2]=aExact)
and(CheckedCode[3]=aExact)
and(CheckedCode[4]=aExact) then result:=true else result:=false;
end;

function Statistics: boolean;
// pokud u�ivatel nehr�l s custom nastaven�m obt�nosti, vypo��t� sk�re
// pokud byla nastavena n�kter� z p�eddefinovan�ch obt�nost�, provede v�po�et sk�re vrac� true
// pokud hr�l u�ivatel s custom nastaven�m (a� u� �asu nebo po�tu ��slic), ned�l� nic a vrac� false
begin
Score:=0; // definovan� hodnoty
if (Config.TimeDif=dCustom)or(Config.FigureDif=dCustom) then result:=false // custom nastaven� u�ivatele - program neum� vyhodnotit
else begin // vyhodnocov�n� standardn�ch nastaven�
     result:=true; // informuje o prob�hnut� statistik
     // vyhodnocen� �asu - ve v�t�� obt�nosti se zbyl� �as v�c n�sob�
     // vyhodnocen� po�tu ��slic - ve v�t�� obt�nosti se zbyl� pokusy v�c n�sob�
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
ScoresUpdate; // aktualizace nejlep��ch v�sledk�
end;

procedure InsertScore(index: byte; NewScore: TScore; var Top10: array of TScore);
// vlo�� nov� dosa�en� sk�re na po�adovan� m�sto a posune zbytek
var i: integer;
begin
// odsunut� zbytku pole
for i:=10 downto index do begin
                          Top10[i].Name:=Top10[i-1].Name;
                          Top10[i].Score:=Top10[i-1].Score;
                          end;
// vlo�en� nov� hodnoty
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
// porovn�v�n� v�sledk�
i:=0;
continue:=true;
if Config.OverallDif=dEasy     then begin
                                    // hled�, kter� v�kon z top 10 hr���v v�sledek p�ekonal
                                    repeat
                                    i:=i+1;
                                    if Score>EasyTop10[i].Score then begin
                                                                     // v�zva pro u�ivatele k zad�n� jm�na
                                                                     Application.CreateForm(TForm5, Form5);
                                                                     Form5.ShowModal;
                                                                     if Form5.InputName.Text<>'' then NewScore.Name:=Form5.InputName.Text
                                                                                                 else NewScore.Name:='Anonymus';
                                                                     Form5.Free;
                                                                     // vlo�en� z�znamu do top 10
                                                                     InsertScore(i,NewScore,EasyTop10);
                                                                     ScoreMessage:='Congratulations! You''ve placed '+inttostr(i)+'. in Easy TOP 10';
                                                                     continue:=false;
                                                                     end;
                                    until (continue=false)or(i>=10);
                                    // pokud je dosa�en� sk�re men�� ne� top 10
                                    if i>=10 then ScoreMessage:='Unfortunately, you haven''t placed in the TOP 10 scores.';
                                    end else
if Config.OverallDif=dModerate then begin
                                    // hled�, kter� v�kon z top 10 hr���v v�sledek p�ekonal
                                    repeat
                                    i:=i+1;
                                    if Score>ModTop10[i].Score  then begin
                                                                     // v�zva pro u�ivatele k zad�n� jm�na
                                                                     Application.CreateForm(TForm5, Form5);
                                                                     Form5.ShowModal;
                                                                     if Form5.InputName.Text<>'' then NewScore.Name:=Form5.InputName.Text
                                                                                                 else NewScore.Name:='Anonymus';
                                                                     Form5.Free;
                                                                     // vlo�en� z�znamu do top 10
                                                                     InsertScore(i,NewScore,ModTop10);
                                                                     ScoreMessage:='Congratulations! You''ve placed '+inttostr(i)+'. in Moderate TOP 10';
                                                                     continue:=false;
                                                                     end;
                                    until (continue=false)or(i>=10);
                                    // pokud je dosa�en� sk�re men�� ne� top 10
                                    if i>=10 then ScoreMessage:='Unfortunately, you haven''t placed in the TOP 10 scores.';
                                    end else
if Config.OverallDif=dHard     then begin
                                    // hled�, kter� v�kon z top 10 hr���v v�sledek p�ekonal
                                    repeat
                                    i:=i+1;
                                    if Score>HardTop10[i].Score then begin
                                                                     // v�zva pro u�ivatele k zad�n� jm�na
                                                                     Application.CreateForm(TForm5, Form5);
                                                                     Form5.ShowModal;
                                                                     if Form5.InputName.Text<>'' then NewScore.Name:=Form5.InputName.Text
                                                                                                 else NewScore.Name:='Anonymus';
                                                                     Form5.Free;
                                                                     // vlo�en� z�znamu do top 10
                                                                     InsertScore(i,NewScore,HardTop10);
                                                                     ScoreMessage:='Congratulations! You''ve placed '+inttostr(i)+'. in Hard TOP 10';
                                                                     continue:=false;
                                                                     end;
                                    until (continue=false)or(i>=10);
                                    // pokud je dosa�en� sk�re men�� ne� top 10
                                    if i>=10 then ScoreMessage:='Unfortunately, you haven''t placed in the TOP 10 scores.';
                                    end;
end;

procedure FillDefaultScores;
// 1. pouze pokud je datov� soubor scores.cbd po�kozen nebo chyb� �pln�...co� se m��e teoreticky st�t
// 2. pro reset dosa�en�ch v�sledk�
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
// na�te ze souboru dosa�en� sk�re
var source: file of TScore;
    i: integer;
begin
AssignFile(source,'scores.cbd');
// blok, kter� hl�d�, zda datov� soubor nen� po�kozen, nebo nechyb� �pln�
try
Reset(source);
for i:=1 to 10 do read(source,EasyTop10[i]);
for i:=1 to 10 do read(source,ModTop10[i]);
for i:=1 to 10 do read(source,HardTop10[i]);
// soubor by m�l b�t zav�en, i kdyby p�i na��t�n� do�lo k chyb�
// pokud chyba ov�em nastane d��ve (soubor t�eba neexistuje) nastala by taky chyba...proto tento blok
except
ShowMessage('Information : My High Scores file (scores.cbd) missing or is harmed. Loading default data.');
FillDefaultScores;
end;
try
CloseFile(source);
except
Application.ProcessMessages; // pokud soubor nen� otev�en, nen� t�eba d�lat prakticky nic...
end;
end;

procedure SaveScores;
// ulo�� nov� z�skan� informace o nejlep��ch v�sledc�ch do souboru
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
 