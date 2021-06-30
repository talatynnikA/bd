use TAL_UNIVER

select top 1
(select avg(NOTE) from PROGRESS where SUBJECT like 'нюХо') [нюХо],
(select avg(NOTE) from PROGRESS where SUBJECT like 'ясад') [ясад]
from PROGRESS

--select avg(NOTE)[нюХо]
--from PROGRESS
--where  SUBJECT like 'нюХо' 