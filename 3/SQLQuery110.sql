 CREATE DATABASE studentsdb
 
 USE studentsdb;

CREATE TABLE Students ( 
    �����_������� int NOT NULL IDENTITY(1,1) PRIMARY KEY, /* ��������� ��� ���������� ����� */
    ������� nvarchar(50),
    ����_�������� date, 
    ��� nvarchar(50),
    ����_����������� date
);

INSERT  into Students ( �������, ����_��������, ���, ����_�����������)
Values( '����������','2002-10-15', '�', '2019-09-01'),
		( '������','2001-10-14', '�', '2019-09-01'),
		( '������','2001-06-13', '�', '2019-09-01'),
		( '������','2000-10-12', '�', '2019-09-01'),
		( '�����','2003-01-11', '�', '2019-09-01');
SELECT * FROM Students;
SELECT * FROM Students WHERE DATEDIFF(YEAR, [����_��������], [����_�����������])<=18 AND ��� = '�';


 