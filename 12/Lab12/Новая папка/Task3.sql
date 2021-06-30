USE [TAL_UNIVER]
GO

-- for once
-- INSERT INTO TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT)
-- VALUES('newst','newst','м', 'ИСиТ');

DECLARE @point NVARCHAR(32);
BEGIN TRY
    BEGIN TRAN

    UPDATE TEACHER 
    SET TEACHER_NAME = 'new new new'
    WHERE TEACHER = 'newst';
    SET @point = 'p1'; 
    SAVE TRAN @point;

    -- if we swap p2 and p3, then transaction will be successfull
    INSERT INTO TEACHER(TEACHER, TEACHER_NAME, GENDER, PULPIT)
    VALUES('newst','new','м', 'ИСиТ');
    SET @point = 'p2'; 
    SAVE TRAN @point;

    DELETE FROM TEACHER
    WHERE TEACHER = 'newst'
    SET @point = 'p3'; 
    SAVE TRAN @point;

    COMMIT TRAN;
    PRINT 'Success';
END TRY
BEGIN CATCH
    PRINT 'Error:' + ERROR_MESSAGE();

    IF @@TRANCOUNT > 0
        BEGIN
            PRINT 'Current point = ' + CAST(@point AS NVARCHAR(50));
            ROLLBACK TRAN @point;
            COMMIT TRAN;
        END;
    
END CATCH