unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, ComCtrls;

type
  TDifficulty = (dEasy,dModerate,dHard,dCustom); // v��tov� tip pro po��t�n� sk�re
  TAccuracy = (aExact,aRight,aWrong); // v��tov� tip pro porovn�v�n� zadan�ho a v�sledn�ho k�du
  TGameEnd = (geVictory,geTimeDefeat,geAttemptsDefeat,geStopped); // v��tov� tip pro ur�en� sc�n��e konce hry
  TScore = record // ukl�d� informace o sk�re
           Name: string[255];
           Score: integer;
           end;
  TConfig = record // informace o z�kladn�m nastaven� pro nov� na�ten� hry
            GLimit: word;
            GFigures: byte;
            OverallDif: TDifficulty; // bere se v�dy podle "ni���" z �asov�ho limitu a po�tu ��slic
            TimeDif: TDifficulty; // nastaven� �asov� obt�nost
            FigureDif: TDifficulty; // nastaven� obt�nost barev
            end;
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    Game1: TMenuItem;
    New1: TMenuItem;
    Exit1: TMenuItem;
    Options1: TMenuItem;
    TimeLimit1: TMenuItem;
    Timer1: TTimer;
    TimeLeft: TLabel;
    Figures1: TMenuItem;
    GroupBox1: TGroupBox;
    Pause1: TMenuItem;
    GameStatus: TStatusBar;
    HighScores1: TMenuItem;
    Bevel1: TBevel;
    GroupBox2: TGroupBox;
    SetDifficulty1: TMenuItem;
    Easy1: TMenuItem;
    Moderate1: TMenuItem;
    Hard1: TMenuItem;
    //function  CheckCode(Input: TComboBox; Target: TLabel): TAccuracy; - fce zru�ena a p�ed�l�na na proceduru
    procedure CheckCode;
    procedure TargetCodeGenerator;
    procedure InputsDisable;
    procedure InputsFill;
    procedure ChecksClear;
    procedure EndGame(EndState: TGameEnd);
    procedure Timer1Timer(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure TimeLimit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Figures1Click(Sender: TObject);
    procedure CheckClick(Sender: TObject);
    procedure InputChange(Sender: TObject);
    procedure Pause1Click(Sender: TObject);
    procedure HighScores1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Easy1Click(Sender: TObject);
    procedure Moderate1Click(Sender: TObject);
    procedure Hard1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  Config: TConfig;
  Inputs: array[1..40]of TComboBox;
  Checks: array[1..40]of TShape;
  Execute: array[1..10]of TButton;
  RowIndex: byte; // index aktu�ln�ho ��kdu (1-10)
  TargetLabels: array[1..4]of TLabel; // labely, do kter�ch se v�sledn� k�d vyp�e
  TargetCode: array[1..4]of Byte; // n�hodn� generovan� k�d, ke kter�mu se m� u�ivatel dobrat
  CheckedCode: array[1..4]of TAccuracy; // v�sledek porovn�n� zadan�ho a v�sledn�ho k�du
  Score: word; // v�sledn� sk�re u�ivatele - pokud vyhraje
  ScoreMessage: string; // informace pro hr��e o jeho pozici v nejlep��ch v�sledc�ch

  // p�i spu�t�n� na�te v�ech 30 nejlep��ch v�sledk� ze souboru a p�i skon�en� programu je zase ulo��
  EasyTop10: array[1..10]of TScore;
  ModTop10: array[1..10]of TScore;
  HardTop10: array[1..10]of TScore;

implementation

{$R *.dfm}

uses TimeOptions,FiguresOptions, Scores, CodeBreakerProcedures;

procedure TForm1.CheckCode;
// porovn�v� k�d v zadan�m vstupn�m poli s k�dem, kter� m� vyj�t
var i,i2: integer;
    ComparedCode,ExactCode: array[1..4]of Integer; // pole pro vyhodnocov�n� zadan�ho k�du
    continue: boolean;
begin
// krok 0 - inicializov�n� prom�nn�ch
for i:=1 to 4 do begin
                 CheckedCode[i]:=aWrong;
                 ComparedCode[i]:=strtoint(Inputs[RowIndex*4-4+i].Text); // argument "RowIndex*4-4+i" d� p�esn� ten index, kter� pot�ebuju
                 ExactCode[i]:=strtoint(TargetLabels[i].Caption);
                 end;
// krok 1 - hled� p�esn� v�sledky
for i:=1 to 4 do if ComparedCode[i]=ExactCode[i] then begin
                                                      CheckedCode[i]:=aExact;
                                                      ComparedCode[i]:=-2;
                                                      ExactCode[i]:=-1;
                                                      end;
// krok 2 - hled� spr�vn� ��sla ne nespr�vn�ch m�stech
for i:=1 to 4 do begin
                 i2:=-1;
                 continue:=true;
                 repeat
                 i2:=i2+1;
                 if ComparedCode[i]=ExactCode[i2] then begin
                                                       CheckedCode[i]:=aRight;
                                                       ComparedCode[i]:=-2;
                                                       ExactCode[i2]:=-1;
                                                       continue:=false;
                                                       end;
                 until (continue=false)or(i2>=4);
                 end;
{
Zru�en� postup - nefunk�n� na 100%
// krok 0 - p�i�azen� v�choz� (a anulov�n� p�edchoz�) hodnoty v�sledkov�mu poli (implicitn� aWrong)
for i:=1 to 4 do CheckedCode[i]:=aWrong;
// krok 1 - hled� p�esn� v�sledky
for i:=1 to 4 do if strtoint(Inputs[RowIndex*4-4+i].Text)=strtoint(TargetLabels[i].Caption) then CheckedCode[i]:=aExact; // argument "RowIndex*4-4+i" d� p�esn� ten index, kter� pot�ebuju
// krok 2 - hled� spr�vn� ��sla ne nespr�vn�ch m�stech - p�i tom je t�eba ignorovat ta, kter� jsou u� obsazena p�esn�m v�sledkem
for i:=1 to 4 do if CheckedCode[i]<>aExact then begin
                                                i2:=0;
                                                continue:=true;
                                                repeat
                                                i2:=i2+1;
                                                if (CheckedCode[i]=aWrong)and(CheckedCode[i2]=aWrong)and(strtoint(Inputs[RowIndex*4-4+i2].Text)=strtoint(TargetLabels[i].Caption)) then begin
                                                                                                                                                                                           CheckedCode[i]:=aRight;
                                                                                                                                                                                           continue:=false; // reaguje pouze na prvn� v�skyt
                                                                                                                                                                                           // pokud se n�jak� ��slo opakuje v k�du v�cekr�t, ale hr�� zad� na �patn� m�sto jen jedno,
                                                                                                                                                                                           // je t�eba ur�it pouze jeden jeho v�skyt - proto se cyklus se mus� ukon�it...
                                                                                                                                                                                           end;

                                                until (i2>=4)or(continue=false);
                                                end;
}
end;

{
funkce zru�ena a nahrazena procedurou
function TForm1.CheckCode(Input: TComboBox; Target: TLabel): TAccuracy;
// porovn�v� k�d v zadan�m vstupn�m poli s k�dem, kter� m� vyj�t
begin
if strtoint(Input.Text)=strtoint(Target.Caption) then result:=aExact // "p��m� z�sah" - spr�vn� ��slo na spr�vn�m m�st�
else begin // porovn�n� se v�emi ostan�mi ��stmi v�sledn�ho k�du, jestli nen� alespo� spr�vn� ��slo na �patn� pozici
     if (((strtoint(Input.Text)=strtoint(TargetLabels[1].Caption))and(CheckedCode[1]<>aExact)))
      or(((strtoint(Input.Text)=strtoint(TargetLabels[2].Caption))and(CheckedCode[2]<>aExact)))
      or(((strtoint(Input.Text)=strtoint(TargetLabels[3].Caption))and(CheckedCode[3]<>aExact)))
      or(((strtoint(Input.Text)=strtoint(TargetLabels[4].Caption))and(CheckedCode[4]<>aExact))) then result:=aRight
                                                                                                else result:=aWrong; // ��slo se v k�du nevyskytuje
     end;
end;
}

procedure TForm1.TargetCodeGenerator;
// vytv��� n�hodn� v�sledn� k�d, ke kter�mu se m� hr�� dobrat
var i,i2,x: integer;
begin
for i:=1 to 4 do begin
                 for i2:=1 to 200000 do Application.ProcessMessages; // zdr�ova�
                 x:=random(Config.GFigures); //n�hodn� vybran� ��slo z tolika, kolik je mo�n�ch (min 2 (0-1), max 10 (0-9))
                 TargetCode[i]:=x;
                 // p�i�azen� pro kontrolu
                 TargetLabels[i].Caption:=inttostr(TargetCode[i]);
                 end;
end;

procedure TForm1.InputsDisable;
// znemo��uje v�b�r ve v�ech pol�ch
var i:integer;
begin
for i:=1 to 40 do Inputs[i].Enabled:=false;
end;

procedure TForm1.InputsFill;
// aktualizuje mo�nosti v�b�ru v jednotliv�ch pol�ch podle zvolen�ho po�tu prom�nn�ch
var i,i2:integer;
begin
for i:=1 to 40 do begin
                  Inputs[i].Items.Clear;
                  Inputs[i].Text:='';
                  for i2:=0 to Config.GFigures-1 do Inputs[i].Items.Add(inttostr(i2));
                  end;
end;

procedure TForm1.ChecksClear;
// vrac� kontrolky do v�choz�ho stavu - v�echny �ern�
var i:integer;
begin
for i:=1 to 40 do Checks[i].Brush.Color:=clBlack;
end;

procedure TForm1.EndGame(EndState: TGameEnd);
var i: integer;
begin
// ukon�uje odpo�et �asu
Timer1.Enabled:=false;
Pause1.Enabled:=false;
// zabra�uje mo�nosti znovu zad�vat k�d na posledn�m zakon�en�m ��dku
Execute[RowIndex].Enabled:=false;
for i:=RowIndex*4-3 to RowIndex*4 do Inputs[i].Enabled:=false;
// aktualizuje obsah vstupn�ch pol� + p�ekresluje kontrolky + �prava stavov�ho ��dku
InputsFill;
ChecksClear;
Pause1.Enabled:=false;
Pause1.Caption:='&Pause';
GameStatus.Panels[3].Text:='Score';
GameStatus.Panels[5].Text:='Attempts Left';
GameStatus.Panels[6].Text:='Time Left';
// v z�vislosti na parametru EndState vypisuje mo�n� konce hry
if EndState=geVictory             then begin
                                  GameStatus.Panels[4].Text:='Victory !';
                                  if Statistics then ShowMessage('You have broken my code. Well done, young hacker. Your final score is '+inttostr(Score)+'. '+ScoreMessage)
                                                else ShowMessage('You have broken my code. Well done, young hacker. Unfortunately, i am unable to work up your score, due to your custom difficulty settings.');
                                  end else
if EndState=geTimeDefeat          then begin
                                  GameStatus.Panels[4].Text:='Defeat !';
                                  ShowMessage('The time''s ran up and you are beaten!');
                                  end else
if EndState=geAttemptsDefeat then begin
                                  GameStatus.Panels[4].Text:='Defeat !';
                                  GameStatus.Panels[5].Text:='0 attemps';
                                  ShowMessage('You are out of your attempts. The victory is mine.');
                                  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var time: integer;
begin
// ka�dou sekundu ode�te 1 z hodnoty zb�vaj�c�ho �asu
time:=strtoint(TimeLeft.Caption);
time:=time-1;
TimeLeft.Caption:=inttostr(time);
// informace pro Status Bar
// sk�re se po��t� podle celkov� nastaven� obt�nosti
if Config.OverallDif=dEasy      then Score:=strtoint(TimeLeft.Caption)   +(10-RowIndex+1)*100 else
if Config.OverallDif=dModerate  then Score:=strtoint(TimeLeft.Caption)*5 +(10-RowIndex+1)*300 else
if Config.OverallDif=dHard      then Score:=strtoint(TimeLeft.Caption)*15+(10-RowIndex+1)*500 else
                                     Score:=0; // pokud se sk�re nepo��t�
if Score<>0 then GameStatus.Panels[3].Text:='Score : '+inttostr(Score)
            else GameStatus.Panels[3].Text:='Not counted';
GameStatus.Panels[6].Text:=TimeLeft.Caption+' secs';
// kdy� zb�v� m�n� �asu ne� ur�it� hodnota, ��sla se zbarv�
if time=60 then TimeLeft.Font.Color:=clYellow;
if time=30 then TimeLeft.Font.Color:=clRed;
// kdy� dojde �as, nast�v� konec hry...
if time<=0 then EndGame(geTimeDefeat);
end;

procedure TForm1.New1Click(Sender: TObject);
var i:integer;
begin
// obnovuje prvky formul��e pro novou hru
TimeLeft.Caption:=inttostr(Config.GLimit);
TimeLeft.Font.Color:=clLime;
Timer1.Enabled:=true;
InputsDisable;
for i:=1 to 4 do Inputs[i].Enabled:=true; // umo��uje v�b�r ve spodn� �ad�
RowIndex:=1;
Execute[1].Enabled:=true;
TargetCodeGenerator; // vytv��� n�hodn� v�sledn� k�d, ke kter�mu se m� hr�� dobrat
Pause1.Enabled:=true;
// iniciace celkov� obt�nosti pro pozd�j� v�po�et sk�re
if (Config.TimeDif=dCustom)  or(Config.FigureDif=dCustom)   then begin
                                                                 Config.OverallDif:=dCustom; // "Custom" na prvn�m m�st�
                                                                 GameStatus.Panels[2].Text:='Custom';
                                                                 end else
if (Config.TimeDif=dEasy)    or(Config.FigureDif=dEasy)     then begin
                                                                 Config.OverallDif:=dEasy; // potom podle zvy�uj�c� se obt�nosti - celkov� se bere v�dy ta ni���...
                                                                 GameStatus.Panels[2].Text:='Easy';
                                                                 end else
if (Config.TimeDif=dModerate)or(Config.FigureDif=dModerate) then begin
                                                                 Config.OverallDif:=dModerate;
                                                                 GameStatus.Panels[2].Text:='Moderate';
                                                                 end else
                                                                 begin
                                                                 Config.OverallDif:=dHard;
                                                                 GameStatus.Panels[2].Text:='Hard';
                                                                 end;
// informace o sk�re pro Status Bar
Score:=0;
if Config.TimeDif=dEasy     then Score:=600 else
if Config.TimeDif=dModerate then Score:=1500 else
if Config.TimeDif=dHard     then Score:=1800;
if Config.FigureDif=dEasy     then Score:=Score+1000 else
if Config.FigureDif=dModerate then Score:=Score+3000 else
if Config.FigureDif=dHard     then Score:=Score+5000;
if Score<>0 then GameStatus.Panels[3].Text:='Score : '+inttostr(Score)
            else GameStatus.Panels[3].Text:='Not counted';
GameStatus.Panels[4].Text:='';
GameStatus.Panels[5].Text:='10 attempts';
GameStatus.Panels[6].Text:=Timeleft.Caption+' secs';
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
Form1.Close;
end;

procedure TForm1.TimeLimit1Click(Sender: TObject);
// v�b�r �asov�ho limitu pro �e�en�
begin
EndGame(geStopped); // pokud u� b�� hra, zastav� ji
Application.CreateForm(TForm2, Form2);
Form2.ShowModal;
Form2.Free;
// aktualizace stavov�ho ��dku
if Config.TimeDif=dEasy     then begin
                                 Timeleft.Caption:='600';
                                 GameStatus.Panels[0].Text:='600 secs (Easy)';
                                 ShowMessage('Time conditions was set by "Easy" cofiguration'); // info pro u�ivatele
                                 end else
if Config.TimeDif=dModerate then begin
                                 Timeleft.Caption:='300';
                                 GameStatus.Panels[0].Text:='300 secs (Mod)';
                                 ShowMessage('Time conditions was set by "Moderate" cofiguration'); // info pro u�ivatele
                                 end else
if Config.TimeDif=dHard     then begin
                                 Timeleft.Caption:='120';
                                 GameStatus.Panels[0].Text:='120 secs (Hard)';
                                 ShowMessage('Time conditions was set by "Hard" cofiguration'); // info pro u�ivatele
                                 end else
                                 begin
                                 Timeleft.Caption:=inttostr(Config.GLimit);
                                 GameStatus.Panels[0].Text:=inttostr(Config.GLimit)+' secs (Custom)';
                                 ShowMessage('Time conditions was set by "Custom" cofiguration'); // info pro u�ivatele
                                 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
// ud�losti p�i vytv��en� formul��e
var i,i2,i3,i4,x,y: integer;
begin
randomize;
// na�ten� dosa�en�ch sk�re
LoadScores;
// v�choz� parametry
Config.GLimit:=300;
Config.GFigures:=7;
Config.TimeDif:=dModerate;
Config.FigureDif:=dModerate;
RowIndex:=1;
// vytv��en� label�, do kter�ch se zapisuje c�lov� k�d
for i:=1 to 4 do begin
                 TargetLabels[i]:=TLabel.Create(self);
                 TargetLabels[i].Parent:=GroupBox2;
                 TargetLabels[i].Font.Size:=17;
                 TargetLabels[i].Font.Style:=TargetLabels[1].Font.Style+[fsBold];
                 TargetLabels[i].Top:=25;
                 TargetLabels[i].Left:=140+((i-1)*30);
                 TargetLabels[i].Caption:='X';
                 end;
// vytv��en� zad�vac�ch pol�
x:=90;
y:=260;
i3:=1;
i4:=0;
for i:=1 to 40 do begin
                  if x>290 then begin // konec ��dku
                                // vytv��� button potvrzuj�c� ukon�en� kombinov�n� na dan�m ��dku
                                Execute[i3]:=TButton.Create(self);
                                Execute[i3].Parent:=GroupBox1;
                                Execute[i3].Width:=50;
                                Execute[i3].Height:=21;
                                Execute[i3].Caption:='Check';
                                Execute[i3].Left:=x+10;
                                Execute[i3].Top:=y;
                                Execute[i3].Enabled:=false;
                                Execute[i3].Hint:='Check your code';
                                Execute[i3].OnClick:=CheckClick;  // p�i�azen� akce po kliknut�
                                // upravuje hodnoty prom�nn�ch pro posun "o ��dek v��"
                                i3:=i3+1;
                                i4:=0;
                                x:=90;
                                y:=y-25;
                                end;
                  // vytv��� v�b�rov� pole
                  Inputs[i]:=TComboBox.Create(self);
                  Inputs[i].Parent:=GroupBox1;
                  Inputs[i].Width:=50;
                  Inputs[i].Height:=25;
                  Inputs[i].Left:=x;
                  Inputs[i].Top:=y;
                  Inputs[i].Enabled:=false;
                  for i2:=0 to 6 do Inputs[i].Items.Add(inttostr(i2));
                  Inputs[i].OnChange:=InputChange; // p�i�azen� procedury kontroluj�c�, co u�ivatel zapisuje do textov�ho pole
                  // vytv��� kontrolky, kter� indikuj� spr�vnost/nespr�vnost k�du
                  Checks[i]:=TShape.Create(self);
                  Checks[i].Parent:=GroupBox1;
                  Checks[i].Width:=10;
                  Checks[i].Height:=10;
                  Checks[i].Shape:=stCircle;
                  Checks[i].Brush.Color:=clBlack;
                  Checks[i].Left:=20+i4*15;
                  Checks[i].Top:=y+7;
                  // posun x-ov� sou�adnice o 1 vedle
                  x:=x+55;
                  i4:=i4+1;
                  end;
// potvrzuj�c� button pro nejvy��� ��dek se mus� vytvo�it extra
// - to u� do toho p�edchoz�ho cyklu nacpat nejde...aspo� ne n�jak efektivn�, tak�e rad�i t�ch p�r ��dk� nav�c...
Execute[10]:=TButton.Create(self);
Execute[10].Parent:=GroupBox1;
Execute[10].Width:=50;
Execute[10].Height:=21;
Execute[10].Caption:='Check';
Execute[10].Left:=x+10;
Execute[10].Top:=y;
Execute[10].Enabled:=false;
Execute[10].OnClick:=CheckClick; // p�i�azen� akce po kliknut�
end;

procedure TForm1.Figures1Click(Sender: TObject);
// v�b�r po�tu ��slic do kombinace k�du
begin
EndGame(geStopped); // pokud u� b�� hra, zastav� ji
Application.CreateForm(TForm3, Form3);
Form3.ShowModal;
Form3.Free;
InputsFill; // p�episuje mo�nosti v�b�ru pro aktu�ln� po�et ��slic
// aktualizace stavov�ho ��dku
if Config.FigureDif=dEasy     then begin
                                   GameStatus.Panels[1].Text:='5 (Easy)';
                                   ShowMessage('Time conditions was set by "Easy" cofiguration'); // info pro u�ivatele
                                   end else
if Config.FigureDif=dModerate then begin
                                   GameStatus.Panels[1].Text:='7 (Mod)';
                                   ShowMessage('Figures conditions was set by "Moderate" cofiguration'); // info pro u�ivatele
                                   end else
if Config.FigureDif=dHard     then begin
                                   GameStatus.Panels[1].Text:='10 (Hard)';
                                   ShowMessage('Figures conditions was set by "Hard" cofiguration'); // info pro u�ivatele
                                   end else
                                   begin
                                   GameStatus.Panels[1].Text:=inttostr(Config.GFigures)+' (Custom)';
                                   ShowMessage('Figures conditions was set by "Custom" cofiguration'); // info pro u�ivatele
                                   end;
end;

procedure TForm1.CheckClick(Sender: TObject);
// potvrzen� dokon�en� ��dku a p�echod o ��dek v��
var i,index: integer;
    continue: boolean; // hl�d�, zda je v�e v po��dku, aby se mohlo pokra�ovat s �innost� procedury
begin
continue:=true; // implicitn� v�e v po��dku je
// kontrola, zda jsou v�echny 4 pole v ��dku spr�vn� zad�na
// zda byl proveden v�b�r z ComboBoxu
if Inputs[RowIndex*4-3].ItemIndex=-1 then begin
                                          continue:=false;
                                          ShowMessage('1st code input not specificated! Access to higher level denied!');
                                          end else
if Inputs[RowIndex*4-2].ItemIndex=-1 then begin
                                          continue:=false;
                                          ShowMessage('2nd code input not specificated! Access to higher level denied!');
                                          end else
if Inputs[RowIndex*4-1].ItemIndex=-1 then begin
                                          continue:=false;
                                          ShowMessage('3rd code input not specificated! Access to higher level denied!');
                                          end else
if Inputs[RowIndex*4]  .ItemIndex=-1 then begin
                                          continue:=false;
                                          ShowMessage('4th code input not specificated! Access to higher level denied!');
                                          end;
// pokud je v�e OK
if continue then begin
                 // porovn�v�n� zadan�ho a c�lov�ho k�du
                 CheckCode;
                 // vybarven� kontrolek podle �sp�nosti
                 index:=0;
                 for i:=1 to 4 do if CheckedCode[i]=aExact then begin // zelenou barvou p�esn� z�sahy
                                                                Checks[RowIndex*4-3+index].Brush.Color:=clLime;
                                                                index:=index+1;
                                                                end;
                 for i:=1 to 4 do if CheckedCode[i]=aRight then begin // �lutou barvou spr�vn� ��sla na �patn�m m�st�
                                                                Checks[RowIndex*4-3+index].Brush.Color:=clYellow;
                                                                index:=index+1;
                                                                end;
                 for i:=1 to 4 do if CheckedCode[i]=aWrong then begin // �ervenou barvou �patn� ��sla
                                                                Checks[RowIndex*4-3+index].Brush.Color:=clRed;
                                                                index:=index+1;
                                                                end;
                 // kontrola, zda nen� uhodnut p�esn� k�d
                 if CheckEnd then begin
                                  continue:=false;
                                  EndGame(geVictory);
                                  end;
                 // kontrola, zda nen� vy�erp�n po�et pokus�
                 if RowIndex>=10 then begin
                                      continue:=false;
                                      EndGame(geAttemptsDefeat);
                                      end;
                 // postup na dal�� ��dek
                 if continue then begin // pouze, pokud neskon�ila hra - uh�dnut�m k�du nebo vy�erp�n�m pokus�
                                  // zm�na stavov�ho ��dku
                                  GameStatus.Panels[5].Text:=inttostr(10-RowIndex)+' attempts';
                                  // sk�re se po��t� podle celkov� nastaven� obt�nosti
                                  if Config.OverallDif=dEasy      then Score:=strtoint(TimeLeft.Caption)   +(10-RowIndex+1)*100 else
                                  if Config.OverallDif=dModerate  then Score:=strtoint(TimeLeft.Caption)*5 +(10-RowIndex+1)*300 else
                                  if Config.OverallDif=dHard      then Score:=strtoint(TimeLeft.Caption)*15+(10-RowIndex+1)*500 else
                                                                       Score:=0; // pokud se sk�re nepo��t�
                                  if Score<>0 then GameStatus.Panels[3].Text:='Score : '+inttostr(Score)
                                              else GameStatus.Panels[3].Text:='Not counted';
                                  //
                                  Execute[RowIndex].Enabled:=false;
                                  Execute[RowIndex+1].Enabled:=true;
                                  for i:=RowIndex*4-3 to RowIndex*4 do begin
                                                                       Inputs[i].Enabled:=false; // hotov� ��dek se "zakonzervuje"
                                                                       Inputs[i+4].Enabled:=true; // nov� ��dek se zp��stupn�
                                                                       end;
                                  RowIndex:=RowIndex+1;
                                  end;
                 end;
end;

procedure TForm1.InputChange(Sender: TObject);
// kontrola, zda u�ivatel nevpisuje jin� znak ne� ��slice 0-9
var text: string;
begin
text:=(Sender as TComboBox).Text; // text aktu�ln�ho vstupn�ho pole - pro v�echny stejn� procedura
if (Ord(text[length(text)])<48)
 or(Ord(text[length(text)])>57) then begin
                                     delete(text,length(text),1);
                                     (Sender as TComboBox).Text:=text;
                                     ShowMessage('Invalid code input! Character deleted.');
                                     end;

end;

procedure TForm1.Pause1Click(Sender: TObject);
// tla��tko "Pauza"
begin
if Pause1.Caption='&Pause' then begin
                               Pause1.Caption:='&Resume';
                               Pause1.Hint:='Resume game';
                               Timer1.Enabled:=false;
                               Execute[RowIndex].Enabled:=false;
                               GameStatus.Panels[6].Text:='Paused';
                               end
                          else begin
                               Pause1.Caption:='&Pause';
                               Pause1.Hint:='Pause game';
                               Timer1.Enabled:=true;
                               Execute[RowIndex].Enabled:=true;
                               GameStatus.Panels[6].Text:=TimeLeft.Caption;
                               end;
end;

procedure TForm1.HighScores1Click(Sender: TObject);
// zobraz� formul�� s nejlep��mi dosa�en�mi v�kony
begin
EndGame(geStopped); // pokud u� b�� hra, zastav� ji
Application.CreateForm(TForm4, Form4);
Form4.ShowModal;
Form4.Free;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
SaveScores; // ulo�en� sk�re
end;

procedure TForm1.Easy1Click(Sender: TObject);
// nastav� lehkou obt�nost pro �as i po�et ��slic
begin
Easy1.Checked:=true;
// nastaven� vlastnost�
Config.GLimit:=600;
Config.GFigures:=5;
Config.TimeDif:=dEasy;
Config.FigureDif:=dEasy;
Config.OverallDif:=dEasy;
// aktualizace komponent
TimeLeft.Caption:='600';
GameStatus.Panels[0].Text:='600 secs (Easy)';
GameStatus.Panels[1].Text:='5 (Easy)';
GameStatus.Panels[2].Text:='Easy';
// info pro u�ivatele
ShowMessage('Conditions was set by "Easy" cofiguration');
end;

procedure TForm1.Moderate1Click(Sender: TObject);
// nastav� st�edn� obt�nost pro �as i po�et ��slic
begin
Moderate1.Checked:=true;
// nastaven� vlastnost�
Config.GLimit:=300;
Config.GFigures:=7;
Config.TimeDif:=dModerate;
Config.FigureDif:=dModerate;
Config.OverallDif:=dModerate;
// aktualizace komponent
TimeLeft.Caption:='300';
GameStatus.Panels[0].Text:='300 secs (Mod)';
GameStatus.Panels[1].Text:='7 (Mod)';
GameStatus.Panels[2].Text:='Moderate';
// info pro u�ivatele
ShowMessage('Conditions was set by "Moderate" cofiguration');
end;

procedure TForm1.Hard1Click(Sender: TObject);
// nastav� st�edn� obt�nost pro �as i po�et ��slic
begin
Hard1.Checked:=true;
// nastaven� vlastnost�
Config.GLimit:=120;
Config.GFigures:=10;
Config.TimeDif:=dHard;
Config.FigureDif:=dHard;
Config.OverallDif:=dHard;
// aktualizace komponent
TimeLeft.Caption:='120';
GameStatus.Panels[0].Text:='120 secs (Hard)';
GameStatus.Panels[1].Text:='10 (Hard)';
GameStatus.Panels[2].Text:='Hard';
// info pro u�ivatele
ShowMessage('Conditions was set by "Hard" cofiguration');
end;

end.
