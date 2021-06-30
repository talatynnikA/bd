 CREATE DATABASE studentsdb
 
 USE studentsdb;

CREATE TABLE Students ( 
    Номер_зачетки int NOT NULL IDENTITY(1,1) PRIMARY KEY, /* Инкремент для первичного ключа */
    Фамилия nvarchar(50),
    Дата_рождения date, 
    Пол nvarchar(50),
    Дата_поступления date
);

INSERT  into Students ( Фамилия, Дата_рождения, Пол, Дата_поступления)
Values( 'Талатынник','2002-10-15', 'м', '2019-09-01'),
		( 'Подрез','2001-10-14', 'м', '2019-09-01'),
		( 'Шкурко','2001-06-13', 'ж', '2019-09-01'),
		( 'Волчек','2000-10-12', 'ж', '2019-09-01'),
		( 'Шахно','2003-01-11', 'ж', '2019-09-01');
SELECT * FROM Students;
SELECT * FROM Students WHERE DATEDIFF(YEAR, [Дата_рождения], [Дата_поступления])<=18 AND Пол = 'ж';


 