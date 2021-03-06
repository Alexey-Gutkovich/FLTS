unit MyObject;

interface
uses sysutils,
     stdctrls,classes,
     extctrls,controls,
     checklst,comctrls,
     graphics,manager,
     buttons,lexem,MvCtrls , Message , Dialogs;

type
  { �������� }
    TValue= record
       Who   : byte;                   // ��� �������� 1-int,2-float,3-id
       Image : string;
       Value : real;
    end;
    { ������������� }
    TIdent= record
       TypeId: byte;                   // ��� �������������� (1-int,2-real)
       Image : string;                 // ����� ��������������
       Value : real;                   // ��������
    end;
    { �������� }
    TBail = record
       value : real;
       text  : string;
    end;
    { ��������� ���-�� � ������� }
    TOffset = record
        Number : word;
        Offset : word;
        busy   : boolean;
    end;
    { ������� ������ }
    TCurrentObj = record
       Who        : byte;              // ��� �������
       AtX,AtY,
       Width,
       Height     : integer;           // ���������� � ������ �������
       Count      : integer;           // ����� ���-�� ���������
       CountRight : integer;           // ���������� ����-�
       { �������� ����-� }
       WhatRight  : array [1..AMOUNT_SELECT] of integer;
       { �������� ��������� }
       WhatSel    : array [1..AMOUNT_SELECT] of integer;
       { ����� ��������� }
       Texts      : array [1..AMOUNT_SELECT] of string;
       { ���� ��������� }
       Weights    : array [1..AMOUNT_SELECT] of real;
       Position   : integer;
       Items      : integer;
    end;

   { ������ CHOICE}
   Mychoice = class (TmvRadioGroup)
     protected
      procedure  KeyDown(var Key: Word; Shift: TShiftState); override;
     public
      WhatRight  : integer;               // ���������� �������
      count      : integer;               // ���������� ��������
      WhatSel    : integer;               // ��������� ��������
   end;

   { ������ MULTICHOICE}
   MyMultiChoice = class (TCheckListBox)
     public
      CountRight : integer;
      count   : integer;                   // ���-�� ��������
      Select  : array [1..AMOUNT_SELECT]
                              of boolean;  // ��������� ��������
      Right   : array [1..AMOUNT_SELECT]
                              of boolean;  // ��������� ��������
   end;

   { ������ SOFTCHOICE}
   MySoftChoice = class (TmvRadioGroup)
     protected
      procedure  KeyDown(var Key: Word; Shift: TShiftState); override;
     public
      count : integer;                     // ���-�� ��������
      weights : array [1..AMOUNT_SELECT]
                              of real;     // ���� ��������
      select : integer;                    // ��������� ��������
   end;

   { ������ ADDCHOICE}
   MyAddChoice = class (TCheckListBox)
     public
      count : integer;                     // ���-�� ��������
      weights : array [1..AMOUNT_SELECT]
                                  of real; // ���� ��������
      select : integer;                    // ��������� ��������
   end;

   { ������ ORCHOICE}
   MyOrChoice = class (TmvRadioGroup)
     protected
      procedure  KeyDown(var Key: Word; Shift: TShiftState); override;
     public
      count : integer;                     // ���-�� ��������
      Right   : array [1..AMOUNT_SELECT]
                              of boolean;  // ��������� ��������
      select : integer;                    // ��������� ��������
   end;

   { ������ SCALE}
   MyScale = class (TTrackBar)
     protected
      procedure  KeyDown(var Key: Word; Shift: TShiftState); override;
     public
       items : integer;
       select : integer;
   end;

   { ������ List}
   MyList = class(TListBox)
     protected
      procedure  KeyDown(var Key: Word; Shift: TShiftState); override;
     public
      WhatRight  : integer;           // ���������� �������
      count : integer;                // ���������� ��������
            select : integer;               // ��������� ��������
   end;

   { ������ Edit}
   MyEdit = class (TEdit)
     protected
      procedure  KeyDown(var Key: Word; Shift: TShiftState); override;
      procedure MouseDown(Button: TMouseButton;
                          Shift: TShiftState;X, Y: Integer);override;
      public
       count   : integer;             // ���-�� ��������
       texts : array [1..AMOUNT_SELECT] of string;
   end;


   { ������ Order}
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
