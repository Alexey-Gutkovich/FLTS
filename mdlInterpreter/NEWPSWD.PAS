unit NewPswd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TNewPswdForm = class(TForm)
    Label1: TLabel;
    Pswd: TEdit;
    Label2: TLabel;
    RePswd: TEdit;
    Ok: TBitBtn;
    CancelB: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure OkClick(Sender: TObject);
    procedure PswdKeyPress(Sender: TObject; var Key: Char);
    procedure CancelBClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewPswdForm: TNewPswdForm;

implementation

uses Manager , Message;

{$R *.DFM}

procedure TNewPswdForm.FormCreate(Sender: TObject);
begin
  Top :=MainF.Top+(MainF.Height-Height) div 2;
  Left:=MainF.Left+(MainF.Width-Width) div 2;
  Caption:=Mess[MainF.CurLang,57];
  Label1.Caption:=Mess[MainF.CurLang,58];
  Label2.Caption:=Mess[MainF.CurLang,59];
end;

procedure TNewPswdForm.OkClick(Sender: TObject);
begin
 { запись в базу }
 if Pswd.Text=RePswd.Text then begin
    MainF.UserTable.Edit;
    MainF.UserTable.fieldbyname('password').AsString:=Pswd.Text;
    MainF.UserTable.Post;
    Close;
 end else  MessageDlg(Mess[MainF.CurLang,60]+
           #13#10+Mess[MainF.CurLang,59],mtError,[mbOk],1 );
end;

procedure TNewPswdForm.PswdKeyPress(Sender: TObject; var Key: Char);
begin
  case Key of
   #13 : OkClick(self);
   #27 : CancelBCLick(self);
  end;
end;

procedure TNewPswdForm.CancelBClick(Sender: TObject);
begin
 Close;
end;

end.
