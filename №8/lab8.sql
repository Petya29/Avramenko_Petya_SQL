-1.Кількість тем може бути в діапазоні від 5 до 10.

create function topic_range() returns trigger as  $topic_range$
	begin
 		if ((select count(*) from topic ) < 5 or (select count(*) from topic ) > 10 ) then
		raise exception 'Topic range can be from 5 to 10';
		end if;
		return new;
 	end;
$topic_range$ language plpgsql;


create trigger topic_insert_trig
	before insert or delete
	on topic
	for each row
	execute procedure topic_range();
	


-2.Новинкою може бути тільки книга видана в поточному році.

CREATE FUNCTION new_book() RETURNS trigger AS  $new_book$
	BEGIN
			IF (EXTRACT (YEAR FROM New.book_date)!=EXTRACT(YEAR FROM current_date)) and (New.book_new='Yes') THEN
				RAISE EXCEPTION 'Новинкою може бути тільки книга видана в поточному році.';
				END IF;	
		RETURN NEW;
	END;
$new_book$ LANGUAGE plpgsql;

CREATE TRIGGER new_book_trig
	BEFORE INSERT OR UPDATE
	ON book
	FOR EACH ROW
	EXECUTE PROCEDURE new_book()	
  
  
-3.Книга з кількістю сторінок до 100 не може коштувати більше 10 $, до 200 - 20 $, до 300 - 3 0 $.

CREATE FUNCTION book_price() RETURNS trigger AS  $book_price$
	BEGIN
			IF (New.book_pages<100)and(New.book_price >money(10)) THEN
				RAISE EXCEPTION 'Книга з кількістю сторінок до 100 не може коштувати більше 10 $';
				END IF;	
			IF (New.book_pages<200)and(New.book_price >money(20)) THEN
				RAISE EXCEPTION 'Книга з кількістю сторінок до 200 не може коштувати більше 20 $';
				END IF;	
			IF (New.book_pages<300)and(New.book_price >money(30)) THEN
				RAISE EXCEPTION 'Книга з кількістю сторінок до 300 не може коштувати більше 30 $';
				END IF;	
				
		RETURN NEW;
	END;
$book_price$ LANGUAGE plpgsql;

CREATE TRIGGER book_price_trig
	BEFORE INSERT OR UPDATE
	ON book
	FOR EACH ROW
	EXECUTE PROCEDURE book_price()
	
-4.Видавництво "BHV" не випускає книги накладом меншим 5000, а видавництво МікроАрт - 10000.

CREATE FUNCTION book_circulation() RETURNS trigger AS  $book_circulation$
	BEGIN
		If(New.book_publishing_id=1 and New.book_circulation<500) THEN 
			RAISE EXCEPTION 'Видавництво "BHV" не випускає книги накладом меншим 5000';
			End If;
		IF ( New.book_publishing_id = 4 and New.book_circulation < 100000) THEN
			RAISE EXCEPTION 'Видавництво " МікроАрт" не випускає книги накладом меншим 10000';
			End If;
		RETURN NEW;
	END;
$book_circulation$ LANGUAGE plpgsql;


CREATE TRIGGER book_circulation_trig
	BEFORE INSERT OR UPDATE
	ON book
	FOR EACH ROW
	EXECUTE PROCEDURE book_circulation()
	
-5.Книги з однаковим кодом повинні мати однакові дані.

CREATE FUNCTION same_books() RETURNS trigger AS  $same_books$
  BEGIN
      IF (New.book_number=Old.book_number)and(New.book_name not like old.book_name) and
      (New.book_date!=old.book_date)and(New.book_category_id!=old.book_category_id)and(New.book_topic_id!=Old.book_topic_id)and
      (New.book_publishing_id!=Old.book_publishing_id) and (New.book_price != Old.book_price) and (New.book_pages != Old.book_pages) THEN
      RAISE EXCEPTION 'Книги з однаковим кодом повинні мати однакові дані.';
      END IF;
    RETURN NEW;
  END;
$same_books$ LANGUAGE plpgsql;


CREATE TRIGGER same_books_trig
BEFORE INSERT OR UPDATE 
ON book
FOR EACH ROW 
EXECUTE PROCEDURE same_books();

-6. Якщо користувач не "dbo", то видалення забороняється.

CREATE FUNCTION forbid_delete() RETURNS trigger AS  $forbid_delete$
	BEGIN
		IF(select current_user <>'dbo') THEN
			RAISE EXCEPTION ' Якщо користувач не "dbo", то видалення забороняється';
			END IF;
		RETURN NEW;
	END;
$forbid_delete$ LANGUAGE plpgsql;

CREATE TRIGGER forbid_delete_trig
	BEFORE DELETE
	ON book
	FOR EACH ROW
	EXECUTE PROCEDURE forbid_delete() 
	
		
-7.Користувач "dbo" не має права змінювати ціну книги.

CREATE FUNCTION db_user() RETURNS trigger AS  $db_user$
	BEGIN
		IF(select current_user='dbo') THEN
			RAISE EXCEPTION 'Користувач "dbo" не має права змінювати ціну книги';
			END IF;
		RETURN NEW;
	END;
$db_user$ LANGUAGE plpgsql;

CREATE TRIGGER db_user_trig
	BEFORE UPDATE of book_price
	ON book
	FOR EACH ROW
	EXECUTE PROCEDURE db_user()
	
-8.Видавництва ДМК і Вільямс підручники не видають.

CREATE FUNCTION book_category_and_publishing() RETURNS trigger AS  $book_category_and_publishing$
	BEGIN			
		IF(New.book_publishing_id=5 and New.book_category_id = 1) THEN 
			RAISE EXCEPTION 'Видавництва ДМК підручники не видають';
			END IF;
		IF(New.book_publishing_id = 2 and New.book_category_id = 1) THEN 
			RAISE EXCEPTION 'Видавництва Вільямс підручники не видають';
			END IF;
		RETURN NEW;
	END;
$book_category_and_publishing$ LANGUAGE plpgsql;

CREATE TRIGGER book_category_and_publishing_trig
	BEFORE INSERT or UPDATE 
	ON book
	FOR EACH ROW
	EXECUTE PROCEDURE book_category_and_publishing()
  
-9.Видавництво не може випустити більше 10 новинок протягом одного місяця поточного року.

CREATE FUNCTION less_ten_new() RETURNS trigger AS  $less_ten_new$
	BEGIN
		IF ((select count(*) from book where book_new='Yes'and EXTRACT(MONTH from book_date)=EXTRACT(MONTH from current_date))>10
			and New.book_new = 'Yes' and EXTRACT(MONTH from New.book_date)=EXTRACT(MONTH from current_date) ) THEN
			RAISE EXCEPTION 'Видавництво не може випустити більше 10 новинок протягом одного місяця поточного року';
			END IF;
		RETURN NEW;
	END;
$less_ten_new$ LANGUAGE plpgsql;

CREATE TRIGGER book_less_ten_new_trig
	BEFORE INSERT or UPDATE 
	ON book
	FOR EACH ROW
	EXECUTE PROCEDURE less_ten_new()
  

-10.видавництво BHV не випускає книги формату 60х88 / 16.

CREATE FUNCTION publishing_format() RETURNS trigger AS  $publishing_format$
	BEGIN
			IF ((New.book_publishing_id =1 )and(New.book_format like'%%60х88/16%%')) THEN
				RAISE EXCEPTION 'видавництво BHV не випускає книги формату 60х88/16.';
				END IF;	
		RETURN NEW;
	END;
$publishing_format$ LANGUAGE plpgsql;

CREATE TRIGGER publishing_format_trig
	BEFORE INSERT or UPDATE 
	ON book
	FOR EACH ROW
	EXECUTE PROCEDURE publishing_format()
