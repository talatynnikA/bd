--������ �������� ����������� ������������, ������� ���� ����������� ������������ ������������ ������ �����������-���� ������ ������ �� �������. 
--������� ������ ��������� � ���������� (�� ���������), ����������� � ������������ (�� ���������). 
--������� 1
use TAL_UNIVER
declare @tv char(20) , @t char(300) = ' '; --� ������� ����������� ������ 
declare cursor1 cursor for select SUBJECT from SUBJECT where PULPIT = '����';

open cursor1; --�������� ������� 
fetch cursor1 into @tv;--�������� FETCH ��������� ���� ������ �� ��������������� ������ � ���������� ��������� �� ��������� ������
--���-�� ���������� ����� INTO  ����� ���-�� �������� ��������������� ������, � �������=������� ������������ �������� � SELECT-������
print '���������� �� ������� ����';
while @@fetch_status = 0 --����������� �������� �������� 
begin 
set @t = rtrim(@tv) + ',' + @t;
fetch cursor1 into @tv;
end;

print @t
close cursor1; ---�������� �������



--������� 2
--��������� ������ ����������� � ������ 1 ������ � �������, ����-������ ��� ��� ����������, ������������� ����� ����� ���������� ������ ������.
declare cursor2_1 cursor local for select AUDITORIUM_CAPACITY, AUDITORIUM_NAME from AUDITORIUM;
declare @capacity int, @name char(10);
open cursor2_1;
fetch cursor2_1 into @capacity, @name;
print '1.' + ' ' + cast(@capacity as varchar(6)) + ' ' + @name;
go 
declare @capacity int, @name char(10);
fetch cursor2_1 into @capacity, @name;
print '2.' + cast(@capacity as varchar(6)) + @name;
go

---���������� ������ ����� ���� ��������, ������ � ����������� � ������ �������.
declare cursor2_2 cursor global for select AUDITORIUM_CAPACITY, AUDITORIUM_NAME from AUDITORIUM;
declare @capacity1 int, @name1 char(10);
open cursor2_2;
fetch cursor2_2 into @capacity1, @name1;
print '1.' + ' ' + cast(@capacity1 as varchar(6)) + ' ' + @name1;
go 
declare @capacity1 int, @name1 char(10);
fetch cursor2_2 into @capacity1, @name1;
print '2.' + ' ' + cast(@capacity1 as varchar(6)) + ' ' + @name1;
close cursor2_2;
deallocate cursor2_2; ---���������� ���������� ���������� �������
go

--������� 3

declare @subject char(5), @idstudent char(4), @note char(1);
declare cursor3_1 cursor local static for select SUBJECT, IDSTUDENT, NOTE from PROGRESS where SUBJECT = '����'
open cursor3_1;
print '���������� �����: ' + cast(@@cursor_rows as varchar(5)); --� ������ ���� ����������� ���-�� �������
update PROGRESS set NOTE = 5 where	SUBJECT = '����';
delete PROGRESS where SUBJECT = '����';	
insert PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
    values('���', 1025, '2020-01-01', 6)
fetch cursor3_1 into @subject, @idstudent, @note;
while @@fetch_status = 0 
begin 
print @subject + ' ' + @idstudent + ' ' + @note;
fetch cursor3_1 into @subject, @idstudent, @note;
end;
close cursor3_1;

declare @subject1 char(5), @idstudent1 char(4), @note1 char(1);
declare cursor3_2 cursor local dynamic for select SUBJECT, IDSTUDENT, NOTE from PROGRESS where SUBJECT = '����'
open cursor3_2;
print '���������� �����: ' + cast(@@cursor_rows as varchar(5));
update PROGRESS set NOTE = 6 where	SUBJECT = '����';
delete PROGRESS where SUBJECT = '����';	
insert PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
    values('���', 1025, '2020-01-01', 6)
fetch cursor3_2 into @subject1, @idstudent1, @note1;
while @@fetch_status = 0 
begin 
print @subject1 + ' ' + @idstudent1 + ' ' + @note1;
fetch cursor3_2 into @subject1, @idstudent1, @note1;
end;
close cursor3_2;


--������� 4
use TAL_UNIVER;
declare @tc int, @rn char(50);
declare cursor4 cursor local dynamic scroll for --������ ��������� ��������� �������� FETCH � ��������������� ������� ����������������. 
select row_number() over(order by SUBJECT) N, SUBJECT from SUBJECT where PULPIT = '����';
open cursor4;
fetch cursor4 into @tc, @rn;
print '��������� ������: ' + cast(@tc as varchar(6)) + ' ' + rtrim(@rn);
fetch last from cursor4 into @tc, @rn;
print '��������� ������: ' + cast(@tc as varchar(6)) + ' ' + rtrim(@rn);
fetch first from cursor4 into @tc, @rn;
print '������ ������: ' + cast(@tc as varchar(6)) + ' ' + rtrim(@rn);
fetch next from cursor4 into @tc, @rn;
print '��������� ������ �� �������: ' + cast(@tc as varchar(6)) + ' ' + rtrim(@rn);
fetch prior from cursor4 into @tc, @rn;
print '���������� ������ �� �������: ' + cast(@tc as varchar(6)) + ' ' + rtrim(@rn);
fetch absolute 3 from cursor4 into @tc, @rn;
print '������ ������ �� ������: ' + cast(@tc as varchar(6)) + ' ' + rtrim(@rn);
fetch absolute -3 from cursor4 into @tc, @rn;
print '������ ������ �� �����: ' + cast(@tc as varchar(6)) + ' ' + rtrim(@rn);
fetch relative 5 from cursor4 into @tc, @rn;
print '����� ������ ������ �� �������: ' + cast(@tc as varchar(6)) + ' ' + rtrim(@rn);
fetch relative -5 from cursor4 into @tc, @rn;
print '����� ������ ����� �� �������: ' + cast(@tc as varchar(6)) + ' ' + rtrim(@rn);
close cursor4;


--������� 5
declare @s char(10), @p char(10), @n varchar(200);
declare cursor5_1 cursor local dynamic scroll for
select SUBJECT, PULPIT, SUBJECT_NAME from SUBJECT
open cursor5_1;
fetch cursor5_1 into @s, @p, @n
while @@fetch_status = 0
 begin
   if @s = '��' update SUBJECT set SUBJECT_NAME = '����� ������ ����������!!!' where current of cursor5_1 

   fetch cursor5_1 into @s, @p, @n  
 end
fetch first from cursor5_1 into @s, @p, @n
print '���������� ������: ' + rtrim(@s) + ' | ' + rtrim(@p) + ' | ' + rtrim(@n);
close cursor5_1
go

declare @a1 char(5), @b1 char(5), @c1 char(15), @d1 char(2);
declare cursor5_2 cursor local dynamic scroll for 
select SUBJECT, IDSTUDENT, PDATE, NOTE from PROGRESS
open cursor5_2;
fetch cursor5_2 into @a1, @b1, @c1, @d1
while @@fetch_status = 0 
 begin
  if @d1 = '5' delete PROGRESS where current of cursor5_2
  fetch cursor5_2 into @a1, @b1, @c1, @d1
 end
close cursor5_2;
go

--������� 6
declare @id char(4), @note char(1); 
declare cursor6 cursor local for 
select s.IDSTUDENT, p.NOTE from STUDENT s inner join  PROGRESS p
on s.IDSTUDENT = p.IDSTUDENT

open cursor6;
fetch cursor6 into @id, @note;
while @@fetch_status = 0
 begin
  if @note < 7 delete PROGRESS where current of cursor6
  if @id = '1025' update PROGRESS set NOTE += 1 where current of cursor6
  fetch cursor6 into @id, @note;
 end
close cursor6;
go

