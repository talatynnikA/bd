USE [TAL_UNIVER]
GO

-- Каждому преподу соответствует кафедра, но не на каждой кафедре есть преподы
SELECT PULPIT.PULPIT_NAME AS Кафедра, TEACHER.TEACHER_NAME   As Препод
FROM  TEACHER
LEFT JOIN PULPIT ON PULPIT.PULPIT = TEACHER.PULPIT
ORDER BY PULPIT.PULPIT_NAME ASC;