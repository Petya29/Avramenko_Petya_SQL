set lc_monetary TO 'en_US.UTF-8'

-1.Вивести книги у яких не введена ціна або ціна дорівнює 0

select * from book where  book_price isNull or book_price = '0'  
-2.Вивести книги у яких введена ціна, але не введений тираж

select * from book where book_price  NotNull and book_publishing isNull 
-3.Вивести книги, про дату видання яких нічого не відомо.

select * from book  where book_date isNull
-4.Вивести книги, з дня видання яких пройшло не більше року.

select * from book  where ( current_date -  book_date) <= 365
-5.Вивести список книг-новинок, відсортоване за зростанням ціни

select * from book where book_new = 'Yes' ORDER BY book_price ASC
-6.Вивести список книг з числом сторінок від 300 до 400, відсортоване в зворотному алфавітному порядку назв

select * from book where book_pages between 300 and 400 ORDER BY book_name DESC
-7.Вивести список книг з ціною від 20 до 40, відсортоване в спаданням дати

select * from book where book_price::numeric between 20 and 40 ORDER by book_date DESC
-8.Вивести список книг, відсортованих в алфавітному порядку назв і ціною по спадаючій

select * from book order by book_name ASC, book_price DESC
-9.Вивести книги, у яких ціна однієї сторінки <10 копійок.

select * from book where (book_price/book_pages)::numeric < 0.10    
-10.Вивести значення наступних колонок: число символів в назві, перші 20 символів назви великими літерами

select  length(book_name), (substring (upper(book_name),1,20)) from book 
-11.Вивести значення наступних колонок: перші 10 і останні 10 символів назви прописними буквами, розділені '...'

select CONCAT (upper (left (book_name,10)), '...',upper (right(book_name,10))) from book
-12.Вивести значення наступних колонок: назва, дата, день, місяць, рік

select book_name as Назва, book_date as Дата,EXTRACT (YEAR from book_date)as Рік,EXTRACT (MONTH from book_date) as Місяць,EXTRACT (DAY from book_date) as День from book
-13.Вивести значення наступних колонок: назва, дата, дата в форматі 'dd / mm / yyyy'

select book_name, book_date, to_char(book_date,'dd/mm/YYYY') from book as book_date_2  
-14.Вивести значення наступних колонок: код, ціна, ціна в грн., Ціна в євро, ціна в руб.

SELECT book_id,book_price as Ціна,concat('₴',book_price::numeric*23.00) as Ціна_в_грн ,concat('€',book_price::numeric) as Ціна_в_євро  ,concat('₽',book_price::numeric) as Ціна_в_руб FROM book 
-15.Вивести значення наступних колонок: код, ціна, ціна в грн. без копійок, ціна без копійок огругленная

select book_id,book_price,concat('₴',floor(book_price::numeric)),ceil(book_price::numeric)::money from book 
-16.Додати інформацію про нову книгу (всі колонки)

INSERT INTO book(book_num,book_id,book_new,book_name,book_price,book_publishing,book_pages,book_format,book_date,book_circulation,book_topic,book_category) values(220,	4687,	'No','Ефективне використання C ++ .50 рекомендацій щодо поліпшення ваших програм і проектів',	17.60,	'ДМК',	240,	'70х100 / 16',	'2000-02-03',5000,	'програмування',	'C & C ++');
-17.Додати інформацію про нову книгу (колонки обов'язкові для введення)

INSERT INTO book(book_num,book_id,book_new,book_name,book_price,book_publishing,book_pages,book_format,book_date,book_circulation,book_topic,book_category) values(191,	860,	'No',	'Операційна система UNIX',	3.50,'BHV С.-Петербург',	395	,'84х100 \ 16',	'1997-05-05',	5000,	'Операційні системи',	'Unix'	);
-18.Видалити книги, видані до 1990 року

delete from book where EXTRACT (YEAR from book_date) < 1990 
-19.Проставити поточну дату для тих книг, у яких дата видання відсутній

update book set book_date = current_date where book_date isNull
-20.Встановити ознака новинка для книг виданих після 2005 року

update book set book_new = 'Yes' where (select EXTRACT (YEAR from book_date)) >= 2005

select * from book
