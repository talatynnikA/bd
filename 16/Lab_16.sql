--задание 1
-- PATH xml 

--сценарий создания xml дока в режиме path из teacher для преп. кафедры исит
use TAL_UNIVER
SELECT * FROM TEACHER 
where PULPIT = 'ИСиТ' 
for xml path('Преподаватель'), root('Список_преподавателей'), elements;





--задание 2
-- AUTO xml



select AUDITORIUM.AUDITORIUM [Номер], AUDITORIUM_TYPE.AUDITORIUM_TYPE [Тип], AUDITORIUM_CAPACITY [Вместимость] 
	from AUDITORIUM inner join AUDITORIUM_TYPE
	on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
	where AUDITORIUM.AUDITORIUM_TYPE = 'ЛК' -- найти только лекционные
	for xml auto, root('AUDITORIYMS'), elements;



--задание 3--док о 3-х новый дисциплинах которые следует добавить в таблицу
declare @h int = 0,
@x varchar(2000) = 
    '<?xml version="1.0" encoding="windows-1251"?>
     <SUBJECTS>
	   <SUBJECT SHORTNAME="ОИТ1" FULLNAME="Основы информационных технологий" PULPIT="ИСиТ" />
	   <SUBJECT SHORTNAME="ОС1" FULLNAME="Операционные системы" PULPIT="ИСиТ" />
	   <SUBJECT SHORTNAME="КСИС1" FULLNAME="Компьютерные системы и сети" PULPIT="ИСиТ" />
	 </SUBJECTS>';
exec sp_xml_preparedocument @h output, @x;   --подготовка документа
insert SUBJECT select SHORTNAME, FULLNAME, PULPIT
   from openxml(@h, '/SUBJECTS/SUBJECT', 0)
    with(SHORTNAME char(10) '@SHORTNAME', FULLNAME varchar(100) '@FULLNAME', PULPIT char(20) '@PULPIT')
exec sp_xml_removedocument @h;               --удаление документа


Delete SUBJECT Where SUBJECT = 'ОИТ1' or SUBJECT = 'ОС1' or SUBJECT = 'КСИС1'

Select * From SUBJECT



--задание 4-- xml структура содерж. пасп. данные , серию, номер, адрес...




alter table STUDENT add INFO xml;

insert into STUDENT(NAME, INFO)--добавить строку с xml столбцом
values('Муругин Вячеслав Андреевич',
'<Паспортные_данные>
        <Серия>AB</Серия>
		<Номер>3046731</Номер>
		<Адрес>
		     <Страна>Беларусь</Страна>
			 <Город>Малорита</Город>
			 <Улица>Цветочная</Улица>
			 <Дом>0</Дом>
		</Адрес>
 </Паспортные_данные>')

update STUDENT
set INFO = '<Паспортные_данные>
              <Серия>AB</Серия>
		      <Номер>3046731</Номер>
		      <Адрес>
		           <Страна>Беларусь</Страна>
			       <Город>Малорита</Город>
			       <Улица>Цветочная</Улица>
			       <Дом>43</Дом>
		      </Адрес>
            </Паспортные_данные>'
where INFO.value('(Паспортные_данные/Адрес/Дом)[1]','varchar(10)') = 0;
select NAME,
INFO.value('(Паспортные_данные/Серия)[1]','varchar(2)') Серия,		--методы value
INFO.value('(Паспортные_данные/Номер)[1]','varchar(7)') Номер,
INFO.query('(Паспортные_данные/Адрес)[1]') Адрес --метод query
From STUDENT
Select * From STUDENT






--задание 5Изменить (ALTER TABLE) таблицу STUDENT в базе данных UNIVER, чтобы значения типизированного столбца с именем INFO контролировались коллекцией XML-схем (XML SCHEMACOLLECTION),



create xml schema collection Students as
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
           elementFormDefault="qualified"
           xmlns:xs="http://www.w3.org/2001/XMLSchema">
       <xs:element name="Паспортные_данные">  
		<xs:complexType>
		 <xs:sequence>
			<xs:element name="Серия" type="xs:string"/>
			<xs:element name="Номер" type="xs:unsignedInt"/>
			<xs:element name="Адрес"> 
				<xs:complexType>
					<xs:sequence>
						<xs:element name="Страна" type="xs:string" />
						<xs:element name="Город" type="xs:string" />
						<xs:element name="Улица" type="xs:string" />
						<xs:element name="Дом" type="xs:string" />
					</xs:sequence>
				</xs:complexType>
			</xs:element>
		</xs:sequence>
	</xs:complexType>
  </xs:element>
</xs:schema>';



alter table STUDENT alter column INFO xml(Students);
alter table STUDENT alter column INFO xml;

drop xml schema collection	Students;

insert into STUDENT(NAME, INFO)
values('Дядюк Виталий Александрович', 
'<Паспортные_данные>
	<Серия>AB</Серия>
	<Номер>1676161</Номер>
	<Адрес>
		<Страна>Беларусь</Страна>
		<Город>Малорита</Город>
		<Улица>Парковая</Улица>
		<Дом>9</Дом>    
	</Адрес>
</Паспортные_данные>')
select * from STUDENT




