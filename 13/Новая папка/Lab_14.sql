use TAL_UNIVER
go

--1. �������� ����. ��� �����, ����. ���.����� �� ������ SUBJECT
--� ����� ������ ��������� �. ����� ���-�� �����, ���������� � ���.�����

CREATE procedure PSUBJECT
as begin
	DECLARE @n int = (SELECT count(*) from SUBJECT);
	SELECT SUBJECT [���], SUBJECT_NAME [����������], PULPIT [�������] from SUBJECT;
	return @n;
end;

DECLARE @k int;
EXEC @k = PSUBJECT; -- ����� ��������� 
print '���������� ���������: ' + cast(@k as varchar(3));
go
--DROP procedure PSUBJECT;



--2. ���., ����� ��������� ��������� @p (��. - ��� �������), @c (���. - ���-��)

ALTER procedure PSUBJECT @p varchar(20), @c nvarchar(2) output
as begin
	SELECT * from SUBJECT where SUBJECT = @p;
	set @c = cast(@@rowcount as nvarchar(2));
end;

DECLARE @k1 int, @k2 nvarchar(2);
EXEC @k1 = PSUBJECT @p = '����', @c = @k2 output;
print '���������� ���������: ' + @k2;
go



--3. ����. ����.���.����, ������� ��� � ���.������ 2
--���. PSUBJECT, ������ @c, �����. �� ������ � #SUBJECT

ALTER procedure PSUBJECT @p varchar(20)
as begin
	SELECT * from SUBJECT where SUBJECT = @p;
end;


CREATE table #SUBJECTs
(
	���_�������� varchar(20),
	��������_�������� varchar(100),
	������� varchar(20)
);
INSERT #SUBJECTs EXEC PSUBJECT @p = '���';
INSERT #SUBJECTs EXEC PSUBJECT @p = '����';
SELECT * from #SUBJECTs;
go

drop table #SUBJECTs



--4. ��������� 4 ��.����� (�������� ��������), ���. ������ � ����.AUDITORIUM
go
CREATE procedure PAUDITORIUM_INSERT
		@a char(20),
		@n varchar(50),
		@c int = 0,
		@t char(10)
as begin 
begin try
	INSERT into AUDITORIUM(AUDITORIUM, AUDITORIUM_TYPE, AUDITORIUM_CAPACITY, AUDITORIUM_NAME)
		values(@a, @n, @c, @t);
		--values(433-1, '��', 433-1, 100);
	return 1;
end try
begin catch
	print '����� ������: ' + cast(error_number() as varchar(6));
	print '���������: ' + error_message();
	print '�������: ' + cast(error_severity() as varchar(6));
	print '�����: ' + cast(error_state() as varchar(8));
	print '����� ������: ' + cast(error_line() as varchar(8));
	if error_procedure() is not null   
	print '��� ���������: ' + error_procedure();
	return -1;
end catch;
end;


DECLARE @rc int;  
EXEC @rc = PAUDITORIUM_INSERT @a = '420-3', @n = '��', @c = 100, @t = '420-3'; 
print '��� ������: ' + cast(@rc as varchar(3));
go

delete AUDITORIUM where AUDITORIUM='420-3';



--5. ����. ������ ��������� �� ���.�������
--������� ����. � ������ ����� ���.(RTRIM)
go
CREATE procedure SUBJECT_REPORT @p char(10) 
as begin
DECLARE @rc int;
begin try
	DECLARE @sb char(10), @r varchar(100) = '';
	DECLARE sbj CURSOR for 
		SELECT SUBJECT from SUBJECT where PULPIT = @p;
	if not exists(SELECT SUBJECT from SUBJECT where PULPIT = @p)
		raiserror('������', 11, 1);
	else 
	OPEN sbj;
	fetch sbj into @sb;
	print '��������: ';
	while @@fetch_status = 0
	begin
		set @r = rtrim(@sb) + ', ' + @r;  
		set @rc = @rc + 1;
		fetch sbj into @sb;
	end
	print @r;
	CLOSE sbj;
	return @rc;
end try
begin catch
	print '������ � ����������' 
	if error_procedure() is not null   
	print '��� ���������: ' + error_procedure();
	return @rc;
end catch;
end;


DECLARE @k2 int;  
EXEC @k2 = SUBJECT_REPORT @p ='����';  
print '���������� ���������: ' + cast(@k2 as varchar(3));
go

drop procedure SUBJECT_REPORT;




--6. ����. ���. 2 ������: � ����.AUD_TYPE(@t, @tn) + ����� ������ PAUD_INSERT
--��� � ������ ����� ���������� � ��.����.SERIALIZABLE
 
CREATE procedure PAUDITORIUM_INSERTX
		@a char(20),
		@n varchar(50),
		@c int = 0,
		@t char(10),
		@tn varchar(50)	--���., ��� ����� � AUD_TYPEAUD_TYPENAME
as begin
DECLARE @rc int = 1;
begin try
	set transaction isolation level serializable;          
	begin tran
	INSERT into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
				values(@n, @tn);
	EXEC @rc = PAUDITORIUM_INSERT @a, @n, @c, @t;
	commit tran;
	return @rc;
end try
begin catch
	print '����� ������: ' + cast(error_number() as varchar(6));
	print '���������: ' + error_message();
	print '�������: ' + cast(error_severity() as varchar(6));
	print '�����: ' + cast(error_state() as varchar(8));
	print '����� ������: ' + cast(error_line() as varchar(8));
	if error_procedure() is not  null   
	print '��� ���������: ' + error_procedure(); 
	if @@trancount > 0 rollback tran ; 
	return -1;
end catch;
end;


DECLARE @k3 int;  
EXEC @k3 = PAUDITORIUM_INSERTX '622-3', @n = '��', @c = 85, @t = '622-3', @tn = '����. �����'; 
print '��� ������: ' + cast(@k3 as varchar(3));

delete AUDITORIUM where AUDITORIUM='622-3';  
delete AUDITORIUM_TYPE where AUDITORIUM_TYPE='��';
go

drop procedure PAUDITORIUM_INSERTX;