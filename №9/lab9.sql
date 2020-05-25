-1.Розробити і перевірити скалярну (scalar) функцію, що повертає загальну вартість книг, виданих в певному році.

CREATE OR REPLACE FUNCTION total_cost ( y int) returns money
as $$
	begin
		return (select sum(book_price) from book where EXTRACT (YEAR from book_date)=total_cost.y );
	end;
$$
language plpgsql;

select total_cost(2000)

-2.Розробити і перевірити табличну (inline) функцію, яка повертає список книг, виданих в певному році.

CREATE OR REPLACE FUNCTION list_books_by_year(yearr int)  returns table ( book_name char, book_date date) 
as $$ 
	BEGIN
		return query(select book.book_name, book.book_date from book where (EXTRACT (YEAR from book.book_date)=list_books_by_year.yearr));
	END;
$$
language plpgsql;

select * from list_books_by_year(2000)

drop function list_books_by_year(int)

-3.Розробити і перевірити функцію типу multi - statement, яка буде:

-a.приймати в якості вхідного параметра рядок, що містить список назв видавництв, розділених символом ';';

-b.виділяти з цього рядка назву видавництва;

-c.формувати нумерований список назв видавництв.

drop function publishing_list(text)

CREATE OR REPLACE FUNCTION publishing_list (publishing text) returns  table( book_publishing text) as $BODY$
	begin
    	
		return query(select list from regexp_split_to_table(publishing, ';') as list) ;
	end;
$BODY$
LANGUAGE plpgsql;

select * from publishing_list('BHV;Пітер;Вільямс;ДМК')

-4.Виконати набір операцій по роботі з SQL курсором:

-a.оголосити курсор;

-b.використовувати змінну для оголошення курсору;

-c.відкрити курсор;

-d. переприсвоіти курсор іншій зміннійї;

-e.виконати вибірку даних з курсору;

-f.закрити курсор;

-g.звільнити курсор.

CREATE OR REPLACE FUNCTION cursor_fun()
RETURNS SETOF varchar as $$
DECLARE
	curs CURSOR FOR select book.book_name from book;
	curs_1 refcursor;
	rec_name record;
	b_name text default '';
BEGIN
	curs_1=curs;
	OPEN curs;
	
	LOOP
		FETCH curs_1 into rec_name;
		EXIT WHEN NOT FOUND;
		b_name = rec_name.book_name;
		return next b_name;
	END LOOP;
	CLOSE curs_1;
END;
$$
language plpgsql;

select  cursor_fun()

DROP FUNCTION cursor_fun()

-5.Розробити курсор для виведення списку книг виданих в певному році.

CREATE OR REPLACE FUNCTION cursor_fun_year(b_year int) 
	returns SETOF varchar as $$
	
	DECLARE 
		b_names text default '';
		rec_book record;
		curs1 CURSOR(b_year int) FOR select book.book_name,book.book_date from book where EXTRACT (YEAR from book.book_date)=b_year;
		
	BEGIN
		OPEN curs1(b_year);
		LOOP
			FETCH curs1 INTO rec_book;
			EXIT WHEN NOT FOUND;
			b_names:=rec_book.book_name||':'||EXTRACT (YEAR from rec_book.book_date);
			return next b_names;
		END LOOP;
		CLOSE curs1;
		
	END;
$$
language plpgsql;

select  cursor_fun_year(2000)
