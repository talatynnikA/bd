
--задание 1 

use TAL_UNIVER;
create table TR_AUDIT -- создаем таблицу для добавления строк триггерами
(
  ID int identity,                -- номер
  STMT varchar(20),               -- DML-оператор
     check (STMT in ('INS', 'DEL', 'UPD')),
  TRNAME varchar(50),             -- имя триггера
  CC varchar(300)                 -- комментарий
)

select * from TR_AUDIT
delete TR_AUDIT
go 

create trigger TR_TEACHERS_INS on TEACHER after insert ---after триггер
as 
  declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
  print 'Операция вставки';
  set @a1 = (select TEACHER from inserted);
  set @a2 = (select TEACHER_NAME from inserted);
  set @a3 = (select GENDER from inserted);
  set @a4 = (select PULPIT from inserted);
  set @in = @a1+' '+@a2+' '+@a3+' '+@a4;

  insert into TR_AUDIT(STMT, TRNAME, CC)
   values('INS', 'TR TEACHERS INS', @in)
   return;

insert into TEACHER
   values('ТАД', 'Талатынник Артём Дмитриевич', 'М', 'ИСиТ')
   --values('ШМА', 'Шкурко Мария Александровна', 'Ж', 'ПОИТ')

   select * from TR_AUDIT


drop trigger TR_TEACHERS_INS
--задание 2
-- after триггер реаг. на событие delete

create trigger TR_TEACHER_DEL on TEACHER after delete 
as
  declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
  print 'Операция удаления';
  set @a1 = (select TEACHER from deleted);
  set @a2 = (select TEACHER_NAME from deleted);
  set @a3 = (select GENDER from deleted);
  set @a4 = (select PULPIT from deleted);
  set @in = @a1+' '+@a2+' '+@a3+' '+@a4;

  insert into TR_AUDIT(STMT, TRNAME, CC)
   values('DEL', 'TR TEACHER DEL', @in)
   return;

  select * from TEACHER

 delete from TEACHER
 where TEACHER = 'Y4itel    '


 drop trigger TR_TEACHER_DEL
 --задание 3 --триггер реаг. на update


 create trigger TR_TEACHER_UPD on TEACHER after update
 as 
   declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
    print 'Операция обновления';
    set @a1 = (select TEACHER from inserted);
	set @a2= (select TEACHER_NAME from inserted);
	set @a3= (select GENDER from inserted);
	set @a4 = (select PULPIT from inserted);
	set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
	set @a1 = (select TEACHER from deleted);
	set @a2= (select TEACHER_NAME from deleted);
	set @a3= (select GENDER from deleted);
	set @a4 = (select PULPIT from deleted);
	set @in =@in + '' + @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
	insert into TR_AUDIT(STMT, TRNAME, CC)  --в сс значения столбцов до и после изменения
						values('UPD', 'TR_TEACHER_UPD', @in);	         
return

update TEACHER set GENDER = 'м' where PULPIT = 'ПОИТ'


drop trigger TR_TEACHER_UPD
--задание 4
--реагирующий на события INSERT, DELETE, UPDATE. 

create trigger TR_TEACHER on TEACHER after insert, update, delete
as 
  declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
  declare @ins int = (select count(*) from inserted),
	      @del int = (select count(*) from deleted); 

  if @ins > 0 and @del = 0
  begin 
   print 'Событие: INSERT'
   set @a1 = (select TEACHER from inserted);
   set @a2 = (select TEACHER_NAME from inserted);
   set @a3 = (select GENDER from inserted);
   set @a4 = (select PULPIT from inserted);
   set @in = @a1+' '+@a2+' '+@a3+' '+@a4;

   insert into TR_AUDIT(STMT, TRNAME, CC)
    values('INS', 'TR TEACHERS', @in);
  end;

  else
  if @ins = 0 and @del > 0
  begin 
   print 'Событие: DELETE'
   set @a1 = (select TEACHER from deleted);
   set @a2 = (select TEACHER_NAME from deleted);
   set @a3 = (select GENDER from deleted);
   set @a4 = (select PULPIT from deleted);
   set @in = @a1+' '+@a2+' '+@a3+' '+@a4;

   insert into TR_AUDIT(STMT, TRNAME, CC)
    values('DEL', 'TR TEACHER', @in)
  end;

  else 
  if @ins > 0 and @del > 0
  begin 
   print 'Событие: UPDATE'
   set @a1 = (select TEACHER from inserted);
   set @a2= (select TEACHER_NAME from inserted);
	set @a3= (select GENDER from inserted);
	set @a4 = (select PULPIT from inserted);
	set @in = @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
	set @a1 = (select TEACHER from deleted);
	set @a2= (select TEACHER_NAME from deleted);
	set @a3= (select GENDER from deleted);
	set @a4 = (select PULPIT from deleted);
	set @in =@in + '' + @a1+' '+ @a2 +' '+ @a3+ ' ' +@a4;
	insert into TR_AUDIT(STMT, TRNAME, CC)  
						values('UPD', 'TR TEACHER', @in);	
  end;
  return;


 delete from TEACHER
 where TEACHER = 'ДМВ'

insert into TEACHER
   values('ДМВ', 'Дядюк Максим Валентинович', 'М', 'ИСиТ')

update TEACHER set GENDER = 'м' where PULPIT = 'ПОИТ'

select * from TR_AUDIT



drop trigger TR_TEACHER
--задание 5--проверка ограничения целостн. до срабатывания after триггера


update TEACHER set GENDER = 'd' where TEACHER = 'ДМВ'
select * from TR_AUDIT


--задание 6
 --для teacher 3 after-trigger которые реагируют на delete и формируют соотв. строки в таблицу tr audit
--1
create trigger TR_TEACHER_DEL1 on TEACHER after delete
as
  declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
  print 'Операция удаления 1-й триггер'
  set @a1 = (select TEACHER from deleted);
  set @a2 = (select TEACHER_NAME from deleted);
  set @a3 = (select GENDER from deleted);
  set @a4 = (select PULPIT from deleted);
  set @in = @a1+' '+@a2+' '+@a3+' '+@a4;

  insert into TR_AUDIT(STMT, TRNAME, CC)
   values('DEL', 'TR TEACHER DEL1', @in)
   return;

--2
create trigger TR_TEACHER_DEL2 on TEACHER after delete 
as 
  declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
  print 'Операция удаления 2-й триггер'
  set @a1 = (select TEACHER from deleted);
  set @a2 = (select TEACHER_NAME from deleted);
  set @a3 = (select GENDER from deleted);
  set @a4 = (select PULPIT from deleted);
  set @in = @a1+' '+@a2+' '+@a3+' '+@a4;

  insert into TR_AUDIT(STMT, TRNAME, CC)
   values('DEL', 'TR TEACHER DEL2', @in)
   return;

--3
create trigger TR_TEACHER_DEL3 on TEACHER after delete 
as 
  declare @a1 char(10), @a2 varchar(100), @a3 char(1), @a4 char(20), @in varchar(300);
  print 'Операция удаления 3-й триггер'
  set @a1 = (select TEACHER from deleted);
  set @a2 = (select TEACHER_NAME from deleted);
  set @a3 = (select GENDER from deleted);
  set @a4 = (select PULPIT from deleted);
  set @in = @a1+' '+@a2+' '+@a3+' '+@a4;

  insert into TR_AUDIT(STMT, TRNAME, CC)
   values('DEL', 'TR TEACHER DEL3', @in)
   return;


select t.name, e.type_desc
  from sys.triggers t join sys.trigger_events e 
   on t.object_id = e.object_id
     where OBJECT_NAME(t.parent_id) = 'TEACHER' and e.type_desc = 'DELETE'



exec SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3',-- упорядочить
             @order = 'First', @stmttype = 'DELETE'
exec SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2',
             @order = 'Last', @stmttype = 'DELETE'

 delete from TEACHER
 where TEACHER = 'ДМВ'

 select * from TR_AUDIT



drop trigger TR_TEACHER_DEL1;
drop trigger TR_TEACHER_DEL2;
drop trigger TR_TEACHER_DEL3;
 --задание 7 --after триггер является частью транзакции в рамках которого выполняется оператор актив. триггер
 create trigger TR_PULPIT_TRAN on PULPIT after insert
 as
   declare @c int = (select count(*) from PULPIT)
   if (@c > 23)
   begin 
       raiserror('Общее количество кафедр не может быть больше 24', 10, 1);
	   rollback;
   end;
return;

insert into PULPIT(PULPIT) values('new')


drop trigger TR_PULPIT_TRAN;
--задание 8--instead of- trigger запр. удаление строк в таблице


create trigger TR_FACULTY_INSTEAD_OF on FACULTY instead of delete
as 
  raiserror(N'Удаление запрещено', 11, 1);
return 

delete FACULTY where FACULTY = 'ИДиП'



drop trigger TR_TEACHERS_INS
drop trigger TR_TEACHER_DEL
drop trigger TR_TEACHER_UPD
drop trigger TR_TEACHER
drop trigger TR_TEACHER_DEL1;
drop trigger TR_TEACHER_DEL2;
drop trigger TR_TEACHER_DEL3;
drop trigger TR_FACULTY_INSTEAD_OF



--задание 9



use TAL_UNIVER
create trigger DDL_TR_PROGRESS on database for DDL_DATABASE_LEVEL_EVENTS
as
  declare @t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','varchar(50)'),
		  @t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','varchar(50)'),
		  @t3 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]','varchar(50)');
  if @t1 = 'progress'
	begin
		print 'Тип события: '+@t1;
		print 'Имя объекта: '+@t2;
		print 'Тип события: '+@t3;
		raiserror(N'операции с таблицей PROGRESS запрещены',16,1);
		rollback;
	end
return

alter table PROGRESS drop Column PDATE




drop trigger DDL_TR_PROGRESS
