unit FiguresOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TForm3 = class(TForm)
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
  Form3: TForm3;

implementation

{$R *.dfm}

uses Unit1;

procedure TForm3.Button2Click(Sender: TObject);
begin
// jenom zavøe formuláø aniž by se nìco zmìnilo
Form3.Close;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
// podle uživatelova výbìru pøiøadí èasomíøe výchozí hodnotu
if EasyLimit.Checked     then begin
                              Unit1.Config.GFigures:=5;
                              Unit1.Config.FigureDif:=dEasy;
                              end else
if ModerateLimit.Checked then begin
                              Unit1.Config.GFigures:=7;
                              Unit1.Config.FigureDif:=dModerate;
                              end else
if HardLimit.Checked     then begin
                              Unit1.Config.GFigures:=10;
                              Unit1.Config.FigureDif:=dHard;
                              end else
                              begin
                              Unit1.Config.GFigures:=UpDown1.Position;
                              Unit1.Config.FigureDif:=dCustom;
                              end;
Form3.Close;
end;

end.
