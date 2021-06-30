use TAL_UNIVER

select * from FACULTY
where  exists (select * from PULPIT where FACULTY.FACULTY=PULPIT.FACULTY)

--кафедры есть на всех факультетах, поэтому ничего не выводит

select * from FACULTY
where not exists (select * from PULPIT where FACULTY.FACULTY=PULPIT.FACULTY)
