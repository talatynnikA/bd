USE [TAL_UNIVER]
GO

SET NOCOUNT ON
IF  EXISTS (select * from  SYS.OBJECTS        -- таблица X есть?
            where OBJECT_ID= object_id(N'DBO.X') )	            
drop table X;           

DECLARE @count int = 0 , @flag CHAR = 'с'; -- flag c - commit / r - rollback
-- включаем режим неявной транзакции
SET IMPLICIT_TRANSACTIONS ON
    BEGIN TRY
        CREATE TABLE X
        (
            K INT,
            Val INT
        );
        INSERT INTO X(K,Val)
        VALUES (1,14),
               (2,11),
               (3, 44),
               (4,90);
        SET @count = (SELECT COUNT(*) FROM X);
        PRINT 'Number of lines: ' + cast(@count AS NVARCHAR(2));
    END TRY
    BEGIN CATCH
        SET @flag = 'r';
    END CATCH

    IF @flag = 'c' COMMIT
    ELSE ROLLBACK;
SET IMPLICIT_TRANSACTIONS OFF
-- если у нас случился rollback, то таблицы Х не будет
IF  EXISTS (select * from  SYS.OBJECTS        -- таблица X есть?
            where OBJECT_ID= object_id(N'DBO.X') )	
            PRINT 'таблица Х есть'
ELSE PRINT 'таблицы Х нету'
