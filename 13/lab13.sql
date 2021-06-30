use TAL_UNIVER;


--Задание 1--процедура без параметров
select * from SUBJECT;
go
create procedure PSUBJECT
as
	begin 
	declare @count int = (select count(*) from SUBJECT)
	select * from SUBJECT
	return @count
	end;
go
declare @k int = 0;
exec @k = PSUBJECT; --вызов процедуры
print 'кол-во предметов = ' + cast(@k as varchar(5));



--Задание 2-- изменить сценарий задания 1
go
alter procedure PSUBJECT @p varchar(20) null, @c int output
as begin
	declare @count int = (select count(*) from SUBJECT)
	print 'параметры @p = ' + @p + ', @c = ' + cast(@c as varchar(5))
	select * from SUBJECT where PULPIT = @p;
	set @c = @@rowcount
	return @count --зн-е к точке вызова
	end;

go
declare @k int = 0, @r int = 0, @p varchar(20) = 'ТЛ';
exec @k = PSUBJECT @p, @c = @r output;
print 'кол-во предметов всего = ' + cast(@k as varchar(5))
print 'кол-во предметов на кафедре ТЛ = ' + cast(@r as varchar(5));



--Задание 3 --процедура без выходного параметра, временная таблица с рез. набором PSUBJECT
select * from SUBJECT;

go
alter procedure PSUBJECT @p varchar(20)
as begin
	declare @count int = (select count(*) from SUBJECT)
	select * from SUBJECT where PULPIT = @p
	end;
go
create table #TSUBJECT
(
	SUBJECT char(10) not null,
	SUBJECT_name varchar(100) null,
	pulpit char(20) not null
)

insert into #TSUBJECT exec PSUBJECT @p = 'ТЛ';
select * from #TSUBJECT;



--Задание 4--процедура с try/catch и зн-я столбцов задаются параметрами
select * from AUDITORIUM;

go
create procedure PAUDITORIUM_INSERT @a char(20), @at char(10), @ac int null, @an varchar(50) null
as declare @rc int = 1
begin try
	insert into AUDITORIUM(AUDITORIUM,AUDITORIUM_TYPE,AUDITORIUM_CAPACITY,AUDITORIUM_NAME)
	values (@a, @at, @ac, @an)
	return @rc -- 1 если успешно
end try
begin catch --обработка ошибки
	print 'Номер ошибки: ' + cast(error_number() as varchar(6))
	print 'Сообщение: ' + error_message()
	print 'Уровень: ' + cast(error_severity() as varchar(6))
	print 'Метка: ' + cast(error_state() as varchar(8))
	print 'Номер строки: ' + cast(error_line() as varchar(8))

	if error_procedure() is not null 
	print 'Имя процедуры: ' + error_procedure()
	set @rc = -1
	return @rc
end catch;


go
declare @rc int;
exec @rc = PAUDITORIUM_INSERT @a = '999-9', @at = 'ЛК', @ac = 30, @an = '999-9';
if @rc = -1
	print 'Код ошибки: ' + cast(@rc as varchar(3))
else print 'Выполнено без ошибок';

select * from AUDITORIUM;

delete from AUDITORIUM where AUDITORIUM = '999-9';

drop procedure PAUDITORIUM_INSERT;



--Задание 5--отчет со списком дисциплин
select * from SUBJECT;

go
create procedure PSUBJECT_REPORT @p char(10)
as declare @rc int = 0
begin try 
	declare @sv char(20), @s char(300) = '';
	declare Cursor_SUBJECT cursor for
	select SUBJECT from SUBJECT where PULPIT = @p

	if not exists(select SUBJECT from SUBJECT where PULPIT = @p)
		raiserror('Ошибка',11,1) --сообщение и обработка если названия кафедры нет
	else
		open Cursor_SUBJECT;

	fetch Cursor_SUBJECT into @sv;
	print 'Предметы на кафедре ' + @p
	while @@fetch_status = 0 
		begin
		set @s = rtrim(@sv) + ',' + @s
		set @rc = @rc + 1;
		fetch Cursor_SUBJECT into @sv;
		end;
	print @s;
	close Cursor_SUBJECT
	return @rc;
end try
begin catch
	print 'Ошибка в параметрах' --если нет кода кафедры
	if error_procedure() is not null
		print 'Имя процедуры: ' + error_procedure()
	return	@rc
end catch;

go
declare @rc int;
exec @rc = PSUBJECT_REPORT @p = 'ТЛ';
print 'Количество дисциплин: ' + cast(@rc as varchar(5));



--Задание 6
select * from AUDITORIUM;
select * from AUDITORIUM_TYPE;


go
create procedure PAUDITORIUM_AND_AUDITORIUM_TYPE_INSERT
				@a char(20), @at char(10), @ac int null, @an varchar(50), @atn varchar(30) null
as declare @rc int = 1
begin try
	set transaction isolation level serializable
	begin tran      -- добавление путем выполнения транзакции
	insert into AUDITORIUM_TYPE(AUDITORIUM_TYPE, AUDITORIUM_TYPENAME) -- добавление путем вызова процедуры
	values(@at, @atn)
	exec @rc = PAUDITORIUM_INSERT @a, @at, @ac, @an
	commit tran
	return @rc
end try
begin catch -- обработка ошибок
	print 'Номер ошибки  : ' + cast(error_number() as varchar(6));
    print 'Сообщение     : ' + error_message();
    print 'Уровень       : ' + cast(error_severity()  as varchar(6));
    print 'Метка         : ' + cast(error_state()   as varchar(8));
	print 'Номер строки  : ' + cast(error_line()  as varchar(8));
	if error_procedure() is not  null   
			print 'Имя процедуры : ' + error_procedure();
     if @@trancount > 0 rollback tran ; 
			return -1;	  
end catch;

go
declare @rc int;
exec @rc = PAUDITORIUM_AND_AUDITORIUM_TYPE_INSERT @a = '333-3', @at = 'ЛБ-К-К', @ac = 50, @an = '333-3', @atn = 'Комп. класс с роботом'
print 'Код ошибки = ' + cast(@rc as varchar(3));

select * from AUDITORIUM;
select * from AUDITORIUM_TYPE;

delete from AUDITORIUM where AUDITORIUM = '333-3';
delete from AUDITORIUM_TYPE where AUDITORIUM_TYPE = 'ЛБ-К-К';




