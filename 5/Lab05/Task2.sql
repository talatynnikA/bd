USE [TMPAD_UNIVER]
GO

SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
FROM AUDITORIUM INNER JOIN AUDITORIUM_TYPE
ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
AND AUDITORIUM_TYPE.AUDITORIUM_TYPENAME LIKE '%компьютер%';