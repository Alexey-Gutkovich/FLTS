unit lexem;

interface
const
     AMOUNTLEX      =  60;        // количество ключевых
                                  // слов языка
     TITLE          =  1;         // ЛЕКСЕМЫ
     ENDTITLE       =  2;
     TESTNAME       =  3;
     DIFFICULTY     =  4;
     QUESTIONS      =  5;
     FULLTIME       =  6;
     BAILOUT        =  7;
     REGISTRATION   =  8;
     PROTOCOL       =  9;
     INTERVAL       =  10;
     RANDOMCHOICE   =  11;
     RANDOM         =  12;
     GRADATION      =  13;
     ENDGRAD        =  14;
     _ON            =  15;
     _OFF           =  16;

     STARTTEST      =  17;
     ENDTEST        =  18;
     MAINHEIGHT     =  19;
     MAINWIDTH      =  20;
     QUESTION       =  21;
     WEIGHT         =  22;
     LOCALTIME      =  23;
     BEGINTEXT      =  24;
     ENDTEXT        =  25;
     CHOICE         =  26;
     ATX            =  27;
     ATY            =  28;
     WIDTH          =  29;
     _WIDTH         =  29;
     HEIGHT         =  30;
     _HEIGHT        =  30;
     ENDCASE        =  31;
     RIGHT          =  32;
     MULTICHOICE    =  33;
     ASK            =  34;
     SOFTCHOICE     =  35;
     ENDCHOICE      =  36;
     ADDCHOICE      =  37;
     ORCHOICE       =  38;
     SCALE          =  39;
     ITEMS          =  40;
     POSITION       =  41;
     _POSITION      =  41;
     ENDSCALE       =  42;
     _LABEL         =  43;
     CAPTION        =  44;
     _CAPTION       =  44;
     FONT           =  45;
     _FONT          =  45;
     ENDLABEL       =  46;
     LIST           =  47;
     EDIT           =  48;
     ENDEDIT        =  49;
     IEDIT          =  50;
     ORDER          =  51;
     SOUND          =  52;
     BUTTON         =  53;
     ENDSOUND       =  54;
     PATH           =  55;
     IMAGE          =  56;
     ENDIMAGE       =  57;
     _IF            =  58;
     _THEN          =  59;
     _GOTO          =  60;

     ANY            =  100;
     INUM           =  101;
     FNUM           =  102;
     SEMIC          =  103;
     TWOP           =  104;
     ONEP           =  105;
     PLUS           =  106;
     MINUS          =  107;
     DIVIDE         =  108;
     MULT           =  109;
     COM            =  110;
     LBRACE         =  111;
     RBRACE         =  112;
     LET            =  113;
     G              =  114;
     LESS           =  115;
     EQ             =  116;
     GE             =  117;
     LE             =  118;
     NEQ            =  119;

     _FEOF           =  200;
     ERROR          =  255;
     AMOUNT_QUESTION=  300;  // максимальное количество вопросов
     AMOUNT_SELECT  =  15;   // максимальное количество вариаций
     AMOUNT_BAILGRAD = 5;    // максим.кол-во градаций (Bail)
     // образы лексем
     images : array [1..AMOUNTLEX] of string = (
    'TITLE',
    'ENDTITLE',
    'TESTNAME',
    'DIFFICULTY',
    'QUESTIONS',
    'FULLTIME',
    'BAILOUT',
    'REGISTRATION',
    'PROTOCOL',
    'INTERVAL',
    'RANDOMCHOICE',
    'RANDOM',
    'GRADATION',
    'ENDGRAD',
    'ON',
    'OFF',
    'STARTTEST',
    'ENDTEST',
    'MAINHEIGHT',
    'MAINWIDTH',
    'QUESTION',
    'WEIGHT',
    'LOCALTIME',
    'BEGINTEXT',
    'ENDTEXT',
    'CHOICE',
    'ATX',
    'ATY',
    'WIDTH',
    'HEIGHT',
    'ENDCASE',
    'RIGHT',
    'MULTICHOICE',
    'ASK',
    'SOFTCHOICE',
    'ENDCHOICE',
    'ADDCHOICE',
    'ORCHOICE',
    'SCALE',
    'ITEMS',
    'POSITION',
    'ENDSCALE',
    'LABEL',
    'CAPTION',
    'FONT',
    'ENDLABEL',
    'LIST',
    'EDIT',
    'ENDEDIT',
    'IEDIT',
    'ORDER',
    'SOUND',
    'BUTTON',
    'ENDSOUND',
    'PATH',
    'IMAGE',
    'ENDIMAGE',
    'IF',
    'THEN',
    'GOTO'
     );
//###############################################
 ErrMsg : array [1..36] of string = (
    'Missing TITLE',
    'Missing ":"',
    'Missing ";"',
    'Missing ENDTITLE',
    'Missing "."',

    'Missing number',
    'Missing integer number',
    'Missing ON/OFF',
    'Missing ","',
    'Missing ENDGRAD',

    'Unknowed error',
    'Missing STARTTEST',
    'Missing ENDTEST',
    'Missing ASK or missing object (example CHOICE ...)',
    'Missing RIGHT or ENDEDIT',

    'Missing last ENDCASE at structure',
    'Missing ENDCHOICE',
    'Missing PATH',
    'Missing BUTTON',
    'Missing ENDSOUND',

    'Missing ENDIMAGE',
    'Missing ITEMS',
    'Missing POSITION',
    'Missing ENDSCALE',
    'Missing CAPTION',

    'Missing FONT',
    'Missing ENDLABEL',
    'Missing THEN',
    'Missing END',
    'Missing ":="',

    'Missing comparision at IF structure',
    'Missing ")"',
    'Error in expression',
    'At RIGHT partition must be single variant',
    'Missing QUESTION',

    'Missing end of comment'
     );
type
    TWeight = record
      value : real;
      text  : string;
      num   : word;
    end;


implementation

end.
