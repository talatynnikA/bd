--Курсор является программной конструкцией, которая дает возможность пользователю обрабатывать строки результирую-щего набора запись за записью. 
--Курсоры бывают локальные и глобальные (по умолчанию), статические и динамические (по умолчанию). 
--задание 1
use TAL_UNIVER
declare @tv char(20) , @t char(300) = ' '; --в декларе объявляется курсор 
declare cursor1 cursor for select SUBJECT from SUBJECT where PULPIT = 'ИСиТ';

open cursor1; --открытие курсора 
fetch cursor1 into @tv;--Оператор FETCH считывает одну строку из результирующего набора и продвигает указатель на следующую строку
--Кол-во переменных после INTO  равно кол-ву столбцов результирующего набора, а порядок=порядку перечисления столбцов в SELECT-списке
print 'Дисциплины на кафедре ИСиТ';
while @@fetch_status = 0 --выполняется вроверка значения 
begin 
set @t = rtrim(@tv) + ',' + @t;
fetch cursor1 into @tv;
end;

print @t
close cursor1; ---закрытие курсора



--задание 2
--Локальный курсор применяется в рамках 1 пакета и ресурсы, выде-ленные ему при объявлении, освобождаются сразу после завершения работы пакета.
declare cursor2_1 cursor local for select AUDITORIUM_CAPACITY, AUDITORIUM_NAME from AUDITORIUM;
declare @capacity int, @name char(10);
open cursor2_1;
fetch cursor2_1 into @capacity, @name;
print '1.' + ' ' + cast(@capacity as varchar(6)) + ' ' + @name;
go 
declare @capacity int, @name char(10);
fetch cursor2_1 into @capacity, @name;
print '2.' + cast(@capacity as varchar(6)) + @name;
go

---Глобальный курсор может быть объявлен, открыт и использован в разных пакетах.
declare cursor2_2 cursor global for select AUDITORIUM_CAPACITY, AUDITORIUM_NAME from AUDITORIUM;
declare @capacity1 int, @name1 char(10);
open cursor2_2;
fetch cursor2_2 into @capacity1, @name1;
print '1.' + ' ' + cast(@capacity1 as varchar(6)) + ' ' + @name1;
go 
declare @capacity1 int, @name1 char(10);
fetch cursor2_2 into @capacity1, @name1;
print '2.' + ' ' + cast(@capacity1 as varchar(6)) + ' ' + @name1;
close cursor2_2;
deallocate cursor2_2; ---деаллокейт освоождает выделенные ресурсы
go

--задание 3

declare @subject char(5), @idstudent char(4), @note char(1);
declare cursor3_1 cursor local static for select SUBJECT, IDSTUDENT, NOTE from PROGRESS where SUBJECT = 'СУБД'
open cursor3_1;
print 'Количество строк: ' + cast(@@cursor_rows as varchar(5)); --в курсор роус указывается кол-во записей
update PROGRESS set NOTE = 5 where	SUBJECT = 'СУБД';
delete PROGRESS where SUBJECT = 'ОАиП';	
insert PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
    values('ООП', 1025, '2020-01-01', 6)
fetch cursor3_1 into @subject, @idstudent, @note;
while @@fetch_status = 0 
begin 
print @subject + ' ' + @idstudent + ' ' + @note;
fetch cursor3_1 into @subject, @idstudent, @note;
end;
close cursor3_1;

declare @subject1 char(5), @idstudent1 char(4), @note1 char(1);
declare cursor3_2 cursor local dynamic for select SUBJECT, IDSTUDENT, NOTE from PROGRESS where SUBJECT = 'СУБД'
open cursor3_2;
print 'Количество строк: ' + cast(@@cursor_rows as varchar(5));
update PROGRESS set NOTE = 6 where	SUBJECT = 'СУБД';
delete PROGRESS where SUBJECT = 'ОАиП';	
insert PROGRESS (SUBJECT, IDSTUDENT, PDATE, NOTE)
    values('ООП', 1025, '2020-01-01', 6)
fetch cursor3_2 into @subject1, @idstudent1, @note1;
while @@fetch_status = 0 
begin 
print @subject1 + ' ' + @idstudent1 + ' ' + @note1;
fetch cursor3_2 into @subject1, @idstudent1, @note1;
end;
close cursor3_2;


--задание 4
use TAL_UNIVER;
declare @tc int, @rn char(50);
declare cursor4 cursor local dynamic scroll for --скролл позволяет применять оператор FETCH с дополнительными опциями позиционирования. 
select row_number() over(order by SUBJECT) N, SUBJECT from SUBJECT where PULPIT = 'ИСиТ';
open cursor4;
fetch cursor4 into @tc, @rn;
print 'следующая строка: ' + cast(@tc as varchar(6)) + ' ' + rtrim(@rn);
fetch last from cursor4 into @tc, @rn;
print 'последняя строка: ' + cast(@tc as varchar(6)) + ' ' + rtrim(@rn);
fetch first from cursor4 into @tc, @rn;
print 'первая строка: ' + cast(@tc as varchar(6)) + ' ' + rtrim(@rn);
fetch next from cursor4 into @tc, @rn;
print 'следующая строка от текущей: ' + cast(@tc as varchar(6)) + ' ' + rtrim(@rn);
fetch prior from cursor4 into @tc, @rn;
print 'предыдущая строка от текущей: ' + cast(@tc as varchar(6)) + ' ' + rtrim(@rn);
fetch absolute 3 from cursor4 into @tc, @rn;
print 'третья строка от начала: ' + cast(@tc as varchar(6)) + ' ' + rtrim(@rn);
fetch absolute -3 from cursor4 into @tc, @rn;
print 'третья строка от конца: ' + cast(@tc as varchar(6)) + ' ' + rtrim(@rn);
fetch relative 5 from cursor4 into @tc, @rn;
print 'пятая строка вперед от текущей: ' + cast(@tc as varchar(6)) + ' ' + rtrim(@rn);
fetch relative -5 from cursor4 into @tc, @rn;
print 'пятая строка назад от текущей: ' + cast(@tc as varchar(6)) + ' ' + rtrim(@rn);
close cursor4;


--задание 5
declare @s char(10), @p char(10), @n varchar(200);
declare cursor5_1 cursor local dynamic scroll for
select SUBJECT, PULPIT, SUBJECT_NAME from SUBJECT
open cursor5_1;
fetch cursor5_1 into @s, @p, @n
while @@fetch_status = 0
 begin
   if @s = 'БД' update SUBJECT set SUBJECT_NAME = 'Самая важная дисциплина!!!' where current of cursor5_1 

   fetch cursor5_1 into @s, @p, @n  
 end
fetch first from cursor5_1 into @s, @p, @n
print 'измененная строка: ' + rtrim(@s) + ' | ' + rtrim(@p) + ' | ' + rtrim(@n);
close cursor5_1
go

declare @a1 char(5), @b1 char(5), @c1 char(15), @d1 char(2);
declare cursor5_2 cursor local dynamic scroll for 
select SUBJECT, IDSTUDENT, PDATE, NOTE from PROGRESS
open cursor5_2;
fetch cursor5_2 into @a1, @b1, @c1, @d1
while @@fetch_status = 0 
 begin
  if @d1 = '5' delete PROGRESS where current of cursor5_2
  fetch cursor5_2 into @a1, @b1, @c1, @d1
 end
close cursor5_2;
go

--задание 6
declare @id char(4), @note char(1); 
declare cursor6 cursor local for 
select s.IDSTUDENT, p.NOTE from STUDENT s inner join  PROGRESS p
on s.IDSTUDENT = p.IDSTUDENT

open cursor6;
fetch cursor6 into @id, @note;
while @@fetch_status = 0
 begin
  if @note < 7 delete PROGRESS where current of cursor6
  if @id = '1025' update PROGRESS set NOTE += 1 where current of cursor6
  fetch cursor6 into @id, @note;
 end
close cursor6;
go

