unit Message;

interface

var

  Mess : array [1..2,1..68] of string = (
//*****************************************************
//                   RUSSIAN
//*****************************************************
  (
    'Файл',                    //1
    'Открыть тест',
    'Закрыть тест',
    'Выход',
    'Пользователь',

    'Начать сеанс',           //6
    'Закончить сеанс',
    'Опции',
    'Шрифт',
    'Фон',

    'Белый',                  //11
    'Серый',
    'Зеленый',
    'Голубой',
    'Язык',

    'Русский',               //16
    'Английский',
    'Немецкий',
    'Французкий',
    'Помощь',

    'Содержание',            //21
    'О программе...',
    'Начать сеанс [Ctrl+L]',
    'Открыть тест [Ctrl+O]',
    'Повторить тест [Ctrl+R]',

    'Закончить сеанс [Ctrl+E]',//26
    'Закрыть тест [Ctrl+C]',
    'Выход из программы [Alt+X]',
    'Общее время на тест',
    'Время на вопрос',

    'Далее',                   //31
    'Воспроизвести',
    'Закрыть тест ?',
    'Закрыть сеанс ?',
    'Выйти из программы ?',

    'Ошибка в тесте [Код ',    //36
    'Обратитесь к АДМИНИСТРАТОРУ !',
    'Общая информация',
    'Имя теста',
    'Уровень сложности',

    'Вопросов',                //41
    'Время на тест',
    'Ваш выбор',
    'Переупорядочите',
    'Вверх',

    'Оценка',                  //46
    'Результат : зачет',
    'Результат : незачет',
    'Результат : неудовлетворительно',
    'Результат',

    'Введите пароль',          //51
    'Имя',
    'Пароль',
    'Изменить после входа',
    'Неправильный пароль.',

    'Повторите ввод.',         //56
    'Изменение пароля',
    'Новый пароль',
    'Повторите ввод',
    'Образец и подтверждение не совпадают.',

    'Открытие теста',          //61
    'Имя теста',
    'Описание',
    'Предмет',
    'Открыть',

    'Закрыть',                  //66
    'Вопрос',
    'Ваш ответ'
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
