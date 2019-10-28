program FLTS;

uses
  Forms,
  manager in 'manager.pas' {Главное окно программы},
  lexem in 'Lexem.pas',
  scaner in 'Scaner.pas',
  Synopsis in 'Synopsis.pas',
  Pswd in 'Pswd.pas' {Окно ввода пароля},
  NewPswd in 'NewPswd.pas' {Окно смены пароля},
  MyObject in 'MyObject.pas',
  OpenTest in 'OpenTest.pas' {Открытие теста},
  Message in 'Message.pas',
  About in 'About.pas' {AboutBox};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainF, MainF);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
