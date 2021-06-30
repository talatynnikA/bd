use TAL_UNIVER

----------1

declare @a char = 'a1', 
@b varchar(50) = 'Artyom_FIT', 
@c datetime, 
@d time,
@e int,
@f smallint,
@g tinyint,
@h numeric(12, 5); 

set @c = getdate(); set @d=sysdatetime();   --присвоить значения set и вычисления

set @e=(select count(*) from AUDITORIUM);

select @g=12, @h=2.55; --неск перем присв зн-я. 

select @a '@a char', @b '@b varchar(50)', @c '@c datetime', @g '@g tinyint';

print @d; 
print '@e int = ' + cast (@e as varchar(10));
print @f;
print '@h numeric(12, 5) = ' + cast(@h as varchar(10))

----------2

declare @total int, @countOfAudit numeric(8, 1), @AVGOfAudit numeric(8, 1), @countOfAuditSmall numeric(8, 1), @procent numeric(8, 1);

select @total = (select sum(AUDITORIUM_CAPACITY) from AUDITORIUM)

if @total>200
begin
select @countOfAudit = (select cast(count(*) as numeric(8, 1)) from AUDITORIUM);
select @AVGOfAudit = (select AVG(AUDITORIUM_CAPACITY) from AUDITORIUM);
select @countOfAuditSmall = (select cast(count(*) as numeric(8, 1)) from AUDITORIUM where AUDITORIUM_CAPACITY < @AVGOfAudit);
set @procent = @countOfAuditSmall/@countOfAudit*100;

select @total 'Общая вместимость', @countOfAudit 'Кол-во аудиторий', @AVGOfAudit 'Средняя вместимость', 
@countOfAuditSmall 'Аудит. с вмест-тью мен., чем средняя', @procent 'Процент аудит. с мен. вмест-тью'; 
end

else if @total<200 print 'Общая вместимость меньше 200 и равна ' + cast(@total as varchar(10))

----------3
      --глоб. переменные
select @@ROWCOUNT [число обработанных строк];
select @@VERSION [версия SQL Server];
select @@SPID [возвр. сист. идент-тор процесса, назначенный сервером текущему подключению];
select @@ERROR [код последней ошибки];
select @@SERVERNAME [имя сервера];
select @@TRANCOUNT [возвр. ур. вложенности транзакции];
select @@FETCH_STATUS [проверка рез-та считывания строк результ. набора];
select @@NESTLEVEL [ур вложенности текущ. процедуры]

----------4

declare @t float = 0.9, @x float = 0.4, @z numeric(8, 3) ;

if (@t>@x)
set @z = power(sin(@t), 2)
else if (@t<@x)
set @z = 4*(@t+@x)
else 
set @z = 1-exp(@x-2)

select @z 'значение z'

----------

--SUBSTRING(выражение, начальная позиция, длина)
--CHARINDEX(искомое выражение, строковое выражение)
declare  @fio varchar(100) = 'Талатынник Артём Дмитриевич'
select 
  SUBSTRING(@fio, 1, CHARINDEX(' ', @fio))
+ SUBSTRING(@fio, CHARINDEX(' ', @fio) + 1, 1) + '. '
+ SUBSTRING(@fio, CHARINDEX(' ', @fio, CHARINDEX(' ', @fio)+ 1 ) + 1, 1) + '.'

----------

select BDAY [Дата рождения], NAME [ФИО], YEAR(getdate())-YEAR(BDAY) [Возраст]
from STUDENT
where MONTH(BDAY)=MONTH(getdate()) + 1

----------

select STUDENT.NAME [ФИО], STUDENT.IDGROUP [Номер группы], datename(WEEKDAY ,DAY(PROGRESS.PDATE)) [День]
from STUDENT  
inner join PROGRESS on STUDENT.IDSTUDENT= PROGRESS.IDSTUDENT
where  PROGRESS.SUBJECT = 'СУБД'
order by STUDENT.NAME 
----------------



----------5

declare @kolAudit0 int, @kolAudit90 int;
set @kolAudit0 = (select count(*) from AUDITORIUM where AUDITORIUM_CAPACITY<60); 
set @kolAudit90 = (select count(*) from AUDITORIUM where AUDITORIUM_CAPACITY>60); 

if (@kolAudit0>@kolAudit90)
print 'Преобладают аудитории для группы'
else if (@kolAudit0<@kolAudit90)
print 'Преобладают аудитории для потоков'
else 
print 'Количетсво аудиторий для групп и для потоков одинаково'

----------6

select case
when NOTE in(4,5) then 'Средний'
when NOTE in(6,7) then 'Выше среднего'
when NOTE in(8,9) then 'Высокий'
when NOTE = 10 then 'Очень высокий'
else 'Низкий'
end [Уровень знаний], count(*) [Количество студентов факультета]
from PROGRESS

group by case 
when NOTE in(4,5) then 'Средний'
when NOTE in(6,7) then 'Выше среднего'
when NOTE in(8,9) then 'Высокий'
when NOTE=10 then 'Очень высокий'
else 'Низкий'
end

----------7

create table #color (id int identity(1,1), kind varchar(100), cost int);

declare @i int = 0, @kind varchar(100) = '***', @cost float = 25;

while @i < 10
begin
insert #color(kind,cost) values (@kind, @cost);
set @kind = @kind + '***';
set @i = @i + 1;
set @cost = @cost*1.1;
end

select * from #color 

drop table #color

----------8
--Оператор RETURN служит для немедленного завершения работы пакета
create table #color (id int identity(1,1), kind varchar(100), cost int);

declare @i int = 0, @kind varchar(100) = '***', @cost float = 25;

while @i < 10
begin
insert #color(kind,cost) values (@kind, @cost);
set @kind = @kind + '***';

if @i=6

begin
select * from #color 
return
end
else

begin
set @i = @i + 1;
set @cost = @cost*1.1;
end

end

select * from #color 

drop table #color

----------9

declare @num1 int = 10, @num2 int = 0, @del float;

begin try 
set @del=@num1/@num2;
print 'Деление выполнилось';
end try

begin catch 
print error_number();
print error_message();
print error_line();
print error_procedure();--имя хранимой процедуры или триггера, в которых произошла ошибка.
print error_severity();--возвращает значение серьезности ошибки, вызвавшей выполнение блока CATCH.
print error_state();--Возвращает номер состояния для ошибки
end catch