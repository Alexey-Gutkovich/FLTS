unit manager;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, Grids, StdCtrls,Synopsis, OleCtrls, ExtCtrls, ComCtrls, Menus,
  ToolWin, MPlayer, Db, DBTables;

type
  TSession = record
    username : string;
    usergroup: string;
    datein : string;
    dateout: string;
    timein : string;
    testname : string;
    testmark : real;
    Unique_Key : longint;
  end;
  TMainF = class(TForm)
    TextQuest: TMemo;
    OD: TOpenDialog;
    ExitPanel: TPanel;
    MainMenu1: TMainMenu;
    AllTime: TProgressBar;
    QuestTime: TProgressBar;
    Label1: TLabel;
    Label2: TLabel;
    SB: TStatusBar;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    ForwardB: TBitBtn;
    MP: TMediaPlayer;
    Bmp: TImage;
    SoundB: TBitBtn;
    QuestTimer: TTimer;
    AllTimer: TTimer;
    UserTable: TTable;
    WorkTable: TTable;
    ProtocolTable: TTable;
    Panel1: TPanel;
    LoginB: TSpeedButton;
    OpenTest: TSpeedButton;
    LogoutB: TSpeedButton;
    BreakTest: TSpeedButton;
    ExitB: TSpeedButton;
    S: TSplitter;
    YetB: TSpeedButton;
    N11: TMenuItem;
    N12: TMenuItem;
    Co1: TMenuItem;
    N13: TMenuItem;
    F8: TMenuItem;
    F10: TMenuItem;
    F12: TMenuItem;
    F14: TMenuItem;
    C1: TMenuItem;
    C2: TMenuItem;
    C3: TMenuItem;
    C4: TMenuItem;
    RealTimer: TTimer;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    MediaTable: TTable;
    procedure CloseBClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure ForwardBClick(Sender: TObject);
    procedure ExitBClick(Sender: TObject);
    procedure LoginBMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure N6Click(Sender: TObject);
    procedure LoginBClick(Sender: TObject);
    procedure SoundBClick(Sender: TObject);
    procedure BreakTestClick(Sender: TObject);
    procedure LogoutBClick(Sender: TObject);
    procedure SMoved(Sender: TObject);
    procedure TextQuestKeyPress(Sender: TObject; var Key: Char);
    procedure YetBClick(Sender: TObject);
    procedure F8Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure RealTimerTimer(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure QuestTimerTimer(Sender: TObject);
    procedure AllTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N15Click(Sender: TObject);
  private
  public
    Memo : TMemo;
    FileName : string;
    FileOpen : boolean;
    Session : TSession;
    LegalEntrance : boolean;
    CurLang : byte;
    procedure ChangeLanguage(lang : byte);
  end;

function SRand( num : word) : word;
var
  MainF: TMainF;

implementation

uses Scaner, Pswd , OpenTest , Message, About;
{$R *.DFM}
var
   Interp: TInterpreter;
   PswdForm : TPswdForm;


procedure TMainF.CloseBClick(Sender: TObject);
begin
  Close;
end;

function SRand( num : word) : word;
begin
  Randomize;
  SRand := Random(num);
end;

procedure TMainF.FormResize(Sender: TObject);
begin
 SB.Panels[0].Width:=MainF.Width-280;
 if MainF.Height<=400 then begin
   MainF.Height:=400;
   ExitPanel.Height:=ForwardB.Top - S.Top - 44;
   ForwardB.Top:=307;
   SoundB.Top:=307;
 end else
 begin
   ExitPanel.Height:=MainF.Height-137-S.Top;
   ForwardB.Top:=MainF.Height-93;
   SoundB.Top:=MainF.Height-93;
 end;
 if MainF.Width<=550 then begin
   MainF.Width:=550;
   ExitPanel.Width:=MainF.ClientWidth;
 end else
 begin
   ExitPanel.Width:=MainF.ClientWidth;
 end;
end;

procedure TMainF.N5Click(Sender: TObject);
{var tmp  : integer;
    SynAn: TSynopsis;
    i    : integer;
    FText:file;
begin
   Memo:=TMemo.Create(Self);
   Memo.Visible:=false;
   InsertControl(Memo);

   FileOpen:=false;
   Application.CreateForm(TOpenForm, OpenForm);
   OpenForm.ShowModal;

   if FileOpen then  begin
      SynAn:=TSynopsis.create(Memo.Lines.Text);
      tmp:=SynAn.Analyze;
      if (tmp<>0) then
        MessageDlg(Mess[CurLang,36]+inttostr(SynAn.ErrorCode)+'].'+#10#13+
        Mess[CurLang,37],mtError,[mbOk],0)
      else begin
         Randomize;
         Session.Unique_Key := Random(1234567890);
         Session.TimeIn:=TimeToStr(Time);
         Session.DateIn:=datetostr(date);

         WorkTable.Active:=true;
         WorkTable.Insert;

         WorkTable.FieldByName('UserName').AsString:=Session.UserName;
         WorkTable.FieldByName('UserGroup').AsString:=Session.UserGroup;
         WorkTable.FieldByName('DateIn').AsDateTime:=Date;
         WorkTable.FieldByName('DateOut').AsString:='';
         WorkTable.FieldByName('TimeIn').AsString:=Session.TimeIn;
         WorkTable.FieldByName('TimeOut').AsString:='';
         WorkTable.FieldByName('TestName').AsString:=Filename;
         WorkTable.FieldByName('TestMark').AsString:='';
         WorkTable.FieldByName('Unique_Key').AsInteger:=Session.Unique_Key;

         WorkTable.Post;
         WorkTable.Active:=false;

         BreakTest.Enabled:=true;
         ForwardB.Enabled:=true;
         N6.Enabled:=true;
         OpenTest.Enabled:=false;
         N5.Enabled:=false;
         Interp:=TInterpreter.Create(Memo.Lines.Text);
         for i:=1 to SynAn.CurQuestion do begin
            Interp.Offset[i].Number:=i;
            Interp.Offset[i].Offset:=SynAn.Offs[i];
         end;
         Interp.KolQuest := SynAn.CurQuestion;
         TextQuest.Lines.Clear;
         SB.Panels[2].Text:=ExtractFileName(FileName);
         Interp.Resume;
     end;
     SynAn.Free;
   end;
     Memo.Free;
end;}
var tmp  : integer;
    Memo : TMemo;
    SynAn: TSynopsis;
    i    : integer;
    FText:file;
begin
  if OD.execute then begin
      Memo:=TMemo.Create(Self);
      Memo.Visible:=false;
      MainF.InsertControl(Memo);
      Memo.Lines.LoadFromFile(OD.FileName);
      SynAn:=TSynopsis.create(Memo.Lines.Text);
      tmp:=SynAn.Analyze;
      if (tmp<>0) then
        MessageDlg('Ошибка в тесте [Код '+inttostr(SynAn.ErrorCode)+'].'+#10#13+
        'Обратитесь к АДМИНИСТРАТОРУ !',mtError,[mbOk],0)
      else begin
         {
         WorkTable.Active:=true;
         WorkTable.Edit;
         Randomize;
         Session.Unique_Key := Random(1234567890);
         Session.TimeIn:=TimeToStr(Time);
         Session.DateIn:=datetostr(date);
         WorkTable.InsertRecord([Session.UserName,Session.UserGroup,
         Date,'',Session.TimeIn,'',
         UpperCase(ExtractFileName(OD.Filename)),'',
         Session.Unique_Key]);
         WorkTable.Post;
         WorkTable.Active:=false;
         }
         Randomize;
         Session.Unique_Key := Random(1234567890);
         Session.TimeIn:=TimeToStr(Time);
         Session.DateIn:=datetostr(date);

         WorkTable.Active:=true;
         WorkTable.Insert;

         WorkTable.FieldByName('UserName').AsString:=Session.UserName;
         WorkTable.FieldByName('UserGroup').AsString:=Session.UserGroup;
         WorkTable.FieldByName('DateIn').AsDateTime:=Date;
         WorkTable.FieldByName('DateOut').AsString:='';
         WorkTable.FieldByName('TimeIn').AsString:=Session.TimeIn;
         WorkTable.FieldByName('TimeOut').AsString:='';
         WorkTable.FieldByName('TestName').AsString:=ExtractFileName(OD.Filename);
         WorkTable.FieldByName('TestMark').AsString:='';
         WorkTable.FieldByName('Unique_Key').AsInteger:=Session.Unique_Key;

         WorkTable.Post;
         WorkTable.Active:=false;
         
         BreakTest.Enabled:=true;
         ForwardB.Enabled:=true;
         N6.Enabled:=true;
         OpenTest.Enabled:=false;
         N5.Enabled:=false;
         Interp:=TInterpreter.Create(Memo.Lines.Text);
         Interp.MaxMark:=0.0;
         for i:=1 to SynAn.CurQuestion do begin
            Interp.Offset[i].Number:=i;
            Interp.Offset[i].Offset:=SynAn.Offs[i];
            Interp.MaxMark:=Interp.MaxMark+SynAn.Weights[i].Value;
         end;
         Interp.KolQuest := SynAn.CurQuestion;
//         SynAn.Free;
//         Memo.Free;
         TextQuest.Lines.Clear;
         SB.Panels[2].Text:=ExtractFileName(OD.FileName);
         Interp.Resume;
     end;
     SynAn.Free;
     Memo.Free;
  end;
end;

procedure TMainF.ForwardBClick(Sender: TObject);
begin
// with Interp do
//  if LocalTimeP<>0 then QuestProt[QuestionP].Time:=1;
 Interp.Resume;
end;

procedure TMainF.ExitBClick(Sender: TObject);
begin
 { спросить действит. ли хочет }
 if MessageDlg(Mess[CurLang,35],
    mtConfirmation,[mbOk,mbNo],0)=mrOk then begin
//    if Interp <> Nil then Interp.Destroy;
    Close;
 end;
end;

procedure TMainF.LoginBMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
   if Sender=LoginB then SB.Panels[0].Text:=LoginB.Hint
   else
   if Sender=LogoutB then SB.Panels[0].Text:=LogoutB.Hint
   else
   if Sender=OpenTest then SB.Panels[0].Text:=OpenTest.Hint
   else
   if Sender=BreakTest then SB.Panels[0].Text:=BreakTest.Hint
   else
   if Sender=ExitB then SB.Panels[0].Text:=ExitB.Hint
   else
   if Sender=ForwardB then SB.Panels[0].Text:=ForwardB.Hint
   else
   if Sender=SoundB then SB.Panels[0].Text:=SoundB.Hint
   else
   if Sender=YetB then SB.Panels[0].Text:=YetB.Hint
   else
   if Sender=ForwardB then SB.Panels[0].Text:=ForwardB.Hint
   else  SB.Panels[0].Text:='';
end;

procedure TMainF.N6Click(Sender: TObject);
begin
// Interp.Destroy;
end;

procedure TMainF.LoginBClick(Sender: TObject);
begin

  LegalEntrance:=false;
  Application.CreateForm(TPswdForm, PswdForm);
  PswdForm.Showmodal;

  if LegalEntrance then begin
    OpenTest.Enabled:=true;
    LogoutB.Enabled:=true;
    N5.Enabled:=true;
    N10.Enabled:=true;
    LoginB.Enabled:=false;
    N9.Enabled:=false;
  end;
end;

procedure TMainF.SoundBClick(Sender: TObject);
begin
  SoundB.Enabled:=false;
  MP.Close;
  MP.Open;
  MP.Play;
  SoundB.Enabled:=true;
  MP.Tag:=MP.Tag-1;
  if MP.Tag=0 then  SoundB.Visible:=false
  else SoundB.Caption:=Mess[CurLang,32]+' ['+inttostr(MP.Tag)+']';
end;

procedure TMainF.BreakTestClick(Sender: TObject);
begin
  if MessageDlg(Mess[CurLang,33],mtConfirmation,[mbOk,mbNo],1) = mrOk then
  begin
     SB.Panels[2].Text:='';
     SoundB.Visible:=false;
     ForwardB.Enabled:=false;
     OpenTest.Enabled:=true;
     N5.Enabled:=true;
     N6.Enabled:=false;
     BreakTest.Enabled:=false;
     TextQuest.Lines.Clear;
     QuestTime.Position:=0;
     AllTime.Position:=0;
     AllTimer.Enabled:=false;
     QuestTimer.Enabled:=false;
     if Interp <> Nil then Interp.Destroy;
  end;
end;


procedure TMainF.LogoutBClick(Sender: TObject);
begin
  if MessageDlg(Mess[CurLang,34],mtConfirmation,[mbOk,mbNo],1) = mrOk then
  begin
     LoginB.Enabled:=true;
     N9.Enabled:=true;
     N10.Enabled:=false;
     LogoutB.Enabled:=false;
     N5.Enabled:=false;
     N6.Enabled:=false;
     OpenTest.Enabled:=false;
     BreakTest.Enabled:=false;
     textQuest.Lines.Clear;
//     if Interp <> Nil then Interp.Destroy;
     ForwardB.Enabled:=false;
  end;
end;

procedure TMainF.SMoved(Sender: TObject);
var i : word;
begin
    Label1.Top:=S.Top+5;
    Label2.Top:=S.Top+5;
    AllTime.Top:=S.Top+26;
    QuestTime.Top:=S.Top+26;
    ExitPanel.Top:=S.Top+37;
    i := ForwardB.Top - S.Top;
    ExitPanel.Height:=i-44;
end;

procedure TMainF.TextQuestKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key=#13) and (ForwardB.Enabled) then ForwardBClick(self);
end;

procedure TMainF.YetBClick(Sender: TObject);
var i : word;
begin
    YetB.Enabled:=false;
    { запись протокола запуска теста }
    WorkTable.Active:=true;
    Randomize;
    Session.Unique_Key := Random(1234567890);
    Session.TimeIn:=TimeToStr(Time);
    Session.DateIn:=datetostr(date);
    WorkTable.InsertRecord([Session.UserName,Session.UserGroup,
    Date,'',Session.TimeIn,'',UpperCase(ExtractFileName(OD.Filename)),'',
    Session.Unique_Key]);

    WorkTable.Active:=false;
    BreakTest.Enabled:=true;
    ForwardB.Enabled:=true;
    N6.Enabled:=true;
    OpenTest.Enabled:=false;
    N5.Enabled:=false;
    { save quest's offset}
{         for i:=1 to KolQuest do begin
       Interp.Offset[i].Number:=i;
       Interp.Offset[i].Offset:=SynAn.Offs[i];
    end;
}
    Interp.Resume;
//   Interp.Execute;
end;

procedure TMainF.F8Click(Sender: TObject);
var i : byte;
begin
   if Sender=F8  then i:=8  else
   if Sender=F10 then i:=10 else
   if Sender=F12 then i:=12 else
   if Sender=F14 then i:=14;
   TextQuest.Font.Size:=i;
end;

procedure TMainF.C1Click(Sender: TObject);
begin
  if Sender=C1 then TextQuest.Color:=clWhite else
  if Sender=C2 then TextQuest.Color:=clSilver else
  if Sender=C3 then TextQuest.Color:=clGreen else
  if Sender=C4 then TextQuest.Color:=clBlue;
end;

procedure TMainF.RealTimerTimer(Sender: TObject);
begin
   SB.Panels[3].Text:=TimeToStr(Time);
end;

procedure TMainF.N13Click(Sender: TObject);
begin
  Application.CreateForm(TAboutBox, AboutBox);
  AboutBox.ShowModal;
end;

procedure TMainF.QuestTimerTimer(Sender: TObject);
begin
  if  QuestTime.Position <> QuestTime.Min then
      QuestTime.Position:=QuestTime.Position-1
  else begin
      QuestTimer.Enabled:=false;
//      Interp.QuestProt[Interp.QuestionP].Time:=Interp.LocalTimeP;
      Interp.Resume;
  end;
end;

procedure TMainF.AllTimerTimer(Sender: TObject);
var i : word;
begin
  if  AllTime.Position <> AllTime.Min then
      AllTime.Position:=AllTime.Position-1
  else begin
      AllTimer.Enabled:=false;
      QuestTimer.Enabled:=false;
      SB.Panels[2].Text:='';
      SoundB.Visible:=false;
      ForwardB.Enabled:=false;
      OpenTest.Enabled:=true;
      BreakTest.Enabled:=false;
      N5.Enabled:=true;
      N6.Enabled:=false;
      QuestTime.Position:=0;
      AllTime.Position:=0;
      TextQuest.Lines.Clear;
//*********************************
//   result & protocol
//*********************************
try
      Interp.FixResult;
except
end;
//*********************************
//      if Interp <> Nil then Interp.Destroy;
     Interp.HideControls;
  end;
end;

procedure TMainF.ChangeLanguage(lang : byte);
begin
 CurLang:=lang;
 N1.Caption:=Mess[lang,1];
 N5.Caption:=Mess[lang,2];
 N6.Caption:=Mess[lang,3];
 N8.Caption:=Mess[lang,4];
 N2.Caption:=Mess[lang,5];

 N9.Caption:=Mess[lang,6];
 N10.Caption:=Mess[lang,7];
 N3.Caption:=Mess[lang,8];
 N11.Caption:=Mess[lang,9];
 N12.Caption:=Mess[lang,10];

 C1.Caption:=Mess[lang,11];
 C2.Caption:=Mess[lang,12];
 C3.Caption:=Mess[lang,13];
 C4.Caption:=Mess[lang,14];
 N14.Caption:=Mess[lang,15];

 N15.Caption:=Mess[lang,16];
 N16.Caption:=Mess[lang,17];
// N17.Caption:=Mess[lang,18];
// N18.Caption:=Mess[lang,19];
 N4.Caption:=Mess[lang,20];

 Co1.Caption:=Mess[lang,21];
 N13.Caption:=Mess[lang,22];
 LoginB.Hint:=Mess[lang,23];
 OpenTest.Hint:=Mess[lang,24];
 YetB.Hint:=Mess[lang,25];

 LogoutB.Hint:=Mess[lang,26];
 BreakTest.Hint:=Mess[lang,27];
 ExitB.Hint:=Mess[lang,28];
 Label1.Caption:=Mess[lang,29];
 Label2.Caption:=Mess[lang,30];

 ForwardB.Caption:=Mess[lang,31];
 SoundB.Caption:=Mess[lang,32];
end;

procedure TMainF.FormCreate(Sender: TObject);
begin
 CurLang:=1;
 ChangeLanguage(1);
end;

procedure TMainF.N15Click(Sender: TObject);
var lang : byte;
begin
  if Sender = N15 then lang:=1
  else
  if Sender = N16 then lang:=2;
{  else
  if Sender = N17 then lang:=3
  else
  lang:=4;}
  ChangeLanguage(lang);
end;

end.
