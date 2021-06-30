USE MASTER
GO

CREATE DATABASE Tal_MyBase
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


USE Tal_1_MyBase

create table ���������� 
(
     ����������   nvarchar(50)  constraint ����������_PK  primary key,              
     �������     nvarchar(50)  not null,                                   
     �����  nvarchar(50) null                                     
)
insert into  ����������   (����������, �������,  
 �����)   
values  ('���-��', '+37545454545','����� �������');
insert into  ����������   (����������, �������,  
 �����)   
values  ('���-��', '+37545887545','����� �����');
insert into  ����������   (����������, �������,  
 �����)   
values  ('����-��', '+37589745','����� ������');
insert into  ����������   (����������, �������,  
 �����)   
values  ('������', '+3756788545','����� ��');
insert into  ����������   (����������, �������,  
 �����)   
values  ('�������', '+375468888','����� ������');
insert into  ����������   (����������, �������,  
 �����)   
values  ('����', '+375456665','����� ������');


create table ������
(
	�����_������ int primary key,
	������������_������ nvarchar(50) not null,
	���������� int not null,
	���������� nvarchar(50) constraint  ������_����������_FK foreign key 
                                  references ����������(����������),
	����_������ date null,
	����������_����� real null
)
insert into  ������   (�����_������, ������������_������,  
 ����������,����_������,����������_�����)   
values  (1, '�����1',10, '2021-02-28', 12);
insert into  ������   (�����_������, ������������_������,  
 ����������,����_������,����������_�����)   
values  (2, '�����2',20, '2019-09-01', 13);
insert into  ������   (�����_������, ������������_������,  
 ����������,����_������,����������_�����)   
values  (3, '�����3',120, '2020-08-14', 14);
insert into  ������   (�����_������, ������������_������,  
 ����������,����_������,����������_�����)   
values  (4, '�����4',40, '2021-01-28', 15);
insert into  ������   (�����_������, ������������_������,  
 ����������,����_������,����������_�����)   
values  (5, '�����5',50, '2021-03-21', 16);
insert into  ������   (�����_������, ������������_������,  
 ����������,����_������,����������_�����)   
values  (6, '�����6',60, '2011-12-31', 17);


create table ������_
(
	
	������������_������ nvarchar(50) primary key,
	���� real null,
	�������� nvarchar(250) null,
	�����_�������� nvarchar(50) not null,
	����������_����� real null, 
                                
)
insert into  ������_   (������������_������, ����,  
 ��������,�����_��������)   
values  ('�����1', 1111,'��������1', '�����1');
insert into  ������_   (������������_������, ����,  
 ��������,�����_��������)   
values  ('�����2', 2222,'��������2', '�����2');
insert into  ������_   (������������_������, ����,  
 ��������,�����_��������)   
values  ('�����3', 3333,'��������3', '�����3');
insert into  ������_   (������������_������, ����,  
 ��������,�����_��������)   
values  ('�����4', 4444,'��������4', '�����4');
insert into  ������_   (������������_������, ����,  
 ��������,�����_��������)   
values  ('�����5', 5555,'��������5', '�����5');
insert into  ������_   (������������_������, ����,  
 ��������,�����_��������)   
values  ('�����6', 6666,'��������6', '�����6');
