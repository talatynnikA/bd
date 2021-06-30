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
USE [TAL_UNIVER]
GO

SELECT * FROM TEACHER;

BEGIN TRY	-- Переключение в режим явной транзакции
    BEGIN TRAN
    INSERT INTO TEACHER(TEACHER, TEACHER_NAME, PULPIT)
    VALUES('NEW', 'NEW', 'ИСиТ');

    UPDATE TEACHER 
    SET TEACHER = 'Y4itel' 
    WHERE TEACHER = 'NEW';

    -- INSERT INTO TEACHER(TEACHER, TEACHER_NAME, PULPIT)
    -- VALUES('ЖЛК', 'Жиляк', 'ИСиТ');

    COMMIT TRAN;
END TRY
BEGIN CATCH
    PRINT 'Error: ' + CAST(ERROR_MESSAGE() AS NVARCHAR(500))
    IF @@TRANCOUNT > 0 ROLLBACK TRAN;
-- @@trancount уровень влож-ти транзакции 
-- > 0, значит, что транзакция не завершена
END CATCH
	---3 задание
	--SAVE TRANSACTION, формирующий контрольную точку транзакции.
DECLARE @point NVARCHAR(32);
BEGIN TRY
    BEGIN TRAN -- Переключение в режим явной транзакции 

    UPDATE TEACHER 
    SET TEACHER_NAME = 'new new new'
    WHERE TEACHER = 'newst';
    SET @point = 'p1'; 
    SAVE TRAN @point;

    -- if we swap p2 and p3, then transaction will be successfull
    INSERT INTO TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT)
    VALUES('newst','new','м', 'ИСиТ');
    SET @point = 'p2'; 
    SAVE TRAN @point;--фиксация транзакции

    DELETE FROM TEACHER
    WHERE TEACHER = 'newst'
    SET @point = 'p3'; 
    SAVE TRAN @point;--фиксация транзакции

    COMMIT TRAN;
    PRINT 'Success';
END TRY
BEGIN CATCH
    PRINT 'Error:' + ERROR_MESSAGE();

    IF @@TRANCOUNT > 0
        BEGIN
            PRINT 'Current point = ' + CAST(@point AS NVARCHAR(50));
            ROLLBACK TRAN @point;-- возрат в исходный режим
            COMMIT TRAN;
        END;
    
END CATCH
---4 задание--не работает-----------------------------------------------
--Неподтвержденное чтение. изменения остаются до момента t2 в неподтвержденном состоянии, т. е. могут быть как за-фиксированными, так и отмененными. 
--Неповторяющееся чтение. Одна транзакция читает данные несколько раз, а другая изме-няет те же данные между двумя операциями чтения в первом процессе. 
--По этой причине данные, прочитанные в различных операциях, будут разными.
--Фантомное чтение. Две послед операции чтения могут получать различные значения, т. к. доп строки фантомными, могут добавляться другими транзакциями.

	-----A---------  
	set transaction isolation level read uncommitted
	begin transaction
	----t1--------
	select count(*) from [dbo].[SUBJECT]

	-----t2------
	---B----
	begin transaction
	select count(*) from [dbo].[SUBJECT]
	insert into SUBJECT values ('вв','иро','ИСиТ')
----t1--
---t2---
rollback;


----5 задание-----------------------------------------------------------
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


--6 задание-----не работает----------------------------
--A--
set transaction isolation level repeatable read
begin transaction
select count(*) from [dbo].[SUBJECT]
----------t1-------
-----------t2----------
--B--
begin transaction
delete from  [SUBJECT] where SUBJECT='gj'
insert into SUBJECT values ('вв','иро','ИСиТ')
----t2-------
rollback

---7 задание--не работает
set transaction isolation level serializable
begin transaction
select count(*) from [dbo].[SUBJECT]
----------t1-------
select * from [dbo].[SUBJECT]
-----------t2----------
commit;
--B--
begin transaction

insert into SUBJECT values ('выв','ирыо','ИСиыТ')
select SUBJECT from [dbo].[SUBJECT]  where PULPIT='ИСиТ';
----t1-------
commit;
select SUBJECT from [dbo].[SUBJECT]  where PULPIT='ИСиТ';
----t2-------
rollback



-----8 задание----------не работает------------------------------------
--Транзакция, выполняющаяся в рамках другой транзакции, называется вложенной. 
--При работе с вложенными транзакциями нужно учитывать следующее: 
--оператор COMMIT вложенной транзакции действует только на внутренние операции вложенной транзакции; 
--оператор ROLLBACK внешней транзакции отменяет зафиксированные операции внут-ренней транзакции; 
--оператор ROLLBACK вложенной транзакции действует на операции внешней и внут-ренней транзакции, а также завершает обе транзакции; 
--уровень вложенности транзакции можно определить с помощью системной функции @@TRANCOUT

select * from [dbo].[SUBJECT] 
select count(*) from [dbo].[SUBJECT] where PULPIT='ИСиТ'
begin tran -- внешняя транзакция
insert [dbo].[SUBJECT] values ('uuirh', 'uerhfi', 'ИСиТ')
	begin tran 
	update [dbo].[PULPIT] set PULPIT_NAME = 'aaaa' where PULPIT='ИСиТ'
	commit --- внутренняя
	if @@TRANCOUNT>0 rollback
select 
	(select count(*) from [dbo].[SUBJECT] where PULPIT='ИСиТ')'SUBJECT',
	(select count(*) from [dbo].[PULPIT] where  PULPIT_NAME = 'aaaa') 'Pulpit'
	rollback


