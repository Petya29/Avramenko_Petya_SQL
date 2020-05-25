--2.Скласти SQLscript, що виконує:

--a.Створення таблиць бази даних. Команди для створення таблиці повинні містити головний ключ, обмеження типу null / not null,  створення зв'язків 

--b.Завантаження даних в таблиці 

-- Table 'book'

CREATE TABLE IF NOT EXISTS book
(	book_id INTEGER PRIMARY KEY,
	book_number INTEGER NOT NULL,
	book_new CHAR(3) NOT NULL,
 	book_name CHAR(250) NOT NULL,
 	book_price MONEY NOT NULL,
 	book_pages INTEGER NOT NULL,
 	book_format CHAR(30) NOT NULL,
 	book_date DATE NOT NULL,
 	book_circulation INTEGER NOT NULL,
 	book_publishing_id INTEGER REFERENCES Publishing(id_publishing) ON UPDATE CASCADE ON DELETE NO ACTION,
 	book_topic_id INTEGER REFERENCES Topic(id_topic) ON UPDATE CASCADE ON DELETE NO ACTION ,
 	book_category_id INTEGER REFERENCES Category(id_category) ON UPDATE CASCADE ON DELETE NO ACTION 
 	
)

-- Table 'publishing'

CREATE TABLE IF NOT EXISTS Publishing
(
	id_publishing INTEGER PRIMARY KEY,
	publishing CHAR(250) NOT NULL
)


-- Table 'Topic'

Create table IF NOT EXISTS Topic
(
	id_topic INTEGER PRIMARY KEY,
	topic CHAR(250) NOT NULL
)


-- Table 'Category'

Create table IF NOT EXISTS Category
(
	id_category INTEGER PRIMARY KEY,
	category CHAR(250) NOT NULL
)


insert into Publishing values (1,'BHV С.-Петербург'),(2,'Вільямс'),(3,'Пітер'),(4,'МікроАрт'),(5,'ДМК')
insert into Topic values (1,'Використання ПК в цілому'),(2,'Операційні системи'),(3,'програмування')
insert into Category values (1,'підручники'),(2,'Апаратні засоби ПК'),(3,'інші книги'),(4,'Linux'),(5,'C & C ++')

INSERT INTO book(book_number,book_id,book_new,book_name,book_price,book_pages,book_format,book_date,book_circulation,book_publishing_id,book_topic_id,book_category_id) values
	(2,5110,'No','Апаратні засоби мультимедія. відеосистема РС',15.51,400,'70х100/16','2000-07-24',	5000,1,1,1),
	(8,4985,'No','Освой самостійно модернізацію і ремонт ПК за 24 години, 2-е вид.',18.90	,288,'70х100 / 16','2000-07-07',5000,2,1,1),
	(9,5141,'No','Структури даних і алгоритми.',37.80,384,'70х100 / 16','2000-09-29',5000, 2,1,	1),
	(20,5127,'Yes','Автоматизація інженерно графічних робіт',11.58,	256,'70х100 / 16','2000-06-15'	,5000, 3,1,1),
	(31,5111,'No','Апаратні засоби мультимедія. відеосистема РС',13.26,420,'70х100 / 16','2000-08-06',5000,	1,1,2),
	(46,5199,'No','Залізо IBM 2001.',30.07,	368,'70х100 / 16','2000-02-12',	5000,4,	1,2),
	(50,3851,'Yes','Захист інформації і безпека комп`ютерних систем',26.00,	480,'84х108 / 16','1999-04-02',	5000,4,	1,3),
	(220,4687,'No','Ефективне використання C ++ .50 рекомендацій щодо поліпшення ваших програм і проектів',	17.60,240,'70х100 / 16','2000-02-03',5000,5,3,5),
	(188,5170,'No',	'Linux Російські версії', 24.43,346,'70х100 / 16','2019-10-09',	5000,5,	2,4)
