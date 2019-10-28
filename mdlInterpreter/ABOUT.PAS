unit About;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    OKButton: TButton;
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
    procedure Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label16MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label16Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation
uses Manager;

{$R *.DFM}

procedure TAboutBox.Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Label1.Font.Color:=clBlue;
  Label3.Font.Color:=clBlue;
  Label5.Font.Color:=clBlue;
  Label7.Font.Color:=clBlue;
end;

procedure TAboutBox.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Label1.Font.Color:=clWindowText;
  Label3.Font.Color:=clWindowText;
  Label5.Font.Color:=clWindowText;
  Label7.Font.Color:=clWindowText;
  Label16MouseMove(Self,Shift,X,Y);
end;

procedure TAboutBox.Label1Click(Sender: TObject);
begin
  Label1.Visible:=false;
  Label2.Visible:=false;
  Label3.Visible:=false;
  Label4.Visible:=false;
  Label5.Visible:=false;
  Label6.Visible:=false;
  Label7.Visible:=false;
  Label8.Visible:=false;
  Label9.Visible:=false;
  Label10.Visible:=false;

  Label11.Visible:=true;
  Label12.Visible:=true;
  Label13.Visible:=true;
  Label14.Visible:=true;
  Label15.Visible:=true;
  Label16.Visible:=true;
  Label17.Visible:=true;
  Label18.Visible:=true;
end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  Top:=MainF.Top+((MainF.Height-Height) div 2);
  Left:=MainF.Left+((MainF.Width-Width) div 2);
end;

procedure TAboutBox.Label16MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if Sender=Label16 then begin
     Label16.Font.Color:=clMaroon;
     Label16.Font.Style:=Label16.Font.Style+[fsUnderline];
  end
  else
  if Sender=Label18 then begin
     Label18.Font.Color:=clMaroon;
     Label18.Font.Style:=Label18.Font.Style+[fsUnderline];
  end else
  begin
     Label18.Font.Color:=clWindowText;
     Label18.Font.Style:=Label18.Font.Style-[fsUnderline];
     Label16.Font.Color:=clWindowText;
     Label16.Font.Style:=Label16.Font.Style-[fsUnderline];
  end;

end;

procedure TAboutBox.Label16Click(Sender: TObject);
begin
//  if FileExists()
//  WinExec('rundll32.exe C:\W95\SYSTEM\mailnews.dll,Mail_RunDLL '+'svd@agtu.secna.ru',0);
end;

end.

