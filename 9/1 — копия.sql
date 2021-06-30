use TAL_UNIVER

----------1

declare @a char = 'a1', 
@b varchar(50) = 'Artyom_FIT', 
@c datetime, 
@d time,
@e int,
@f smallint,
@g tinyint,
@h numeric(12, 5); 

set @c = getdate(); set @d=sysdatetime();   --��������� �������� set � ����������

set @e=(select count(*) from AUDITORIUM);

select @g=12, @h=2.55; --���� ����� ����� ��-�. 

select @a '@a char', @b '@b varchar(50)', @c '@c datetime', @g '@g tinyint';

print @d; 
print '@e int = ' + cast (@e as varchar(10));
print @f;
print '@h numeric(12, 5) = ' + cast(@h as varchar(10))

----------2

declare @total int, @countOfAudit numeric(8, 1), @AVGOfAudit numeric(8, 1), @countOfAuditSmall numeric(8, 1), @procent numeric(8, 1);

select @total = (select sum(AUDITORIUM_CAPACITY) from AUDITORIUM)

if @total>200
begin
select @countOfAudit = (select cast(count(*) as numeric(8, 1)) from AUDITORIUM);
select @AVGOfAudit = (select AVG(AUDITORIUM_CAPACITY) from AUDITORIUM);
select @countOfAuditSmall = (select cast(count(*) as numeric(8, 1)) from AUDITORIUM where AUDITORIUM_CAPACITY < @AVGOfAudit);
set @procent = @countOfAuditSmall/@countOfAudit*100;

select @total '����� �����������', @countOfAudit '���-�� ���������', @AVGOfAudit '������� �����������', 
@countOfAuditSmall '�����. � �����-��� ���., ��� �������', @procent '������� �����. � ���. �����-���'; 
end

else if @total<200 print '����� ����������� ������ 200 � ����� ' + cast(@total as varchar(10))

----------3
      --����. ����������
select @@ROWCOUNT [����� ������������ �����];
select @@VERSION [������ SQL Server];
select @@SPID [�����. ����. �����-��� ��������, ����������� �������� �������� �����������];
select @@ERROR [��� ��������� ������];
select @@SERVERNAME [��� �������];
select @@TRANCOUNT [�����. ��. ����������� ����������];
select @@FETCH_STATUS [�������� ���-�� ���������� ����� �������. ������];
select @@NESTLEVEL [�� ����������� �����. ���������]

----------4

declare @t float = 0.9, @x float = 0.4, @z numeric(8, 3) ;

if (@t>@x)
set @z = power(sin(@t), 2)
else if (@t<@x)
set @z = 4*(@t+@x)
else 
set @z = 1-exp(@x-2)

select @z '�������� z'

----------

--SUBSTRING(���������, ��������� �������, �����)
--CHARINDEX(������� ���������, ��������� ���������)
declare  @fio varchar(100) = '���������� ���� ����������'
select 
  SUBSTRING(@fio, 1, CHARINDEX(' ', @fio))
+ SUBSTRING(@fio, CHARINDEX(' ', @fio) + 1, 1) + '. '
+ SUBSTRING(@fio, CHARINDEX(' ', @fio, CHARINDEX(' ', @fio)+ 1 ) + 1, 1) + '.'

----------

select BDAY [���� ��������], NAME [���], YEAR(getdate())-YEAR(BDAY) [�������]
from STUDENT
where MONTH(BDAY)=MONTH(getdate()) + 1

----------

select STUDENT.NAME [���], STUDENT.IDGROUP [����� ������], datename(WEEKDAY ,DAY(PROGRESS.PDATE)) [����]
from STUDENT  
inner join PROGRESS on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
where  PROGRESS.SUBJECT = '����'
order by STUDENT.NAME 
----------------



----------5

declare @kolAudit0 int, @kolAudit90 int;
set @kolAudit0 = (select count(*) from AUDITORIUM where AUDITORIUM_CAPACITY<60); 
set @kolAudit90 = (select count(*) from AUDITORIUM where AUDITORIUM_CAPACITY>60); 

if (@kolAudit0>@kolAudit90)
print '����������� ��������� ��� ������'
else if (@kolAudit0<@kolAudit90)
print '����������� ��������� ��� �������'
else 
print '���������� ��������� ��� ����� � ��� ������� ���������'

----------6

select case
when NOTE in(4,5) then '�������'
when NOTE in(6,7) then '���� ��������'
when NOTE in(8,9) then '�������'
when NOTE = 10 then '����� �������'
else '������'
end [������� ������], count(*) [���������� ��������� ����������]
from PROGRESS

group by case 
when NOTE in(4,5) then '�������'
when NOTE in(6,7) then '���� ��������'
when NOTE in(8,9) then '�������'
when NOTE=10 then '����� �������'
else '������'
end

----------7

create table #color (id int identity(1,1), kind varchar(100), cost int);

declare @i int = 0, @kind varchar(100) = '***', @cost float = 25;

while @i < 10
begin
insert #color(kind,cost) values (@kind, @cost);
set @kind = @kind + '***';
set @i = @i + 1;
set @cost = @cost*1.1;
end

select * from #color 

drop table #color

----------8
--�������� RETURN ������ ��� ������������ ���������� ������ ������
create table #color (id int identity(1,1), kind varchar(100), cost int);

declare @i int = 0, @kind varchar(100) = '***', @cost float = 25;

while @i < 10
begin
insert #color(kind,cost) values (@kind, @cost);
set @kind = @kind + '***';

if @i=6

begin
select * from #color 
return
end
else

begin
set @i = @i + 1;
set @cost = @cost*1.1;
end

end

select * from #color 

drop table #color

----------9

declare @num1 int = 10, @num2 int = 0, @del float;

begin try 
set @del=@num1/@num2;
print '������� �����������';
end try

begin catch 
print error_number();
print error_message();
print error_line();
print error_procedure();--��� �������� ��������� ��� ��������, � ������� ��������� ������.
print error_severity();--���������� �������� ����������� ������, ��������� ���������� ����� CATCH.
print error_state();--���������� ����� ��������� ��� ������
end catch