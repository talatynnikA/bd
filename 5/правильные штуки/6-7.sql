use TAL_UNIVER

select isnull(TEACHER.TEACHER_NAME,'***')[TEACHER_NAME], PULPIT.PULPIT_NAME
from PULPIT left outer join TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT

select isnull(TEACHER.TEACHER_NAME,'***')[TEACHER_NAME], PULPIT.PULPIT_NAME
from  TEACHER right outer join  PULPIT
on PULPIT.PULPIT = TEACHER.PULPIT

select isnull(TEACHER.TEACHER_NAME,'***')[TEACHER_NAME], PULPIT.PULPIT_NAME
from PULPIT  right outer join  TEACHER
on PULPIT.PULPIT = TEACHER.PULPIT