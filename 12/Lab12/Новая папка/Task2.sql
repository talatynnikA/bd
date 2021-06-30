USE [TAL_UNIVER]
GO

SELECT * FROM TEACHER;

BEGIN TRY
    BEGIN TRAN
    INSERT INTO TEACHER(TEACHER, TEACHER_NAME, PULPIT)
    VALUES('NEW', 'NEW', 'ИСиТ');

    UPDATE TEACHER 
    SET TEACHER = 'ЖЛК' 
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