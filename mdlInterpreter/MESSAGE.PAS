unit Message;

interface

var

  Mess : array [1..2,1..68] of string = (
//*****************************************************
//                   RUSSIAN
//*****************************************************
  (
    '����',                    //1
    '������� ����',
    '������� ����',
    '�����',
    '������������',

    '������ �����',           //6
    '��������� �����',
    '�����',
    '�����',
    '���',

    '�����',                  //11
    '�����',
    '�������',
    '�������',
    '����',

    '�������',               //16
    '����������',
    '��������',
    '����������',
    '������',

    '����������',            //21
    '� ���������...',
    '������ ����� [Ctrl+L]',
    '������� ���� [Ctrl+O]',
    '��������� ���� [Ctrl+R]',

    '��������� ����� [Ctrl+E]',//26
    '������� ���� [Ctrl+C]',
    '����� �� ��������� [Alt+X]',
    '����� ����� �� ����',
    '����� �� ������',

    '�����',                   //31
    '�������������',
    '������� ���� ?',
    '������� ����� ?',
    '����� �� ��������� ?',

    '������ � ����� [��� ',    //36
    '���������� � �������������� !',
    '����� ����������',
    '��� �����',
    '������� ���������',

    '��������',                //41
    '����� �� ����',
    '��� �����',
    '���������������',
    '�����',

    '������',                  //46
    '��������� : �����',
    '��������� : �������',
    '��������� : �������������������',
    '���������',

    '������� ������',          //51
    '���',
    '������',
    '�������� ����� �����',
    '������������ ������.',

    '��������� ����.',         //56
    '��������� ������',
    '����� ������',
    '��������� ����',
    '������� � ������������� �� ���������.',

    '�������� �����',          //61
    '��� �����',
    '��������',
    '�������',
    '�������',

    '�������',                  //66
    '������',
    '��� �����'
  ),
//*****************************************************
//                   english
//*****************************************************
  (
    'Test',                    //1
    'Open',
    'Close',
    'Exit',
    'User',

    'Log in',           //6
    'Log off',
    'Options',
    'Font',
    'BackGround',

    'White',                  //11
    'Gray',
    'Green',
    'Blue',
    'Language',

    'Russian',               //16
    'English',
    '',
    '',
    'Help',

    'Contents',            //21
    'About...',
    'Login [Ctrl+L]',
    'Open test [Ctrl+O]',
    'Repeat test [Ctrl+R]',

    'Logoff [Ctrl+E]',//26
    'Close test [Ctrl+C]',
    'Program terminate [Alt+X]',
    'All time',
    'Question time',

    'Next',                   //31
    'Play',
    'Close test ?',
    'Logoff ?',
    'Program terminate ?',

    'Error [Code',    //36
    'Run to administrator ! Go-Go !',
    'Summary',
    'Test name',
    'Difficulty level',

    'Questions',                //41
    'All time',
    'Your answer',
    'Reorder',
    'Up',

    'Mark',                  //46
    'Result : accept',
    'Result : not accept',
    'Result : dissatisfactorily',
    'Result',

    'Enter password',          //51
    'Name',
    'Password',
    'Change after entrance',
    'Incorrect password.',

    'Repeat enter.',         //56
    'Change password',
    'New password',
    'Repeat enter',
    'Specimen and confirmation not equal.',

    'Test open',          //61
    'Test name',
    'Description',
    'Subject',
    'Open',

    'Close',                  //66
    'Question',
    'Your answer'
  ));

implementation

end.
