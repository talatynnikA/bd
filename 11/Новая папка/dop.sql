use TAL_UNIVER

declare kurs cursor local for  select FACULTY.FACULTY, PULPIT.PULPIT, isnull(SUBJECT.SUBJECT, '���') 
from FACULTY 
join PULPIT on FACULTY.FACULTY = PULPIT.FACULTY 
left outer join SUBJECT on PULPIT.PULPIT = SUBJECT.PULPIT
order by  FACULTY.FACULTY, PULPIT.PULPIT, SUBJECT.SUBJECT;

declare @a1 varchar(50), @a11 varchar(50) = '###', @a2 varchar(50), @a22 varchar(50) = '###', @a3 varchar(100), @a33 varchar(200) = '', @a44 int = 0;  

open kurs 
fetch kurs into @a1, @a2, @a3;
print @a1 + @a2 + @a3
while @@FETCH_STATUS = 0
begin 
if(@a11 != '###' and  (@a11 != @a1 or @a22 != @a2))
begin
set @a33 =  SUBSTRING(@a33, 1, LEN(@a33)-1) + '.';--���������� �������� ���������� ���������� ��������� �������� �������� �������
print '     ����������: ' + @a33;--��������� ������� �� ��������� ��� ����� �������� �����
set @a33 = '';
end;
if(@a11 != @a1) 
begin
select @a11 = @a1;
print '���������: ' + @a11 
end;
if(@a22 != @a2) 
begin 
set @a22 = @a2;  
print '   �������:' + @a22; 
set @a44 = (select count(*) from TEACHER where PULPIT = @a22);
print '     ���������� ��������������: ' + cast(@a44 as varchar(10)); 
end;
set @a33 = @a33 + rtrim(@a3) + ', ';--������� ������� �������
fetch kurs into @a1, @a2, @a3;
print @a1 + @a2 + @a3 --����
end;
close kurs;    
go