use TAL_UNIVER

select AUDITORIUM_TYPE.AUDITORIUM_TYPE, AUDITORIUM.AUDITORIUM, AUDITORIUM.AUDITORIUM_CAPACITY
from AUDITORIUM, AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_CAPACITY >= all(select AUDITORIUM_CAPACITY from AUDITORIUM  where AUDITORIUM like '4%' )
and AUDITORIUM.AUDITORIUM_TYPE= AUDITORIUM_TYPE.AUDITORIUM_TYPE