USE [TAL_UNIVER]
GO

---9. ??????????? SELECT-?????? ?? ?????? CROSS JOIN-?????????? ?????? 
--- AUDITORIUM_TYPE ? AUDITORIUM, ???????-????? ?????????, ??????????? ??????????, ??????????? ??? ?????????? ??????? ? ??-????? 1.
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
FROM AUDITORIUM 
    INNER JOIN AUDITORIUM_TYPE
    ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
ORDER BY AUDITORIUM;


----
SELECT AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
FROM AUDITORIUM
    CROSS JOIN AUDITORIUM_TYPE
WHERE AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
ORDER BY AUDITORIUM;