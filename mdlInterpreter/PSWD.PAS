unit Pswd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons,Db,DbTables;

type
  TPswdForm = class(TForm)
    Label1: TLabel;
    Name: TEdit;
    Label2: TLabel;
    Password: TEdit;
    ChPswd: TCheckBox;
    Ok: TBitBtn;
    CancelB: TBitBtn;
    procedure OkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NameKeyPress(Sender: TObject; var Key: Char);
    procedure CancelBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PswdForm: TPswdForm;

implementation

uses manager, NewPswd, Data , Message;

{$R *.DFM}

procedure TPswdForm.OkClick(Sender: TObject);
begin
 { работа с базой }
 MainF.UserTable.Active:=true;
 if MainF.UserTable.locate('username',Name.Text,[]) and
   (MainF.UserTable.fieldbyname('password').AsString=Password.Text) then begin
   { заполняем стр-ру Session }
    MainF.Session.UserName := Name.Text;
    MainF.Session.UserGroup:=MainF.UserTable.fieldbyname('usergroup').AsString;
    MainF.LegalEntrance:=true;
    if ChPswd.Checked then begin
       Application.CreateForm(TNewPswdForm, NewPswdForm);
       NewPswdForm.ShowModal;
    end;
    Close;
    MainF.SB.Panels[1].Text:=MainF.Session.UserName;
 end else
 begin
   MessageDlg(Mess[MainF.CurLang,55]+#13#10+
              Mess[MainF.CurLang,56],mtError,[mbOk],1);
 end;
 MainF.UserTable.Active:=false;
end;

procedure TPswdForm.FormCreate(Sender: TObject);
begin
  Top :=MainF.Top+(MainF.Height-Height) div 2;
  Left:=MainF.Left+(MainF.Width-Width) div 2;
  Caption:=Mess[MainF.CurLang,51];
  Label1.caption:=Mess[MainF.CurLang,52];
  Label2.caption:=Mess[MainF.CurLang,53];
  ChPswd.caption:=Mess[MainF.CurLang,54];
end;

procedure TPswdForm.NameKeyPress(Sender: TObject; var Key: Char);
begin
 case Key of
  #13: OkCLick(self);
  #27: CancelBCLick(self);
 end;
end;

procedure TPswdForm.CancelBClick(Sender: TObject);
begin
 Close;
end;

end.
