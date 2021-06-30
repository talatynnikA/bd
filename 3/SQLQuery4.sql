ALTER Table STUDENT ADD POL nchar(1) default 'м' check (POL in ('м','ж'));
ALTER Table STUDENT DROP Column Дата_поступления;