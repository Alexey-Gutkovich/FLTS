program FLTS;

uses
  Forms,
  manager in 'manager.pas' {������� ���� ���������},
  lexem in 'Lexem.pas',
  scaner in 'Scaner.pas',
  Synopsis in 'Synopsis.pas',
  Pswd in 'Pswd.pas' {���� ����� ������},
  NewPswd in 'NewPswd.pas' {���� ����� ������},
  MyObject in 'MyObject.pas',
  OpenTest in 'OpenTest.pas' {�������� �����},
  Message in 'Message.pas',
  About in 'About.pas' {AboutBox};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainF, MainF);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
