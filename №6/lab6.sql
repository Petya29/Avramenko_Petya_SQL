set lc_monetary TO 'en_US.UTF-8'
-1.Вивести значення наступних колонок: назва книги, ціна, назва видавництва. Використовувати внутрішнє з'єднання, застосовуючи where.

select book.book_name as Назва, book.book_price as Ціна,publishing.publishing as Видавництво from book,publishing  
	where book.book_publishing_id = publishing.id_publishing

-2.Вивести значення наступних колонок: назва книги, назва категорії. Використовувати внутрішнє з'єднання, застосовуючи inner join.

select b.book_name as Назва, b.book_price as Ціна,c.category as Катерогія from book b inner join category c on b.book_publishing_id = c.id_category

-3.Вивести значення наступних колонок: назва книги, ціна, назва видавництво, формат.

select b.book_name as Назва, b.book_price as Ціна,p.publishing as Видавництво, b.book_format as Формат from book b,publishing p 
	where b.book_publishing_id = p.id_publishing

-4.Вивести значення наступних колонок: тема, категорія, назва книги, назва видавництво. Фільтр за темами і категоріями.

select t.topic as Тема, c.category as Категорія , b.book_name as Назва,p.publishing as Видавництво 
	from book b inner join publishing p on b.book_publishing_id = p.id_publishing
		    inner join category c on  b.book_category_id=c.id_category
		    inner join topic t on b.book_topic_id=t.id_topic 
		    order by t.topic,c.category
				
-5.Вивести книги видавництва 'BHV', видані після 2000 р

select b.book_name as Назва,b.book_date as Дата_видання,p.publishing as Видавництво from book b inner join publishing p on b.book_publishing_id=p.id_publishing 
		where EXTRACT (YEAR from b.book_date) >= '2000' and p.publishing like 'BHV%'
		
-6.Вивести загальну кількість сторінок по кожній назві категорії. Фільтр за спаданням кількості сторінок.

select c.category as категорія,sum(b.book_pages) as загальна_кількість_сторінок  
	from book b inner join category c on b.book_category_id=c.id_category group by c.category order by sum(b.book_pages) DESC

-7.Вивести середню вартість книг по темі 'Використання ПК' і категорії 'Linux'.

select t.topic as Тема, c.category as Категорія ,avg(b.book_price::numeric) as Середня_ціна
	from book b inner join category c on b.book_category_id=c.id_category
				inner join topic t on b.book_topic_id=t.id_topic 
				where t.topic like 'Використання ПК%' or c.category ='Linux'
				group by t.topic,c.category     
				
-8.Вивести всі дані універсального відношення. Використовувати внутрішнє з'єднання, застосовуючи where.

select b.book_id,b.book_number,b.book_new,b.book_name,b.book_price,b.book_pages,b.book_format,b.book_date,b.book_circulation,p.publishing,t.topic,c.category 
	from book b, category c, topic t, publishing p where b.book_category_id=c.id_category and b.book_topic_id=t.id_topic and b.book_publishing_id=p.id_publishing

-9.Вивести всі дані універсального відношення. Використовувати внутрішнє з'єднання, застосовуючи inner join.

select b.book_id,b.book_number,b.book_new,b.book_name,b.book_price,b.book_pages,b.book_format,b.book_date,b.book_circulation,p.publishing,t.topic,c.category 
		 from book b inner join category c on b.book_category_id=c.id_category 
					 inner join topic t on b.book_topic_id=t.id_topic
					 inner join publishing p on b.book_publishing_id=p.id_publishing
					 
-10.Вивести всі дані універсального відношення. Використовувати зовнішнє з'єднання, застосовуючи left join / rigth join.

select b.book_id,b.book_number,b.book_new,b.book_name,b.book_price,b.book_pages,b.book_format,b.book_date,b.book_circulation,p.publishing,t.topic,c.category
	from book b left join category c on b.book_category_id=c.id_category 
					 left join topic t on b.book_topic_id=t.id_topic
					 left join publishing p on b.book_publishing_id=p.id_publishing
					 
select b.book_id,b.book_number,b.book_new,b.book_name,b.book_price,b.book_pages,b.book_format,b.book_date,b.book_circulation,p.publishing,t.topic,c.category
	from book b right join category c on b.book_category_id=c.id_category 
					 right join topic t on b.book_topic_id=t.id_topic
					 right join publishing p on b.book_publishing_id=p.id_publishing;
					 
-11.Вивести пари книг, що мають однакову кількість сторінок. Використовувати самооб'єднання і аліаси (self join).

select a.book_name as Book_name_1 , a.book_pages as Amount_of_pages_1, b.book_name as Book_name_2, b.book_pages as Amount_of_pages_2 
	from book a ,book b where a.book_pages=b.book_pages and a.book_id <> b.book_id

-12.Вивести тріади книг, що мають однакову ціну. Використовувати самооб'єднання і аліаси (self join).

select a.book_name , a.book_price, b.book_name , b.book_price ,c.book_name , c.book_price  from book a ,book b, book c	
	where a.book_price=b.book_price and b.book_price =c.book_price and a.book_id <> b.book_id and b.book_id <> c.book_id and a.book_id<>c.book_id;
	
-13.Вивести всі книги категорії 'C ++'. використовувати підзапити (Subquery) .

select book.book_name,category.category from book inner join category on category.id_category=book.book_category_id
	where book_category_id in (select id_category from category where category like '%C ++%')

-14.Вивести книги видавництва 'BHV', видані після 2000 р Використовувати підзапити (Subquery) .

select * from book  where book_publishing_id in (select id_publishing from publishing 
						 	where publishing like 'BHV%') and EXTRACT (YEAR from book_date) >= '2000';

-15.Вивести список видавництв, у яких розмір книг перевищує 400 сторінок. Використовувати пов'язані підзапити (correlated subquery).

select p.publishing from publishing p where (select avg(b.book_pages) from book b where p.id_publishing = b.book_publishing_id )>400;

select distinct(p.publishing) from publishing p inner join book b on  p.id_publishing = b.book_publishing_id
	where b.book_publishing_id in (select book_publishing_id from book where book_pages >400);
 
-16.Вивести список категорій за якими більше 3-х книг. Використовувати пов'язані підзапити (correlated subquery).

select c.category as Категорія,count(*) as Кількість_книг from category c inner join book b on c.id_category=b.book_category_id 
	where (select count(*) from  book b where b.book_category_id=c.id_category ) >= 3 group by category;

-17.Вивести список книг видавництва 'BHV', якщо в списку є хоча б одна книга цього видавництва. Використовувати exists.

select b.book_name,p.publishing from book b inner join publishing p on b.book_publishing_id= p.id_publishing 
	where exists (select p.publishing  from publishing p where  b.book_publishing_id= p.id_publishing and p.publishing like 'BHV%');

-18.Вивести список книг видавництва 'BHV', якщо в списку немає жодної книги цього видавництва. використовувати not  exists.---?

select b.book_name,p.publishing from book b inner join publishing p on b.book_publishing_id= p.id_publishing 
	where  p.publishing like 'BHV%' and not exists (select p.publishing  from publishing p where b.book_publishing_id= p.id_publishing and p.publishing like 'BHV%');
	
select b.book_name,p.publishing from book b inner join publishing p on b.book_publishing_id= p.id_publishing 
	where not exists (select p.publishing  from publishing p where b.book_publishing_id= p.id_publishing and p.publishing like 'BHV%');
	
-19.Вивести відсортоване загальний список назв тем і категорій. Використовувати union.

 select 'Topic' as type, topic from topic union select 'Category' as type, category from category order by topic;

-20.Вивести відсортоване в зворотному порядку загальний список  перших слів назв книг (що не повторюються) і категорій. Використовувати union.

select distinct('book_name_first' )as type, substring(book_name from 0 for position(' ' in book_name)) FROM book UNION SELECT 'category' AS TYPE, category FROM category order by substring DESC;

