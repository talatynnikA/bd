use TAL_UNIVER

--------------------------------------1

select min(AUDITORIUM_CAPACITY) [Минимальная вместимость],
max(AUDITORIUM_CAPACITY) [Максимальная вместимость],
count(*) [Количество аудиторий],
sum(AUDITORIUM_CAPACITY) [Суммарная вместимость],
avg(AUDITORIUM_CAPACITY) [Средняя вместимость]
from AUDITORIUM 

--------------------------------------2

select AUDITORIUM_TYPE.AUDITORIUM_TYPENAME, 
min(AUDITORIUM_CAPACITY) [Минимальная вместимость],
max(AUDITORIUM_CAPACITY) [Максимальная вместимость],
count(*) [Количество аудиторий],
sum(AUDITORIUM_CAPACITY) [Суммарная вместимость],
avg(AUDITORIUM_CAPACITY) [Средняя вместимость]
from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM_TYPE.AUDITORIUM_TYPE=AUDITORIUM.AUDITORIUM_TYPE
group by AUDITORIUM_TYPE.AUDITORIUM_TYPENAME

--------------------------------------3

select * from 
(select case 
when PROGRESS.NOTE between 4 and 5 then '4-5'
when PROGRESS.NOTE between 6 and 7 then '6-7'
when PROGRESS.NOTE between 8 and 9 then '8-9'
else '10' 
end [Оценка], 
count(*) [Количество]
from PROGRESS group by case 
when PROGRESS.NOTE between 4 and 5 then '4-5'
when PROGRESS.NOTE between 6 and 7 then '6-7'
when PROGRESS.NOTE between 8 and 9 then '8-9'
else '10' end) as T
order by case [Оценка]
when '4-5' then 1
when '6-7' then 2
when '8-9' then 3
when '10' then 4 
end

--------------------------------------4

select FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.IDGROUP, round(avg(cast(PROGRESS.NOTE as float(4))),2)[Средняя оценка]
from FACULTY 
inner join GROUPS on FACULTY.FACULTY = GROUPS.FACULTY
inner join STUDENT on STUDENT.IDGROUP = GROUPS.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
group by FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.IDGROUP
order by [Средняя оценка] desc

---------------------------------------

select FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.IDGROUP, round(avg(cast(PROGRESS.NOTE as float(4))),2)[Средняя оценка]
from FACULTY 
inner join GROUPS on FACULTY.FACULTY = GROUPS.FACULTY
inner join STUDENT on STUDENT.IDGROUP = GROUPS.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where PROGRESS.SUBJECT like 'ОАиП' or PROGRESS.SUBJECT like 'СУБД'
group by FACULTY.FACULTY, GROUPS.PROFESSION, GROUPS.IDGROUP
order by [Средняя оценка] desc

--------------------------------------5

select FACULTY.FACULTY, GROUPS.PROFESSION,  PROGRESS.SUBJECT, avg(PROGRESS.NOTE)[Средняя оценка]
from FACULTY 
inner join GROUPS on FACULTY.FACULTY = GROUPS.FACULTY
inner join STUDENT on STUDENT.IDGROUP = GROUPS.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where FACULTY.FACULTY like 'ИДиП'
group by FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT

---------------------------------------

select FACULTY.FACULTY, GROUPS.PROFESSION,  PROGRESS.SUBJECT, avg(PROGRESS.NOTE)[Средняя оценка]
from FACULTY 
inner join GROUPS on FACULTY.FACULTY = GROUPS.FACULTY
inner join STUDENT on STUDENT.IDGROUP = GROUPS.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where FACULTY.FACULTY like 'ИДиП'
group by rollup (FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT)

--------------------------------------6

select FACULTY.FACULTY, GROUPS.PROFESSION,  PROGRESS.SUBJECT, avg(PROGRESS.NOTE)[Средняя оценка]
from FACULTY 
inner join GROUPS on FACULTY.FACULTY = GROUPS.FACULTY
inner join STUDENT on STUDENT.IDGROUP = GROUPS.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where FACULTY.FACULTY like 'ИДиП'
group by cube (FACULTY.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT)

--------------------------------------7

select GROUPS.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE)[Средняя оценка] 
from GROUPS, PROGRESS
where GROUPS.FACULTY='ТОВ'
group by GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY
union 
select GROUPS.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE)[Средняя оценка] 
from GROUPS, PROGRESS
where GROUPS.FACULTY='ХТиТ'
group by GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY

select GROUPS.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE)[Средняя оценка] 
from GROUPS, PROGRESS
where GROUPS.FACULTY='ТОВ'
group by GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY
union all
select GROUPS.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE)[Средняя оценка] 
from GROUPS, PROGRESS
where GROUPS.FACULTY='ХТиТ'
group by GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY

--------------------------------------8 (пересечения нет)

select GROUPS.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE)[Средняя оценка] 
from GROUPS, PROGRESS
where GROUPS.FACULTY='ТОВ'
group by GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY
intersect
select GROUPS.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE)[Средняя оценка] 
from GROUPS, PROGRESS
where GROUPS.FACULTY='ХТиТ'
group by GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY

--------------------------------------9 (берет те строки из 1ой, которых нет во 2ой)

select GROUPS.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE)[Средняя оценка] 
from GROUPS, PROGRESS
where GROUPS.FACULTY='ТОВ'
group by GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY
except
select GROUPS.FACULTY, GROUPS.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE)[Средняя оценка] 
from GROUPS, PROGRESS
where GROUPS.FACULTY='ХТиТ'
group by GROUPS.PROFESSION, PROGRESS.SUBJECT, GROUPS.FACULTY

-------------------------------------10

select SUBJECT.SUBJECT_NAME, count(*)[Количество студентов]
from SUBJECT 
inner join PROGRESS on PROGRESS.SUBJECT= SUBJECT.SUBJECT
group by SUBJECT.SUBJECT_NAME, PROGRESS.NOTE
having PROGRESS.NOTE in (8,9)