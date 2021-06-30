use X_BSTU;

select
min(AUDITORIUM_CAPACITY) [Минимальная вместимость],
max(AUDITORIUM_CAPACITY) [Максимальная вместимость],
avg(AUDITORIUM_CAPACITY) [Средняя вместимость],
count(AUDITORIUM) [Количество аудиторий],
sum(AUDITORIUM_CAPACITY) [Вместимость всех аудиторий]
from AUDITORIUM 

select 
at.AUDITORIUM_TYPE  [Тип аудитории],
min(AUDITORIUM.AUDITORIUM_CAPACITY) [Минимальная вместимость],
max(AUDITORIUM.AUDITORIUM_CAPACITY) [Максимальная вместимость],
avg(AUDITORIUM.AUDITORIUM_CAPACITY) [Средняя вместимость],
sum(AUDITORIUM.AUDITORIUM_CAPACITY) [Сумма вместимости всех аудиторий],
count(at.AUDITORIUM_TYPENAME) [Количество аудиторий]
from AUDITORIUM  Inner Join  AUDITORIUM_TYPE at 
on AUDITORIUM.AUDITORIUM_TYPE = at.AUDITORIUM_TYPE  
and AUDITORIUM.AUDITORIUM_CAPACITY >= 30
group by at.AUDITORIUM_TYPE 


select *
from (select Case 
	when NOTE  between 1 and  5 then '1-5'
	when NOTE  between 5 and  7 then '5-7'
	when NOTE between 7 and  10  then '7-10'
	end  [Оценка], count(*) [Количество]
from PROGRESS 
group by Case 
   when NOTE  between 1 and  5 then '1-5'
   when NOTE  between 5 and  7 then '5-7'
   when NOTE between 7 and  10  then '7-10'
   end ) as T
order by  Case [Оценка]
   when '1-5' then 3
   when '5-7' then 2
   when '7-10' then 1
   else 0
   end  


--select f.FACULTY, g.PROFESSION, avg(p.NOTE) [AVG NOTE]
--from FACULTY f inner join GROUPS g on g.FACULTY = f.FACULTY, STUDENT s inner join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
--group by f.FACULTY, g.PROFESSION

select f.FACULTY, g.PROFESSION, avg(p.NOTE) [AVG NOTE]
from FACULTY f inner join GROUPS g on g.FACULTY = f.FACULTY inner join STUDENT s on s.IDGROUP = g.IDGROUP inner join PROGRESS p on p.IDSTUDENT = s.IDSTUDENT
group by f.FACULTY, g.PROFESSION

--комбинация в заданном порядке--
select f.FACULTY, PROFESSION, SUBJECT, avg(NOTE) [NOTE] 
from FACULTY f, GROUPS, STUDENT, PROGRESS 
where f.FACULTY in ('ТОВ')
group by rollup (f.FACULTY, PROFESSION, SUBJECT);


--любая возможная комбинация--
select f.FACULTY, PROFESSION, SUBJECT, avg(NOTE) [NOTE]
from FACULTY f, GROUPS, STUDENT, PROGRESS 
where f.FACULTY in ('ТОВ', 'ХТиТ')
group by cube (f.FACULTY, PROFESSION, SUBJECT);


--объединение--
SELECT f.FACULTY, PROFESSION, SUBJECT, avg(NOTE) 
FROM FACULTY f, GROUPS, STUDENT, PROGRESS  WHERE f.FACULTY='ТОВ' 
Group BY f.FACULTY, PROFESSION, SUBJECT
UNION
SELECT f.FACULTY, PROFESSION, SUBJECT, avg(NOTE) 
FROM FACULTY f, GROUPS, STUDENT, PROGRESS  WHERE f.FACULTY='ХТиТ' 
Group BY f.FACULTY, PROFESSION, SUBJECT
--пересечение--
SELECT f.FACULTY, PROFESSION, SUBJECT, avg(NOTE) 
FROM FACULTY f, GROUPS, STUDENT, PROGRESS  WHERE f.FACULTY='ТОВ' 
Group BY f.FACULTY, PROFESSION, SUBJECT
intersect 
SELECT f.FACULTY, PROFESSION, SUBJECT, avg(NOTE) 
FROM FACULTY f, GROUPS, STUDENT, PROGRESS  WHERE f.FACULTY='ХТиТ' 
Group BY f.FACULTY, PROFESSION, SUBJECT
--разность--
SELECT f.FACULTY, PROFESSION, SUBJECT, avg(NOTE) 
FROM FACULTY f, GROUPS, STUDENT, PROGRESS  WHERE f.FACULTY='ТОВ' 
Group BY f.FACULTY, PROFESSION, SUBJECT
EXCEPT 
SELECT f.FACULTY, PROFESSION, SUBJECT, avg(NOTE) 
FROM FACULTY f, GROUPS, STUDENT, PROGRESS  WHERE f.FACULTY='ХТиТ' 
Group BY f.FACULTY, PROFESSION, SUBJECT

--having вычисляется для каждой строки + агрегатные функции, в group by--
SELECT  p1.NOTE, 
(select  COUNT(NOTE)  from PROGRESS p2 
WHERE p2.NOTE = p1.NOTE)  [Количество студентов с такой оценкой]
FROM  PROGRESS p1 
GROUP BY  p1.NOTE
HAVING  NOTE like 8  or  NOTE like 9 

SELECT  p1.IDSTUDENT,  p1.NOTE, 
(select  COUNT(NOTE)  from PROGRESS p2 
WHERE p2.IDSTUDENT = p1.IDSTUDENT  
and  p2.NOTE = p1.NOTE)  [Количество]
FROM  PROGRESS p1 
GROUP BY  p1.IDSTUDENT,  p1.NOTE
HAVING  NOTE like 8  or  NOTE like 9 