--������� 1
-- PATH xml 

--�������� �������� xml ���� � ������ path �� teacher ��� ����. ������� ����
use TAL_UNIVER
SELECT * FROM TEACHER 
where PULPIT = '����' 
for xml path('�������������'), root('������_��������������'), elements;





--������� 2
-- AUTO xml



select AUDITORIUM.AUDITORIUM [�����], AUDITORIUM_TYPE.AUDITORIUM_TYPE [���], AUDITORIUM_CAPACITY [�����������] 
	from AUDITORIUM inner join AUDITORIUM_TYPE
	on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
	where AUDITORIUM.AUDITORIUM_TYPE = '��' -- ����� ������ ����������
	for xml auto, root('AUDITORIYMS'), elements;



--������� 3--��� � 3-� ����� ����������� ������� ������� �������� � �������
declare @h int = 0,
@x varchar(2000) = 
    '<?xml version="1.0" encoding="windows-1251"?>
     <SUBJECTS>
	   <SUBJECT SHORTNAME="���1" FULLNAME="������ �������������� ����������" PULPIT="����" />
	   <SUBJECT SHORTNAME="��1" FULLNAME="������������ �������" PULPIT="����" />
	   <SUBJECT SHORTNAME="����1" FULLNAME="������������ ������� � ����" PULPIT="����" />
	 </SUBJECTS>';
exec sp_xml_preparedocument @h output, @x;   --���������� ���������
insert SUBJECT select SHORTNAME, FULLNAME, PULPIT
   from openxml(@h, '/SUBJECTS/SUBJECT', 0)
    with(SHORTNAME char(10) '@SHORTNAME', FULLNAME varchar(100) '@FULLNAME', PULPIT char(20) '@PULPIT')
exec sp_xml_removedocument @h;               --�������� ���������


Delete SUBJECT Where SUBJECT = '���1' or SUBJECT = '��1' or SUBJECT = '����1'

Select * From SUBJECT



--������� 4-- xml ��������� ������. ����. ������ , �����, �����, �����...




alter table STUDENT add INFO xml;

insert into STUDENT(NAME, INFO)--�������� ������ � xml ��������
values('������� �������� ���������',
'<����������_������>
        <�����>AB</�����>
		<�����>3046731</�����>
		<�����>
		     <������>��������</������>
			 <�����>��������</�����>
			 <�����>���������</�����>
			 <���>0</���>
		</�����>
 </����������_������>')

update STUDENT
set INFO = '<����������_������>
              <�����>AB</�����>
		      <�����>3046731</�����>
		      <�����>
		           <������>��������</������>
			       <�����>��������</�����>
			       <�����>���������</�����>
			       <���>43</���>
		      </�����>
            </����������_������>'
where INFO.value('(����������_������/�����/���)[1]','varchar(10)') = 0;
select NAME,
INFO.value('(����������_������/�����)[1]','varchar(2)') �����,		--������ value
INFO.value('(����������_������/�����)[1]','varchar(7)') �����,
INFO.query('(����������_������/�����)[1]') ����� --����� query
From STUDENT
Select * From STUDENT






--������� 5�������� (ALTER TABLE) ������� STUDENT � ���� ������ UNIVER, ����� �������� ��������������� ������� � ������ INFO ���������������� ���������� XML-���� (XML SCHEMACOLLECTION),



create xml schema collection Students as
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault="unqualified" 
           elementFormDefault="qualified"
           xmlns:xs="http://www.w3.org/2001/XMLSchema">
       <xs:element name="����������_������">  
		<xs:complexType>
		 <xs:sequence>
			<xs:element name="�����" type="xs:string"/>
			<xs:element name="�����" type="xs:unsignedInt"/>
			<xs:element name="�����"> 
				<xs:complexType>
					<xs:sequence>
						<xs:element name="������" type="xs:string" />
						<xs:element name="�����" type="xs:string" />
						<xs:element name="�����" type="xs:string" />
						<xs:element name="���" type="xs:string" />
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
values('����� ������� �������������', 
'<����������_������>
	<�����>AB</�����>
	<�����>1676161</�����>
	<�����>
		<������>��������</������>
		<�����>��������</�����>
		<�����>��������</�����>
		<���>9</���>    
	</�����>
</����������_������>')
select * from STUDENT




