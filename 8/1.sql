use TAL_UNIVER

---------1-----------------

create view [Преподователь]
as select TEACHER[Код преподавателя], TEACHER_NAME[Имя], GENDER[Пол], PULPIT[Кафедра]
from TEACHER

select * from [Преподователь]

select * from [Преподователь] order by [Кафедра]
drop view [Преподователь]
---------2--------------------

create view [Количество кафедр]
as select FACULTY.FACULTY_NAME[Факультет], count(PULPIT) [Кол-во кафедр]
from FACULTY 
inner join PULPIT on FACULTY.FACULTY=PULPIT.FACULTY
group by FACULTY.FACULTY_NAME--запрос не должен содержать секцию группировки чтобы insert update delete

select * from [Количество кафедр]
--drop view [Количество кафедр]
---------3-------------------

create view [Аудитории]
as select AUDITORIUM.AUDITORIUM[Код аудитории], AUDITORIUM.AUDITORIUM_NAME[Наименование] 
from AUDITORIUM--1t
where AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%'

select * from [Аудитории]

insert [Аудитории] values ('148-1', '148-1')
insert [Аудитории] values ('141-1', '141-1')

drop view [Аудитории]

---------4--------------------

create view [Лекционные_аудитории]
as select AUDITORIUM.AUDITORIUM[Код аудитории], AUDITORIUM.AUDITORIUM_TYPE[Наименование аудитории] 
from AUDITORIUM
where AUDITORIUM.AUDITORIUM_TYPE like 'ЛК%' with check option --если не удовл. усл where

insert [Лекционные_аудитории] values ('120-1', 'ЛК')--нет group by, агрег. ф-ии
insert [Лекционные_аудитории] values ('130-1', 'ЛБ')--в from - только 1 таблица 

select * from [Лекционные_аудитории]
drop view [Лекционные_аудитории]
---------5-------------------

create view [Дисциплины]
as select top(15) SUBJECT.SUBJECT[Код], SUBJECT.SUBJECT_NAME[Наименование дисципины], SUBJECT.PULPIT[Код кафедры]
from SUBJECT 
order by SUBJECT.SUBJECT_NAME

select * from [Дисциплины]
drop view [Дисциплины]
---------6

alter view [Количество кафедр] with schemabinding --запр. на опер. кот. наруш раб. представл
as select FACULTY.FACULTY_NAME[Факультет], count(PULPIT) [Кол-во кафедр]
from dbo.FACULTY 
inner join dbo.PULPIT on FACULTY.FACULTY=PULPIT.FACULTY
group by FACULTY.FACULTY_NAME

select * from [Количество кафедр]
drop view [Количество кафедр]
