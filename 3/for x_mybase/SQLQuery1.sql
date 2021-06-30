use Tal_MyBase
CREATE table STUDENT(
Номер_зачетки int primary key not null,
Фамилия_студента nvarchar(50) not null,
Номер_группы int not null
);

ALTER Table STUDENT ADD POL char


INSERT  into STUDENT ( Номер_зачетки, Фамилия_студента, Номер_группы, POL)
Values(1234, 'Талатынник', 2, 'м'),
		(2345, 'Подрез',2,'м'),
		(3456, 'Шахно', 3 ,'ж');

		SELECT *From STUDENT
SELECT count(*) From STUDENT;
SELECT Номер_зачетки, Фамилия_студента From STUDENT;
SELECT Номер_группы [студенты 2 группы],Номер_зачетки, Фамилия_студента From STUDENT
		Where Номер_группы = 2;
SELECT Distinct Top(2) Номер_зачетки, Фамилия_студента
	From STUDENT ORDER BY Номер_зачетки DESC;

	UPDATE STUDENT set Номер_группы = 5;

SELECT *From STUDENT

DELETE FROM STUDENT WHERE Номер_зачетки= 1234;

SELECT *From STUDENT


SELECT Distinct Номер_зачетки, Номер_группы, Фамилия_студента, POL
				FROM STUDENT WHERE Номер_зачетки 
				between 1234 And 3456

SELECT  Номер_зачетки, Номер_группы, Фамилия_студента, POL
				FROM STUDENT WHERE Номер_зачетки 
				Like 3456
DROP TABLE STUDENT;

CREATE TABLE RESULTS
( ID int primary key identity (1,1),
STUDENT_NAME nvarchar(50),
AVER_VALUE AS (EKZ1 + EKZ2 + EKZ3)/3,
EKZ1 int,
EKZ2 int,
EKZ3 int
)
INSERT INTO RESULTS (STUDENT_NAME,  EKZ1, EKZ2, EKZ3)
	VALUES ('Талатынник', 6,4,4),
	('Подрез', 4,5,4),
	('Фамилия', 6,5,7)

SELECT *From RESULTS;