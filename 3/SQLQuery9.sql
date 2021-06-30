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