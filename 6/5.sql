use TAL_UNIVER

select * from FACULTY
where  exists (select * from PULPIT where FACULTY.FACULTY=PULPIT.FACULTY)

--������� ���� �� ���� �����������, ������� ������ �� �������

select * from FACULTY
where not exists (select * from PULPIT where FACULTY.FACULTY=PULPIT.FACULTY)
