unit Scores;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm4 = class(TForm)
    ScoresChart: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    OKButton: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  EasyNames: array[1..10]of TLabel;
  ModNames: array[1..10]of TLabel;
  HardNames: array[1..10]of TLabel;
  EasyScores: array[1..10]of TLabel;
  ModScores: array[1..10]of TLabel;
  HardScores: array[1..10]of TLabel;

implementation

{$R *.dfm}

uses Unit1, CodeBreakerProcedures;

procedure TForm4.FormCreate(Sender: TObject);
// vytváøení dynamických komponent formuláøe
var i,y: integer;
begin
y:=15;
for i:=1 to 10 do begin
                  EasyNames[i]:=TLabel.Create(self);
                  EasyNames[i].Parent:=TabSheet1;
                  EasyNames[i].Caption:=EasyTop10[i].Name;
                  EasyNames[i].Left:=50;
                  EasyNames[i].Constraints.MaxWidth:=80; //  zabraòuje pøesahu jména do hodnoty skóre
                  EasyNames[i].Top:=y;
                  EasyScores[i]:=TLabel.Create(self);
                  EasyScores[i].Parent:=TabSheet1;
                  EasyScores[i].Caption:=inttostr(EasyTop10[i].Score);
                  EasyScores[i].Left:=140;
                  EasyScores[i].Top:=y;
                  ModNames[i]:=TLabel.Create(self);
                  ModNames[i].Parent:=TabSheet2;
                  ModNames[i].Caption:=ModTop10[i].Name;
                  ModNames[i].Left:=50;
                  ModNames[i].Constraints.MaxWidth:=80; //  zabraòuje pøesahu jména do hodnoty skóre
                  ModNames[i].Top:=y;
                  ModScores[i]:=TLabel.Create(self);
                  ModScores[i].Parent:=TabSheet2;
                  ModScores[i].Caption:=inttostr(ModTop10[i].Score);
                  ModScores[i].Left:=140;
                  ModScores[i].Top:=y;
                  HardNames[i]:=TLabel.Create(self);
                  HardNames[i].Parent:=TabSheet3;
                  HardNames[i].Caption:=HardTop10[i].Name;
                  HardNames[i].Left:=50;
                  HardNames[i].Constraints.MaxWidth:=80; //  zabraòuje pøesahu jména do hodnoty skóre
                  HardNames[i].Top:=y;
                  HardScores[i]:=TLabel.Create(self);
                  HardScores[i].Parent:=TabSheet3;
                  HardScores[i].Caption:=inttostr(HardTop10[i].Score);
                  HardScores[i].Left:=140;
                  HardScores[i].Top:=y;
                  y:=y+15;
                  end;
end;

procedure TForm4.OKButtonClick(Sender: TObject);
begin
Form4.Close;
end;

procedure TForm4.Button2Click(Sender: TObject);
// vymaže všechna dosažená skóre
var i: integer;
begin
// nejprve potvrzení akce
if MessageDlg('Are you sure, you want to delete all your achieved scores?',mtConfirmation,[mbYes,mbNo],0) = IDYes then
begin
FillDefaultScores; // vynuluje dosažené výsledky
// pøepis hodnot v tabulkách
for i:=1 to 10 do begin
                  EasyNames[i].Caption:=EasyTop10[i].Name;
                  EasyScores[i].Caption:=inttostr(EasyTop10[i].Score);
                  ModNames[i].Caption:=ModTop10[i].Name;
                  ModScores[i].Caption:=inttostr(ModTop10[i].Score);
                  HardNames[i].Caption:=HardTop10[i].Name;
                  HardScores[i].Caption:=inttostr(HardTop10[i].Score);
                  end;
ShowMessage('Scores were reseted to defaults');                  
end;
end;

end.
