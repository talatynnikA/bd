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
begin try
begin tran -- ������������ � ����� ����� ���������� 
	delete [dbo].[PULPIT] where [PULPIT]='����'
	insert [PULPIT] values ('as', 'sdfghyuj', '��')
	insert [PULPIT] values ('erty', 'smwenwjb', '��')
	commit tran --�������� ����������
	end try
	begin catch
	print 'error: ' + case
	when error_number()=547 
	then '������ �������, �������� ����������'
	else '����������� ������: ' + cast(error_number() as varchar(5)) + error_message()
	end
	if @@trancount>0 rollback tran -- ������ � �������� �����
	end catch

	---3 �������
	--SAVE TRANSACTION, ����������� ����������� ����� ����������.
	declare @point varchar(32)  
	begin try
	begin tran			--������ ����� �����
	insert [PULPIT] values ('v���', ' ���', '��')
		set @point = 'p1'	
		save tran @point		--����� ����� 1
	delete [PULPIT] where PULPIT ='����'
		set @point = 'p2'
		save tran @point		--����� ����� 2
	insert [PULPIT] values ('�����', '�����', '��')
	commit tran					--��������
	end try
	begin catch
	print 'error: ' + case
	when error_number()=547 
	then '������ �������, �������� ����������'
	else '����������� ������: ' + cast(error_number() as varchar(5)) + error_message()
	end
	if @@trancount>0 
	begin
		print '����������� ����� ' + @point
		rollback tran @point		--����� � ����� �����
		commit tran					--��������� ���������� �� ����� �����
		end
	end catch

---4 �������-------------------------------------------------
--���������������� ������. ��������� �������� �� ������� t2 � ���������������� ���������, �. �. ����� ���� ��� ��-��������������, ��� � �����������. 
--��������������� ������. ���� ���������� ������ ������ ��������� ���, � ������ ����-���� �� �� ������ ����� ����� ���������� ������ � ������ ��������. 
--�� ���� ������� ������, ����������� � ��������� ���������, ����� �������.
--��������� ������. ��� ������ �������� ������ ����� �������� ��������� ��������, �. �. ��� ������ ����������, ����� ����������� ������� ������������.

	-----A---------
	set transaction isolation level read uncommitted
	begin transaction
	----t1--------
	select count(*) from [dbo].[SUBJECTS]

	-----t2------
	---B----
	begin transaction
	select count(*) from [dbo].[SUBJECTS]
	insert into SUBJECTS values ('��','���','����')
----t1--
---t2---
rollback;


----5 �������-----------------------------------------------------------
--A--
set transaction isolation level read committed
begin transaction
	select * from [dbo].[SUBJECTS]
-----------------t1--------------------
----------------------t2---------------

----B----
begin transaction
	select count(*) from [dbo].[SUBJECTS]
	delete from  [SUBJECTS] where SUBJECTS='gj'
----t1----------
-----t2-----


--6 �������---------------------------------
--A--
set transaction isolation level repeatable read
begin transaction
select count(*) from [dbo].[SUBJECTS]
----------t1-------
-----------t2----------
--B--
begin transaction
delete from  [SUBJECTS] where SUBJECTS='gj'
insert into SUBJECTS values ('��','���','����')
----t2-------
rollback

---7 �������
set transaction isolation level serializable
begin transaction
select count(*) from [dbo].[SUBJECTS]
----------t1-------
select * from [dbo].[SUBJECTS]
-----------t2----------
commit;
--B--
begin transaction

insert into SUBJECTS values ('��','���','����')
select SUBJECTS from [dbo].[SUBJECTS]  where PULPIT='����';
----t1-------
commit;
select SUBJECTS from [dbo].[SUBJECTS]  where PULPIT='����';
----t2-------
rollback



-----8 �������----------------------------------------------
--����������, ������������� � ������ ������ ����������, ���������� ���������. 
--��� ������ � ���������� ������������ ����� ��������� ���������: 
--�������� COMMIT ��������� ���������� ��������� ������ �� ���������� �������� ��������� ����������; 
--�������� ROLLBACK ������� ���������� �������� ��������������� �������� ����-������ ����������; 
--�������� ROLLBACK ��������� ���������� ��������� �� �������� ������� � ����-������ ����������, � ����� ��������� ��� ����������; 
--������� ����������� ���������� ����� ���������� � ������� ��������� ������� @@TRANCOUT

select * from [dbo].[SUBJECTS] 
select count(*) from [dbo].[SUBJECTS] where PULPIT='����'
begin tran -- ������� ����������
insert [dbo].[SUBJECTS] values ('uuirh', 'uerhfi', '����')
	begin tran 
	update [dbo].[PULPIT] set PULPIT_NAME = 'aaaa' where PULPIT='����'
	commit --- ����������
	if @@TRANCOUNT>0 rollback
select 
	(select count(*) from [dbo].[SUBJECTS] where PULPIT='����')'subjects',
	(select count(*) from [dbo].[PULPIT] where  PULPIT_NAME = 'aaaa') 'Pulpit'
	rollback


