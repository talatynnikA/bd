SELECT *From STUDENT
SELECT count(*) From STUDENT;
SELECT Номер_зачетки, Фамилия_студента From STUDENT;
SELECT Номер_группы [студенты 2 группы],Номер_зачетки, Фамилия_студента From STUDENT
		Where Номер_группы = 2;
SELECT Distinct Top(2) Номер_зачетки, Фамилия_студента
	From STUDENT ORDER BY Номер_зачетки DESC;
