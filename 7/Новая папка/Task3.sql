USE [TAL_UNIVER]
GO

--3. Разработать запрос на основе таблицы PROGRESS, который содержит количество экзаменационных оценок в заданном интер-вале. 
--При этом учесть, что сортировка строк должна осуществляться в порядке, обратном величине оценки;
--сумма значений в столбце количество должна быть равна количеству строк в таблице PROGRESS. 
--Использовать подзапрос в секции FROM, в подзапросе применить GROUP BY, сор-тировку осуществить во внешнем запросе. 
--В секции GROUP BY, в SELECT-списке подзапроса и в ORDER BY внешнего запро-са применить CASE. 

SELECT *
FROM (SELECT CASE
    WHEN PROGRESS.NOTE = 10 THEN '10'
    WHEN PROGRESS.NOTE = 9 THEN '9'
    WHEN PROGRESS.NOTE = 8 OR PROGRESS.NOTE = 7 THEN '7-8'
    WHEN PROGRESS.NOTE = 6 OR PROGRESS.NOTE = 5 THEN '5-6'
    WHEN PROGRESS.NOTE = 4 THEN '4'
    WHEN PROGRESS.NOTE < 4 THEN '0-3'
    END [Оценка],
        COUNT(*) [Кол-во]
    FROM PROGRESS
    GROUP BY 
    CASE WHEN PROGRESS.NOTE = 10 THEN '10'
    WHEN PROGRESS.NOTE = 9 THEN '9'
    WHEN PROGRESS.NOTE = 8 OR PROGRESS.NOTE = 7 THEN '7-8'
    WHEN PROGRESS.NOTE = 6 OR PROGRESS.NOTE = 5 THEN '5-6'
    WHEN PROGRESS.NOTE = 4 THEN '4'
    WHEN PROGRESS.NOTE < 4 THEN '0-3'
    END
) AS T
ORDER BY 
CASE [Оценка]
WHEN '10' THEN 1
WHEN  '9' THEN 2
WHEN  '7-8' THEN 3
WHEN  '5-6' THEN 4
WHEN  '5-6' THEN 5
WHEN  '4' THEN 6
WHEN  '0-3' THEN 7
END 