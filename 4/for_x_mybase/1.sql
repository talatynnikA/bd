USE MASTER
GO

CREATE DATABASE Tal__MyBase
ON PRIMARY
(
	NAME = N'Tal_MyBase_mdf.mdf',
    FILENAME = N'D:\Tal_MyBase_DB.mdf',

    SIZE = 5MB,
    MAXSIZE = 10MB,
    FILEGROWTH = 1MB
),
FILEGROUP G1
( 
    NAME = N'Tal_MyBase_11',
    FILENAME = N'D:\Tal_MyBase_G1_1.ndf', 
    SIZE = 10Mb,
    MAXSIZE=15Mb,
    FILEGROWTH=1Mb
),
( 
    NAME = N'Tal_MyBase_12',
    FILENAME = N'D:\Tal_MyBase_G1_2.ndf', 
    SIZE = 2Mb, 
    MAXSIZE=5Mb,
    FILEGROWTH=1Mb
),
FILEGROUP G2
(
    NAME = N'Tal_MyBase_21',
    FILENAME = N'D:\Tal_MyBase_G2_1.ndf', 
    SIZE = 5Mb,
    MAXSIZE=10Mb,
    FILEGROWTH=1Mb
),
(
    NAME = N'Tal_MyBase_22',
    FILENAME = N'D:\Tal_MyBase_G2_2.ndf', 
    SIZE = 2Mb,
    MAXSIZE=5Mb,
    FILEGROWTH=1Mb
)
LOG ON
(
    NAME = N'Tal_MyBase_LOG',
    FILENAME = N'D:\Tal_MyBase_LOG.ldf',
    SIZE = 5Mb,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 1MB
)
GO

create table Покупатель 
(
     Покупатель   nvarchar(50)  constraint Покупатель_PK  primary key,              
     Телефон     nvarchar(50)  not null,                                   
     Адрес  nvarchar(50) null                                     
)
insert into  Покупатель   (Покупатель, Телефон,  
 Адрес)   
values  ('Кто-то', '+37545454545','улица пушкина');
insert into  Покупатель   (Покупатель, Телефон,  
 Адрес)   
values  ('где-то', '+37545887545','улица петра');
insert into  Покупатель   (Покупатель, Телефон,  
 Адрес)   
values  ('кого-то', '+37589745','улица ленина');
insert into  Покупатель   (Покупатель, Телефон,  
 Адрес)   
values  ('Аноним', '+3756788545','улица фа');
insert into  Покупатель   (Покупатель, Телефон,  
 Адрес)   
values  ('Василий', '+375468888','улица ьььььь');
insert into  Покупатель   (Покупатель, Телефон,  
 Адрес)   
values  ('Петр', '+375456665','улица хххххх');


create table Сделка
(
	Номер_сделки int(50) primary key,
	Наименование_товара nvarchar(50) not null,
	Количество int(50) not null,
	Покупатель nvarchar(50) constraint  Сделка_Покупатель_FK foreign key 
                                  references Покупатель(Покупатель),
	Дата_сделки date null,
	Количество_ячеек real null
)
insert into  Сделка   (Номер_сделки, Наименование_товара,  
 Количество,Дата_сделки,Количество_ячеек)   
values  (1, 'товар1',10, 2021-02-28, 12);
insert into  Сделка   (Номер_сделки, Наименование_товара,  
 Количество,Дата_сделки,Количество_ячеек)   
values  (2, 'товар2',20, 2019-09-01, 13);
insert into  Сделка   (Номер_сделки, Наименование_товара,  
 Количество,Дата_сделки,Количество_ячеек)   
values  (3, 'товар3',120, 2020-08-14, 14);
insert into  Сделка   (Номер_сделки, Наименование_товара,  
 Количество,Дата_сделки,Количество_ячеек)   
values  (4, 'товар4',40, 2021-01-28, 15);
insert into  Сделка   (Номер_сделки, Наименование_товара,  
 Количество,Дата_сделки,Количество_ячеек)   
values  (5, 'товар5',50, 2021-03-21, 16);
insert into  Сделка   (Номер_сделки, Наименование_товара,  
 Количество,Дата_сделки,Количество_ячеек)   
values  (6, 'товар6',60, 2011-12-31, 17);


create table Товары_
(
	
	Наименование_товара nvarchar(50) primary key,
	Цена real null,
	Описание nvarchar(250), null,
	Место_хранения nvarchar(50), not null,
	Количество_ячеек int constraint  Товары__Количество_ячеек_FK foreign key 
                                  references Сделка(Количество_ячеек),
)
insert into  Товары_   (Наименование_товара, Цена,  
 Описание,Место_хранения)   
values  ('товар1', 1111,'описание1', 'место1');
insert into  Товары_   (Наименование_товара, Цена,  
 Описание,Место_хранения)   
values  ('товар2', 2222,'описание2', 'место2');
insert into  Товары_   (Наименование_товара, Цена,  
 Описание,Место_хранения)   
values  ('товар3', 3333,'описание3', 'место3');
insert into  Товары_   (Наименование_товара, Цена,  
 Описание,Место_хранения)   
values  ('товар4', 4444,'описание4', 'место4');
insert into  Товары_   (Наименование_товара, Цена,  
 Описание,Место_хранения)   
values  ('товар5', 5555,'описание5', 'место5');
insert into  Товары_   (Наименование_товара, Цена,  
 Описание,Место_хранения)   
values  ('товар6', 6666,'описание6', 'место6');
