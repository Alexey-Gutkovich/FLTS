unit MyObject;

interface
uses sysutils,
     stdctrls,classes,
     extctrls,controls,
     checklst,comctrls,
     graphics,manager,
     buttons,lexem,MvCtrls , Message , Dialogs;

type
  { значение }
    TValue= record
       Who   : byte;                   // тип значения 1-int,2-float,3-id
       Image : string;
       Value : real;
    end;
    { идентификатор }
    TIdent= record
       TypeId: byte;                   // тип идентификатора (1-int,2-real)
       Image : string;                 // образ идентификатора
       Value : real;                   // значение
    end;
    { градации }
    TBail = record
       value : real;
       text  : string;
    end;
    { служебная инф-ия о вопросе }
    TOffset = record
        Number : word;
        Offset : word;
        busy   : boolean;
    end;
    { текущий объект }
    TCurrentObj = record
       Who        : byte;              // тип объекта
       AtX,AtY,
       Width,
       Height     : integer;           // координаты и размер объекта
       Count      : integer;           // общее кол-во вариантов
       CountRight : integer;           // количество прав-х
       { перечень прав-х }
       WhatRight  : array [1..AMOUNT_SELECT] of integer;
       { перечень выбранных }
       WhatSel    : array [1..AMOUNT_SELECT] of integer;
       { текст вариантов }
       Texts      : array [1..AMOUNT_SELECT] of string;
       { Веса вариантов }
       Weights    : array [1..AMOUNT_SELECT] of real;
       Position   : integer;
       Items      : integer;
    end;

   { объект CHOICE}
   Mychoice = class (TmvRadioGroup)
     protected
      procedure  KeyDown(var Key: Word; Shift: TShiftState); override;
     public
      WhatRight  : integer;               // правильный вариант
      count      : integer;               // количество вариаций
      WhatSel    : integer;               // выбранная вариация
   end;

   { объект MULTICHOICE}
   MyMultiChoice = class (TCheckListBox)
     public
      CountRight : integer;
      count   : integer;                   // кол-во вариаций
      Select  : array [1..AMOUNT_SELECT]
                              of boolean;  // выбранная вариация
      Right   : array [1..AMOUNT_SELECT]
                              of boolean;  // праильные вариации
   end;

   { объект SOFTCHOICE}
   MySoftChoice = class (TmvRadioGroup)
     protected
      procedure  KeyDown(var Key: Word; Shift: TShiftState); override;
     public
      count : integer;                     // кол-во вариаций
      weights : array [1..AMOUNT_SELECT]
                              of real;     // веса вариаций
      select : integer;                    // выбранная вариация
   end;

   { объект ADDCHOICE}
   MyAddChoice = class (TCheckListBox)
     public
      count : integer;                     // кол-во вариаций
      weights : array [1..AMOUNT_SELECT]
                                  of real; // веса вариаций
      select : integer;                    // выбранная вариация
   end;

   { объект ORCHOICE}
   MyOrChoice = class (TmvRadioGroup)
     protected
      procedure  KeyDown(var Key: Word; Shift: TShiftState); override;
     public
      count : integer;                     // кол-во вариаций
      Right   : array [1..AMOUNT_SELECT]
                              of boolean;  // праильные вариации
      select : integer;                    // выбранная вариация
   end;

   { объект SCALE}
   MyScale = class (TTrackBar)
     protected
      procedure  KeyDown(var Key: Word; Shift: TShiftState); override;
     public
       items : integer;
       select : integer;
   end;

   { объект List}
   MyList = class(TListBox)
     protected
      procedure  KeyDown(var Key: Word; Shift: TShiftState); override;
     public
      WhatRight  : integer;           // правильный вариант
      count : integer;                // количество вариаций
            select : integer;               // выбранная вариация
   end;

   { объект Edit}
   MyEdit = class (TEdit)
     protected
      procedure  KeyDown(var Key: Word; Shift: TShiftState); override;
      procedure MouseDown(Button: TMouseButton;
                          Shift: TShiftState;X, Y: Integer);override;
      public
       count   : integer;             // кол-во вариаций
       texts : array [1..AMOUNT_SELECT] of string;
   end;


   { объект Order}
   MyOrder = class (TmvRadioGroup)
     protected
       List   : TListBox;
       Button : TBitBtn;
       procedure ClickUp(Sender : TObject);
       procedure EnterList(Sender : TObject);
     public
       count   : integer;
       WhatRight : array [1..AMOUNT_SELECT] of word;
       WhatSel : array [1..AMOUNT_SELECT] of word;
       constructor Create(Owner : TComponent) ; override;
   end;

implementation

//#############################################################
procedure MyOrder.ClickUp(Sender : TObject);
var tmp : string;
    tmpi: word;
begin
  if List.Items.Count > 0 then
  if List.ItemIndex<>0 then begin
     tmp := List.Items[List.ItemIndex];
     tmpi:=WhatSel[List.ItemIndex+1];
     List.Items[List.ItemIndex]:=List.Items[List.ItemIndex-1];
     WhatSel[List.ItemIndex+1]:=WhatSel[List.ItemIndex];
     List.Items[List.ItemIndex-1] := tmp;
     WhatSel[List.ItemIndex]:=tmpi;
     List.ItemIndex:=List.ItemIndex-1;
  end;
end;
//#############################################################
procedure MyOrder.EnterList(Sender : TObject);
begin
  Button.Enabled:=true;
end;
//#############################################################
constructor  MyOrder.Create (Owner : TComponent);
begin
  inherited create(Owner);
  List := TListBox.Create(Owner);
  inherited insertcontrol(List);
  Button := TBitBtn.Create(Owner);
  inherited insertcontrol(Button);
  Button.OnClick:=ClickUp;
  List.OnEnter:=EnterList;
  Button.Enabled:=false;
end;
//#############################################################
procedure MyChoice.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key=13 then MainF.ForwardBClick(MainF);
end;
//#############################################################
procedure MySoftChoice.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key=13 then MainF.ForwardBClick(MainF);
end;
//#############################################################
procedure MyOrChoice.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key=13 then MainF.ForwardBClick(MainF);
end;
//#############################################################
procedure MyList.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key=13 then MainF.ForwardBClick(MainF);
end;
//#############################################################
procedure MyEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key=13 then MainF.ForwardBClick(MainF);
end;
//#############################################################
procedure MyEdit.MouseDown(Button: TMouseButton;
                 Shift: TShiftState;X, Y: Integer);
begin
    if Text=Mess[MainF.CurLang,68] then Text:='';
end;
//#############################################################
procedure MyScale.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key=13 then MainF.ForwardBClick(MainF);
end;
//#############################################################

end.
