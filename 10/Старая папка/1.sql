use TAL_UNIVER

----------1

exec sp_helpindex 'STUDENT'
exec sp_helpindex 'AUDITORIUM'
exec sp_helpindex 'AUDITORIUM_TYPE'

----------

create table #task (id int identity(1,1), kind varchar(100), cost int);

declare @i int = 0, @kind varchar(100) = '***', @cost float = 25;

while @i < 1000
begin
insert #task(kind,cost) values (@kind, @cost);
set @i = @i + 1;
set @cost = @cost+10;
end

select * from #task 

create clustered index #task_CL on #task(id asc)
select * from #task where id < 100 order by id desc

drop table #task

----------2_некластеризованный_составной_неуникальный

create table #EX
(TKEY int, CC int identity(1,1),TF varchar(100));
set nocount on;    

declare @a int = 0;

while   @a < 20000
begin
insert #EX(TKEY, TF) values (floor(30000*RAND()), replicate('строка ', 10));
set @a = @a + 1; 
end;
  
create index #EX_NONCLU on #EX(TKEY, CC)

--индекс не применяется
select * from  #EX where  TKEY > 1500 and  CC < 4500;  
select * from  #EX order by  TKEY, CC

--индекс применяется
select * from  #EX where  TKEY = 556 and  CC > 3

drop table #EX

----------3_некластеризованный_покрытия

create table #EX3
(TKEY int, CC int identity(1,1),TF varchar(100));
set nocount on;    

declare @aa int = 0;

while   @aa < 20000
begin
insert #EX3(TKEY, TF) values (floor(30000*RAND()), replicate('строка ', 10));
set @aa = @aa + 1; 
end;
  
create  index #EX_TKEY_X on #EX3(TKEY) include (CC)

select CC from #EX3 where TKEY > 15000 

drop table #EX3

----------4_некластеризованный_фильтруемый

create table #EX4
(TKEY int, CC int identity(1,1),TF varchar(100));
set nocount on;    

declare @aaa int = 0;

while   @aaa < 20000
begin
insert #EX4(TKEY, TF) values (floor(30000*RAND()), replicate('строка ', 10));
set @aaa = @aaa + 1; 
end;
  
select TKEY from  #EX4 where TKEY between 5000 and 19999; 
select TKEY from  #EX4 where TKEY > 15000 and  TKEY < 20000  
select TKEY from  #EX4 where TKEY = 17000

create  index #EX_WHERE on #EX4(TKEY) where (TKEY >= 15000 and TKEY < 20000);  

drop table #EX4

----------5

create table #EX5
(TKEY int, CC int identity(1, 1), TF varchar(100));

set nocount on;           
declare @b int = 0;

while   @b < 20000      
begin
insert #EX5(TKEY, TF) values(floor(30000 * RAND()), replicate('строка ', 10));
set @b = @b + 1; 
end;

create index #EX_TKEY ON #EX5(TKEY);

insert top(10000) #EX5(TKEY, TF) select TKEY, TF from #EX5;

--фрагментация
select name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
from sys.dm_db_index_physical_stats(db_id(N'EX5db'), object_id(N'EX5'), NULL, NULL, NULL) ss 
join sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id
where name is not null;

--реорганизация
alter index #EX_TKEY on #EX5 reorganize;

select name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
from sys.dm_db_index_physical_stats(db_id(N'EX5db'), object_id(N'EX5'), NULL, NULL, NULL) ss 
join sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id
where name is not null;

--перестройка
alter index #EX_TKEY on #EX5 rebuild;

select name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
from sys.dm_db_index_physical_stats(db_id(N'EX5db'), object_id(N'EX5'), NULL, NULL, NULL) ss 
join sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id
where name is not null;

drop table #EX5

----------6_процент_заполнения_индексных_страниц_нижнего_уровня

drop index #EX_TKEY on #EX5;
create index #EX_TKEY on #EX5(TKEY) with (fillfactor = 65);

insert top(50) percent #EX5(TKEY, TF) select TKEY, TF from #EX5;

select name [Индекс], avg_fragmentation_in_percent [Фрагментация (%)]
from sys.dm_db_index_physical_stats(db_id(N'EX5db'), object_id(N'EX5'), NULL, NULL, NULL) ss 
join sys.indexes ii on ss.object_id = ii.object_id and ss.index_id = ii.index_id
where name is not null;