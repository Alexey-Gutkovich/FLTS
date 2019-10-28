unit synopsis;

interface
uses dialogs,sysutils,stdctrls,classes,lexem;


type
    TSynopsis = class(TObject)
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
     procedure ConditionSD;            // разбор условия оператора if
     procedure BodySD;                 // разбор тела оператора if
     procedure ElementExpSD;           // разбор элементарного выражения
     procedure ExpressionSD;           // разбор выражения
     procedure AdditionSD;             // разбор слагаемого
     procedure LetSD;                  // разбор присваивания
     procedure SetError(code:integer); // выставление флага и кода ошибки
     procedure GetLexem(len:integer);  // получение образа текущ.
                                       // отсканиров. лексемы
     function  IsAlpha(c:char) : boolean; // проверка на букву
     function  IsDigit(c:char) : boolean; // проверка на цифру
     function  TextScaner : integer;   // сканер текста
  protected
     TextLength  : integer;            //  размер текста
     TextSize    : integer;            //
     Text        : string;             //  входной текст
  public
     TotalT      : word;
     TextP       : string;
     CurQuestion : word;
     ErrCond     : boolean;            // флаг ошибки
     CurPointer  : integer;            //  указатель (текущ. позиция в тексте)
     ErrorMsg    : string;             // текст сообщения об ошибке
     ErrorCode   : integer;            // код ошибки
     CurrentLine : integer;            // текущая строка
     Lexem       : string[128];        //  образ отсканир. лексемы
     Offs : array [1..AMOUNT_QUESTION] of word;
     Weights : array [1..AMOUNT_QUESTION] of TWeight;
     Times   : array [1..AMOUNT_QUESTION] of word;
     Num  : array [1..AMOUNT_QUESTION] of word;
     constructor Create(txt: string);
end;
//#################################################################


implementation

//#############################################################
constructor TSynopsis.Create(txt: string);
begin
  Text := txt;
  inherited Create;
end;
//#############################################################
procedure   TSynopsis.SetError(code:integer);
begin
      ErrCond:=true;
      ErrorCode:=code;
end;
//#############################################################
function TSynopsis.Analyze : integer;
var tmp : integer;
    SaveDecimalSep : char;
begin
    SaveDecimalSep:=DecimalSeparator;
    DecimalSeparator:='.';
    CurQuestion:=0;
    ErrCond :=false;
    CurrentLine:=1;

    CurPointer :=1;
    TextSize:=length(Text);

    TitleSD;
    if not ErrCond then  TestSD;

    DecimalSeparator:=SaveDecimalSep;
    if ErrCond then begin
       ErrorMsg:=ErrMsg[ErrorCode];
       analyze:=1
    end else analyze:=0;
end;
//#############################################################
procedure TSynopsis.SS_SD;
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
    end;
    _IF:   begin
       S_SD;
       if ErrCond then exit;
    end;
    ANY: begin
       LetSD;
       if ErrCond then exit;
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
procedure TSynopsis.S_SD;
var tmp:integer;
begin
   tmp:=TextScaner;  // IF
   ConditionSD;
   if ErrCond then exit;
   tmp:=TextScaner;
   if(tmp<>_THEN) then begin
      seterror(28);
      exit;
   end;
   BodySD;
   if ErrCond then exit;
end;
//#############################################################
procedure TSynopsis.BodySD;
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
procedure TSynopsis.ElementExpSD;
var tmp:integer;
begin
   tmp:=TextScaner;
   case tmp of
     INUM,FNUM,ANY : exit;
     LBRACE: begin
         ExpressionSD;
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
end;
//#############################################################
procedure TSynopsis.ExpressionSD;
var tmp:integer;
begin
   AdditionSD;
   if ErrCond then exit;
   SavePointer;
   tmp:=TextScaner;
   while tmp in [PLUS,MINUS] do begin
      AdditionSD;
      if ErrCond then exit;
      SavePointer;
      tmp:=TextScaner;
   end;
   RestorePointer;
end;
//#############################################################
procedure TSynopsis.ConditionSD;
var tmp:integer;
begin
  ExpressionSD;
  if ErrCond then exit;
  tmp:=TextScaner;
  if not (tmp in [G..NEQ]) then begin
     seterror(31);
     exit;
  end;
  ExpressionSD;
  if ErrCond then exit;
end;
//#############################################################
procedure TSynopsis.AdditionSD;
var tmp:integer;
begin
   ElementExpSD;
   if ErrCond then exit;
   SavePointer;
   tmp:=TextScaner;
   while tmp in [DIVIDE,MULT] do begin
      ElementExpSD;
      if ErrCond then exit;
      SavePointer;
      tmp:=TextScaner;
   end;
   RestorePointer;
end;
//#############################################################
procedure TSynopsis.LetSD;
var tmp:integer;
begin
  tmp:=TextScaner;
  if(tmp<>ANY) then begin
     seterror(11);
     exit;
  end;
  tmp:=TextScaner;
  if(tmp<>LET) then begin
     seterror(30);
     exit;
  end;
  ExpressionSD;
  if ErrCond then exit;
end;
//#############################################################
procedure TSynopsis.TitleSD;
var tmp : byte;
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
procedure TSynopsis.GradationSD;
var tmp:integer;
      l:integer;
begin
   tmp:=TextScaner;
   if(tmp<>TWOP) then begin
      SetError(2);
      exit;
   end;
   SavePointer;
   repeat
       RestorePointer;
       tmp:=TextScaner;
       if(tmp<>FNUM)and(tmp<>INUM) then begin
          SetError(10); // missing endgrad   ok
          exit;
       end;
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
       end;
       SavePointer;
       tmp:=TextScaner;
   until (tmp=ENDGRAD);
end;
//#############################################################
procedure TSynopsis.TestParametrSD ;
var tmp : word;
    l   : word;
    off : word;
    par : word;
begin
   SavePointer;
   tmp:=TextScaner;
   if tmp=GRADATION then begin
      GradationSD;
      if ErrCond then exit;
   end
   else
//################################################
   if tmp in [REGISTRATION..RANDOM] then begin
      tmp:=TextScaner;
      if(tmp<>TWOP) then begin
         SetError(2); //missing  :  ok
         exit;
      end;
      tmp:=TextScaner;
      if not(tmp in [_ON,_OFF]) then begin
         SetError(8);  // missing ON ok
         exit;
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
      off:=CurPointer;
      tmp:=TextScaner;
      while (tmp<>SEMIC) do begin
         SavePointer;
         tmp:=TextScaner;
         if(tmp =_FEOF) then begin
            seterror(3); exit;
         end;
      end;
      RestorePointer;
      if(par=TESTNAME) then TextP:=copy(Text,off,CurPointer-off+1);
//################################################
   end
   else
   if tmp in [QUESTIONS,FULLTIME] then  begin
       par := tmp;
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
       if par = FULLTIME then TotalT := strtoint(lexem);
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
   end
   else
//################################################
   begin
      SetError(11);
      exit;
   end;
end;
//#############################################################
procedure TSynopsis.TestSD;
var tmp:integer;
begin
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

   QuestionSD;
   if ErrCond then exit;

   SavePointer;
   tmp:=TextScaner;
   while(tmp in [MAINHEIGHT..BEGINTEXT]) do begin
      RestorePointer;
      QuestionSD;
      if ErrCond then exit;
      SavePointer;
      tmp:=TextScaner;
   end;
   if(tmp<>ENDTEST) then begin
      SetError(13);
      exit;
   end;
   RestorePointer;
   Offs[CurQuestion+1]:=CurPointer;
   tmp:=TextScaner;
   tmp:=TextScaner;
   if(tmp<>ONEP) then begin
      SetError(5);
      exit;
   end;
end;
//#############################################################
procedure TSynopsis.QuestionSD;
var tmp:integer;
begin
   QuestParSD;
   if ErrCond   then exit;

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

     if tmp<>ASK then begin
        ObjectSD;
        if ErrCond   then exit;
     end;
     SavePointer;
     tmp:=TextScaner;

   until (tmp=ASK);

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
procedure TSynopsis.ObjectSD;
var tmp:integer;
    par:integer;
begin
   SavePointer;
   tmp:=TextScaner;
   par:=tmp;
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
      case par of
        CHOICE : begin SetError(34); exit; end;
        else     begin
             SetError(3);
             exit;
        end;     
      end;
   end;
end;
//#############################################################
procedure TSynopsis.QuestParSD    ;
var tmp:integer;
    quest : boolean;
    par:integer;
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
                par := tmp;
                if tmp=QUESTION then begin
                     CurQuestion:=CurQuestion+1;
                     Offs[CurQuestion]:=CurPointer-9;
                     quest:=true; // find QUESTION
                end;
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
                if par = LOCALTIME then
                   Times[CurQuestion]:=strtoint(lexem)
                else
                if par = QUESTION then
                   Num[CurQuestion]:=strtoint(lexem);
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
                if(tmp<>FNUM)and(tmp<>INUM) then begin
                   SetError(6);
                   exit;
                end;
                Weights[CurQuestion].value:=strtofloat(lexem);
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
                  tmp:=TextScaner;

                Weights[CurQuestion].text:=copy(Text,par,CurPointer-par);
                if(tmp<>ENDTEXT) then begin
                   seterror(11);  // missing endtext
                   exit;
                end;
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
procedure TSynopsis.PositionSizeSD;
var tmp:integer;
begin
    SavePointer;
    tmp:=TextScaner;
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
            tmp:=TextScaner;
            if(tmp<>SEMIC) then begin
                seterror(3); exit;   // missing ;
            end;
         end;
         else begin
               seterror(11);
               exit;
         end;
      end;
      SavePointer;
      tmp:=TextScaner;
    until tmp in [INUM,FNUM,ITEMS,POSITION,CAPTION,FONT,PATH];
    RestorePointer;
end;
//#############################################################
procedure TSynopsis.IntSelectSD    ;
var tmp:integer;
begin
   repeat
      tmp:=TextScaner;
      if(tmp<>INUM)and(tmp<>FNUM) then begin
         SetError(7);  //missing inum
         exit;
      end;
      tmp:=TextScaner;
      if(tmp<>TWOP) then begin
         SetError(2);
         exit;
      end;
      tmp:=TextScaner;
      while (tmp<>ENDCASE)and(tmp<>_FEOF) do begin
         tmp:=TextScaner;
         if tmp=ASK then begin
            seterror(16);  //missing endcase
            exit;
         end;         
      end;
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
procedure TSynopsis.AnySelectSD;
var tmp:integer;
begin
   repeat
      tmp:=TextScaner;
      if(tmp<>FNUM)and(tmp<>INUM) then begin
         SetError(17);
         exit;
      end;
      tmp:=TextScaner;
      if(tmp<>TWOP) then begin
         SetError(2);
         exit;
      end;
      tmp:=TextScaner;
      while (tmp<>ENDCASE)and(tmp<>_FEOF) do begin
         tmp:=TextScaner;
         if tmp=ASK then begin
            seterror(16);  //missing endcase
            exit;
         end;
      end;
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
procedure TSynopsis.ChoiceSD    ;
var tmp:integer;
begin
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

end;
//#############################################################
procedure TSynopsis.MultiChoiceSD;
var tmp:integer;
begin
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
         SavePointer;
         tmp:=TextScaner;
          if (tmp<>COM) then RestorePointer;
     end;
end;
//#############################################################
procedure TSynopsis.SoftChoiceSD;
var tmp:integer;
begin
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
procedure TSynopsis.AddChoiceSD ;
var tmp:integer;
begin
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
procedure TSynopsis.OrChoiceSD  ;
var tmp:integer;
begin
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
         SavePointer;
         tmp:=TextScaner;
         if (tmp<>COM) then RestorePointer;
     end;
end;
//#############################################################
procedure TSynopsis.ScaleSD;
var tmp:integer;
begin
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
procedure TSynopsis.LabelSD;
var tmp:integer;
begin
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

   tmp:=TextScaner;
   while (tmp<>SEMIC) do  tmp:=TextScaner;

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
procedure TSynopsis.ListSD ;
var tmp:integer;
begin
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
end;
//#############################################################
procedure TSynopsis.EditSD;
var tmp:integer;
begin
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
procedure TSynopsis.OrderSD;
var tmp:integer;
begin
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
         SavePointer;
         tmp:=TextScaner;
         if (tmp<>COM) then RestorePointer;
     end;
end;
//#############################################################
procedure TSynopsis.SoundSD;
var tmp:integer;
begin
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
   tmp:=TextScaner;     //filename ?
   while (tmp<>SEMIC)and(tmp<>_FEOF) do begin
      tmp:=TextScaner;
      if (tmp in [TITLE..ENDIMAGE]) then begin
         seterror(3);
         exit;
      end;

   end;
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
procedure TSynopsis.ImageSD;
var tmp:integer;
begin
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
   tmp:=TextScaner;     //filename ?
   while (tmp<>SEMIC)and(tmp<>_FEOF) do begin
      tmp:=TextScaner;
      if (tmp in [TITLE..ENDIMAGE]) then begin
         seterror(3);
         exit;
      end;
   end;
   tmp:=TextScaner;
   if(tmp<>ENDIMAGE) then begin
      SetError(21);
      exit;
   end;
end;
//#############################################################
procedure TSynopsis.MoveFrwd;
begin
   inc(CurPointer);
end;
//#############################################################
procedure TSynopsis.SavePointer;
begin
   TextLength:= CurPointer;
end;
//#############################################################
procedure TSynopsis.RestorePointer;
begin
  CurPointer:= TextLength;
end;
//#############################################################
function TSynopsis.IsAlpha(c:char) : boolean;
begin
  if ((c>='A') and (c<='z'))or((c>='А')and(c<='я')) then IsAlpha:=true else IsAlpha:=false;
end;
//#############################################################
function TSynopsis.IsDigit(c:char) : boolean;
begin
  if (c>='0') and (c<='9') then IsDigit:=true else IsDigit:=false;
end;
//#############################################################
procedure TSynopsis.GetLexem(len:integer);
var  i : integer;
begin
   for i:=1 to len do Lexem[i]:=Text[CurPointer-len+i-1];
   Lexem[0]:=chr(len);
end;
//#############################################################
function TSynopsis.TextScaner : integer;
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
