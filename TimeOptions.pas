unit TimeOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    EasyLimit: TRadioButton;
    ModerateLimit: TRadioButton;
    HardLimit: TRadioButton;
    CustomLimit: TRadioButton;
    CustomLimitValue: TEdit;
    UpDown1: TUpDown;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses Unit1;

procedure TForm2.Button2Click(Sender: TObject);
begin
// jenom zavøe formuláø aniž by se nìco zmìnilo
Form2.Close;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
// podle uživatelova výbìru pøiøadí èasomíøe výchozí hodnotu
if EasyLimit.Checked     then begin
                              Unit1.Config.GLimit:=600;
                              Unit1.Config.TimeDif:=dEasy;
                              Form1.TimeLeft.Caption:='600';
                              end else
if ModerateLimit.Checked then begin
                              Unit1.Config.GLimit:=300;
                              Unit1.Config.TimeDif:=dModerate;
                              Form1.TimeLeft.Caption:='300';
                              end else
if HardLimit.Checked     then begin
                              Unit1.Config.GLimit:=120;
                              Unit1.Config.TimeDif:=dHard;
                              Form1.TimeLeft.Caption:='120';
                              end else
                              begin
                              Unit1.Config.GLimit:=UpDown1.Position;
                              Unit1.Config.TimeDif:=dCustom;
                              Form1.TimeLeft.Caption:=inttostr(UpDown1.Position);
                              end;
Form2.Close;
end;

end.
