use TAL_UNIVER

---------1-----------------

create view [�������������]
as select TEACHER[��� �������������], TEACHER_NAME[���], GENDER[���], PULPIT[�������]
from TEACHER

select * from [�������������]

select * from [�������������] order by [�������]
drop view [�������������]
---------2--------------------

create view [���������� ������]
as select FACULTY.FACULTY_NAME[���������], count(PULPIT) [���-�� ������]
from FACULTY 
inner join PULPIT on FACULTY.FACULTY=PULPIT.FACULTY
group by FACULTY.FACULTY_NAME--������ �� ������ ��������� ������ ����������� ����� insert update delete

select * from [���������� ������]
--drop view [���������� ������]
---------3-------------------

create view [���������]
as select AUDITORIUM.AUDITORIUM[��� ���������], AUDITORIUM.AUDITORIUM_NAME[������������] 
from AUDITORIUM--1t
where AUDITORIUM.AUDITORIUM_TYPE like '��%'

select * from [���������]

insert [���������] values ('148-1', '148-1')
insert [���������] values ('141-1', '141-1')

drop view [���������]

---------4--------------------

create view [����������_���������]
as select AUDITORIUM.AUDITORIUM[��� ���������], AUDITORIUM.AUDITORIUM_TYPE[������������ ���������] 
from AUDITORIUM
where AUDITORIUM.AUDITORIUM_TYPE like '��%' with check option --���� �� �����. ��� where

insert [����������_���������] values ('120-1', '��')--��� group by, �����. �-��
insert [����������_���������] values ('130-1', '��')--� from - ������ 1 ������� 

select * from [����������_���������]
drop view [����������_���������]
---------5-------------------

create view [����������]
as select top(15) SUBJECT.SUBJECT[���], SUBJECT.SUBJECT_NAME[������������ ���������], SUBJECT.PULPIT[��� �������]
from SUBJECT 
order by SUBJECT.SUBJECT_NAME

select * from [����������]
drop view [����������]
---------6

alter view [���������� ������] with schemabinding --����. �� ����. ���. ����� ���. ���������
as select FACULTY.FACULTY_NAME[���������], count(PULPIT) [���-�� ������]
from dbo.FACULTY 
inner join dbo.PULPIT on FACULTY.FACULTY=PULPIT.FACULTY
group by FACULTY.FACULTY_NAME

select * from [���������� ������]
drop view [���������� ������]
