USE [TAL_UNIVER]
GO
--2. �� ������ ������ AUDITORIUM � AUDITORIUM_TYPE ����������� ������, ����������� ��� ������� ���� ��������� ������������, �����������, 
--������� ����������� ���������, ��������� ���-�������� ���� ��������� � ����� ������-���� ��������� ������� ����. 
--�������������� ����� ������ �����-���� ������� � ������������� ���� ����-����� (������� AUDITORIUM_TYPE.AU-DITORIUM_TYPENAME) 
--� ������� � ������������ ����������. ������������ ���������� ���������� ������, ������ GROUP BY � ���������� �������

SELECT AUDITORIUM_TYPE.AUDITORIUM_TYPENAME, 
       MAX(AUDITORIUM_CAPACITY) [Max_capacity],
       Min(AUDITORIUM_CAPACITY) [Min_capacity],
       AVG(AUDITORIUM_CAPACITY) [Avg_capacity],
       SUM(AUDITORIUM_CAPACITY) [Sum_capacity],
       COUNT(*) [Count_type]
FROM AUDITORIUM_TYPE
INNER JOIN AUDITORIUM
ON AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
GROUP BY AUDITORIUM_TYPE.AUDITORIUM_TYPENAME;