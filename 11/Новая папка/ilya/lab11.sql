use TAL_UNIVER;

--������� 1

select * from SUBJECTS;

declare @tsub char(70) = '', @sub char(400) = '';
declare isitsubs cursor
	for select SUBJECTS_NAME from SUBJECTS where PULPIT = '��';

open isitsubs
fetch isitsubs into @tsub
print '�������� ���������: '
while @@fetch_status = 0
	begin 
	set @sub = rtrim(@tsub) + ',' +  @sub
	fetch isitsubs into @tsub
	end;
print @sub
close isitsubs;


--������� 2 Local/global

select * from GROUPS;

declare groups1 cursor local 
	for select IDGROUP, FACULTY from GROUPS;

declare @gid int, @fac char(10);

open groups1
fetch groups1 into @gid, @fac
print '1.'+ cast(@gid as varchar(10)) + '/' + @fac;
go
--���������� ������: A cursor with the name 'groups1' does not exist
declare @gid int, @fac char(10);
fetch groups1 into @gid, @fac
print '2.'+ cast(@gid as varchar(10)) + '/' + @fac;
go


declare groups2 cursor global 
	for select IDGROUP, FACULTY from GROUPS;

declare @gid int, @fac char(10);

open groups2
fetch groups2 into @gid, @fac
print '1.'+ cast(@gid as varchar(10))+ '/' + @fac;
go
declare @gid int, @fac char(10);
fetch groups2 into @gid, @fac
print '2.'+ cast(@gid as varchar(10))+ '/' + @fac;
go


--������� 3 static/dynamic

select * from PROFESSION;

declare @prof char(20), @profname char(70), @qual char(40);
declare professions cursor local static 
	for select PROFESSION, PROFESSION_NAME, QUALIFICATION from PROFESSION where QUALIFICATION like '%��������%';

open professions
print '���������� �����: ' + cast(@@cursor_rows as varchar(5))
delete PROFESSION where QUALIFICATION = '�������-�����-��������'
fetch professions into @prof, @profname, @qual
while @@FETCH_STATUS = 0
	begin 
	print @prof + '' + @profname + '' + @qual
	fetch professions into @prof, @profname, @qual
	end;
close professions;
go

select * from PROFESSION;


declare @prof char(20), @profname char(70), @qual char(40);
declare professions cursor local dynamic 
	for select PROFESSION, PROFESSION_NAME, QUALIFICATION from PROFESSION where QUALIFICATION like '%��������%';

open professions
print '���������� �����: ' + cast(@@cursor_rows as varchar(5))
insert into PROFESSION(PROFESSION,FACULTY,PROFESSION_NAME,QUALIFICATION)
	values('1-34 01 01', '����', '������������ �����', '�������-�����-��������'),
		  ('1-34 01 02', '����', '�������������� �����', '�������-�����-��������')
fetch professions into @prof, @profname, @qual
while @@FETCH_STATUS = 0
	begin 
	print @prof + '' + @profname + '' + @qual
	fetch professions into @prof, @profname, @qual
	end;
close professions;
go

--������� 4 ���������

select * from PROFESSION;


declare @profname char(70), @prof char(20), @qual char(40);
declare professions cursor local dynamic scroll
	for select row_number() over (order by PROFESSION_NAME) N, PROFESSION, QUALIFICATION from dbo.PROFESSION;

open professions
fetch first from professions into @profname, @prof, @qual
print '������ ������: ' + @profname + '' + @prof + '' + @qual
fetch next from professions into @profname, @prof, @qual
print '��������� ������: ' + @profname + '' + @prof + '' + @qual
fetch absolute 4 from professions into @profname, @prof, @qual
print '�������� ������ �� ������: ' + @profname + '' + @prof + '' + @qual
fetch prior from professions into @profname, @prof, @qual
print '���������� ������, �.�. 3-��: ' + @profname + '' + @prof + '' + @qual
fetch relative -2 from professions into @profname, @prof, @qual
print '������ ������ �� �������, �.�. 1-��: ' + @profname + '' + @prof + '' + @qual
close professions;
go


--������� 5 

select * from PROFESSION;


declare @profname char(70), @prof char(20), @qual char(40);
declare professions cursor local dynamic
	for select  PROFESSION_NAME, PROFESSION, QUALIFICATION from PROFESSION for update;

open professions
fetch professions into @profname, @prof, @qual
delete PROFESSION where current of professions
fetch professions into @profname, @prof, @qual
update PROFESSION set PROFESSION = '1-34 01 03' where current of professions
close professions;
go


--������� 6

--��������
select * from GROUPS;
select * from STUDENT;
select * from PROGRESS;

declare @grid int, @studn char(70), @note int;
declare  students cursor local dynamic
	for select GROUPS.IDGROUP, STUDENT.STUDENT_NAME, PROGRESS.NOTE 
	from GROUPS inner join STUDENT 
	on GROUPS.IDGROUP = STUDENT.IDGROUP inner join PROGRESS
	on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
	where PROGRESS.NOTE < 4 
	for update;

open students
fetch students into @grid, @studn, @note
while @@fetch_status = 0
	begin
	delete PROGRESS where current of students
	fetch students into @grid, @studn, @note
	end;
close students;

insert into PROGRESS(SUBJECTS,IDSTUDENT,PDATE,NOTE)
	values('��', 1000, '2021-02-24', 1),
		  ('��', 1001, '2021-02-25', 2),
		  ('��', 1002, '2021-02-26', 3);
go

--���������
declare @grid int, @studn char(70), @note int;
declare  students cursor local dynamic
	for select GROUPS.IDGROUP, STUDENT.STUDENT_NAME, PROGRESS.NOTE 
	from GROUPS inner join STUDENT 
	on GROUPS.IDGROUP = STUDENT.IDGROUP inner join PROGRESS
	on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT
	where  STUDENT.IDSTUDENT = 1006
	for update;

open students
fetch students into @grid, @studn, @note
update PROGRESS set NOTE = NOTE + 1 where current of students
close students;

select * from PROGRESS;


--������� 8

select * from FACULTY;
select * from PULPIT;
select * from TEACHER;
select * from SUBJECTS;

--declare @fac char(10), @pul char(10), @countt int, @subs char(50);
--declare information cursor local static
--	for select FACULTY.FACULTY, PULPIT.PULPIT, count(TEACHER), SUBJECTS.SUBJECTS
--	from FACULTY full outer join PULPIT
--	on FACULTY.FACULTY = PULPIT.FACULTY full outer join TEACHER
--	on PULPIT.PULPIT = TEACHER.PULPIT full outer join SUBJECTS
--	on TEACHER.PULPIT = SUBJECTS.PULPIT
--	group by FACULTY.FACULTY, PULPIT.PULPIT, SUBJECTS.SUBJECTS;

--open information 
--fetch information into @fac, @pul, @countt, @subs
--while @@fetch_status = 0 
--	begin
--	print @fac + '' + @pul + '' + cast(@countt as varchar(10)) + ' ' + @subs
--	fetch information into @fac, @pul, @countt, @subs
--	end;
--close information;
--go

declare @fac char(10), @pul char(10), @subs char(50);
declare information cursor local static
	for select FACULTY.FACULTY, PULPIT.PULPIT, isnull(SUBJECTS.SUBJECTS, '���') 
	from FACULTY inner join PULPIT
	on FACULTY.FACULTY = PULPIT.FACULTY left outer join SUBJECTS
	on PULPIT.PULPIT = SUBJECTS.PULPIT
	order by FACULTY.FACULTY, PULPIT.PULPIT, SUBJECTS;

open information
fetch information into @fac, @pul, @subs
while @@fetch_status = 0
	begin
	print @fac + '' + @pul + '' + @subs
	fetch information into @fac, @pul, @subs
	end;
close information;

declare @fx char(10) = '###', @px char(10) = '###', @cs int = 0, @sx char(100) = '';

open information
fetch information into @fac, @pul, @subs
while @@fetch_status = 0
begin
	
	if(@fx != @fac)
	begin
	set @fx = @fac;
	print '���������: ' + @fx
	end;
	if(@px != @pul)
	begin
	set @px = @pul
	print '   �������: ' + @px
	set @cs = (select count(*) from TEACHER where PULPIT = @px)
	print '     ���������� ��������������: ' + cast(@cs as varchar(10))
	print '     ����������: '
	end;
	if(@fx != '###' )
	begin
	set @sx = substring(@subs,1,len(@subs)) + ','
	print '     ' + @sx
	set @sx = ''
	end;

set @sx = @sx + rtrim(@subs) + ', '
fetch information into @fac, @pul, @subs
end;
close information;
go
