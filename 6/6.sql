use TAL_UNIVER

select top 1
(select avg(NOTE) from PROGRESS where SUBJECT like '����') [����],
(select avg(NOTE) from PROGRESS where SUBJECT like '����') [����]
from PROGRESS

--select avg(NOTE)[����]
--from PROGRESS
--where  SUBJECT like '����' 