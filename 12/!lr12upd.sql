--����������  ��� �������� ���� ������, ����������� ����� ������� ���������� ��������� ����������, 
--���������� ���� ������, ����� ��� ���������� ���� ������������ ���������� ��� ��� ��� ����������� ��� ��� �� �����������. 
--�������� �������� ����������: 
--����������� (��������� ��������� ��, ���������� � ����������, ���� ���������� ���, ���� �� ���������� �� ����); 
--��������������� (���������� ������ ����������� ����� ������������� ��������� ��); 
--��������������� (���������� ��������� ������� ������������ ���������� �� ���������� �� ����������);
--������������� (��������� � ��, ����������� � ��������������� �����������, ����� ���� �������� ������ � ������� ����� ����������).
--1 �������
--������ � ������� ����������� 
use TAL_UNIVER
set nocount on
if exists(select * from SYS.objects  ---���� �� �������
			where OBJECT_ID = object_id(N'DBO.X'))
	drop table X
	--���� r �� ����� ROLLBACK, ��� �������� � ������ ���� ��������� � ��, �������������� ��������� ����-������� 
	declare @a int, @flag char='c'
	set implicit_transactions on --������� ����� ������� ����������
	create table X(K int)        --������ ����������
		insert X values(1),(2),(3)
		set @a = (select count(*) from X)
		print '���-�� �����= ' + cast(@a as varchar(2))
		if @flag = 'c' commit		--���������� �����: ��������
		else rollback				--���������� ����������: �����  
	set implicit_transactions off	--����
	if exists( select * from SYS.objects  -- ������� �?
			where OBJECT_ID = object_id(N'DBO.X'))
			print '����'
			else print '���'

--2�������
--������������ ����� ����������
USE [TAL_UNIVER]
GO

SELECT * FROM TEACHER;

BEGIN TRY	-- ������������ � ����� ����� ����������
    BEGIN TRAN
    INSERT INTO TEACHER(TEACHER, TEACHER_NAME, PULPIT)
    VALUES('NEW', 'NEW', '����');

    UPDATE TEACHER 
    SET TEACHER = 'Y4itel' 
    WHERE TEACHER = 'NEW';

    -- INSERT INTO TEACHER(TEACHER, TEACHER_NAME, PULPIT)
    -- VALUES('���', '�����', '����');

    COMMIT TRAN;
END TRY
BEGIN CATCH
    PRINT 'Error: ' + CAST(ERROR_MESSAGE() AS NVARCHAR(500))
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
-- @@trancount ������� ����-�� ���������� 
-- > 0, ������, ��� ���������� �� ���������
END CATCH
	---3 �������
	--SAVE TRANSACTION, ����������� ����������� ����� ����������.
DECLARE @point NVARCHAR(32);
BEGIN TRY
    BEGIN TRAN -- ������������ � ����� ����� ���������� 

    UPDATE TEACHER 
    SET TEACHER_NAME = 'new new new'
    WHERE TEACHER = 'newst';
    SET @point = 'p1'; 
    SAVE TRAN @point;

    -- if we swap p2 and p3, then transaction will be successfull
    INSERT INTO TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT)
    VALUES('newst','new','�', '����');
    SET @point = 'p2'; 
    SAVE TRAN @point;--�������� ����������

    DELETE FROM TEACHER
    WHERE TEACHER = 'newst'
    SET @point = 'p3'; 
    SAVE TRAN @point;--�������� ����������

    COMMIT TRAN;
    PRINT 'Success';
END TRY
BEGIN CATCH
    PRINT 'Error:' + ERROR_MESSAGE();

    IF @@TRANCOUNT > 0
        BEGIN
            PRINT 'Current point = ' + CAST(@point AS NVARCHAR(50));
            ROLLBACK TRAN @point;-- ������ � �������� �����
            COMMIT TRAN;
        END;
    
END CATCH
---4 �������--�� ��������-----------------------------------------------
--���������������� ������. ��������� �������� �� ������� t2 � ���������������� ���������, �. �. ����� ���� ��� ��-��������������, ��� � �����������. 
--��������������� ������. ���� ���������� ������ ������ ��������� ���, � ������ ����-���� �� �� ������ ����� ����� ���������� ������ � ������ ��������. 
--�� ���� ������� ������, ����������� � ��������� ���������, ����� �������.
--��������� ������. ��� ������ �������� ������ ����� �������� ��������� ��������, �. �. ��� ������ ����������, ����� ����������� ������� ������������.

	-----A---------  
	set transaction isolation level read uncommitted
	begin transaction
	----t1--------
	select count(*) from [dbo].[SUBJECT]

	-----t2------
	---B----
	begin transaction
	select count(*) from [dbo].[SUBJECT]
	insert into SUBJECT values ('��','���','����')
----t1--
---t2---
rollback;


----5 �������-----------------------------------------------------------
--A--
set transaction isolation level read committed
begin transaction
	select * from [dbo].[SUBJECT]
-----------------t1--------------------
----------------------t2---------------

----B----
begin transaction
	select count(*) from [dbo].[SUBJECT]
	delete from  [SUBJECT] where SUBJECT='gj'
----t1----------
-----t2-----


--6 �������-----�� ��������----------------------------
--A--
set transaction isolation level repeatable read
begin transaction
select count(*) from [dbo].[SUBJECT]
----------t1-------
-----------t2----------
--B--
begin transaction
delete from  [SUBJECT] where SUBJECT='gj'
insert into SUBJECT values ('��','���','����')
----t2-------
rollback

---7 �������--�� ��������
set transaction isolation level serializable
begin transaction
select count(*) from [dbo].[SUBJECT]
----------t1-------
select * from [dbo].[SUBJECT]
-----------t2----------
commit;
--B--
begin transaction

insert into SUBJECT values ('���','����','�����')
select SUBJECT from [dbo].[SUBJECT]  where PULPIT='����';
----t1-------
commit;
select SUBJECT from [dbo].[SUBJECT]  where PULPIT='����';
----t2-------
rollback



-----8 �������----------�� ��������------------------------------------
--����������, ������������� � ������ ������ ����������, ���������� ���������. 
--��� ������ � ���������� ������������ ����� ��������� ���������: 
--�������� COMMIT ��������� ���������� ��������� ������ �� ���������� �������� ��������� ����������; 
--�������� ROLLBACK ������� ���������� �������� ��������������� �������� ����-������ ����������; 
--�������� ROLLBACK ��������� ���������� ��������� �� �������� ������� � ����-������ ����������, � ����� ��������� ��� ����������; 
--������� ����������� ���������� ����� ���������� � ������� ��������� ������� @@TRANCOUT

select * from [dbo].[SUBJECT] 
select count(*) from [dbo].[SUBJECT] where PULPIT='����'
begin tran -- ������� ����������
insert [dbo].[SUBJECT] values ('uuirh', 'uerhfi', '����')
	begin tran 
	update [dbo].[PULPIT] set PULPIT_NAME = 'aaaa' where PULPIT='����'
	commit --- ����������
	if @@TRANCOUNT>0 rollback
select 
	(select count(*) from [dbo].[SUBJECT] where PULPIT='����')'SUBJECT',
	(select count(*) from [dbo].[PULPIT] where  PULPIT_NAME = 'aaaa') 'Pulpit'
	rollback


