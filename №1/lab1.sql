--2.Скласти SQL-script, що виконує:

--a.Створення бази даних

--b.Створення таблиці на основі універсального відношення. Команда для створення таблиці повинна містити головний ключ, обмеження типу null/ not null, default, check.

--c.Створення додаткового індексу.
--d.Завантаження даних в таблицю

CREATE DATABASE lab_1
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    CONNECTION LIMIT = -1;
    
CREATE TABLE book
(	book_id INTEGER PRIMARY KEY,
	book_num INTEGER NOT NULL,
	book_new CHAR(3) NOT NULL,
 	book_name CHAR(250) NOT NULL,
 	book_price MONEY NOT NULL,
 	book_publishing CHAR(250) NOT NULL,
 	book_pages INTEGER NOT NULL,
 	book_format CHAR(30) NOT NULL,
 	book_date DATA NOT NULL,
 	book_circulation INTEGR NOT NULL,
 	book_topic CHAR(250) NOT NULL,
 	book_category CHAR(100) NOT NULL
);

INSERT INTO book(book_num,book_id,book_new,book_name,book_price,book_publiching,book_pages,book_format,book_data,book_circulation,book_topic,book_category) values(2,5110,'No',	'Апаратні засоби мультимедія. відеосистема РС',15.51,'BHV С.-Петербург',	400,'70х100/ 16','7/24/2000',	5000,	'Використання ПК в ціломy','підручники');
INSERT INTO book(book_num,book_id,book_new,book_name,book_price,book_publiching,book_pages,book_format,book_data,book_circulation,book_topic,book_category) values(8,	4985,	'No',	'Освой самостійно модернізацію і ремонт ПК за 24 години, 2-е вид.',	18.90	,'Вільямс',288,'70х100 / 16',	'7/7/2000',	5000,'Використання ПК в цілому','підручники');
INSERT INTO book(book_num,book_id,book_new,book_name,book_price,book_publiching,book_pages,book_format,book_data,book_circulation,book_topic,book_category) values(9,5141,'No','Структури даних і алгоритми.',37.80,'Вільямс',	384,	'70х100 / 16',	'9/29/2000',	5000, 'Використання ПК в цілому',	'підручники');
INSERT INTO book(book_num,book_id,book_new,book_name,book_price,book_publiching,book_pages,book_format,book_data,book_circulation,book_topic,book_category) values(20,	5127,	'Yes',	'Автоматизація інженерно графічних робіт',	11.58,'Пітер',	256,	'70х100 / 16',	'6/15/2000'	,5000, 'Використання ПК в цілому'	,'підручники');
INSERT INTO book(book_num,book_id,book_new,book_name,book_price,book_publiching,book_pages,book_format,book_data,book_circulation,book_topic,book_category) values(31,	5111,	'No',	'Апаратні засоби мультимедія. відеосистема РС',	15.51,	'BHV С.-Петербург',	400,'70х100 / 16'	,'7/24/2000',	5000,	'Використання ПК в цілому',	'Апаратні засоби ПК');
INSERT INTO book(book_num,book_id,book_new,book_name,book_price,book_publiching,book_pages,book_format,book_data,book_circulation,book_topic,book_category) values(46,	5199,	'No',	'Залізо IBM 2001.',	30.07,	'МікроАрт',	368,	'70х100 / 16',	'12/2/2000',	5000,	'Використання ПК в цілому',	'Апаратні засоби ПК');
INSERT INTO book(book_num,book_id,book_new,book_name,book_price,book_publiching,book_pages,book_format,book_data,book_circulation,book_topic,book_category) values(50,	3851	,'Yes',	'Захист інформації і безпека комп`ютерних систем',	26.00,	'DiaSoft',480,	'84х108 / 16',	'2/4/1999',	5000,	'Використання ПК в цілому',	'Захист і безпека ПК');
INSERT INTO book(book_num,book_id,book_new,book_name,book_price,book_publishing,book_pages,book_format,book_date,book_circulation,book_topic,book_category) values(191,	860,	'No',	'Операційна система UNIX',	3.50,'BHV С.-Петербург',	395	,'84х100 \ 16',	'1997-05-05',	5000,	'Операційні системи',	'Unix'	);
INSERT INTO book(book_num,book_id,book_new,book_name,book_price,book_publishing,book_pages,book_format,book_date,book_circulation,book_topic,book_category) values(220,	4687,	'No','Ефективне використання C ++ .50 рекомендацій щодо поліпшення ваших програм і проектів',	17.60,	'ДМК',	240,	'70х100 / 16',	'2000-02-03',5000,	'програмування',	'C & C ++');

--3.Скласти SQL-script, що виконує:

--a.Додавання в таблицю нового текстового поля "Автор", розміром 15 символів

--b.Збільшення розміру текстового поля "Автор" до 20 символів

--c.Видалення текстового поля "Автор" з таблиці

--d.Зміна порядку сортування індексу 

--e.видалення індексу

CREATE INDEX book_index ON book(book_id);

DROP INDEX book_index;

ALTER TABLE book ADD COLUMN book_author CHAR(15);

ALTER TABLE book ALTER COLUMN book_author TYPE varchar(20);

ALTER TABLE book DROP COLUMN book_author;
