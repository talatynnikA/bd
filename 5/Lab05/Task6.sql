USE [TAL_UNIVER]
GO

SELECT COUNT(*) FROM PULPIT;
SELECT COUNT(*) FROM TEACHER;

SELECT PULPIT.PULPIT_NAME AS Кафедра, ISNULL(TEACHER.TEACHER_NAME, '***')  As Препод
FROM PULPIT
INNER JOIN TEACHER ON PULPIT.PULPIT = TEACHER.PULPIT AND PULPIT.PULPIT_NAME LIKE '%Инф%'
ORDER BY PULPIT.PULPIT_NAME ASC;

-- SELECT PULPIT.PULPIT_NAME AS Кафедра, ISNULL(TEACHER.TEACHER_NAME, '***')  As Препод
-- FROM PULPIT
-- LEFT JOIN TEACHER ON PULPIT.PULPIT = TEACHER.PULPIT AND PULPIT.PULPIT_NAME LIKE '%Инф%'
-- ORDER BY PULPIT.PULPIT_NAME ASC;

SELECT PULPIT.PULPIT_NAME AS Кафедра, ISNULL(TEACHER.TEACHER_NAME, '***')  As Препод
FROM PULPIT
FULL OUTER JOIN TEACHER ON PULPIT.PULPIT = TEACHER.PULPIT
ORDER BY PULPIT.PULPIT_NAME ASC;