USE [TMPAD_UNIVER]
GO

SELECT FACULTY.FACULTY_NAME [Факультет],
    PROFESSION.[PROFESSION_NAME] [Специальность],
    PULPIT.PULPIT_NAME [Кафедра],
    [SUBJECT].SUBJECT_NAME [Дисциплина],
    STUDENT.NAME [Студент],
    CASE 
        WHEN PROGRESS.NOTE = 1 THEN 'один'
        WHEN PROGRESS.NOTE = 2 THEN 'два'
        WHEN PROGRESS.NOTE = 3 THEN 'три'
        WHEN PROGRESS.NOTE = 4 THEN 'четыре'
        WHEN PROGRESS.NOTE = 5 THEN 'пять'
        WHEN PROGRESS.NOTE = 6 THEN 'шесть'
        WHEN PROGRESS.NOTE = 7 THEN 'семь'
        WHEN PROGRESS.NOTE = 8 THEN 'восемь'
        WHEN PROGRESS.NOTE = 9 THEN 'девять'
        WHEN PROGRESS.NOTE = 10 THEN 'десять'
       END [Оценка]
FROM ((((((FACULTY
    INNER JOIN PROFESSION ON FACULTY.FACULTY = PROFESSION.FACULTY)
    INNER JOIN GROUPS ON PROFESSION.PROFESSION = GROUPS.PROFESSION)
    INNER JOIN STUDENT ON GROUPS.IDGROUP = STUDENT.IDGROUP)
    INNER JOIN PROGRESS ON STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT)
    INNER JOIN SUBJECT ON SUBJECT.PULPIT = SUBJECT.SUBJECT)
    INNER JOIN PULPIT ON SUBJECT.PULPIT = PULPIT.PULPIT)
WHERE PROGRESS.NOTE BETWEEN 6 AND 8
ORDER BY PROGRESS.NOTE DESC;

