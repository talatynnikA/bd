use Khartanovich4_MyBase

----------

declare @sb char(20), @t char(300)='';
declare things cursor for select ��������_������������ from ������������
open things;
fetch things into @sb;
while @@FETCH_STATUS=0
begin 
set @t=rtrim(@sb)+'     '+@t;
fetch things into @sb;
end;
print @t;
close things

deallocate things

----------

declare @a int, @rn char(50);
declare cursor1 cursor local dynamic scroll for select ROW_NUMBER() over (order by ��������_������������) namess, ��������_������������ from ������������
open cursor1
fetch cursor1 into @a, @rn;
print '��������� ������: ' + cast(@a as varchar(3)) + ' ' + rtrim(@rn);

fetch last from cursor1 into  @a, @rn;
print '��������� ������: ' + cast(@a as varchar(3)) + ' ' + rtrim(@rn);

fetch first from cursor1 into  @a, @rn;
print '������ ������: ' + cast(@a as varchar(3)) + ' ' + rtrim(@rn);

fetch absolute 2 from cursor1 into  @a, @rn;
print '������ ������ �� ������: ' + cast(@a as varchar(3)) + ' ' + rtrim(@rn);

close cursor1