-----������ � ��� ������ ���� ������, ����������� �������� ����� � ������������ �������, ��� ��� ��� ���� ������ ������-������ � ���� ����������������� ��������� ������ ������. 
exec SP_HELPINDEX '[AUDITORIUM]'
exec SP_HELPINDEX '[dbo].[AUDITORIUM_TYPE]'
exec SP_HELPINDEX '[dbo].[FACULTY]'
exec SP_HELPINDEX '[dbo].[GROUPS]'
exec SP_HELPINDEX '[dbo].[PROFESSION]'
exec SP_HELPINDEX '[dbo].[PROGRESS]'
exec SP_HELPINDEX '[dbo].[PULPIT]'
exec SP_HELPINDEX '[dbo].[STUDENT]'
exec SP_HELPINDEX '[dbo].[SUBJECT]'
exec SP_HELPINDEX '[dbo].[TEACHER]'


	CREATE table #my(
		tind int,
		tfield varchar(100));

		SET nocount on --�� �������� ��������� � ����� �����
		DECLARE @p int = 0
		WHILE @p<1000
			begin
			insert #my(tind, tfield)
					values (floor(30000*rand()), '�')
			SET @p +=1
		end
		select * from #my

		drop table #my

		select * from #my a where TIND between 1500 and 2000
		order by TIND  

-----����� ���������� ������� ����� ���������� ���������� �������, ���� �������� ��-������ ���:
		checkpoint ---- ���������� ���� ������
		DBCC DROPCLEANBUFFERS -----�������� �������� ���

--------------------������ ���������������� ������ 

		CREATE clustered index #my_cl on #my(TIND asc)

		drop index #my.#my_cl
		-- cl index 0.0033

		---------------------------------2------------------------------------------
	
	CREATE table #my2(
		TKEY int,
		CC int identity(1,1),
		TF varchar(100));

		SET nocount on
		DECLARE @w int = 0
		WHILE @w<10000 ---��������� � ������� ������
			begin
			insert #my2(TKEY, TF)
					values (floor(30000*rand()), '�ccc')
		SET @w +=1
		end
		SELECT count(*) [���-�� �����] from #my2
		select * from #my2

		--drop table #my2
------������ ���������,������,�����������. ������ 
		create index #my2_noncl on #my2(TKEY, CC)   

		drop index #my2.#my2_noncl

		select * from #my2 where TKEY >1500 and CC<4500 -- index - 0.037 , non - 0.037
		select * from #my2 order by TKEY, CC -- index - 0.037, non - 0.037
		select * from #my2 where TKEY = 556 and CC>3 -- index - 0.0032 , non - 0.037
		----------------3
		create index #my2_noncl_x on #my2(TKEY) include (CC)  --�������� ������ ��
		--������ ������������������ ������ �������� ���������������� �������� � ������ ��������� ������ �������� ������ ��� ���������� ����-����������� ��������
		drop index #my2.#my2_noncl_x
		select CC from #my2 where TKEY > 15000 --index - 0.019, non - 0.037
		--------------4
		create index #my2_where on #my2(TKEY) where ( TKEY >=15000 and TKEY <20000) ---����������� ������ 
		select  TKEY from #my2 where TKEY between 5000 and 19999 -- index - 0.037 , non - 0.037
		select TKEY from #my2  where TKEY >15000 and TKEY <20000 -- index - 0.01, non - 0.037
		select TKEY from #my2 where TKEY = 17000 -- index - 0.0032, non - 0.037

		checkpoint
		DBCC DROPCLEANBUFFERS
----------------5---------
			
		CREATE index #my2_TKEY on #my2(TKEY)

		delete from #my2 where TKEY between 10000 and 20000 

---�������� ���������� � ������� ������������:
		SELECT name[������], avg_fragmentation_in_percent [������������ (%)] ---������� ����������� �������������� ���������� ������ 
			from sys.dm_db_index_physical_stats(DB_ID(N'TEMPDB'),
			OBJECT_ID(N'#my2'), null, null, null) ss
			join sys.indexes ii on ss.object_id = ii.object_id
					and ss.index_id = ii.index_id
					where name is not null


		insert top(1000) #my2(TKEY, TF) select TKEY , TF from #my2  --��������� 1000 �����

------���������� �� ������������
		alter index #my2_TKEY on #my2 reorganize   ---����� �����. ������������� ����� ������ �� ����� ������ ������, ��. ��. �������� 

		alter index #my2_TKEY on #my2 rebuild with (online = off) --����� ������� ������������ =0
----------6----------
		drop index #my2.#my2_TKEY

		create index #my2_TtKEY on #my2(TKEY) with (fillfactor = 65)   --- ������ ���������� � ��������� ������ �������� ������� �� ����� ��� ��������.

		insert top(50) percent into #my2(TKEY, TF)
					select TKEY, TF from #my2




		
		






