use TAL_UNIVER

select distinct s1.NAME, s1.BDAY
from STUDENT s1 inner join STUDENT s2 on s1.BDAY = s2.BDAY and s1.NAME != s2.NAME 
order by s1.BDAY desc