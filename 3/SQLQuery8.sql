SELECT Distinct Номер_зачетки, Номер_группы, Фамилия_студента, POL
				FROM STUDENT WHERE Номер_зачетки 
				between 1234 And 3456

SELECT  Номер_зачетки, Номер_группы, Фамилия_студента, POL
				FROM STUDENT WHERE Номер_зачетки 
				Like 3456
DROP TABLE STUDENT;
