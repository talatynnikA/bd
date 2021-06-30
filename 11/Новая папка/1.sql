use TAL_UNIVER

----------1

declare @sb char(20), @t char(300) = '';
declare IsitSB cursor for select SUBJECT from SUBJECT
open IsitSB;
fetch IsitSB into @sb;
while @@FETCH_STATUS=0
begin 
set @t = rtrim(@sb) + ', ' + @t;
fetch IsitSB into @sb;
end;
print @t;
close IsitSB

deallocate IsitSB

----------2

declare subj cursor local for select SUBJECT from SUBJECT;
declare @sb2 char(20), @t2 char(300)='';
open subj 
fetch subj into @sb2;
print '1. ' + @sb2;
go
declare @sb2 char(20), @t2 char(300)='';
fetch subj into @sb2;
print '2. ' + @sb2;
go

declare subj cursor global for select SUBJECT from SUBJECT;
declare @sb2 char(20), @t2 char(300)='';
open subj 
fetch subj into @sb2;
print '1. ' + @sb2;
go
declare @sb2 char(20), @t2 char(300)='';
fetch subj into @sb2;
print '2. ' + @sb2;
close subj;
deallocate subj;
go

----------3

declare cursor3 cursor for select SUBJECT from SUBJECT
open cursor3
print   'Количество строк : '+cast(@@CURSOR_ROWS as varchar(5)); 
close cursor3
go

deallocate cursor3


declare cursor31 cursor local static for select SUBJECT from SUBJECT
open cursor31
print   'Количество строк : '+cast(@@CURSOR_ROWS as varchar(5)); 
close cursor31

----------4

declare @a int, @rn char(20);
declare cursor4 cursor local dynamic scroll for select ROW_NUMBER() over (order by SUBJECT) namess, SUBJECT FROM SUBJECT
open cursor4
fetch cursor4 into @a, @rn;
print 'следующая строка: ' + cast(@a as varchar(3)) + ' ' + rtrim(@rn);

fetch last from cursor4 into  @a, @rn;
print 'последняя строка: ' + cast(@a as varchar(3)) + ' ' + rtrim(@rn);

fetch first from cursor4 into  @a, @rn;
print 'первая строка: ' + cast(@a as varchar(3)) + ' ' + rtrim(@rn);

fetch absolute 3 from cursor4 into  @a, @rn;
print 'третья срока от начала: ' + cast(@a as varchar(3)) + ' ' + rtrim(@rn);

close cursor4

----------5

insert into  TEACHER    (TEACHER,   TEACHER_NAME, GENDER, PULPIT )
values  ('ХРТНВЧ',    'Хартанович Алина Александровна', 'ж',  'ИСиТ');

declare @a1 char(50), @a2 char(10);
declare cursor5 cursor local dynamic for select TEACHER.TEACHER_NAME, TEACHER.PULPIT 
from TEACHER 
where TEACHER.TEACHER='ХРТНВЧ' for update
open cursor5
fetch cursor5 into @a1, @a2
delete TEACHER where current of cursor5
close cursor5

select * from TEACHER

----------6

declare @sn char(50), @g int, @nt int;
declare cursor6 cursor local dynamic for select GROUPS.IDGROUP, STUDENT.NAME, PROGRESS.NOTE 
from PROGRESS 
inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
inner join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP 
where PROGRESS.NOTE < 4 for update
open cursor6
fetch cursor6 into @g, @sn, @nt
delete PROGRESS where current of cursor6
close cursor6;

select * from PROGRESS

----------

declare @sn1 char(50), @g1 int, @nt1 int;
declare cursor61 cursor local dynamic for select GROUPS.IDGROUP, STUDENT.NAME, PROGRESS.NOTE 
from PROGRESS 
inner join STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
inner join GROUPS on STUDENT.IDGROUP = GROUPS.IDGROUP 
where PROGRESS.IDSTUDENT = 1019 for update
open cursor61
fetch cursor61 into @g1, @sn1, @nt1
update PROGRESS set NOTE = NOTE + 1 where current of cursor61
close cursor61;

select * from PROGRESS

insert into PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
    values   ('СУБД', 1000,  '01.12.2013',1),
           ('СУБД', 1001,  '01.12.2013',2),
           ('СУБД', 1002,  '01.12.2013',3),
           ('СУБД', 1003,  '01.12.2013',1)
