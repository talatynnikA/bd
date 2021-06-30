USE [TAL_UNIVER]
GO
--2. На основе таблиц AUDITORIUM и AUDITORIUM_TYPE разработать запрос, вычисляющий для каждого типа аудиторий максимальную, минимальную, 
--среднюю вместимость аудиторий, суммарную вме-стимость всех аудиторий и общее количе-ство аудиторий данного типа. 
--Результирующий набор должен содер-жать столбец с наименованием типа ауди-торий (столбец AUDITORIUM_TYPE.AU-DITORIUM_TYPENAME) 
--и столбцы с вычисленными величинами. Использовать внутреннее соединение таблиц, секцию GROUP BY и агрегатные функции

SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPENAME, 
       MAX(AUDITORIUM_CAPACITY) [Max_capacity],
       Min(AUDITORIUM_CAPACITY) [Min_capacity],
       AVG(AUDITORIUM_CAPACITY) [Avg_capacity],
       SUM(AUDITORIUM_CAPACITY) [Sum_capacity],
       COUNT(*) [Count_type]
FROM AUDITORIUM_TYPE
INNER JOIN AUDITORIUM
ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
GROUP BY AUDITORIUM_TYPE.AUDITORIUM_TYPENAME;