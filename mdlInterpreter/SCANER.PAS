unit scaner;

interface
uses dialogs,sysutils,
     stdctrls,classes,
     extctrls,controls,
     checklst,comctrls,
     graphics,manager,
     buttons,db,lexem,Forms,
     MyObject,MvCtrls , windows;

type
   { Запись протокола вопроса }
   TProtocolRecord = record
      UKey : longint;   // ? зачем надо
      Quest: word;
      Mark : real;
      Time : integer;
   end;

TInterpreter = class(TThread)
    function Analyze : integer;        // вызов анализатора
  private
     procedure TitleSD;                // разбор заголовка теста
     procedure TestSD;                 // разбор теста
     procedure QuestionSD;             // разбор вопроса в тесте
     procedure QuestParSD;             // разбор параметров вопроса
     procedure ObjectSD;               // разбор заголовка теста
     procedure IntSelectSD;            // разбор списка типа INT
     procedure AnySelectSD;            // разбор списка типа ANY
     procedure ChoiceSD;               // разбор об'екта Choice
     procedure MultiChoiceSD;          // разбор об'екта MultiChoice
     procedure SoftChoiceSD;           // разбор об'екта SoftChoice
     procedure AddChoiceSD;            // разбор об'екта AddChoice
     procedure OrChoiceSD;             // разбор об'екта OrChoice
     procedure ScaleSD;                // разбор об'екта Scale
     procedure LabelSD;                // разбор об'екта Label
     procedure ListSD;                 // разбор об'екта List
     procedure EditSD;                 // разбор об'екта Edit
     procedure OrderSD;                // разбор об'екта Order
     procedure SoundSD;                // разбор об'екта Sound
     procedure ImageSD;                // разбор об'екта Image
     procedure PositionSizeSD;         // разбор размеров и коорд. об'екта
     procedure TestParametrSD;         // разбор параметров теста
     procedure GradationSD;            // разбор Gradation
     procedure SavePointer;            // сохранение текущ. указателя текста
     procedure RestorePointer;         // востановление текущ. указателя текста
     procedure MoveFrwd;               // сдвиг указателя на позицию вправо
     procedure SS_SD;
     procedure S_SD;
     procedure BodySD;                 // разбор тела оператора if
     function  ConditionSD  : boolean; // разбор условия оператора if
     function  ElementExpSD : TValue;  // разбор элементарного выражения
     function  ExpressionSD : TValue;  // разбор выражения
     function  AdditionSD   : TValue;  // разбор слагаемого
     procedure LetSD;                  // разбор присваивания
     procedure SetError(code:integer); // выставление флага и кода ошибки
     procedure GetLexem(len:integer);  // получение образа текущ.
                                       // отсканиров. лексемы
     function  IsAlpha(c:char) : boolean; // проверка на букву
     function  IsDigit(c:char) : boolean; // проверка на цифру
     function  TextScaner : integer;   // сканер текста

     { функции работы с переменными }
     function  FindId(id : string) : boolean;
     function  GetIdFromTable(id : string) : TIdent;
     procedure AddIdToTable(id : TIdent);
     procedure ChangeValueId(idname : string;id : TValue);
  protected
     TextLength  : integer;            // размер текста
     TextSize    : integer;
     Text        : string;             // входной текст
     Identity    : array[1..AMOUNT_QUESTION shl 1] of TIdent;
     CountId     : word;
     FlagIn      : boolean;
     procedure execute; override;
  public                               // протокол теста
     CurQuest    : word;
     QuestProt   : array [1.. AMOUNT_QUESTION] of TProtocolRecord;
     KolQuest    : word;               // количество вопросов в тесте
     Mark        : real;               // набранные баллы
     MaxMark     : real;
     { Заголовок теста }
     TestNameP   : string;             // название теста
     DifficultyP : string;             // уровень сложности
     QuestionsP  : integer;            // текущий вопрос в тесте
     FullTimeP   : integer;            // время на решение теста
     BailOutP    : real;               // мин.уровень сдачи теста
     RegistrationP : boolean;          // флаг рег-ции пользователя
     ProtocolP   : boolean;            // флаг ведения протокола
     IntervalP   : boolean;            // флаг учета потраченного времени
     RandomChoiceP:boolean;            //
     RandomP     : boolean;            // флаг случ.вывода вопросов
     BailP       : array [1..AMOUNT_BAILGRAD] of TBail;
     CountBail   : integer;            // количество градаций в Bail
     { Заголовок вопроса }
     MainHeightP : integer;            // высота окна
     MainWidthP  : integer;            // ширина окна
     QuestionP   : integer;            // номер вопроса
     LocalTimeP  : integer;            // время на ответ
     WeightP     : real;               // вес вопроса
     TextP       : string;             // текстовый стимул
     ButtonP     : integer;            // количество воспроизведений

     OffSet      : array [1..AMOUNT_QUESTION] of TOffset;
//     LocalTimes  : array [1..AMOUNT_QUESTION] of integer;
     CurObj      : TCurrentObj;

     MyCh        : TControl;           // текущий объект
     MyWinCh     : TWinControl;
     MyBmp       : TBitmap;
     CurQuestion : integer;
     JumpTo      : boolean;
     ErrCond     : boolean;            // флаг ошибки
     CurPointer  : integer;            // указатель (текущ. позиция в тексте)
     ErrorMsg    : string;             // текст сообщения об ошибке
     ErrorCode   : integer;            // код ошибки
     CurrentLine : integer;            // текущая строка
     Lexem       : string[128];        // образ отсканир. лексемы
     First       : byte;

     TmpStr : string;
     TmpInt : byte;
     Generate : boolean;
     TmpSeq : array [1..AMOUNT_SELECT] of integer;
     TmpReal : array [1..AMOUNT_SELECT] of real;
     TmpString : array [1..AMOUNT_SELECT] of string;
     SetNum : set of 1..AMOUNT_SELECT;
     TmpAvi : string;
     TmpBMP : string;
     TmpWav : string;

     constructor Create(txt: string);
     destructor Destroy;
     procedure  GoQuestion(NumQuest:integer);
     procedure  FreeMemory;
     procedure  HideControls;
     procedure  InsertChoice;
     procedure  InsertMultiChoice;
     procedure  InsertSoftChoice;
     procedure  InsertAddChoice;
     procedure  InsertOrChoice;
     procedure  InsertScale;
     procedure  InsertList;
     procedure  InsertEdit;
     procedure  InsertImage;
     procedure  InsertSound;
     procedure  InsertLabel;
     procedure  InsertOrder;
     procedure  Redrawing;
     procedure  FixResult;

     function   ChoiceEstimate(Ch : MyChoice) : real;
     function   SoftChoiceEstimate(Ch : MySoftChoice) : real;
     function   MultiChoiceEstimate(Ch : MyMultiChoice) : real;
     function   AddChoiceEstimate(Ch : MyAddChoice) : real;
     function   OrChoiceEstimate(Ch : MyOrChoice) : real;
     function   ListEstimate(Ch : MyList) : real;
     function   EditEstimate(Ch : MyEdit) : real;
     function   OrderEstimate(Ch : MyOrder) : real;

     function   Find (who : byte) : byte;
     procedure  GenerateSeq;
     procedure  RandomCh_Choice (var CurObj : TCurrentObj);
     procedure  RandomCh_MultiChoice (var CurObj : TCurrentObj);
     procedure  RandomCh_OrChoice (var CurObj : TCurrentObj);
     procedure  RandomCh_AddChoice (var CurObj : TCurrentObj);
     procedure  RandomCh_SoftChoice (var CurObj : TCurrentObj);
     procedure  RandomCh_List (var CurObj : TCurrentObj);
     procedure  RandomCh_Order (var CurObj : TCurrentObj);
end;
//#############################################################

implementation
uses Message;

constructor TInterpreter.Create(txt: string);
begin
  Text := txt;
  inherited Create(true);
end;
//#############################################################
destructor TInterpreter.Destroy;
begin
  FreeMemory;
  inherited Destroy;
end;
//#############################################################
procedure TInterpreter.execute;
var i : word;
begin
  for i:=1 to KolQuest do begin
     Identity[i].TypeId:=2;
     Identity[i].Image:='Q'+inttostr(i);
     Identity[i].Value:=0.0;

     QuestProt[i].Time:=-1;
  end;
  CountId:=KolQuest;
  Analyze;
  Destroy;
end;
//#############################################################
function TInterpreter.Find (who : byte) : byte;
var i: integer;
begin
   for i:=1 to CurObj.Count do
     if TmpSeq[i]=who then begin
        Find := i;
        exit;
     end;
end;
//#############################################################
procedure TInterpreter.GenerateSeq;
var i : word;
begin
  Randomize;
  SetNum:=[];
  // генерация паоследовательности
  for i:=1 to CurObj.Count do begin
     Generate:=false;
     while not Generate do begin
        TmpInt:=SRand(CurObj.Count)+1;
        if not (TmpInt in SetNum) then begin
           SetNum:=SetNum+[TmpInt];
           TmpSeq[i]:=TmpInt;
           Generate:=true;
        end;
     end; //while
  end; //for
end;
//#############################################################
procedure  TInterpreter.RandomCh_OrChoice (var CurObj : TCurrentObj);
var
    i : word;
begin
    GenerateSeq;
    for i:=1 to CurObj.Count  do   TmpString[i]:=CurObj.Texts[TmpSeq[i]];
    for i:=1 to CurObj.Count  do   CurObj.Texts[i]:=TmpString[i];
    for i:=1 to CurObj.CountRight  do
    CurObj.WhatRight[i]:=Find(CurObj.WhatRight[i]);
end;
//#############################################################
procedure  TInterpreter.RandomCh_SoftChoice (var CurObj : TCurrentObj);
var
    i : word;
begin
    GenerateSeq;
    for i:=1 to CurObj.Count  do   TmpString[i]:=CurObj.Texts[TmpSeq[i]];
    for i:=1 to CurObj.Count  do   CurObj.Texts[i]:=TmpString[i];
    for i:=1 to CurObj.Count  do   TmpReal[i]:=CurObj.Weights[TmpSeq[i]];
    for i:=1 to CurObj.Count  do   CurObj.Weights[i]:=TmpReal[i];
end;
//#############################################################
procedure  TInterpreter.RandomCh_AddChoice (var CurObj : TCurrentObj);
var
    i : word;
begin
    GenerateSeq;
    for i:=1 to CurObj.Count  do   TmpString[i]:=CurObj.Texts[TmpSeq[i]];
    for i:=1 to CurObj.Count  do   CurObj.Texts[i]:=TmpString[i];
    for i:=1 to CurObj.Count  do   TmpReal[i]:=CurObj.Weights[TmpSeq[i]];
    for i:=1 to CurObj.Count  do   CurObj.Weights[i]:=TmpReal[i];
end;
//#############################################################
procedure  TInterpreter.RandomCh_MultiChoice (var CurObj : TCurrentObj);
var
    i : word;
begin
    GenerateSeq;
    for i:=1 to CurObj.Count  do   TmpString[i]:=CurObj.Texts[TmpSeq[i]];
    for i:=1 to CurObj.Count  do   CurObj.Texts[i]:=TmpString[i];
    for i:=1 to CurObj.CountRight  do
      CurObj.WhatRight[i]:=Find(CurObj.WhatRight[i]);
end;
//#############################################################
procedure  TInterpreter.RandomCh_Choice (var CurObj : TCurrentObj);
var
    i : word;
begin
    GenerateSeq;
    for i:=1 to CurObj.Count  do   TmpString[i]:=CurObj.Texts[TmpSeq[i]];
    for i:=1 to CurObj.Count  do   CurObj.Texts[i]:=TmpString[i];
    CurObj.WhatRight[1]:=Find(CurObj.WhatRight[1]);
end;
//#############################################################
procedure  TInterpreter.RandomCh_List (var CurObj : TCurrentObj);
var
    i : word;
begin
    GenerateSeq;
    for i:=1 to CurObj.Count  do   TmpString[i]:=CurObj.Texts[TmpSeq[i]];
    for i:=1 to CurObj.Count  do   CurObj.Texts[i]:=TmpString[i];
    CurObj.WhatRight[1]:=Find(CurObj.WhatRight[1]);
end;
//#############################################################
procedure  TInterpreter.RandomCh_Order (var CurObj : TCurrentObj);
var
    i : word;
begin
    GenerateSeq;
    for i:=1 to CurObj.Count  do   TmpString[i]:=CurObj.Texts[TmpSeq[i]];
    for i:=1 to CurObj.Count  do   CurObj.Texts[i]:=TmpString[i];
    for i:=1 to CurObj.Count  do
    CurObj.WhatRight[i]:=Find(CurObj.WhatRight[i]);
end;
//#############################################################
procedure TInterpreter.InsertLabel;
begin
  MyCh.Width:=CurObj.Width;           // ширина
  MyCh.Height:=CurObj.Height;         // высота
  MyCh.Top:=CurObj.AtY;              // позиция
  MyCh.Left:=CurObj.AtX;

 (MyCh as TLabel).Font.Size:=CurObj.Items;
 (MyCh as TLabel).Caption:=CurObj.Texts[1];
  MainF.ExitPanel.insertcontrol(MyCh);
end;
//#############################################################
procedure TInterpreter.InsertScale;
begin
  MyCh.Width:=CurObj.Width;           // ширина
  MyCh.Height:=CurObj.Height;         // высота
  MyCh.Top:=CurObj.AtY;              // позиция
  MyCh.Left:=CurObj.AtX;

 (MyCh as TTrackBar).Max:=CurObj.Items;
 (MyCh as TTrackBar).Position:=CurObj.Position;
  MainF.ExitPanel.insertcontrol(MyCh);
end;
//#############################################################
procedure Tinterpreter.InsertChoice;
var i : integer;
begin
  {вставили RadioGroup}
   MyCh.Width:=CurObj.Width;           // ширина
   MyCh.Height:=CurObj.Height;         // высота
   MyCh.Top:=CurObj.AtY;              // позиция
   MyCh.Left:=CurObj.AtX;
   if RandomChoiceP then RandomCh_Choice (CurObj);

  (MyCh as MyChoice).WhatRight:=CurObj.WhatRight[1];

  (MyCh as TmvRadioGroup).WordWrap:=true;
  (MyCh as TmvRadioGroup).Caption:=' '+Mess[MainF.CurLang,50]+' ';
  MainF.ExitPanel.insertcontrol(MyCh);

  with (MyCh as MyChoice) do begin
    {количество RadioButton'ов}
     Count:=CurObj.Count;
    {вставка Radiobutton'ов}
    for i:=1 to Count do  begin
        Items.Add(CurObj.Texts[i]);
    end;
  end;
end;
//#############################################################
procedure Tinterpreter.InsertSoftChoice;
var i : integer;
begin
  {вставили RadioGroup}
  MyCh.Width:=CurObj.Width;           // ширина
  MyCh.Height:=CurObj.Height;         // высота
  MyCh.Top:=CurObj.AtY;              // позиция
  MyCh.Left:=CurObj.AtX;
  if RandomChoiceP then RandomCh_SoftChoice(CurObj);
  (MyCh as TmvRadioGroup).WordWrap:=true;
  (MyCh as TmvRadioGroup).Caption:=' '+Mess[MainF.CurLang,43]+' ';

  for i:=1 to CurObj.Count do
    (MyCh as MySoftChoice).weights[i]:=CurObj.weights[i];
  MainF.ExitPanel.insertcontrol(MyCh);

  with (MyCh as MySoftChoice) do begin
    {количество RadioButton'ов}
     Count:=CurObj.Count;
    {вставка Radiobutton'ов}
    for i:=1 to Count do  begin
        Items.Add(CurObj.Texts[i]);
    end;
  end;
end;
//#############################################################
procedure Tinterpreter.InsertAddChoice;
var i : integer;
begin
  MyCh.Width:=CurObj.Width;           // ширина
  MyCh.Height:=CurObj.Height;         // высота
  MyCh.Top:=CurObj.AtY;              // позиция
  MyCh.Left:=CurObj.AtX;
  if RandomChoiceP then RandomCh_AddChoice(CurObj);
  for i:=1 to CurObj.Count do
   (MyCh as MyAddChoice).Weights[i] := CurObj.Weights[i];

  MainF.ExitPanel.insertcontrol(MyCh);

  with (MyCh as MyAddChoice) do begin
    {количество CheckBox'ы}
     Count:=CurObj.Count;
    {вставка CheckBox'ов}
    for i:=1 to Count do  begin
        Items.Add(CurObj.Texts[i]);
    end;
  end;
end;
//#############################################################
procedure Tinterpreter.InsertOrChoice;
var i : integer;
begin
  {вставили RadioGroup}
  MyCh.Width:=CurObj.Width;           // ширина
  MyCh.Height:=CurObj.Height;         // высота
  MyCh.Top:=CurObj.AtY;              // позиция
  MyCh.Left:=CurObj.AtX;
  if RandomChoiceP then RandomCh_OrChoice(CurObj);
  for i:=1 to CurObj.CountRight do
     if CurObj.WhatRight[i] <> 0 then
     (MyCh as MyOrChoice).Right[CurObj.WhatRight[i]] := true;

  (MyCh as TmvRadioGroup).WordWrap:=true;
  (MyCh as TmvRadioGroup).Caption:=' '+Mess[MainF.CurLang,43]+' ';
  MainF.ExitPanel.insertcontrol(MyCh);

  with (MyCh as MyOrChoice) do begin
    {количество RadioButton'ов}
     Count:=CurObj.Count;
    {вставка Radiobutton'ов}
    for i:=1 to Count do  begin
        Items.Add(CurObj.Texts[i]);
    end;
  end;
end;
//#############################################################
procedure  TInterpreter.InsertMultiChoice;
var i : integer;
begin
  MyCh.Width:=CurObj.Width;           // ширина
  MyCh.Height:=CurObj.Height;         // высота
  MyCh.Top:=CurObj.AtY;              // позиция
  MyCh.Left:=CurObj.AtX;
  if RandomChoiceP then RandomCh_MultiChoice(CurObj);

  for i:=1 to CurObj.CountRight do
     if CurObj.WhatRight[i] <> 0 then
     (MyCh as MyMultiChoice).Right[CurObj.WhatRight[i]] := true;

  MainF.ExitPanel.insertcontrol(MyCh);

  with (MyCh as MyMultiChoice) do begin
    {количество RadioButton'ов}
     Count:=CurObj.Count;
    {вставка Radiobutton'ов}
    for i:=1 to Count do  begin
        Items.Add(CurObj.Texts[i]);
    end;
  end;
end;
//#############################################################
procedure Tinterpreter.InsertList;
var i : integer;
begin
  {вставили список}
  MyCh.Width:=CurObj.Width;           // ширина
  MyCh.Height:=CurObj.Height;         // высота
  MyCh.Top:=CurObj.AtY;              // позиция
  MyCh.Left:=CurObj.AtX;
  if RandomChoiceP then RandomCh_List(CurObj);

  (MyCh as MyList).WhatRight:=CurObj.WhatRight[1];

  MainF.ExitPanel.insertcontrol(MyCh);

  with (MyCh as MyList) do begin
    {количество элементов в списке}
     Count:=CurObj.Count;
    {вставка элементовов}
    for i:=1 to Count do  begin
        Items.Add(CurObj.Texts[i]);
    end;
  end;
end;
//#############################################################
procedure  TInterpreter.InsertEdit;
var i : word;
begin
  MyCh.Width:=CurObj.Width;           // ширина
  MyCh.Height:=CurObj.Height;         // высота
  MyCh.Top:=CurObj.AtY;              // позиция
  MyCh.Left:=CurObj.AtX;
  (MyCh as MyEdit).Count := CurObj.Count;
  for i:=1 to CurObj.Count do
    (MyCh as MyEdit).Texts[i] := Curobj.Texts[i];

  (MyCh as TEdit).Text:=Mess[MainF.CurLang,68];
  MainF.ExitPanel.insertcontrol(MyCh);
end;
//############################################################
procedure   TInterpreter.InsertImage;
var  fname : string;
     path  : string;
     tmppath : PChar;
     len : word;
begin
   MainF.Bmp.Width:=CurObj.Width;           // ширина
   MainF.Bmp.Height:=CurObj.Height;         // высота
   MainF.Bmp.Top:=CurObj.AtY;              // позиция
   MainF.Bmp.Left:=CurObj.AtX;
   MainF.Bmp.Visible:=true;
//******************* local
   MainF.Bmp.Picture.Bitmap.LoadFromFile(CurObj.Texts[1]);
//*******************
{  fname:=inttostr(SRand(65535))+inttostr(SRand(999));
  GetTempPath(128,PChar(path));
  path:=path+fname+'.BMP';
  MainF.MediaTable.Open;
  if MainF.MediaTable.Locate('MNAME',CurObj.Texts[1],[locaseInsensitive]) then begin
     if FileExists(path) then DeleteFile(PChar(path));
       (MainF.MediaTable.FieldByName('FILM') as TBlobField).SaveToFile(path);
     MainF.Bmp.Picture.Bitmap.LoadFromFile(path);
     MainF.MediaTable.Close;
     TmpBMP:=path;
  end;
}
end;
//#############################################################
procedure  TInterpreter.InsertSound;
var  fname : string;
     path  : string;
     find : boolean;
begin
//********************  local
  MainF.MP.Tag:=ButtonP;
  MainF.SoundB.Visible:=true;
  MainF.SoundB.Caption:='Воспроизвести ['+inttostr(MainF.MP.Tag)+']';
  MainF.MP.FileName:=CurObj.Texts[1];
//********************
{  fname:=inttostr(SRand(65535))+inttostr(SRand(999));
  GetTempPath(128,PChar(path));
  path:=path+fname;
  find:=false;
  MainF.MediaTable.Open;
try
  if MainF.MediaTable.Locate('MNAME',CurObj.Texts[1],[locaseInsensitive])
  then find:=true;
  if find then begin
    MainF.MP.Tag:=ButtonP;
    MainF.SoundB.Enabled:=true;
    MainF.SoundB.Visible:=true;
    MainF.SoundB.Caption:=Mess[MainF.CurLang,32]+' ['+inttostr(MainF.MP.Tag)+']';
   if uppercase(MainF.MediaTable.FieldByName('SM').AsString)='M' then begin
       if FileExists(path+'.AVI') then DeleteFile(PChar(path+'.AVI'));
      (MainF.MediaTable.FieldByName('FILM') as TBlobField).SaveToFile(PChar(path+'.AVI'));
      MainF.MP.FileName:=path+'.AVI';
      TmpAVI:=MainF.MP.FileName;
   end else begin
       if FileExists(path+'.WAV') then DeleteFile(PChar(path+'.WAV'));
      (MainF.MediaTable.FieldByName('FILM') as TBlobField).SaveToFile(PChar(path+'.WAV'));
      MainF.MP.FileName:=path+'.WAV';
      TmpWAV:=MainF.MP.FileName;
   end;
   MainF.MediaTable.Close;
   end;
except on EDatabaseError do begin
   MessageDlg('MCI Error.'+#13#10+Mess[MainF.CurLang,37],mtError,[mbOk],0);
   MainF.SoundB.Visible:=false;
  end;
end;//try
}
end;
//#############################################################
procedure  TInterpreter.InsertOrder;
var tmp : word;
    tmp1: word;
    i   : word;
begin
  MyWinCh.Width:=CurObj.Width;           // ширина
  MyWinCh.Height:=CurObj.Height;         // высота
  MyWinCh.Top:=CurObj.AtY;              // позиция
  MyWinCh.Left:=CurObj.AtX;
  (MyWinCh as TmvRadioGroup).Caption:=' '+Mess[MainF.CurLang,44]+' ';
  if RandomChoiceP then RandomCh_Order(CurObj);

  for i:=1 to CurObj.CountRight do begin
       (MyWinCh as MyOrder).WhatSel[i]:=i;
       (MyWinCh as MyOrder).WhatRight[i]:=CurObj.WhatRight[i];
  end;
  (MyWinCh as MyOrder).Count:=CurObj.CountRight;

  MyWinCh.Visible:=false;
  MainF.ExitPanel.insertcontrol(MyWinCh);
  { List }
  tmp1:=MyWinCh.ClientHeight div 20;
  MyWinCh.Controls[0].Height:=15*tmp1;
  MyWinCh.Controls[0].Top:=2*tmp1;
  tmp:=MyWinCh.ClientWidth div 20;
  MyWinCh.Controls[0].Width:=18*tmp;
  MyWinCh.Controls[0].Left:=tmp;
  { Insert Texts}
  for i:=1 to CurObj.Count do
      (MyWinCh.Controls[0] as TListBox).
      Items.Add(CurObj.Texts[i]);
  { Button }
  (MyWinCh.Controls[1] as TBitBtn).Caption:=Mess[MainF.CurLang,45];
  MyWinCh.Controls[1].Width:=18*tmp;
  MyWinCh.Controls[1].Left:=tmp;
  MyWinCh.Controls[1].Height:=3*tmp1;
  MyWinCh.Controls[1].Top:=17*tmp1;
  MyWinCh.Visible:=true;
end;
//#############################################################
function  TInterpreter.ChoiceEstimate(Ch : MyChoice) : real;
begin
  if Ch.WhatRight = (Ch as TmvRadioGroup).ItemIndex+1 then  ChoiceEstimate:=WeightP
  else ChoiceEstimate:=0.0;
end;
//#############################################################
function  TInterpreter.SoftChoiceEstimate(Ch : MySoftChoice) : real;
begin
  SoftChoiceEstimate:=WeightP*Ch.weights[(Ch as TmvRadioGroup).ItemIndex+1];
end;
//#############################################################
function  TInterpreter.MultiChoiceEstimate(Ch : MyMultiChoice) : real;
var i : word;
    diff : boolean;
begin
  diff := false;
  for i:=1 to Ch.Count do
    if Ch.Right[i] <> Ch.Checked[i-1] then diff := true;
  if not diff then MultiChoiceEstimate:=WeightP
              else MultiChoiceEstimate:=0.0;
end;
//#############################################################
function  TInterpreter.AddChoiceEstimate(Ch : MyAddChoice) : real;
var i : word;
    Mark : real;
begin
  Mark := 0.0;
  for i:=1 to Ch.Count do
    if Ch.Checked[i-1]  then  Mark := Mark + Ch.Weights[i];
  AddChoiceEstimate:=WeightP * Mark;
end;
//#############################################################
function  TInterpreter.ListEstimate(Ch : MyList) : real;
begin
  if Ch.WhatRight = (Ch as TListBox).ItemIndex+1 then  ListEstimate:=WeightP
  else ListEstimate:=0.0;
end;
//#############################################################
function  TInterpreter.OrChoiceEstimate(Ch : MyOrChoice) : real;
var i : word;
begin
  if Ch.Right[(Ch as TmvRadioGroup).ItemIndex+1] then
     OrChoiceEstimate:=WeightP else OrChoiceEstimate:=0.0;
end;
//#############################################################
function  TInterpreter.EditEstimate(Ch : MyEdit) : real;
{ удаление начальных и конечных пробелов }
function SpaceKill(str : string) : string;
var tmp   : integer;
    i     :integer;
    tmpstr:string;
begin
   i := 1;
   for tmp:=1 to length(str) do
     if ord(str[tmp])<=32 then inc(i) else break;
   tmpstr:=copy(str,i,length(str)-i+1);
   for i:=length(tmpstr) downto 1 do
     if ord(tmpstr[i])>32 then break;
   SpaceKill:=copy(tmpstr,1,i);
end;
var i : word;
    quess : boolean;
    str : string;
begin
   str := SpaceKill((Ch as TEdit).Text);
   for i:=1 to Ch.Count do
     if str = SpaceKill((Ch as MyEdit).texts[i]) then begin
        quess := true;
        break;
     end;
   if quess then EditEstimate := WeightP else EditEstimate := 0.0;
end;
//#############################################################
function  TInterpreter.OrderEstimate(Ch : MyOrder) : real;
var i : byte;
    ok : boolean;
begin
  ok := true;
  for i:=1 to Ch.Count do if Ch.WhatRight[i]<>Ch.WhatSel[i] then ok:=false;
  if ok then OrderEstimate:=WeightP;
end;
//#############################################################
procedure   TInterpreter.SetError(code:integer);
begin
      ErrCond:=true;
      ErrorCode:=code;
end;
//#############################################################
procedure  TInterpreter.GoQuestion(NumQuest:integer);
begin
  CurPointer:=Offset[NumQuest].Offset;
//  DecimalSeparator:='.';
  QuestionSD;
end;
//#############################################################
function  TInterpreter.FindId(id : string) : boolean;
var i : word;
begin
  for i:=1 to  CountId do
    if Identity[i].Image=id then begin
      FindID:=true;
      exit;
    end;
  FindId:=false;
end;
//#############################################################
function  TInterpreter.GetIdFromTable(id : string) : TIdent;
var i : word;
begin
  for i:=1 to CountId do
    if Identity[i].Image=id then begin
      GetIdFromTable:=Identity[i];
      exit;
    end;
end;
//#############################################################
procedure TInterpreter.AddIdToTable(id : TIdent);
begin
  inc(CountID);
  Identity[CountId]:=id;
end;
//#############################################################
procedure TInterpreter.ChangeValueId(idname : string; id : TValue);
var i : word;
begin
  for i:=1 to CountId do
    if Identity[i].Image=idname then begin
      Identity[i].Value:=id.Value;
      Identity[i].TypeId:=id.Who;
      exit;
    end;
end;
//#############################################################
procedure TInterpreter.FixResult;
var i : word;
procedure Sort;
var b, i, t : word;
    tmp : TOffset;
begin
  { сортировка }
  b:=KolQuest;
  while (b<>0) do begin
    t:=0;
    for i:=1 to b-1 do
      if Offset[i].number>Offset[i+1].number then begin
         tmp := Offset[i];
         Offset[i] := Offset[i+1];
         Offset[i+1] := tmp;
         t := i;
      end;
    b := t;
  end;
end;

begin
     MainF.TextQuest.Lines.Add(Mess[MainF.CurLang,46]+' '+ floattostrf(Mark,ffGeneral,4,4));
    { если диагноз не выставляется }
    if (CountBail=0) and (BailOutP=0) then else
    if CountBail = 0 then    { если зачет/незачет}
       if  Mark >= BailOutP then
            MainF.TextQuest.Lines.Add(Mess[MainF.CurLang,47])
       else MainF.TextQuest.Lines.Add(Mess[MainF.CurLang,48])
    // если градация
    else  begin
       if Mark < BailP[1].value then
            MainF.TextQuest.Lines.Add(Mess[MainF.CurLang,49])
       else
       if Mark >= BailP[CountBail].value then
            MainF.TextQuest.Lines.Add(Mess[MainF.CurLang,50]+' : '+ BailP[CountBail].text)
       else
       for i:=1 to CountBail do
         if Mark < BailP[i].value then begin
            MainF.TextQuest.Lines.Add(Mess[MainF.CurLang,50]+' : '+ BailP[i].text);
            break;
         end;
    end;
    { запись в базу протокола }
    if ProtocolP and RegistrationP then begin
       MainF.ProtocolTable.Active:=true;
       if not RandomP then
          for i:=1 to KolQuest do begin
            MainF.ProtocolTable.Insert;
            MainF.ProtocolTable.FieldByName('unique_key').
            AsString:=inttostr(MainF.Session.Unique_Key);
            MainF.ProtocolTable.FieldByName('question').AsInteger:=QuestProt[i].Quest;
            if QuestProt[i].Time<>-1 then
              MainF.ProtocolTable.FieldByName('Time').AsInteger:=QuestProt[i].Time;
            try
              MainF.ProtocolTable.FieldByName('answer').AsFloat:=QuestProt[i].Mark;
            except on EDatabaseError do
              MainF.ProtocolTable.FieldByName('answer').AsFloat:=0.0;
            end;
            MainF.ProtocolTable.Post;
          end
        // если Random : on
        else begin
           Sort;
           for i:=1 to KolQuest do begin
             MainF.ProtocolTable.Insert;
             MainF.ProtocolTable.FieldByName('unique_key').
             AsString:=inttostr(MainF.Session.Unique_Key);
             MainF.ProtocolTable.FieldByName('question').AsInteger:=QuestProt[i].Quest;
             if QuestProt[i].Time<>-1 then
                MainF.ProtocolTable.FieldByName('Time').AsInteger:=QuestProt[i].Time;
             try
               MainF.ProtocolTable.FieldByName('answer').AsFloat:=QuestProt[i].Mark;
             except on EDatabaseError do
               MainF.ProtocolTable.FieldByName('answer').AsFloat:=0.0;
             end;
             MainF.ProtocolTable.Post;
           end
        end;
       MainF.ProtocolTable.Active:=false;
    end;

    if  RegistrationP then begin
       MainF.WorkTable.Active:=true;
       if MainF.WorkTable.locate('Unique_Key',MainF.Session.Unique_Key,[]) then begin
          MainF.WorkTable.Edit;
          MainF.WorkTable.FieldByName('DateOut').AsString:=DateTostr(date);
          MainF.WorkTable.FieldByName('TimeOut').AsString:=TimeTostr(Time);
          try
             MainF.WorkTable.FieldByName('TestMark').AsFloat:=Mark;
          except on EDatabaseError do
             MainF.WorkTable.FieldByName('TestMark').AsFloat:=0.0;
          end;
          MainF.WorkTable.FieldByName('Amnt_Quest').AsInteger:=KolQuest;
          MainF.WorkTable.FieldByName('Max_Value').AsFloat:=MaxMark;
       end;
       MainF.WorkTable.Post;
       MainF.WorkTable.Active:=false;
    end;
end;
//#################################################################
function TInterpreter.Analyze : integer;
var tmp : integer;
    SaveDecimalSep : char;
    tmpstr:string;
    i   : integer;
    TmpOff :  array [1..AMOUNT_QUESTION] of TOffset;
    Deal : boolean;


begin
    CurQuestion:=0;
    Mark:=0.0;
    First:=0;
    FlagIn:=true;
    JumpTo:=false;
    SaveDecimalSep:=DecimalSeparator;
    DecimalSeparator:='.';
    ErrCond :=false;
    CurrentLine:=1;

    CurPointer :=1;
    TextSize:=length(Text);
    { разбор параметров теста }
    TitleSD;

    if not ErrCond then begin
         MainF.TextQuest.Lines.Add(' '+Mess[MainF.CurLang,38]+':');
         MainF.TextQuest.Lines.Add(' '+Mess[MainF.CurLang,39]+': '+TestnameP);
         MainF.TextQuest.Lines.Add(' '+Mess[MainF.CurLang,40]+': '+DifficultyP);
         MainF.TextQuest.Lines.Add(' '+Mess[MainF.CurLang,41]+': '+inttostr(KolQuest));
         MainF.TextQuest.Lines.Add(' '+Mess[MainF.CurLang,42]+': '+inttostr(FulltimeP));
    end;

    Suspend;
//****************************************
// обработка  RANDOM : ON
//****************************************
    if RandomP then begin
        for i:=1 to KolQuest do Offset[i].busy:=false;
        Randomize;
        for i:=1 to KolQuest do begin
          Deal:=false;
          while not Deal do begin
             tmp:=SRand(KolQuest)+1;
             if not Offset[tmp].Busy then begin
                  TmpOff[i] := Offset[tmp];
                  Offset[tmp].Busy:=true;
                  Deal:=true;
             end;  // if
          end;  // while
        end; // for
        for i:=1 to KolQuest do Offset[i]:=TmpOff[i];
    end;

    if not ErrCond then  TestSD;

//****************************************
    if LocalTimeP<>0 then begin
       QuestProt[QuestionP].Time:=
       MainF.QuestTime.Max - MainF.QuestTime.Position;
    end;
    MainF.AllTimer.Enabled:=false;
    MainF.QuestTimer.Enabled:=false;
    MainF.SB.Panels[1].Text:='';
    MainF.SB.Panels[2].Text:='';
    MainF.SoundB.Visible:=false;
    MainF.ForwardB.Enabled:=false;
    MainF.OpenTest.Enabled:=true;
    MainF.BreakTest.Enabled:=false;
    MainF.N5.Enabled:=true;
    MainF.N6.Enabled:=false;
    MainF.TextQuest.Lines.Clear;
    MainF.QuestTime.Position:=0;
    MainF.AllTime.Position:=0;
//****************************************
    { Итог теста}

    FixResult;

    MainF.OpenTest.Enabled:=true;
    MainF.YetB.Enabled:=true;
    MainF.N5.Enabled:=true;
    MainF.BreakTest.Enabled:=false;
    MainF.N6.Enabled:=false;

    DecimalSeparator:=SaveDecimalSep;
end;
//#############################################################
procedure TInterpreter.SS_SD;
var tmp : integer;
begin
  SavePointer;
  tmp:=TextScaner;
  repeat
  RestorePointer;
  case tmp of
    _GOTO : begin
       tmp:=TextScaner;
       tmp:=TextScaner;
       if(tmp<>INUM) then begin
          seterror(7);
          exit;
       end;
       FlagIn:=false;
       CurQuestion:=strtoint(lexem);
       JumpTo:=true;
    end;
    _IF:   begin
       S_SD;
       if ErrCond then exit;
       if JumpTo then FlagIn:=false
       else  FlagIn:=true;
    end;
    ANY: begin
       LetSD;
       if ErrCond then exit;
       FlagIn:=true;
    end;
  end;
  tmp:=TextScaner;
  if(tmp<>SEMIC) then begin
     seterror(3);
     exit;
  end;
  SavePointer;
  tmp:=TextScaner;
  until not(tmp in [_GOTO,ANY,_IF]);
  RestorePointer;
end;
//#############################################################
procedure TInterpreter.S_SD;
var tmp  : integer;
    cond : boolean;
begin
   cond:=true;
   tmp:=TextScaner;  // IF
   cond:=ConditionSD;
   if ErrCond then exit;
   tmp:=TextScaner;
   if(tmp<>_THEN) then begin
      seterror(28);
      exit;
   end;
   // если условие не выполн. и флаг интерп. true
   if not cond and FlagIn then FlagIn:=false;
   BodySD;
   if ErrCond then exit;
end;
//#############################################################
procedure TInterpreter.BodySD;
var tmp:integer;
begin
  SavePointer;
  tmp:=TextScaner;
  if(tmp=_IF) then  begin
      RestorePointer;
      S_SD;
      if ErrCond then exit;
  end else
  if(tmp=_GOTO) then begin
      tmp:=TextScaner;
      if(tmp<>INUM) then begin
         seterror(7);
         exit;
      end;
      if FlagIn then begin
        CurQuestion:=strtoint(lexem);
        JumpTo:=true;
        FlagIn:=false;
      end;
  end else
  if(tmp<>ANY) then begin
     seterror(11);
     exit;
  end else
  begin
     RestorePointer;
     LetSD;
     if ErrCond then exit;
  end;
end;
//#############################################################
function TInterpreter.ElementExpSD : TValue;
var tmp : integer;
    val : TValue;
    id  : TIdent;
begin
   tmp:=TextScaner;
   case tmp of
     INUM : begin
        val.Who:=1;
        val.Value:=strtoint(lexem);
     end;
     FNUM : begin
        val.Who:=2;
        val.Value:=strtofloat(lexem);
     end;
     ANY  : begin
        if FlagIn  then
        if FindId(lexem) then begin
          id:=GetIdFromTable(lexem);
          val.Who:=id.TypeId;
          val.Value:=id.Value;
        end else begin
          val.Who:=1;
          val.Value:=0;
        end;
     end;
     LBRACE: begin
         val:=ExpressionSD;
         if ErrCond then exit;
         tmp:=TextScaner;
         if(tmp<>RBRACE) then begin
            seterror(32);
            exit;
         end;
     end;
     else  begin
         seterror(33);
         exit;
     end;
   end;
   ElementExpSD:=val;
end;
//#############################################################
function TInterpreter.ExpressionSD : TValue;
var tmp :integer;
    val1:TValue;
    val2:TValue;
begin
   val1:=AdditionSD;
   if ErrCond then exit;
   SavePointer;
   tmp:=TextScaner;
   while tmp in [PLUS,MINUS] do begin
      val2:=AdditionSD;
      if ErrCond then exit;

      if FlagIn then
      if(tmp=PLUS) then begin
         if(val1.Who=2)or(val2.Who=2) then  val1.Who:=2
                                      else  val1.Who:=1;
         val1.Value:=val1.Value+val2.Value;
      end else
      begin
         if(val1.Who=2)or(val2.Who=2) then  val1.Who:=2
                                      else  val1.Who:=1;
         val1.Value:=val1.Value-val2.Value;
      end;
      SavePointer;
      tmp:=TextScaner;
   end;
   RestorePointer;
   ExpressionSD:=val1;
end;
//#############################################################
function TInterpreter.ConditionSD : boolean;
var tmp  : integer;
    oper : integer;
    val1 : TValue;
    val2 : TValue;
begin
  val1:=ExpressionSD;
  if ErrCond then exit;
  tmp:=TextScaner;
  if not (tmp in [G..NEQ]) then begin
     seterror(31);
     exit;
  end;
  oper:=tmp;
  val2:=ExpressionSD;
  if ErrCond then exit;

  if FlagIn then
  case oper of
   G:    if val1.Value > val2.Value then
         ConditionSD:=true else ConditionSD:=false;
   LESS: if val1.Value < val2.Value then
         ConditionSD:=true else ConditionSD:=false;
   EQ:   if val1.Value = val2.Value then
         ConditionSD:=true else ConditionSD:=false;
   GE:   if val1.Value >= val2.Value then
         ConditionSD:=true else ConditionSD:=false;
   LE:   if val1.Value <= val2.Value then
         ConditionSD:=true else ConditionSD:=false;
   NEQ:  if val1.Value <> val2.Value then
         ConditionSD:=true else ConditionSD:=false;
  end;
end;
//#############################################################
function TInterpreter.AdditionSD : TValue;
var tmp  : integer;
    val1 : TValue;
    val2 : TValue;
begin
   val1:=ElementExpSD;
   if ErrCond then exit;
   SavePointer;
   tmp:=TextScaner;
   while tmp in [DIVIDE,MULT] do begin
      val2:=ElementExpSD;
      if ErrCond then exit;

      if FlagIn then
      case tmp of
       DIVIDE : begin
          val1.Who:=2;
          val1.Value:=val1.Value / val2.Value;
       end;
       MULT   : begin
          if(val1.Who=2)or(val2.Who=2) then  val1.Who:=2
                                       else  val1.Who:=1;
          val1.Value:=val1.Value * val2.Value;
       end;
      end;

      SavePointer;
      tmp:=TextScaner;
   end;
   RestorePointer;
   AdditionSD:=val1;
end;
//#############################################################
procedure TInterpreter.LetSD;
var tmp    : integer;
    idname : string;
    val    : TValue;
    id     : TIdent;
begin
  tmp:=TextScaner;
  if(tmp<>ANY) then begin
     seterror(11);
     exit;
  end;
  idname:=lexem;
  tmp:=TextScaner;
  if(tmp<>LET) then begin
     seterror(30);
     exit;
  end;
  val:=ExpressionSD;
  if ErrCond then exit;

  if FlagIn then
  { если переменная не определена }
  if not FindId(idname) then begin
    id.TypeId:=val.Who;
    id.Image:=idname;
    id.Value:=val.Value;
    AddIdToTable(id);
  end
  { если переменная определена }
  else  ChangeValueId(idname , val);
end;
//#############################################################
procedure TInterpreter.TitleSD;
var tmp : integer;
begin
   tmp:=TextScaner;
   if (tmp<>TITLE)  then begin
      SetError(1);  // missing title ok
      exit;
   end;
   tmp:=TextScaner;
   if (tmp<>TWOP)then begin
      SetError(2); // missing : ok
      exit;
   end;
   SavePointer;
   tmp:=TextScaner;

   while (tmp in [TESTNAME..GRADATION]) do begin
     RestorePointer;
     TestParametrSD;
     if ErrCond then begin
       ErrCond:=true; exit;
     end;
     tmp:=TextScaner;
     if (tmp<>SEMIC)then begin
        SetError(3);
        exit;
     end;

     SavePointer;
     tmp:=TextScaner;
   end;
   if (tmp<>ENDTITLE) then begin
      SetError(4);  // missing endtitle  ok
      exit;
   end;
   tmp:=TextScaner;
   if (tmp<>ONEP) then begin
      SetError(5);   // missing . ok
      exit;
   end;
end;
//#############################################################
procedure TInterpreter.GradationSD;
var tmp   :integer;
      l   :integer;
    tmpstr:string;
begin
   CountBail:=0;
   tmp:=TextScaner;
   if(tmp<>TWOP) then begin
      SetError(2);
      exit;
   end;
   SavePointer;
   repeat
       inc(CountBail);
       tmpstr:='';
       RestorePointer;
       tmp:=TextScaner;
       if(tmp<>FNUM)and(tmp<>INUM) then begin
          SetError(10); // missing endgrad   ok
          exit;
       end;
       BailP[CountBail].value:=strtofloat(lexem);
       tmp:=TextScaner;
       if(tmp<>TWOP) then begin
          SetError(2);
          exit;
       end;
       // ANY
       while (tmp<>SEMIC) do begin
          tmp:=TextScaner;
          if (tmp=ENDGRAD)or(tmp=_FEOF) then begin
            seterror(3); exit;
          end;
          if tmp<>SEMIC then tmpstr:=tmpstr+' '+lexem;
       end;
       BailP[CountBail].text:=tmpstr;
       SavePointer;
       tmp:=TextScaner;
   until (tmp=ENDGRAD);
end;
//#############################################################
procedure TInterpreter.TestParametrSD ;
var tmp : integer;
    l   : integer;
    par : integer;
    val : boolean;
    tmpstr:string;
    off : word;
begin
   val:=false;
   tmpstr:='';
   SavePointer;
   tmp:=TextScaner;
   if tmp=GRADATION then begin
      GradationSD;
      if ErrCond then exit;
   end
   else
//################################################
   if tmp in [REGISTRATION..RANDOM] then begin
      par:=tmp;
      tmp:=TextScaner;
      if(tmp<>TWOP) then begin
         SetError(2); //missing  :  ok
         exit;
      end;
      tmp:=TextScaner;
      if not(tmp in [_ON,_OFF]) then begin
         SetError(8);  // missing ON ok
         exit;
      end else
      if tmp=_ON then val:=true else val:=false;
      case  par of
         REGISTRATION :  RegistrationP:=val;
         PROTOCOL:       ProtocolP:=val;
         INTERVAL:       IntervalP:=val;
         RANDOMCHOICE:   RandomChoiceP:=val;
         RANDOM:         RandomP:=val;
      end;
   end
   else
//################################################
   if tmp in [TESTNAME,DIFFICULTY] then begin
      par:=tmp;
      tmp:=TextScaner;
      if(tmp<>TWOP) then begin
         SetError(2);  // missing : ok
         exit;
      end;
      off := CurPointer;
      tmp:=TextScaner;
      while (tmp<>SEMIC) do begin
         SavePointer;
         tmp:=TextScaner;
         if(tmp = _FEOF) then begin
            seterror(3); exit;
         end;
      end;
      RestorePointer;
      tmpstr:=copy(Text,off,CurPointer-off);
      tmp:=TextScaner;
      case par of
        TESTNAME:  TestNameP:=tmpstr;
        DIFFICULTY:DifficultyP:=tmpstr;
      end;
      RestorePointer;
//################################################
   end
   else
   if tmp in [QUESTIONS,FULLTIME] then  begin
       par:=tmp;
       tmp:=TextScaner;
       if(tmp<>TWOP) then begin
          SetError(2);
          exit;
       end;
       tmp:=TextScaner;
       if(tmp<>INUM) then begin
          SetError(7);
          exit;
       end;
       case par of
       QUESTIONS: QuestionsP:=strtoint(lexem);
       FULLTIME:  FullTimeP:=strtoint(lexem);
       end;
   end
   else
//################################################
   if tmp = BAILOUT  then begin
       tmp:=TextScaner;
       if(tmp<>TWOP) then begin
          SetError(2);
          exit;
       end;
       tmp:=TextScaner;
       if(tmp<>FNUM)and(tmp<>INUM) then begin
          SetError(6);  // missing number   ok
          exit;
       end;
       BailOutP:=strtofloat(lexem);
   end
   else
//################################################
   begin
      SetError(11);
      exit;
   end;
end;
//#############################################################
procedure TInterpreter.TestSD;
//const  CurQuest : word = 0;
var tmp:integer;
begin
   if RandomP then CurQuest:=0;
   tmp:=TextScaner;
   if(tmp<>STARTTEST) then begin
      SetError(12);
      exit;
   end;
   tmp:=TextScaner;
   if(tmp<>TWOP) then begin
      SetError(2);
      exit;
   end;
//   GoQuestion(1);

//   if ErrCond then exit;

   SavePointer;
   tmp:=TextScaner;
   while(tmp in [MAINHEIGHT..BEGINTEXT]) do begin
      RestorePointer;
      if JumpTo then begin
         JumpTo:=false;
         GoQuestion(CurQuestion);
      end
      else
        if not RandomP then GoQuestion(QuestionP+1)
        else begin
          CurQuest:=CurQuest+1;
          GoQuestion(CurQuest);
        end;

      if ErrCond then exit;
      if RandomP then begin
         CurPointer:=Offset[CurQuest].Offset;
      end;
      SavePointer;
      tmp:=TextScaner;
   end;  // while
   if(tmp<>ENDTEST) then begin
      SetError(13);
      exit;
   end;
   tmp:=TextScaner;
   if(tmp<>ONEP) then begin
      SetError(5);
      exit;
   end;
end;
//#############################################################
procedure TInterpreter.FreeMemory;
var j : integer;
begin
  for j:=MainF.ExitPanel.ControlCount downto 1 do
     if not (MainF.ExitPanel.Controls[j-1] is TImage) then
        MainF.ExitPanel.Controls[j-1].free
     else  MainF.ExitPanel.Controls[j-1].Visible:=false;
end;
//#############################################################
procedure TInterpreter.HideControls;
var j : integer;
begin
  for j:=MainF.ExitPanel.ControlCount downto 1 do
     MainF.ExitPanel.Controls[j-1].Visible:=false;
end;
//#############################################################
procedure  TInterpreter.Redrawing;
begin
      MainF.QuestTime.Brush.Color:=clBtnFace;
end;
//#############################################################
procedure TInterpreter.QuestionSD;
const MH : word = 0;
      MW : word = 0;
//      first : word = 0;
var tmp:integer;
    s : string;
    i : word;
    QuestMark : real;
    Scr : TScreen;
{ Удаление начальных и конечных пробелов }
procedure  SpaceKill(var str : string);
var tmp   : integer;
    i     :integer;
begin
   i := 1;
   for tmp:=1 to length(str) do
     if ord(str[tmp])<=32 then inc(i) else break;
   str:=copy(str,i,length(str)-i+1);
end;

begin
   Scr:=TScreen.Create(Nil);
   QuestParSD;
   { параметры вопросa }
   if MH <> MainHeightP then begin
       if Scr.Height < MainHeightP then begin
          MH:=Scr.Height;
          MainF.Height:=MH;
          MainF.Top:=0;
       end
       else begin
          MainF.Height:=MainHeightP;
          MH:=MainHeightP;
          MainF.Top:=(Scr.Height-MainF.Height) div 2;
       end
   end;
   if MW <> MainWidthP then begin
      if Scr.Width < MainWidthP then begin
          MH:=Scr.Width;
          MainF.Width:=MH;
          MainF.Left:=0;
       end
       else begin
          MainF.Width:=MainWidthP;
          MH:=MainWidthP;
          MainF.Left:=(Scr.Width-MainF.Width) div 2;
       end
   end;
   Scr.Free;
   MainF.TextQuest.Clear;
   if not RandomP then
   MainF.TextQuest.Lines.Add('  '+Mess[MainF.CurLang,67]+': '+inttostr(QuestionP)+#13#10##32#32)
   else
   MainF.TextQuest.Lines.Add('  '+Mess[MainF.CurLang,67]+': '+inttostr(CurQuest)+#13#10##32#32);
   MainF.TextQuest.Lines.Add(TextP);

   SavePointer;
   tmp:=TextScaner;
   repeat
     RestorePointer;

     if not(tmp in [CHOICE,MULTICHOICE,ADDCHOICE,
       ORCHOICE,_LABEL,ORDER,SOUND,SOFTCHOICE,
       LIST,EDIT,IMAGE,ASK,SCALE]) then begin
         seterror(14);
         exit;
     end;

     CurObj.who:=0;

     ObjectSD;
     if ErrCond   then exit;
     case CurObj.who of
       CHOICE : begin  // testing
           MyCh := MyChoice.Create(MainF.ExitPanel);
           MyCh.visible:=true;
           Synchronize(InsertChoice);
       end;
       MULTICHOICE : begin  // testing
           MyCh := MyMultiChoice.Create(MainF.ExitPanel);
           MyCh.visible:=true;
           Synchronize(InsertMultiChoice);
       end;
       SOFTCHOICE: begin    // testing
           MyCh := MySoftChoice.Create(MainF.ExitPanel);
           MyCh.visible:=true;
           Synchronize(InsertSoftChoice);
       end;
       ADDCHOICE:  begin  // testing
           MyCh := MyAddChoice.Create(MainF.ExitPanel);
           MyCh.visible:=true;
           Synchronize(InsertAddChoice);
       end;
       ORCHOICE:   begin   // testing
           MyCh := MyOrChoice.Create(MainF.ExitPanel);
           MyCh.visible:=true;
           Synchronize(InsertOrChoice);
       end;
       SCALE : begin       // testing
           MyCh:=MyScale.Create(MainF.ExitPanel);
           MyCh.visible:=true;
           Synchronize(InsertScale);
       end;
       LIST : begin       // testing
           MyCh:=MyList.Create(MainF.ExitPanel);
           MyCh.visible:=true;
           Synchronize(InsertList);
       end;
       EDIT : begin      // testing
           MyCh:=MyEdit.Create(MainF.ExitPanel);
           MyCh.visible:=true;
           Synchronize(InsertEdit);
       end;
       IMAGE : begin      // testing
           { удаление начальных и конечных пробелов}
           SpaceKill(CurObj.Texts[1]);
//           if FileExists(CurObj.Texts[1]) then   // local
              Synchronize(InsertImage);
       end;
       SOUND : begin      // testing
           { удаление начальных и конечных пробелов}
           SpaceKill(CurObj.Texts[1]);
//           if FileExists(CurObj.Texts[1]) then     // local
              Synchronize(InsertSound);
       end;
       _LABEL : begin
           MyCh:=TLabel.Create(MainF.ExitPanel);
           MyCh.visible:=true;
           SpaceKill(CurObj.Texts[1]);
           Synchronize(InsertLabel);
       end;
       ORDER : begin
            MyWinCh:=MyOrder.Create(MainF.ExitPanel);
            MyWinCh.Visible:=true;
            Synchronize(InsertOrder);
       end;
     end;

     SavePointer;
     tmp:=TextScaner;

   until (tmp=ASK);
//###############################################################
//                          TIME
//###############################################################
   if first = 0 then  begin
      first := 1;
      if FullTimeP <> 0 then begin
         MainF.AllTime.Max:=FullTimeP;
         MainF.AllTime.Min:=0;
         MainF.AllTime.Step:=1;
         MainF.AllTime.Position:=FullTimeP;
         MainF.AllTimer.Enabled:=true;
      end;
   end;
   { Время пошло }
   // если local врем. параметр не установлены
   if (LocalTimeP=0) then begin
      QuestProt[QuestionP].Time:=-1;
      MainF.QuestTimer.Enabled:=false;
   end else
   // если local вр. парам. установл.
   if (LocalTimeP <> 0) then begin
      if QuestionP <> 1 then begin
         QuestProt[QuestionP-1].Time:=
         MainF.QuestTime.Max - MainF.QuestTime.Position;
      end;
      MainF.QuestTime.Max:=LocalTimeP;
      MainF.QuestTime.Min:=0;
      MainF.QuestTime.Step:=1;
      MainF.QuestTime.Position:=LocalTimeP;

      MainF.QuestTimer.Enabled:=true
   end;

   Suspend;

   QuestMark:=0;
   for i:=MainF.ExitPanel.ControlCount downto 1 do begin
      { MyChoice }
      if MainF.ExitPanel.Controls[i-1] is MyChoice then
         QuestMark:=QuestMark+ChoiceEstimate(MainF.ExitPanel.Controls[i-1] as MyChoice)
      else
      { MySoftChoice }
      if MainF.ExitPanel.Controls[i-1] is MySoftChoice then
         QuestMark:=QuestMark+SoftChoiceEstimate(MainF.ExitPanel.Controls[i-1]
         as MySoftChoice)
      { MyMultiChoice }
      else
      if MainF.ExitPanel.Controls[i-1] is MyMultiChoice then
         QuestMark:=QuestMark+MultiChoiceEstimate(MainF.ExitPanel.Controls[i-1]
         as MyMultiChoice)
      else
      { MyAddChoice }
      if MainF.ExitPanel.Controls[i-1] is MyAddChoice then
         QuestMark:=QuestMark+AddChoiceEstimate(MainF.ExitPanel.Controls[i-1]
         as MyAddChoice)
      else
      { MyList }
      if MainF.ExitPanel.Controls[i-1] is MyList then
         QuestMark:=QuestMark+ListEstimate(MainF.ExitPanel.Controls[i-1]
         as MyList)
      else
      { OrChoice }
      if MainF.ExitPanel.Controls[i-1] is MyOrChoice then
         QuestMark:=QuestMark+OrChoiceEstimate(MainF.ExitPanel.Controls[i-1]
         as MyOrChoice)
      else
      { Edit }
      if MainF.ExitPanel.Controls[i-1] is MyEdit then
         QuestMark:=QuestMark+EditEstimate(MainF.ExitPanel.Controls[i-1]
         as MyEdit)
      else
      { Order }
      if MainF.ExitPanel.Controls[i-1] is MyOrder then
         QuestMark:=QuestMark+OrderEstimate(MainF.ExitPanel.Controls[i-1]
         as MyOrder);
   end;  //for
   Mark:=Mark + QuestMark;
   Identity[QuestionP].value:=QuestMark;
//************************************  delete mediafiles
//   if FileExists(TmpBMP) then DeleteFile(PChar(TmpBMP));
//   if FileExists(TmpAVI) then DeleteFile(PChar(TmpAVI));
//   if FileExists(TmpWAV) then DeleteFile(PChar(TmpWAV));
//************************************
    { если ведется протокол теста }
    if ProtocolP and RegistrationP then begin
       QuestProt[QuestionP].Quest:=QuestionP;
       QuestProt[QuestionP].Mark:=QuestMark;
    end;
   { Освободили память }
   Synchronize(FreeMemory);

   tmp:=TextScaner;
   if(tmp<>SEMIC) then begin
      SetError(3);
      exit;
   end;
   SavePointer;
   tmp:=TextScaner;
   RestorePointer;
   if tmp in [_GOTO,_IF,ANY] then SS_SD;

end;
//#############################################################
procedure TInterpreter.ObjectSD;
var tmp:integer;
begin
   SavePointer;
   tmp:=TextScaner;
   RestorePointer;
   case  tmp of
     CHOICE:      ChoiceSD;
     MULTICHOICE: MultiChoiceSD;
     SOFTCHOICE:  SoftChoiceSD;
     ADDCHOICE:   AddChoiceSD;
     ORCHOICE:    OrChoiceSD;
     SCALE:       ScaleSD;
     _LABEL:      LabelSD;
     LIST:        ListSD;
     EDIT:        EditSD;
     ORDER:       OrderSD;
     SOUND:       SoundSD;
     IMAGE:       ImageSD;
     else   begin
        seterror(11); // missing ASK;
        exit;
     end;
   end;
   if ErrCond then exit;
   tmp:=TextScaner;
   if(tmp<>SEMIC) then begin
      SetError(3);
      exit;
   end;
end;
//#############################################################
procedure TInterpreter.QuestParSD    ;
var tmp:integer;
    par:integer;
    quest : boolean;
    tmpstr: string;
begin
    quest:=false;
    tmp:=TextScaner;
    if not(tmp in [MAINHEIGHT..BEGINTEXT]) then begin
       SetError(14); // missing question
       exit;
    end;
    while (tmp in [MAINHEIGHT..BEGINTEXT]) do begin
       case tmp of
          MAINHEIGHT,MAINWIDTH,QUESTION,
          LOCALTIME:  begin
                par:=tmp;
                if tmp=QUESTION then quest:=true; // find QUESTION
                tmp:=TextScaner;
                if(tmp<>TWOP) then begin
                   SetError(2);  //missing ;
                   exit;
                end;
                tmp:=TextScaner;
                if(tmp<>INUM) then begin
                   SetError(7);    // missing inum
                   exit;
                end;
                case par of
                   MAINHEIGHT: MainHeightP:=strtoint(lexem);
                   MAINWIDTH:  MainWidthP :=strtoint(lexem);
                   QUESTION:   QuestionP  :=strtoint(lexem);
                   LOCALTIME:  LocalTimeP :=strtoint(lexem);
                end;
                tmp:=TextScaner;
                if(tmp<>SEMIC) then begin
                   SetError(3);
                   exit;
                end;
          end;
          WEIGHT: begin
                tmp:=TextScaner;
                if(tmp<>TWOP) then begin
                   SetError(2);
                   exit;
                end;
                tmp:=TextScaner;
                if not((tmp=FNUM)or(tmp=INUM)) then begin
                   SetError(6);
                   exit;
                end;
                WeightP:=strtofloat(lexem);
                tmp:=TextScaner;
                if(tmp<>SEMIC) then begin
                   SetError(3);
                   exit;
                end;
          end;
          BEGINTEXT: begin
                tmp:=TextScaner;
                if(tmp<>TWOP) then begin
                   SetError(2);
                   exit;
                end;

                par:=CurPointer;
                tmp:=TextScaner;
                while (tmp<>ENDTEXT)and(tmp<>_FEOF) do
                 begin
                   SavePointer;
                   tmp:=TextScaner;
                 end;
                if(tmp<>ENDTEXT) then begin
                   seterror(11);  // missing endtext
                   exit;
                end;
                RestorePointer;
                TextP:=Copy(Text,par,CurPointer-par);
                tmp:=TextScaner;
                tmp:=TextScaner;
                if(tmp<>SEMIC) then begin
                   SetError(3);
                   exit;
                end;
          end;
       end; //case
       SavePointer;
       tmp:=TextScaner;
       if not(tmp in [MAINHEIGHT..BEGINTEXT]) then RestorePointer;
    end;
    if not quest then begin
       seterror(35);   // missing question
       exit;
    end;
end;
//#############################################################
procedure TInterpreter.PositionSizeSD;
var tmp:integer;
    par:integer;
begin
    SavePointer;
    tmp:=TextScaner;
    par:=tmp;
    if tmp in [INUM,FNUM,ITEMS,POSITION,CAPTION,FONT,PATH] then begin
       RestorePointer;
       exit;
    end;

    repeat
      case  tmp of
         ATX,ATY,WIDTH,HEIGHT : begin
            tmp:=TextScaner;
            if(tmp<>TWOP) then begin
                seterror(2); exit;  //missing :
            end;
            tmp:=TextScaner;
            if(tmp<>INUM) then begin
                seterror(7); exit;  // missing INUM
            end;
            case par of
              ATX:   CurObj.AtX:=strtoint(lexem);
              ATY:   CurObj.AtY:=strtoint(lexem);
              WIDTH: CurObj.Width:=strtoint(lexem);
              HEIGHT:CurObj.Height:=strtoint(lexem);
            end;
            tmp:=TextScaner;
            if(tmp<>SEMIC) then begin
                seterror(3); exit;   // missing ;
            end;
         end;
         else begin
               seterror(25);  // misiing число ???
               exit;
         end;
      end;
      SavePointer;
      tmp:=TextScaner;
      par:=tmp;
    until tmp in [INUM,FNUM,ITEMS,POSITION,CAPTION,FONT,PATH];
    RestorePointer;
end;
//#############################################################
procedure TInterpreter.IntSelectSD;
var tmp:integer;
    tmpstr:string;
    off:integer;
begin
   CurObj.Count:=0;
   CurObj.CountRight:=0;
   repeat
      off:=0;
      inc(CurObj.Count);
      tmp:=TextScaner;
      if(tmp<>INUM) then begin
         SetError(7);
         exit;
      end;
      tmp:=TextScaner;
      if(tmp<>TWOP) then begin
         SetError(2);
         exit;
      end;
      off:=CurPointer;
      tmp:=TextScaner;
      while (tmp<>ENDCASE)and(tmp<>_FEOF) do begin
         SavePointer;
         tmp:=TextScaner;
      end;
      RestorePointer;
      CurObj.Texts[CurObj.Count]:=Copy(Text,off,CurPointer-off);
      tmp:=TextScaner;
      if(tmp<>ENDCASE) then begin
         seterror(16);  //missing endcase
         exit;
      end;
      tmp:=TextScaner;
      if(tmp<>SEMIC) then begin
         SetError(3);
         exit;
      end;
      SavePointer;
      tmp:=TextScaner;
      if(tmp=RIGHT)or(tmp=ENDEDIT) then begin
        RestorePointer;
        exit;
      end
      else
      if(tmp<>INUM) then begin
         SetError(15);  // missing right or endedit
         exit;
      end;
      RestorePointer;
   until(tmp<>INUM);
end;
//#############################################################
procedure TInterpreter.AnySelectSD;
var tmp:integer;
    off:integer;
begin
   CurObj.Count:=0;
   CurObj.CountRight:=0;
   repeat
      inc(CurObj.Count);
      tmp:=TextScaner;
      if(tmp<>FNUM)and(tmp<>INUM) then begin
         SetError(17);
         exit;
      end;
      CurObj.Weights[CurObj.Count]:=strtofloat(lexem);

      tmp:=TextScaner;
      if(tmp<>TWOP) then begin
         SetError(2);
         exit;
      end;

      off:=CurPointer;
      tmp:=TextScaner;
      while (tmp<>ENDCASE)and(tmp<>_FEOF) do begin
         SavePointer;
         tmp:=TextScaner;
         {
         if (tmp in [TITLE..ENDIMAGE])and (tmp<>ENDCASE) then begin
            seterror(16);
            exit;
         end;
         }
      end;
      RestorePointer;
      CurObj.Texts[CurObj.Count]:=Copy(Text,off,CurPointer-off);
      tmp:=TextScaner;

      if(tmp<>ENDCASE) then begin
         seterror(11);  //missing endcase
         exit;
      end;
      tmp:=TextScaner;
      if(tmp<>SEMIC) then begin
         SetError(3);
         exit;
      end;
      SavePointer;
      tmp:=TextScaner;
      if(tmp=ENDCHOICE) then begin
        RestorePointer;
        exit;
      end
      else
      if(tmp<>FNUM)and(tmp<>INUM) then begin
         SetError(17);
         exit;
      end;
      RestorePointer;
   until(tmp<>FNUM)and(tmp<>INUM);
end;
//#############################################################
procedure TInterpreter.ChoiceSD    ;
var tmp:integer;
begin
     tmp:=TextScaner;
     tmp:=TextScaner;
     CurObj.who:=CHOICE;
     if(tmp<>TWOP) then begin
        SetError(2);
        exit;
     end;

     PositionSizeSD;
     if ErrCond then exit;

     IntSelectSD;
     if ErrCond then exit;

     tmp:=TextScaner;
     if(tmp<>RIGHT) then begin
        SetError(20);   // missing right
        exit;
     end;
     tmp:=TextScaner;
     if(tmp<>TWOP) then begin
        SetError(2);
        exit;
     end;
     tmp:=TextScaner;
     if(tmp<>INUM) then begin
        SetError(7);
        exit;
     end;
     CurObj.CountRight:=1;
     CurObj.WhatRight[1]:=strtoint(lexem);
end;
//#############################################################
procedure TInterpreter.MultiChoiceSD;
var tmp:integer;
begin
     CurObj.Count:=0;
     CurObj.CountRight:=0;
     CurObj.who:=MULTICHOICE;
     tmp:=TextScaner;
     tmp:=TextScaner;
     if(tmp<>TWOP) then begin
        SetError(2);
        exit;
     end;

     PositionSizeSD;
     if ErrCond then exit;

     IntSelectSD;
     if ErrCond then exit;

     tmp:=TextScaner;
     if(tmp<>RIGHT) then begin
        SetError(15);
        exit;
     end;
     tmp:=TextScaner;
     if(tmp<>TWOP) then begin
        SetError(2);
        exit;
     end;

     tmp:=TextScaner;
     if(tmp<>INUM) then begin
        SetError(7);
        exit;
     end;
     inc(CurObj.CountRight);
     CurObj.WhatRight[1]:=strtoint(lexem);
     SavePointer;
     tmp:=TextScaner;
     if(tmp=SEMIC) then begin
        RestorePointer;
        exit;
     end;
     if(tmp<>COM)and(tmp<>INUM) then begin
        SetError(3);
        exit;
     end;
     while(tmp=COM) do begin
         tmp:=TextScaner;
         if(tmp<>INUM) then begin
           SetError(7);
           exit;
         end;
         inc(CurObj.CountRight);
         CurObj.WhatRight[CurObj.CountRight]:=strtoint(lexem);
         SavePointer;
         tmp:=TextScaner;
          if (tmp<>COM) then RestorePointer;
     end;
end;
//#############################################################
procedure TInterpreter.SoftChoiceSD;
var tmp:integer;
begin
     CurObj.CountRight:=0;
     CurObj.who:=SOFTCHOICE;
     tmp:=TextScaner;
     tmp:=TextScaner;
     if(tmp<>TWOP) then begin
        SetError(2);
        exit;
     end;

     PositionSizeSD;
     if ErrCond then exit;

     AnySelectSD;
     if ErrCond then exit;

     tmp:=TextScaner;
     if(tmp<>ENDCHOICE) then begin
        SetError(23);
        exit;
     end;
end;
//#############################################################
procedure TInterpreter.AddChoiceSD ;
var tmp:integer;
begin
     CurObj.CountRight:=0;
     CurObj.who:=ADDCHOICE;
     tmp:=TextScaner;
     tmp:=TextScaner;
     if(tmp<>TWOP) then begin
        SetError(2);
        exit;
     end;

     PositionSizeSD;
     if ErrCond then exit;

     AnySelectSD;
     if ErrCond then exit;

     tmp:=TextScaner;
     if(tmp<>ENDCHOICE) then begin
        SetError(23);
        exit;
     end;
end;
//#############################################################
procedure TInterpreter.OrChoiceSD  ;
var tmp:integer;
begin
     CurObj.CountRight:=0;
     CurObj.who:=ORCHOICE;
     tmp:=TextScaner;
     tmp:=TextScaner;
     if(tmp<>TWOP) then begin
        SetError(2);
        exit;
     end;

     PositionSizeSD;
     if ErrCond then exit;

     IntSelectSD;
     if ErrCond then exit;

     tmp:=TextScaner;
     if(tmp<>RIGHT) then begin
        SetError(20);
        exit;
     end;
     tmp:=TextScaner;
     if(tmp<>TWOP) then begin
        SetError(2);
        exit;
     end;

     tmp:=TextScaner;
     if(tmp<>INUM) then begin
        SetError(7);
        exit;
     end;
     inc(CurObj.CountRight);
     CurObj.WhatRight[1]:=strtoint(lexem);
     SavePointer;
     tmp:=TextScaner;
     if(tmp=SEMIC) then begin
        RestorePointer;
        exit;
     end;
     if(tmp<>COM)and(tmp<>INUM) then begin
        SetError(2);
        exit;
     end;
     while(tmp=COM) do begin
         tmp:=TextScaner;
         if(tmp<>INUM) then begin
           SetError(7);
           exit;
         end;
         inc(CurObj.CountRight);
         CurObj.WhatRight[CurObj.CountRight]:=strtoint(lexem);
         SavePointer;
         tmp:=TextScaner;
         if (tmp<>COM) then RestorePointer;
     end;
end;
//#############################################################
procedure TInterpreter.ScaleSD;
var tmp:integer;
begin
   CurObj.Who:=SCALE;
   tmp:=TextScaner;
   tmp:=TextScaner;
   if (tmp<>TWOP) then begin
      SetError(2);
      exit;
   end;

   PositionSizeSD;
   if ErrCond then exit;

   tmp:=TextScaner;
   if(tmp<>ITEMS) then begin
     SetError(22);
     exit;
   end;
   tmp:=TextScaner;
   if(tmp<>TWOP) then begin
     SetError(2);
     exit;
   end;
   tmp:=TextScaner;
   if(tmp<>INUM) then begin
     SetError(7);
     exit;
   end;
   CurObj.Items:=strtoint(lexem);
   tmp:=TextScaner;
   if(tmp<>SEMIC) then begin
     SetError(3);
     exit;
   end;
   tmp:=TextScaner;
   if(tmp<>POSITION) then begin
     SetError(23);
     exit;
   end;
   tmp:=TextScaner;
   if(tmp<>TWOP) then begin
     SetError(2);
     exit;
   end;
   tmp:=TextScaner;
   if(tmp<>INUM) then begin
     SetError(7);
     exit;
   end;
   CurObj.Position:=strtoint(lexem);
   tmp:=TextScaner;
   if(tmp<>SEMIC) then begin
     SetError(3);
     exit;
   end;
   tmp:=TextScaner;
   if(tmp<>ENDSCALE) then begin
     SetError(24);
     exit;
   end;
end;
//#############################################################
procedure TInterpreter.LabelSD;
var tmp:integer;
    off:word;
begin
   CurObj.Who:=_LABEL;
   tmp:=TextScaner;
   tmp:=TextScaner;
   if (tmp<>TWOP) then begin
      SetError(2);
      exit;
   end;

   PositionSizeSD;
   if ErrCond then exit;

   tmp:=TextScaner;
   if(tmp<>CAPTION) then begin
     SetError(25);
     exit;
   end;
   tmp:=TextScaner;
   if(tmp<>TWOP) then begin
     SetError(2);
     exit;
   end;
   off:=CurPointer;
   SavePointer;
   tmp:=TextScaner;
   while (tmp<>SEMIC) do begin
      if tmp = _FEOF then begin
         SetError(3);
         exit;
      end;
      SavePointer;
      tmp:=TextScaner;
   end;
   RestorePointer;
   CurObj.Texts[1]:=copy(Text,off,CurPointer-off);
   tmp:=TextScaner;
   if(tmp<>SEMIC) then begin
     SetError(3);
     exit;
   end;
   tmp:=TextScaner;
   if(tmp<>FONT) then begin
     SetError(26);
     exit;
   end;
   tmp:=TextScaner;
   if(tmp<>TWOP) then begin
     SetError(2);
     exit;
   end;
   tmp:=TextScaner;
   if(tmp<>INUM) then begin
     SetError(7);
     exit;
   end;
   CurObj.Items:=strtoint(lexem);
   tmp:=TextScaner;
   if(tmp<>SEMIC) then begin
     SetError(3);
     exit;
   end;
   tmp:=TextScaner;
   if(tmp<>ENDLABEL) then begin
     SetError(27);
     exit;
   end;
end;
//#############################################################
procedure TInterpreter.ListSD ;
var tmp:integer;
begin
     CurObj.Who:=LIST;
     tmp:=TextScaner;
     tmp:=TextScaner;
     if(tmp<>TWOP) then begin
        SetError(2);
        exit;
     end;

     PositionSizeSD;
     if ErrCond then exit;

     IntSelectSD;
     if ErrCond then exit;

     tmp:=TextScaner;
     if(tmp<>RIGHT) then begin
        SetError(20);
        exit;
     end;
     tmp:=TextScaner;
     if(tmp<>TWOP) then begin
        SetError(2);
        exit;
     end;
     tmp:=TextScaner;
     if(tmp<>INUM) then begin
        SetError(7);
        exit;
     end;
     CurObj.CountRight:=1;
     CurObj.WhatRight[1]:=strtoint(lexem);
end;
//#############################################################
procedure TInterpreter.EditSD;
var tmp:integer;
begin
     CurObj.Who:=EDIT;
     tmp:=TextScaner;
     tmp:=TextScaner;
     if(tmp<>TWOP) then begin
        SetError(2);
        exit;
     end;

     PositionSizeSD;
     if ErrCond then exit;

     IntSelectSD;
     if ErrCond then exit;

     tmp:=TextScaner;
     if(tmp<>ENDEDIT) then begin
       SetError(36);
       exit;
     end;
end;
//#############################################################
procedure TInterpreter.OrderSD;
var tmp:integer;
begin
     CurObj.Who:=ORDER;
     tmp:=TextScaner;
     tmp:=TextScaner;
     if(tmp<>TWOP) then begin
        SetError(2);
        exit;
     end;

     PositionSizeSD;
     if ErrCond then exit;

     IntSelectSD;
     if ErrCond then exit;

     tmp:=TextScaner;
     if(tmp<>RIGHT) then begin
        SetError(15);
        exit;
     end;
     tmp:=TextScaner;
     if(tmp<>TWOP) then begin
        SetError(2);
        exit;
     end;

     tmp:=TextScaner;
     if(tmp<>INUM) then begin
        SetError(7);
        exit;
     end;
     CurObj.CountRight:=1;
     CurObj.WhatRight[1]:=strtoint(lexem);
     tmp:=TextScaner;
     if(tmp<>COM) then begin
        SetError(9);
        exit;
     end;
     while(tmp=COM) do begin
         tmp:=TextScaner;
         if(tmp<>INUM) then begin
           SetError(7);
           exit;
         end;
//         CurObj.CountRight:=1;
//         CurObj.WhatRight[1]:=strtoint(lexem);
         inc(CurObj.CountRight);
         CurObj.WhatRight[CurObj.CountRight]:=strtoint(lexem);
         SavePointer;
         tmp:=TextScaner;
         if (tmp<>COM) then RestorePointer;
     end;
end;
//#############################################################
procedure TInterpreter.SoundSD;
var tmp:integer;
    off:integer;
begin
   CurObj.Who:=SOUND;
   tmp:=TextScaner;
   tmp:=TextScaner;
   if(tmp<>TWOP) then begin
      SetError(2);
      exit;
   end;
   tmp:=TextScaner;
   if(tmp<>PATH) then begin
      SetError(18);
      exit;
   end;
   tmp:=TextScaner;
   if(tmp<>TWOP) then begin
      SetError(2);
      exit;
   end;
   off:=CurPointer;
   tmp:=TextScaner;     //filename
   while (tmp<>SEMIC)and(tmp<>_FEOF) do begin
      SavePointer;
      tmp:=TextScaner;
     {
      if (tmp in [TITLE..ENDIMAGE]) then begin
         seterror(3);
         exit;
      end;
     }
   end;
   RestorePointer;
   CurObj.Texts[1]:=Copy(Text,off,CurPointer-off);
   tmp:=TextScaner;
   tmp:=TextScaner;
   if(tmp<>BUTTON) then begin
      SetError(19);
      exit;
   end;
   tmp:=TextScaner;
   if(tmp<>TWOP) then begin
      SetError(2);
      exit;
   end;
   tmp:=TextScaner;
   if(tmp<>INUM) then begin
      SetError(7);
      exit;
   end;
   ButtonP:=strtoint(lexem);
   tmp:=TextScaner;
   if(tmp<>SEMIC) then begin
      SetError(3);
      exit;
   end;
   tmp:=TextScaner;
   if(tmp<>ENDSOUND) then begin
      SetError(20);
      exit;
   end;
end;
//#############################################################
procedure TInterpreter.ImageSD;
var tmp:integer;
    off:integer;
begin
   CurObj.Who:=IMAGE;
   tmp:=TextScaner;
   tmp:=TextScaner;
   if(tmp<>TWOP) then begin
      SetError(2);
      exit;
   end;

   PositionSizeSD;
   if  ErrCond then exit;

   tmp:=TextScaner;
   if(tmp<>PATH) then begin
      SetError(18);
      exit;
   end;
   tmp:=TextScaner;
   if(tmp<>TWOP) then begin
      SetError(2);
      exit;
   end;
   off:=CurPointer;
   tmp:=TextScaner;     //filename ?
   while (tmp<>SEMIC)and(tmp<>_FEOF) do begin
      SavePointer;
      tmp:=TextScaner;
{
      if (tmp in [TITLE..ENDIMAGE]) then begin
         seterror(3);
         exit;
      end;
}
   end;
   RestorePointer;
   CurObj.Texts[1]:=Copy(Text,off,CurPointer-off);
   tmp:=TextScaner;
   tmp:=TextScaner;
   if(tmp<>ENDIMAGE) then begin
      SetError(21);
      exit;
   end;
end;
//#############################################################
procedure TInterpreter.MoveFrwd;
begin
   inc(CurPointer);
end;
//#############################################################
procedure TInterpreter.SavePointer;
begin
   TextLength:= CurPointer;
end;
//#############################################################
procedure TInterpreter.RestorePointer;
begin
  CurPointer:= TextLength;
end;
//#############################################################
function TInterpreter.IsAlpha(c:char) : boolean;
begin
  if ((c>='A') and (c<='z'))or((c>='А')and(c<='я')) then
  IsAlpha:=true else IsAlpha:=false;
end;
//#############################################################
function TInterpreter.IsDigit(c:char) : boolean;
begin
  if (c>='0') and (c<='9') then IsDigit:=true else IsDigit:=false;
end;
//#############################################################
procedure TInterpreter.GetLexem(len:integer);
var  i : integer;
begin
   for i:=1 to len do Lexem[i]:=Text[CurPointer-len+i-1];
   Lexem[0]:=chr(len);
end;
//#############################################################
function TInterpreter.TextScaner : integer;
const l : integer = 1;
var   loclen : integer;
      i : integer;
      point : boolean;
label  FLOAT,
       INT,
       YET;
begin
    point:=false;
YET:
    if(CurrentLine=1) then l:=1;
    loclen:=0;
    if (CurPointer>TextSize) then begin                       // EOF
       TextScaner:=_FEOF;
       Lexem:='End of text';
       exit;
    end;
    while ((Text[CurPointer]=#13)or(Text[CurPointer]=#10)or
          (Text[CurPointer]=#32)) do
    begin                                            //cr & lf & space
       if (Text[CurPointer]=#10)and(l<CurPointer) then  begin
           l:=CurPointer;
           inc(CurrentLine);
       end;
       if (CurPointer>=TextSize) then goto YET;
       MoveFrwd;
    end;
    if (Text[CurPointer]='#') then begin  // comment
       repeat
         MoveFrwd;
       until(Text[CurPointer]=#13);
       MoveFrwd;
       MoveFrwd;
       if (l<CurPointer) then begin
               l:=CurPointer;
               inc(CurrentLine);
       end;
       goto YET;
    end else
    if IsAlpha(Text[CurPointer]) then begin // alpha
       inc(loclen);
       MoveFrwd;
       while (IsAlpha(Text[CurPointer])or IsDigit(Text[CurPointer])) do  begin
         inc(loclen);
         MoveFrwd;
       end;
       GetLexem(loclen);
       for i:=1 to AMOUNTLEX do
         if uppercase(Lexem)=images[i] then begin
            TextScaner:=i;
            exit;
         end;
       TextScaner:=ANY;
       exit;
    end else
    if IsDigit(Text[CurPointer]) then begin  // digit
       inc(loclen);
INT:
       repeat
         MoveFrwd;
         inc(loclen);
         if(Text[CurPointer]='.') then goto FLOAT;
       until (not IsDigit(Text[CurPointer]));
       if not IsAlpha(Text[CurPointer]) then begin
         if point then TextScaner:=FNUM else TextScaner:=INUM;
         GetLexem(loclen-1);
         exit;
       end else
       begin
         while (Text[CurPointer]<>' ') do begin
           MoveFrwd;
           inc(loclen);
         end;
       // 9A
         GetLexem(loclen-1);
         TextScaner:=ANY;
         exit;
       end;
FLOAT:
       repeat
         MoveFrwd;
         inc(loclen);
       until (not IsDigit(Text[CurPointer]));

       if not IsAlpha(Text[CurPointer]) then begin
          TextScaner:=FNUM;
          GetLexem(loclen-1);
          exit;
       end else
       begin
          // 9.A
          TextScaner:=ANY;
          GetLexem(loclen-1);
          exit;
       end;
    end else
    // ETC
    case Text[CurPointer] of
      '.' : begin
               MoveFrwd;
               inc(loclen);
               if(IsDigit(Text[CurPointer])) then begin // if digit
                  inc(loclen);
                  point:=true;
                  goto INT;
               end;
               TextScaner:=ONEP;Lexem:='.';exit;
            end;
      '+' : begin
               TextScaner:=PLUS;Lexem:='+';MoveFrwd; exit;
            end;
      '-' : begin
               TextScaner:=MINUS;Lexem:='-';MoveFrwd; exit;
            end;
      '*' : begin
               TextScaner:=MULT;Lexem:='*';MoveFrwd; exit;
            end;
      '/' : begin
               TextScaner:=DIVIDE;Lexem:='/';MoveFrwd; exit;
            end;
      '=' : begin
               TextScaner:=EQ; Lexem:='=';MoveFrwd; exit;
            end;
      '>' : begin
               MoveFrwd;
               if(Text[CurPointer]='=') then begin
                  TextScaner:=GE;
                  Lexem:='>=';
                  MoveFrwd;
               end  else begin TextScaner:=G;Lexem:='>'; end;
               exit;
            end;
      '<' : begin
               MoveFrwd;
               if(Text[CurPointer]='=') then begin
                  TextScaner:=LE;
                  Lexem:='<=';
                  MoveFrwd;
               end else
               if(Text[CurPointer]='>') then begin
                  TextScaner:=NEQ;
                  Lexem:='<>';
                  MoveFrwd;
               end
               else begin TextScaner:=LESS;Lexem:='<';end;
               exit;
            end;
      '(' : begin
               TextScaner:=LBRACE;Lexem:='(';MoveFrwd; exit;
            end;
      ')' : begin
               TextScaner:=RBRACE;Lexem:=')';MoveFrwd; exit;
            end;
      ',' : begin
               TextScaner:=COM;Lexem:=',';MoveFrwd; exit;
            end;
      ':' : begin
               MoveFrwd;
               if(Text[CurPointer]='=') then begin
                  TextScaner:=LET;
                  Lexem:=':=';
                  MoveFrwd;
               end
               else begin TextScaner:=TWOP;Lexem:=':'; end;
               exit;
            end;
      ';' : begin
               TextScaner:=SEMIC;Lexem:=';';MoveFrwd;exit;
            end;
    end;
    Lexem:=Text[CurPointer];
    MoveFrwd;
    TextScaner:=ANY;
end;

end.
