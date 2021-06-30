--Транзакция  это механизм базы данных, позволяющий таким образом объединять несколько операторов, 
--изменяющих базу данных, чтобы при выполнении этой совокупности операторов они или все выполнились или все не выполнились. 
--Основные свойства транзакции: 
--атомарность (операторы изменения БД, включенные в транзакцию, либо выполнятся все, либо не выполнится ни один); 
--согласованность (транзакция должна фиксировать новое согласованное состояние БД); 
--изолированность (отсутствие взаимного влияния параллельных транзакций на результаты их выполнения);
--долговечность (изменения в БД, выполненные и зафиксированные транзакцией, могут быть отменены только с помощью новой транзакции).
--1 задание
--работа с неявной транзакцией 
use TAL_UNIVER
set nocount on
if exists(select * from SYS.objects  ---есть ли таблица
			where OBJECT_ID = object_id(N'DBO.X'))
	drop table X
	--если r то будет ROLLBACK, что приведет к отмене всех изменений в БД, осуществленных последней тран-закцией 
	declare @a int, @flag char='c'
	set implicit_transactions on --влючаем режим неявной транзакции
	create table X(K int)        --начало транзакции
		insert X values(1),(2),(3)
		set @a = (select count(*) from X)
		print 'кол-во строк= ' + cast(@a as varchar(2))
		if @flag = 'c' commit		--завершение транз: фиксация
		else rollback				--завершение транзакции: откат  
	set implicit_transactions off	--выкл
	if exists( select * from SYS.objects  -- таблица е?
			where OBJECT_ID = object_id(N'DBO.X'))
			print 'есть'
			else print 'нет'

--2задание
--автомарность явной транзакции
begin try
begin tran -- Переключение в режим явной транзакции 
	delete [dbo].[PULPIT] where [PULPIT]='ИСиТ'
	insert [PULPIT] values ('as', 'sdfghyuj', 'ИТ')
	insert [PULPIT] values ('erty', 'smwenwjb', 'ИТ')
	commit tran --фиксация транзакции
	end try
	begin catch
	print 'error: ' + case
	when error_number()=547 
	then 'нельзя удалить, конфликт инструкций'
	else 'неизвестная ошибка: ' + cast(error_number() as varchar(5)) + error_message()
	end
	if @@trancount>0 rollback tran -- возрат в исходный режим
	end catch

	---3 задание
	--SAVE TRANSACTION, формирующий контрольную точку транзакции.
	declare @point varchar(32)  
	begin try
	begin tran			--начало явной транз
	insert [PULPIT] values ('vорм', ' асп', 'ИТ')
		set @point = 'p1'	
		save tran @point		--контр точка 1
	delete [PULPIT] where PULPIT ='ИСиТ'
		set @point = 'p2'
		save tran @point		--контр точка 2
	insert [PULPIT] values ('нггпп', 'иопмр', 'ИТ')
	commit tran					--фиксация
	end try
	begin catch
	print 'error: ' + case
	when error_number()=547 
	then 'нельзя удалить, конфликт инструкций'
	else 'неизвестная ошибка: ' + cast(error_number() as varchar(5)) + error_message()
	end
	if @@trancount>0 
	begin
		print 'контрольная точка ' + @point
		rollback tran @point		--откат к контр точке
		commit tran					--фикссация изменеений до контр точки
		end
	end catch

---4 задание-------------------------------------------------
--Неподтвержденное чтение. изменения остаются до момента t2 в неподтвержденном состоянии, т. е. могут быть как за-фиксированными, так и отмененными. 
--Неповторяющееся чтение. Одна транзакция читает данные несколько раз, а другая изме-няет те же данные между двумя операциями чтения в первом процессе. 
--По этой причине данные, прочитанные в различных операциях, будут разными.
--Фантомное чтение. Две послед операции чтения могут получать различные значения, т. к. доп строки фантомными, могут добавляться другими транзакциями.

	-----A---------
	set transaction isolation level read uncommitted
	begin transaction
	----t1--------
	select count(*) from [dbo].[SUBJECTS]

	-----t2------
	---B----
	begin transaction
	select count(*) from [dbo].[SUBJECTS]
	insert into SUBJECTS values ('вв','иро','ИСиТ')
----t1--
---t2---
rollback;


----5 задание-----------------------------------------------------------
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


--6 задание---------------------------------
--A--
set transaction isolation level repeatable read
begin transaction
select count(*) from [dbo].[SUBJECTS]
----------t1-------
-----------t2----------
--B--
begin transaction
delete from  [SUBJECTS] where SUBJECTS='gj'
insert into SUBJECTS values ('вв','иро','ИСиТ')
----t2-------
rollback

---7 задание
set transaction isolation level serializable
begin transaction
select count(*) from [dbo].[SUBJECTS]
----------t1-------
select * from [dbo].[SUBJECTS]
-----------t2----------
commit;
--B--
begin transaction

insert into SUBJECTS values ('вв','иро','ИСиТ')
select SUBJECTS from [dbo].[SUBJECTS]  where PULPIT='ИСиТ';
----t1-------
commit;
select SUBJECTS from [dbo].[SUBJECTS]  where PULPIT='ИСиТ';
----t2-------
rollback



-----8 задание----------------------------------------------
--Транзакция, выполняющаяся в рамках другой транзакции, называется вложенной. 
--При работе с вложенными транзакциями нужно учитывать следующее: 
--оператор COMMIT вложенной транзакции действует только на внутренние операции вложенной транзакции; 
--оператор ROLLBACK внешней транзакции отменяет зафиксированные операции внут-ренней транзакции; 
--оператор ROLLBACK вложенной транзакции действует на операции внешней и внут-ренней транзакции, а также завершает обе транзакции; 
--уровень вложенности транзакции можно определить с помощью системной функции @@TRANCOUT

select * from [dbo].[SUBJECTS] 
select count(*) from [dbo].[SUBJECTS] where PULPIT='ИСиТ'
begin tran -- внешняя транзакция
insert [dbo].[SUBJECTS] values ('uuirh', 'uerhfi', 'ИСиТ')
	begin tran 
	update [dbo].[PULPIT] set PULPIT_NAME = 'aaaa' where PULPIT='ИСиТ'
	commit --- внутренняя
	if @@TRANCOUNT>0 rollback
select 
	(select count(*) from [dbo].[SUBJECTS] where PULPIT='ИСиТ')'subjects',
	(select count(*) from [dbo].[PULPIT] where  PULPIT_NAME = 'aaaa') 'Pulpit'
	rollback


