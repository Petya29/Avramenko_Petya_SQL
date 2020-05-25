set lc_monetary TO 'en_US.UTF-8'

-1.Вивести значення наступних колонок: назва книги, ціна, назва видавництва, формат.
create function get_N_P_PU_f()
  returns table (book_name text,book_price money,book_publiching text,book_format text )
as
$$
Select cast(book_name as text),cast(book_price as money),cast(publishing.publishing as text),cast(book_format as text) 
from book , publishing 
where book.book_publishing_id =publishing.id_publishing
$$
language sql;

select * from get_N_P_PU_f();
 

-2.Вивести значення наступних колонок: тема, категорія, назва книги, назва видавництва. Фільтр по темам і категоріям.
create function get_t_c_n_p()
	returns table (book_topic char, book_category char,book_name char,book_publishing char)
as $$
select topic.topic ,category.category ,book_name ,publishing.publishing 
from book, category, publishing, topic 
where book.book_publishing_id =publishing.id_publishing and book.book_category_id= category.id_category and book.book_topic_id = topic.id_topic
order by topic.topic,category.category
$$
language sql;

select * from get_t_c_n_p();

-3.Вивести книги видавництва 'BHV', видані після 2000 р
create function after_2000() returns table(book_name char,publishing char, book_year date) 
as $$
select b.book_name,p.publishing,b.book_date
from book b inner join publishing p on b.book_publishing_id =p.id_publishing
where p.publishing like 'BHV%' and EXTRACT (YEAR from b.book_date) >= '2000'
$$
language sql;

select * from after_2000()

-4.Вивести загальну кількість сторінок по кожній назві категорії. Фільтр за спаданням кількості сторінок.
create function sum_pages()
returns table (category char, sum_pages bigint)
as $$
select c.category, sum(b.book_pages) from book b inner join category c on b.book_category_id= c.id_category
group by category
order by sum(b.book_pages) DESC
$$
language sql;

select * from sum_pages()

-5.Вивести середню вартість книг по темі 'Використання ПК' і категорії 'Linux'.
create function avg_price(topic char,category char)
returns table (topic char, category char,avg_price money)
as $$
select t.topic, c.category,cast(avg(b.book_price::numeric) as money)
	from book b inner join category c on b.book_category_id=c.id_category
				inner join topic t on b.book_topic_id=t.id_topic 
				where t.topic like avg_price.topic or c.category =avg_price.category
				group by t.topic,c.category  
$$
language sql;

select * from avg_price('Використання ПК%','Linux')

-6.Вивести всі дані універсального відносини.
create function univers_relation()
returns table (book_id integer, book_number integer,book_new text, book_name text,book_price money,book_pages integer, book_format text, book_date date, book_circulation integer,publishing text,topic text,category text)
as $$
select cast(b.book_id as integer),cast(b.book_number as integer),cast(b.book_new as text),cast(b.book_name as text),cast(b.book_price as money),
	   cast(b.book_pages as integer),cast(b.book_format as text),cast(b.book_date as date),cast(b.book_circulation as integer),cast(p.publishing as text),
	   cast(t.topic as text),cast(c.category as text) 
		 from book b inner join category c on b.book_category_id=c.id_category 
					 inner join topic t on b.book_topic_id=t.id_topic
					 inner join publishing p on b.book_publishing_id=p.id_publishing
$$
language sql;

select * from univers_relation()

-7.Вивести пари книг, що мають однакову кількість сторінок.
create function same_number_pages()
returns table (book_name_1 char, book_pages_1 integer, book_name_2 char, book_pages_2 integer)
as $$
select a.book_name, a.book_pages, b.book_name, b.book_pages  from book a ,book b	
	   where 	a.book_pages=b.book_pages and a.book_id <> b.book_id
$$
language sql;	   

select * from  same_number_pages();

-8.Вивести тріади книг, що мають однакову ціну.
create function same_number_pages_3()
returns table (book_name_1 text, book_pages_1 money, book_name_2 text, book_pages_2 money,book_name_3 text, book_pages_3 money)
as $$
select cast(a.book_name as text) , cast(a.book_price as money), cast(b.book_name as text) , cast(b.book_price as money) ,cast(c.book_name as text) , cast(c.book_price as money) from book a ,book b, book c	
	where a.book_price=b.book_price and b.book_price =c.book_price and a.book_id <> b.book_id and b.book_id <> c.book_id and a.book_id<>c.book_id;
$$
language sql;	   

select * from same_number_pages_3();

-9.Вивести всі книги категорії 'C ++'.
create function books_by_category(category char)
returns table (book_name char, category char)
as $$
select book.book_name,category.category from book inner join category on category.id_category=book.book_category_id
	where category.category like books_by_category.category
$$
language sql;		

select * from books_by_category('%C ++%');;

-10.Вивести список видавництв, у яких розмір книг перевищує 400 сторінок.
create function pages_more_400()
returns table (publishing char)
as $$
select distinct (p.publishing) from publishing p inner join book b on  p.id_publishing = b.book_publishing_id
	where b.book_publishing_id in (select book_publishing_id from book where book_pages >400);
$$
language sql;

select * from pages_more_400();

-11.Вивести список категорій за якими більше 3-х книг.
create function category_book_amount(amount int)
returns table (category text, amount int)
as $$
select cast(c.category as text),cast(count(*) as int) from category c inner join book b on c.id_category=b.book_category_id 
	where (select count(*) from  book b where b.book_category_id=c.id_category ) >= category_book_amount.amount
	group by category
$$
language sql;

select * from category_book_amount(3);

-12.Вивести список книг видавництва 'BHV', якщо в списку є хоча б одна книга цього видавництва.
create function books_by_category_exists(category text)
returns table(book_name  char, category  char )
as $$
select b.book_name ,p.publishing from book b inner join publishing p on b.book_publishing_id= p.id_publishing 
	where exists (select p.publishing  from publishing p where  b.book_publishing_id= p.id_publishing and p.publishing like books_by_category_exists.category)
$$
language sql;

select * from books_by_category_exists('BHV%');

-13.Вивести список книг видавництва 'BHV', якщо в списку немає жодної книги цього видавництва.--??
create function book_by_category_not_exists(category text)
returns table(book_name  char, category  char )
as $$
select b.book_name ,p.publishing from book b inner join publishing p on b.book_publishing_id= p.id_publishing 
	where not exists (select p.publishing  from publishing p where  b.book_publishing_id= p.id_publishing and p.publishing like book_by_category_not_exists.category)
$$
language sql;

select * from book_by_category_not_exists('BHV%');

-14.Вивести відсортоване загальний список назв тем і категорій.
create function topics_and_categories()
returns table ( type char,topics_and_categories char)
as $$
select  'Topic',topic from topic union select 'Category', category from category order by topic
$$
language sql;

select * from topics_and_categories();

-15.Вивести відсортоване в зворотному порядку загальний список неповторяющихся перших слів назв книг і категорій
create function first_book_name_catergory()
returns table (type char, book_name_and_category char)
as $$
select distinct('book_name_first' )as type, substring(book_name from 0 for position(' ' in book_name)) 
	FROM book UNION SELECT 'category' AS TYPE, category FROM category order by substring DESC
$$
language sql;

select * from first_book_name_catergory();
