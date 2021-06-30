USE [TAL_UNIVER]
GO
--1. На основе таблицы AUDITORIUM разработать SELECT-запрос, вычисляющий максимальную, минимальную и среднюю вместимость аудиторий,
--суммарную вме-стимость всех аудиторий и общее количе-ство аудиторий. 
SELECT 
    MIN(AUDITORIUM_CAPACITY) [Минимальная вместимость],
    MAX(AUDITORIUM_CAPACITY) [Максимальная вместимость],
    AVG(AUDITORIUM_CAPACITY) [Средняя вместимость],
    SUM(AUDITORIUM_CAPACITY) [Суммарная вместимость],
    COUNT(AUDITORIUM_CAPACITY) [Кол-во аудиторий]
FROM AUDITORIUM

