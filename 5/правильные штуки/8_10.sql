USE [Tal_MyBase]
GO

SELECT *
FROM dbo.Товары_
    INNER JOIN dbo.Сделка
    ON Сделка.Наименование_товара = Товары_.Наименование_товара And
							Товары_.Описание Like '%описание%'

	SELECT *     --Товары_.Цена, Сделка.Наименование_товара
FROM Товары_, Сделка
Where Сделка.Наименование_товара = Товары_.Наименование_товара  And
							Товары_.Описание Like '%описание%'
	-------------------------------------------------
	SELECT Товары_.Цена, Сделка.Наименование_товара,
	Case
	when(Товары_.Цена)=230 then 'двести тридцать'
	when(Товары_.Цена)=12 then 'двенадцать'
	when(Товары_.Цена)=345 then 'триста сорок пять'
else 'другая цена'
end [Цены]
FROM dbo.Товары_
    INNER JOIN dbo.Сделка
    ON Сделка.Наименование_товара = Товары_.Наименование_товара
								order by Товары_.Наименование_товара

---------------------------------------------------

--соединение FULL OUTER JOIN двух таблиц:
-- − является коммутативной операцией;

SELECT *
FROM dbo.Товары_
    FULL JOIN dbo.Сделка
    ON Сделка.Наименование_товара = Товары_.Наименование_товара

-- full коммутативнАЯ, если формируемый результирующий набор не зависит от порядка, в котором указаны исходные таблицы.
SELECT *
FROM dbo.Сделка
    FULL JOIN dbo.Товары_
    ON Товары_.Наименование_товара = Сделка.Наименование_товара

---− является объединением LEFT OUTER JOIN и RIGHT OUTER JOIN соединений этих таблиц;
-- like a full join

SELECT *
FROM dbo.Сделка
    LEFT JOIN dbo.Товары_
    ON Товары_.Наименование_товара = Сделка.Наименование_товара
UNION
SELECT *
FROM dbo.Сделка
    RIGHT JOIN dbo.Товары_
    ON Товары_.Наименование_товара = Сделка.Наименование_товара

-- inner join
SELECT *
FROM dbo.Товары_
    INNER JOIN dbo.Сделка
    ON Сделка.Наименование_товара = Товары_.Наименование_товара And
							Товары_.Описание Like '%описание%'

-- -включает соединение INNER JOIN этих таб-лиц.
---like an inner join
SELECT *
FROM dbo.Товары_
    FULL JOIN dbo.Сделка
    ON Сделка.Наименование_товара = Товары_.Наименование_товара
WHERE Сделка.Наименование_товара IS NOT NULL
    AND Товары_.Наименование_товара IS NOT NULL



	---------------------------------------------------
	SELECT *
FROM dbo.Товары_
    FULL JOIN dbo.Сделка
    ON Сделка.Наименование_товара = Товары_.Наименование_товара

	------------------------------------------------------
USE [Tal_MyBase]
GO

	SELECT *
FROM dbo.Товары_
    CROSS JOIN dbo.Сделка
    WHERE Сделка.Наименование_товара = Товары_.Наименование_товара


USE [TAL_UNIVER]
GO

select PULPIT.PULPIT_NAME
from PULPIT full outer join TEACHER on TEACHER.PULPIT = PULPIT.PULPIT

select isnull(TEACHER.TEACHER_NAME, '***')
from PULPIT full outer join TEACHER on TEACHER.PULPIT = PULPIT.PULPIT

select isnull(TEACHER.TEACHER_NAME, '***') [Преподователь], PULPIT.PULPIT_NAME [Кафедра]
from TEACHER full outer join PULPIT on TEACHER.PULPIT = PULPIT.PULPIT
