unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, ComCtrls;

type
  TDifficulty = (dEasy,dModerate,dHard,dCustom); // výètový tip pro poèítání skóre
  TAccuracy = (aExact,aRight,aWrong); // výètový tip pro porovnávání zadaného a výsledného kódu
  TGameEnd = (geVictory,geTimeDefeat,geAttemptsDefeat,geStopped); // výètový tip pro urèení scénáøe konce hry
  TScore = record // ukládá informace o skóre
           Name: string[255];
           Score: integer;
           end;
  TConfig = record // informace o základním nastavení pro nové naètení hry
            GLimit: word;
            GFigures: byte;
            OverallDif: TDifficulty; // bere se vždy podle "nižší" z èasového limitu a poètu èíslic
            TimeDif: TDifficulty; // nastavená èasová obtížnost
            FigureDif: TDifficulty; // nastavená obtížnost barev
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
    //function  CheckCode(Input: TComboBox; Target: TLabel): TAccuracy; - fce zrušena a pøedìlána na proceduru
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
  RowIndex: byte; // index aktuálního øákdu (1-10)
  TargetLabels: array[1..4]of TLabel; // labely, do kterých se výsledný kód vypíše
  TargetCode: array[1..4]of Byte; // náhodnì generovaný kód, ke kterému se má uživatel dobrat
  CheckedCode: array[1..4]of TAccuracy; // výsledek porovnání zadaného a výsledného kódu
  Score: word; // výsledné skóre uživatele - pokud vyhraje
  ScoreMessage: string; // informace pro hráèe o jeho pozici v nejlepších výsledcích

  // pøi spuštìní naète všech 30 nejlepších výsledkù ze souboru a pøi skonèení programu je zase uloží
  EasyTop10: array[1..10]of TScore;
  ModTop10: array[1..10]of TScore;
  HardTop10: array[1..10]of TScore;

implementation

{$R *.dfm}

uses TimeOptions,FiguresOptions, Scores, CodeBreakerProcedures;

procedure TForm1.CheckCode;
// porovnává kód v zadaném vstupním poli s kódem, který má vyjít
var i,i2: integer;
    ComparedCode,ExactCode: array[1..4]of Integer; // pole pro vyhodnocování zadaného kódu
    continue: boolean;
begin
// krok 0 - inicializování promìnných
for i:=1 to 4 do begin
                 CheckedCode[i]:=aWrong;
                 ComparedCode[i]:=strtoint(Inputs[RowIndex*4-4+i].Text); // argument "RowIndex*4-4+i" dá pøesnì ten index, který potøebuju
                 ExactCode[i]:=strtoint(TargetLabels[i].Caption);
                 end;
// krok 1 - hledá pøesné výsledky
for i:=1 to 4 do if ComparedCode[i]=ExactCode[i] then begin
                                                      CheckedCode[i]:=aExact;
                                                      ComparedCode[i]:=-2;
                                                      ExactCode[i]:=-1;
                                                      end;
// krok 2 - hledá správná èísla ne nesprávných místech
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
Zrušený postup - nefunkèní na 100%
// krok 0 - pøiøazení výchozí (a anulování pøedchozí) hodnoty výsledkovému poli (implicitnì aWrong)
for i:=1 to 4 do CheckedCode[i]:=aWrong;
// krok 1 - hledá pøesné výsledky
for i:=1 to 4 do if strtoint(Inputs[RowIndex*4-4+i].Text)=strtoint(TargetLabels[i].Caption) then CheckedCode[i]:=aExact; // argument "RowIndex*4-4+i" dá pøesnì ten index, který potøebuju
// krok 2 - hledá správná èísla ne nesprávných místech - pøi tom je tøeba ignorovat ta, která jsou už obsazena pøesným výsledkem
for i:=1 to 4 do if CheckedCode[i]<>aExact then begin
                                                i2:=0;
                                                continue:=true;
                                                repeat
                                                i2:=i2+1;
                                                if (CheckedCode[i]=aWrong)and(CheckedCode[i2]=aWrong)and(strtoint(Inputs[RowIndex*4-4+i2].Text)=strtoint(TargetLabels[i].Caption)) then begin
                                                                                                                                                                                           CheckedCode[i]:=aRight;
                                                                                                                                                                                           continue:=false; // reaguje pouze na první výskyt
                                                                                                                                                                                           // pokud se nìjaké èíslo opakuje v kódu vícekrát, ale hráè zadá na špatné místo jen jedno,
                                                                                                                                                                                           // je tøeba urèit pouze jeden jeho výskyt - proto se cyklus se musí ukonèit...
                                                                                                                                                                                           end;

                                                until (i2>=4)or(continue=false);
                                                end;
}
end;

{
funkce zrušena a nahrazena procedurou
function TForm1.CheckCode(Input: TComboBox; Target: TLabel): TAccuracy;
// porovnává kód v zadaném vstupním poli s kódem, který má vyjít
begin
if strtoint(Input.Text)=strtoint(Target.Caption) then result:=aExact // "pøímý zásah" - správné èíslo na správném místì
else begin // porovnání se všemi ostaními èástmi výsledného kódu, jestli není alespoò správné èíslo na špatné pozici
     if (((strtoint(Input.Text)=strtoint(TargetLabels[1].Caption))and(CheckedCode[1]<>aExact)))
      or(((strtoint(Input.Text)=strtoint(TargetLabels[2].Caption))and(CheckedCode[2]<>aExact)))
      or(((strtoint(Input.Text)=strtoint(TargetLabels[3].Caption))and(CheckedCode[3]<>aExact)))
      or(((strtoint(Input.Text)=strtoint(TargetLabels[4].Caption))and(CheckedCode[4]<>aExact))) then result:=aRight
                                                                                                else result:=aWrong; // èíslo se v kódu nevyskytuje
     end;
end;
}

procedure TForm1.TargetCodeGenerator;
// vytváøí náhodnì výsledný kód, ke kterému se má hráè dobrat
var i,i2,x: integer;
begin
for i:=1 to 4 do begin
                 for i2:=1 to 200000 do Application.ProcessMessages; // zdržovaè
                 x:=random(Config.GFigures); //náhodnì vybrané èíslo z tolika, kolik je možných (min 2 (0-1), max 10 (0-9))
                 TargetCode[i]:=x;
                 // pøiøazení pro kontrolu
                 TargetLabels[i].Caption:=inttostr(TargetCode[i]);
                 end;
end;

procedure TForm1.InputsDisable;
// znemožòuje výbìr ve všech polích
var i:integer;
begin
for i:=1 to 40 do Inputs[i].Enabled:=false;
end;

procedure TForm1.InputsFill;
// aktualizuje možnosti výbìru v jednotlivých polích podle zvoleného poètu promìnných
var i,i2:integer;
begin
for i:=1 to 40 do begin
                  Inputs[i].Items.Clear;
                  Inputs[i].Text:='';
                  for i2:=0 to Config.GFigures-1 do Inputs[i].Items.Add(inttostr(i2));
                  end;
end;

procedure TForm1.ChecksClear;
// vrací kontrolky do výchozího stavu - všechny èerné
var i:integer;
begin
for i:=1 to 40 do Checks[i].Brush.Color:=clBlack;
end;

procedure TForm1.EndGame(EndState: TGameEnd);
var i: integer;
begin
// ukonèuje odpoèet èasu
Timer1.Enabled:=false;
Pause1.Enabled:=false;
// zabraòuje možnosti znovu zadávat kód na posledním zakonèeném øádku
Execute[RowIndex].Enabled:=false;
for i:=RowIndex*4-3 to RowIndex*4 do Inputs[i].Enabled:=false;
// aktualizuje obsah vstupních polí + pøekresluje kontrolky + úprava stavového øádku
InputsFill;
ChecksClear;
Pause1.Enabled:=false;
Pause1.Caption:='&Pause';
GameStatus.Panels[3].Text:='Score';
GameStatus.Panels[5].Text:='Attempts Left';
GameStatus.Panels[6].Text:='Time Left';
// v závislosti na parametru EndState vypisuje možné konce hry
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
// každou sekundu odeète 1 z hodnoty zbývajícího èasu
time:=strtoint(TimeLeft.Caption);
time:=time-1;
TimeLeft.Caption:=inttostr(time);
// informace pro Status Bar
// skóre se poèítá podle celkové nastavené obtížnosti
if Config.OverallDif=dEasy      then Score:=strtoint(TimeLeft.Caption)   +(10-RowIndex+1)*100 else
if Config.OverallDif=dModerate  then Score:=strtoint(TimeLeft.Caption)*5 +(10-RowIndex+1)*300 else
if Config.OverallDif=dHard      then Score:=strtoint(TimeLeft.Caption)*15+(10-RowIndex+1)*500 else
                                     Score:=0; // pokud se skóre nepoèítá
if Score<>0 then GameStatus.Panels[3].Text:='Score : '+inttostr(Score)
            else GameStatus.Panels[3].Text:='Not counted';
GameStatus.Panels[6].Text:=TimeLeft.Caption+' secs';
// když zbývá ménì èasu než urèitá hodnota, èísla se zbarví
if time=60 then TimeLeft.Font.Color:=clYellow;
if time=30 then TimeLeft.Font.Color:=clRed;
// když dojde èas, nastává konec hry...
if time<=0 then EndGame(geTimeDefeat);
end;

procedure TForm1.New1Click(Sender: TObject);
var i:integer;
begin
// obnovuje prvky formuláøe pro novou hru
TimeLeft.Caption:=inttostr(Config.GLimit);
TimeLeft.Font.Color:=clLime;
Timer1.Enabled:=true;
InputsDisable;
for i:=1 to 4 do Inputs[i].Enabled:=true; // umožòuje výbìr ve spodní øadì
RowIndex:=1;
Execute[1].Enabled:=true;
TargetCodeGenerator; // vytváøí náhodnì výsledný kód, ke kterému se má hráè dobrat
Pause1.Enabled:=true;
// iniciace celkové obtížnosti pro pozdìjí výpoèet skóre
if (Config.TimeDif=dCustom)  or(Config.FigureDif=dCustom)   then begin
                                                                 Config.OverallDif:=dCustom; // "Custom" na prvním místì
                                                                 GameStatus.Panels[2].Text:='Custom';
                                                                 end else
if (Config.TimeDif=dEasy)    or(Config.FigureDif=dEasy)     then begin
                                                                 Config.OverallDif:=dEasy; // potom podle zvyšující se obtížnosti - celkovì se bere vždy ta nižší...
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
// informace o skóre pro Status Bar
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
// výbìr èasového limitu pro øešení
begin
EndGame(geStopped); // pokud už bìží hra, zastaví ji
Application.CreateForm(TForm2, Form2);
Form2.ShowModal;
Form2.Free;
// aktualizace stavového øádku
if Config.TimeDif=dEasy     then begin
                                 Timeleft.Caption:='600';
                                 GameStatus.Panels[0].Text:='600 secs (Easy)';
                                 ShowMessage('Time conditions was set by "Easy" cofiguration'); // info pro uživatele
                                 end else
if Config.TimeDif=dModerate then begin
                                 Timeleft.Caption:='300';
                                 GameStatus.Panels[0].Text:='300 secs (Mod)';
                                 ShowMessage('Time conditions was set by "Moderate" cofiguration'); // info pro uživatele
                                 end else
if Config.TimeDif=dHard     then begin
                                 Timeleft.Caption:='120';
                                 GameStatus.Panels[0].Text:='120 secs (Hard)';
                                 ShowMessage('Time conditions was set by "Hard" cofiguration'); // info pro uživatele
                                 end else
                                 begin
                                 Timeleft.Caption:=inttostr(Config.GLimit);
                                 GameStatus.Panels[0].Text:=inttostr(Config.GLimit)+' secs (Custom)';
                                 ShowMessage('Time conditions was set by "Custom" cofiguration'); // info pro uživatele
                                 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
// události pøi vytváøení formuláøe
var i,i2,i3,i4,x,y: integer;
begin
randomize;
// naètení dosažených skóre
LoadScores;
// výchozí parametry
Config.GLimit:=300;
Config.GFigures:=7;
Config.TimeDif:=dModerate;
Config.FigureDif:=dModerate;
RowIndex:=1;
// vytváøení labelù, do kterých se zapisuje cílový kód
for i:=1 to 4 do begin
                 TargetLabels[i]:=TLabel.Create(self);
                 TargetLabels[i].Parent:=GroupBox2;
                 TargetLabels[i].Font.Size:=17;
                 TargetLabels[i].Font.Style:=TargetLabels[1].Font.Style+[fsBold];
                 TargetLabels[i].Top:=25;
                 TargetLabels[i].Left:=140+((i-1)*30);
                 TargetLabels[i].Caption:='X';
                 end;
// vytváøení zadávacích polí
x:=90;
y:=260;
i3:=1;
i4:=0;
for i:=1 to 40 do begin
                  if x>290 then begin // konec øádku
                                // vytváøí button potvrzující ukonèení kombinování na daném øádku
                                Execute[i3]:=TButton.Create(self);
                                Execute[i3].Parent:=GroupBox1;
                                Execute[i3].Width:=50;
                                Execute[i3].Height:=21;
                                Execute[i3].Caption:='Check';
                                Execute[i3].Left:=x+10;
                                Execute[i3].Top:=y;
                                Execute[i3].Enabled:=false;
                                Execute[i3].Hint:='Check your code';
                                Execute[i3].OnClick:=CheckClick;  // pøiøazení akce po kliknutí
                                // upravuje hodnoty promìnných pro posun "o øádek výš"
                                i3:=i3+1;
                                i4:=0;
                                x:=90;
                                y:=y-25;
                                end;
                  // vytváøí výbìrové pole
                  Inputs[i]:=TComboBox.Create(self);
                  Inputs[i].Parent:=GroupBox1;
                  Inputs[i].Width:=50;
                  Inputs[i].Height:=25;
                  Inputs[i].Left:=x;
                  Inputs[i].Top:=y;
                  Inputs[i].Enabled:=false;
                  for i2:=0 to 6 do Inputs[i].Items.Add(inttostr(i2));
                  Inputs[i].OnChange:=InputChange; // pøiøazení procedury kontrolující, co uživatel zapisuje do textového pole
                  // vytváøí kontrolky, které indikují správnost/nesprávnost kódu
                  Checks[i]:=TShape.Create(self);
                  Checks[i].Parent:=GroupBox1;
                  Checks[i].Width:=10;
                  Checks[i].Height:=10;
                  Checks[i].Shape:=stCircle;
                  Checks[i].Brush.Color:=clBlack;
                  Checks[i].Left:=20+i4*15;
                  Checks[i].Top:=y+7;
                  // posun x-ové souøadnice o 1 vedle
                  x:=x+55;
                  i4:=i4+1;
                  end;
// potvrzující button pro nejvyšší øádek se musí vytvoøit extra
// - to už do toho pøedchozího cyklu nacpat nejde...aspoò ne nìjak efektivnì, takže radši tìch pár øádkù navíc...
Execute[10]:=TButton.Create(self);
Execute[10].Parent:=GroupBox1;
Execute[10].Width:=50;
Execute[10].Height:=21;
Execute[10].Caption:='Check';
Execute[10].Left:=x+10;
Execute[10].Top:=y;
Execute[10].Enabled:=false;
Execute[10].OnClick:=CheckClick; // pøiøazení akce po kliknutí
end;

procedure TForm1.Figures1Click(Sender: TObject);
// výbìr poètu èíslic do kombinace kódu
begin
EndGame(geStopped); // pokud už bìží hra, zastaví ji
Application.CreateForm(TForm3, Form3);
Form3.ShowModal;
Form3.Free;
InputsFill; // pøepisuje možnosti výbìru pro aktuální poèet èíslic
// aktualizace stavového øádku
if Config.FigureDif=dEasy     then begin
                                   GameStatus.Panels[1].Text:='5 (Easy)';
                                   ShowMessage('Time conditions was set by "Easy" cofiguration'); // info pro uživatele
                                   end else
if Config.FigureDif=dModerate then begin
                                   GameStatus.Panels[1].Text:='7 (Mod)';
                                   ShowMessage('Figures conditions was set by "Moderate" cofiguration'); // info pro uživatele
                                   end else
if Config.FigureDif=dHard     then begin
                                   GameStatus.Panels[1].Text:='10 (Hard)';
                                   ShowMessage('Figures conditions was set by "Hard" cofiguration'); // info pro uživatele
                                   end else
                                   begin
                                   GameStatus.Panels[1].Text:=inttostr(Config.GFigures)+' (Custom)';
                                   ShowMessage('Figures conditions was set by "Custom" cofiguration'); // info pro uživatele
                                   end;
end;

procedure TForm1.CheckClick(Sender: TObject);
// potvrzení dokonèení øádku a pøechod o øádek výš
var i,index: integer;
    continue: boolean; // hlídá, zda je vše v poøádku, aby se mohlo pokraèovat s èinností procedury
begin
continue:=true; // implicitnì vše v poøádku je
// kontrola, zda jsou všechny 4 pole v øádku správnì zadána
// zda byl proveden výbìr z ComboBoxu
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
// pokud je vše OK
if continue then begin
                 // porovnávání zadaného a cílového kódu
                 CheckCode;
                 // vybarvení kontrolek podle úspìšnosti
                 index:=0;
                 for i:=1 to 4 do if CheckedCode[i]=aExact then begin // zelenou barvou pøesné zásahy
                                                                Checks[RowIndex*4-3+index].Brush.Color:=clLime;
                                                                index:=index+1;
                                                                end;
                 for i:=1 to 4 do if CheckedCode[i]=aRight then begin // žlutou barvou správná èísla na špatném místì
                                                                Checks[RowIndex*4-3+index].Brush.Color:=clYellow;
                                                                index:=index+1;
                                                                end;
                 for i:=1 to 4 do if CheckedCode[i]=aWrong then begin // èervenou barvou špatná èísla
                                                                Checks[RowIndex*4-3+index].Brush.Color:=clRed;
                                                                index:=index+1;
                                                                end;
                 // kontrola, zda není uhodnut pøesný kód
                 if CheckEnd then begin
                                  continue:=false;
                                  EndGame(geVictory);
                                  end;
                 // kontrola, zda není vyèerpán poèet pokusù
                 if RowIndex>=10 then begin
                                      continue:=false;
                                      EndGame(geAttemptsDefeat);
                                      end;
                 // postup na další øádek
                 if continue then begin // pouze, pokud neskonèila hra - uhádnutím kódu nebo vyèerpáním pokusù
                                  // zmìna stavového øádku
                                  GameStatus.Panels[5].Text:=inttostr(10-RowIndex)+' attempts';
                                  // skóre se poèítá podle celkové nastavené obtížnosti
                                  if Config.OverallDif=dEasy      then Score:=strtoint(TimeLeft.Caption)   +(10-RowIndex+1)*100 else
                                  if Config.OverallDif=dModerate  then Score:=strtoint(TimeLeft.Caption)*5 +(10-RowIndex+1)*300 else
                                  if Config.OverallDif=dHard      then Score:=strtoint(TimeLeft.Caption)*15+(10-RowIndex+1)*500 else
                                                                       Score:=0; // pokud se skóre nepoèítá
                                  if Score<>0 then GameStatus.Panels[3].Text:='Score : '+inttostr(Score)
                                              else GameStatus.Panels[3].Text:='Not counted';
                                  //
                                  Execute[RowIndex].Enabled:=false;
                                  Execute[RowIndex+1].Enabled:=true;
                                  for i:=RowIndex*4-3 to RowIndex*4 do begin
                                                                       Inputs[i].Enabled:=false; // hotový øádek se "zakonzervuje"
                                                                       Inputs[i+4].Enabled:=true; // nový øádek se zpøístupní
                                                                       end;
                                  RowIndex:=RowIndex+1;
                                  end;
                 end;
end;

procedure TForm1.InputChange(Sender: TObject);
// kontrola, zda uživatel nevpisuje jiný znak než èíslice 0-9
var text: string;
begin
text:=(Sender as TComboBox).Text; // text aktuálního vstupního pole - pro všechny stejná procedura
if (Ord(text[length(text)])<48)
 or(Ord(text[length(text)])>57) then begin
                                     delete(text,length(text),1);
                                     (Sender as TComboBox).Text:=text;
                                     ShowMessage('Invalid code input! Character deleted.');
                                     end;

end;

procedure TForm1.Pause1Click(Sender: TObject);
// tlaèítko "Pauza"
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
// zobrazí formuláø s nejlepšími dosaženými výkony
begin
EndGame(geStopped); // pokud už bìží hra, zastaví ji
Application.CreateForm(TForm4, Form4);
Form4.ShowModal;
Form4.Free;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
SaveScores; // uložení skóre
end;

procedure TForm1.Easy1Click(Sender: TObject);
// nastaví lehkou obtížnost pro èas i poèet èíslic
begin
Easy1.Checked:=true;
// nastavení vlastností
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
// info pro uživatele
ShowMessage('Conditions was set by "Easy" cofiguration');
end;

procedure TForm1.Moderate1Click(Sender: TObject);
// nastaví støední obtížnost pro èas i poèet èíslic
begin
Moderate1.Checked:=true;
// nastavení vlastností
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
// info pro uživatele
ShowMessage('Conditions was set by "Moderate" cofiguration');
end;

procedure TForm1.Hard1Click(Sender: TObject);
// nastaví støední obtížnost pro èas i poèet èíslic
begin
Hard1.Checked:=true;
// nastavení vlastností
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
// info pro uživatele
ShowMessage('Conditions was set by "Hard" cofiguration');
end;

end.
