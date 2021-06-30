use TAL_UNIVER;


--������� 1--��������� ��� ����������
select * from SUBJECT;
go
create procedure PSUBJECT
as
	begin 
	declare @count int = (select count(*) from SUBJECT)
	select * from SUBJECT
	return @count
	end;
go
declare @k int = 0;
exec @k = PSUBJECT; --����� ���������
print '���-�� ��������� = ' + cast(@k as varchar(5));



--������� 2-- �������� �������� ������� 1
go
alter procedure PSUBJECT @p varchar(20) null, @c int output
as begin
	declare @count int = (select count(*) from SUBJECT)
	print '��������� @p = ' + @p + ', @c = ' + cast(@c as varchar(5))
	select * from SUBJECT where PULPIT = @p;
	set @c = @@rowcount
	return @count --��-� � ����� ������
	end;

go
declare @k int = 0, @r int = 0, @p varchar(20) = '��';
exec @k = PSUBJECT @p, @c = @r output;
print '���-�� ��������� ����� = ' + cast(@k as varchar(5))
print '���-�� ��������� �� ������� �� = ' + cast(@r as varchar(5));



--������� 3 --��������� ��� ��������� ���������, ��������� ������� � ���. ������� PSUBJECT
select * from SUBJECT;

go
alter procedure PSUBJECT @p varchar(20)
as begin
	declare @count int = (select count(*) from SUBJECT)
	select * from SUBJECT where PULPIT = @p
	end;
go
create table #TSUBJECT
(
	SUBJECT char(10) not null,
	SUBJECT_name varchar(100) null,
	pulpit char(20) not null
)

insert into #TSUBJECT exec PSUBJECT @p = '��';
select * from #TSUBJECT;



--������� 4--��������� � try/catch � ��-� �������� �������� �����������
select * from AUDITORIUM;

go
create procedure PAUDITORIUM_INSERT @a char(20), @at char(10), @ac int null, @an varchar(50) null
as declare @rc int = 1
begin try
	insert into AUDITORIUM(AUDITORIUM,AUDITORIUM_TYPE,AUDITORIUM_CAPACITY,AUDITORIUM_NAME)
	values (@a, @at, @ac, @an)
	return @rc -- 1 ���� �������
end try
begin catch --��������� ������
	print '����� ������: ' + cast(error_number() as varchar(6))
	print '���������: ' + error_message()
	print '�������: ' + cast(error_severity() as varchar(6))
	print '�����: ' + cast(error_state() as varchar(8))
	print '����� ������: ' + cast(error_line() as varchar(8))

	if error_procedure() is not null 
	print '��� ���������: ' + error_procedure()
	set @rc = -1
	return @rc
end catch;


go
declare @rc int;
exec @rc = PAUDITORIUM_INSERT @a = '999-9', @at = '��', @ac = 30, @an = '999-9';
if @rc = -1
	print '��� ������: ' + cast(@rc as varchar(3))
else print '��������� ��� ������';

select * from AUDITORIUM;

delete from AUDITORIUM where AUDITORIUM = '999-9';

drop procedure PAUDITORIUM_INSERT;



--������� 5--����� �� ������� ���������
select * from SUBJECT;

go
create procedure PSUBJECT_REPORT @p char(10)
as declare @rc int = 0
begin try 
	declare @sv char(20), @s char(300) = '';
	declare Cursor_SUBJECT cursor for
	select SUBJECT from SUBJECT where PULPIT = @p

	if not exists(select SUBJECT from SUBJECT where PULPIT = @p)
		raiserror('������',11,1) --��������� � ��������� ���� �������� ������� ���
	else
		open Cursor_SUBJECT;

	fetch Cursor_SUBJECT into @sv;
	print '�������� �� ������� ' + @p
	while @@fetch_status = 0 
		begin
		set @s = rtrim(@sv) + ',' + @s
		set @rc = @rc + 1;
		fetch Cursor_SUBJECT into @sv;
		end;
	print @s;
	close Cursor_SUBJECT
	return @rc;
end try
begin catch
	print '������ � ����������' --���� ��� ���� �������
	if error_procedure() is not null
		print '��� ���������: ' + error_procedure()
	return	@rc
end catch;

go
declare @rc int;
exec @rc = PSUBJECT_REPORT @p = '��';
print '���������� ���������: ' + cast(@rc as varchar(5));



--������� 6
select * from AUDITORIUM;
select * from AUDITORIUM_TYPE;


go
create procedure PAUDITORIUM_AND_AUDITORIUM_TYPE_INSERT
				@a char(20), @at char(10), @ac int null, @an varchar(50), @atn varchar(30) null
as declare @rc int = 1
begin try
	set transaction isolation level serializable
	begin tran      -- ���������� ����� ���������� ����������
	insert into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) -- ���������� ����� ������ ���������
	values(@at, @atn)
	exec @rc = PAUDITORIUM_INSERT @a, @at, @ac, @an
	commit tran
	return @rc
end try
begin catch -- ��������� ������
	print '����� ������  : ' + cast(error_number() as varchar(6));
    print '���������     : ' + error_message();
    print '�������       : ' + cast(error_severity()  as varchar(6));
    print '�����         : ' + cast(error_state()   as varchar(8));
	print '����� ������  : ' + cast(error_line()  as varchar(8));
	if error_procedure() is not  null   
			print '��� ��������� : ' + error_procedure();
     if @@trancount > 0 rollback tran ; 
			return -1;	  
end catch;

go
declare @rc int;
exec @rc = PAUDITORIUM_AND_AUDITORIUM_TYPE_INSERT @a = '333-3', @at = '��-�-�', @ac = 50, @an = '333-3', @atn = '����. ����� � �������'
print '��� ������ = ' + cast(@rc as varchar(3));

select * from AUDITORIUM;
select * from AUDITORIUM_TYPE;

delete from AUDITORIUM where AUDITORIUM = '333-3';
delete from AUDITORIUM_TYPE where AUDITORIUM_TYPE = '��-�-�';




