use Tal_MyBase
CREATE table STUDENT(
�����_������� int primary key not null,
�������_�������� nvarchar(50) not null,
�����_������ int not null
);

ALTER Table STUDENT ADD POL char


INSERT  into STUDENT ( �����_�������, �������_��������, �����_������, POL)
Values(1234, '����������', 2, '�'),
		(2345, '������',2,'�'),
		(3456, '�����', 3 ,'�');

		SELECT *From STUDENT
SELECT count(*) From STUDENT;
SELECT �����_�������, �������_�������� From STUDENT;
SELECT �����_������ [�������� 2 ������],�����_�������, �������_�������� From STUDENT
		Where �����_������ = 2;
SELECT Distinct Top(2) �����_�������, �������_��������
	From STUDENT ORDER BY �����_������� DESC;

	UPDATE STUDENT set �����_������ = 5;

SELECT *From STUDENT

DELETE FROM STUDENT WHERE �����_�������= 1234;

SELECT *From STUDENT


SELECT Distinct �����_�������, �����_������, �������_��������, POL
				FROM STUDENT WHERE �����_������� 
				between 1234 And 3456

SELECT  �����_�������, �����_������, �������_��������, POL
				FROM STUDENT WHERE �����_������� 
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
	VALUES ('����������', 6,4,4),
	('������', 4,5,4),
	('�������', 6,5,7)

SELECT *From RESULTS;