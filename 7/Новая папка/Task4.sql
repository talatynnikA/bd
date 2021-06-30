USE [TAL_UNIVER]
GO

-- FACULTY, GROUPS, STUDENT и PROGRESS 
--4. Разработать SELECT-запроса на основе таблиц FACULTY, GROUPS, STUDENT и PROGRESS, который содержит среднюю экзаменационную оценку для каждого курса каждой специальности.
--Строки отсортированы в порядке убывания средней оценки. 
--При этом следует учесть, что средняя оценка должна рассчитываться с точностью до двух знаков после запятой.
--Использовать внутреннее соединение таблиц, агрегатную функцию AVG и встроенные функции CAST и ROUND.
--Переписать SELECT-запрос, разработанный в задании 4 так, чтобы в расчете среднего значения оценок использовались оценки только по дисциплинам с кодами БД и ОАиП. Использовать WHERE.

SELECT FACULTY.FACULTY_NAME AS ФАКУЛЬТЕТ,
    GROUPS.PROFESSION AS СПЕЦИАЛЬНОСТЬ,
    CASE 
       WHEN MONTH( GETDATE() ) BETWEEN 8 AND 12
            THEN YEAR( GETDATE() ) - GROUPS.YEAR_FIRST + 1
            ELSE YEAR( GETDATE() ) - GROUPS.YEAR_FIRST
       END AS КУРС,
    ROUND(AVG(CAST(PROGRESS.NOTE AS [float](4))),2)
FROM FACULTY
    INNER JOIN GROUPS
    ON GROUPS.FACULTY = FACULTY.FACULTY
    INNER JOIN STUDENT
    ON GROUPS.IDGROUP = STUDENT.IDGROUP
    INNER JOIN PROGRESS
    ON PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
GROUP BY FACULTY.FACULTY_NAME, 
       GROUPS.PROFESSION, 
       CASE 
       WHEN MONTH( GETDATE() ) BETWEEN 8 AND 12
            THEN YEAR( GETDATE() ) - GROUPS.YEAR_FIRST + 1
            ELSE YEAR( GETDATE() ) - GROUPS.YEAR_FIRST
       END 
