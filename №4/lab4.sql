set lc_monetary TO 'en_US.UTF-8'

-1.Вивести статистику: загальна кількість всіх книг, їх вартість, їх середню вартість, мінімальну і максимальну ціну

select count(book_name) as Загальна_кількість,
	   sum(book_price) as Загальна_вартість, 
	   avg(book_price::numeric)::money as Середня_вартість, 
	   MIN(book_price::numeric)::money as Мінімальна_вартість,
	   MAX(book_price::numeric)::money as Максимальна_вартість 
	   from book
	   
-2.Вивести загальна кількість всіх книг без урахування книг з непроставленою ціною

select count(book_name) from book where book_price NotNull 

-3.Вивести статистику (див. 1) для книг новинка / не новинка

select book_new,count(book_name) as Загальна_кількість,sum(book_price) as Загальна_вартість, 
		avg(book_price::numeric)::money as Середня_вартість, 
		MIN(book_price::numeric)::money as Мінімальна_вартість, 
		MAX(book_price::numeric)::money as Максимальна_вартість from book
		group by book_new
		
select count(book_name) as Загальна_кількість,sum(book_price) as Загальна_вартість, 
		avg(book_price::numeric)::money as Середня_вартість, 
		MIN(book_price::numeric)::money as Мінімальна_вартість, 
		MAX(book_price::numeric)::money as Максимальна_вартість from book
		where book_new='No'
		
-4.Вивести статистику (див. 1) для книг за кожним роком видання

select (select EXTRACT (YEAR from book_date)), count(book_name) as Загальна_кількість,sum(book_price) as Загальна_вартість, 
		avg(book_price::numeric)::money as Середня_вартість, 
		MIN(book_price::numeric)::money as Мінімальна_вартість, 
		MAX(book_price::numeric)::money as Максимальна_вартість from book
		group by (select EXTRACT (YEAR from book_date))
		
-5.Змінити п.4, виключивши з статистики книги з ціною від 10 до 20

select (select EXTRACT (YEAR from book_date)), count(book_name) as Загальна_кількість,sum(book_price) as Загальна_вартість, 
		avg(book_price::numeric)::money as Середня_вартість, 
		MIN(book_price::numeric)::money as Мінімальна_вартість, 
		MAX(book_price::numeric)::money as Максимальна_вартість from book
		where book_price::numeric not between 10 and 20
		group by (select EXTRACT (YEAR from book_date))
		
-6.Змінити п.4. Відсортувати статистику за спаданням кількості.

select (select EXTRACT (YEAR from book_date)) as Рік, count(book_name) as Загальна_кількість,sum(book_price) as Загальна_вартість, 
		avg(book_price::numeric)::money as Середня_вартість, 
		MIN(book_price::numeric)::money as Мінімальна_вартість, 
		MAX(book_price::numeric)::money as Максимальна_вартість from book
		group by (select EXTRACT (YEAR from book_date))
		order by count(book_name) DESC
		
-7.Вивести загальну кількість кодів книг і  кодів книг, що не повторюються

select count(book_id), count(distinct book_id) from book

-8.Вивести статистику: загальна кількість і вартість книг по першій букві її назви

select left (book_name,1),
	count(book_name) as загальна_кількість, 
	sum(book_price) as загальна_вартість 
	from book 
	group by (left (book_name,1)) 
	
-9.Змінити п. 8, виключивши з статистики назви починаються з англ. букви і з цифри.

select left (book_name,1),
	count(book_name) as загальна_кількість,
	sum(book_price) as загальна_вартість 
	from book 
	where book_name not like '[1-9]%' and left (book_name,1) not between 'A' and 'Z' 
	group by (left (book_name,1))

-10.Змінити п. 9 так щоб до складу статистики потрапили дані з роками великими 2000.

select left (book_name,1),
	count(book_name) as загальна_кількість,
	sum(book_price) as загальна_вартість 
	from book 
	where book_name not like '[1-9]%' and left (book_name,1) not between 'A' and 'Z' and (select EXTRACT (YEAR from book_date))>2000
	group by (left (book_name,1)) 
	
-11.Змінити п. 10. Відсортувати статистику за спаданням перших букв назви.

select left (book_name,1),
	count(book_name) as загальна_кількість,
	sum(book_price) as загальна_вартість 
	from book 
	where book_name not like '[1-9]%' and left (book_name,1) not between 'A' and 'Z' and (select EXTRACT (YEAR from book_date))>2000
	group by (left (book_name,1)) 
	order by left (book_name,1) DESC 
	
-12.Вивести статистику (див. 1) по кожному місяцю кожного року.

select (select EXTRACT (MONTH from book_date)) as Місяць,(select EXTRACT (YEAR from book_date)) as Рік,count(book_name) as Загальна_кількість,
	   sum(book_price) as Загальна_вартість, 
	   avg(book_price::numeric)::money as Середня_вартість, 
	   MIN(book_price::numeric)::money as Мінімальна_вартість, 
	   MAX(book_price::numeric)::money as Максимальна_вартість from book
	   group by (select EXTRACT (MONTH from book_date)),(select EXTRACT (YEAR from book_date))

-13.Змінити п. 12 так щоб до складу статистики не були дані з незаповненими датами.

select (select EXTRACT (MONTH from book_date)) as Місяць,
	   (select EXTRACT (YEAR from book_date)) as Рік,
	   count(book_name) as Загальна_кількість,
	   sum(book_price) as Загальна_вартість, 
	   avg(book_price::numeric)::money as Середня_вартість, 
	   MIN(book_price::numeric)::money as Мінімальна_вартість, 
	   MAX(book_price::numeric)::money as Максимальна_вартість from book
	   where book_date NotNull
	   group by (select EXTRACT (MONTH from book_date)),(select EXTRACT (YEAR from book_date))

-14.Змінити п. 12. Фільтр за спаданням року і зростанням місяця.

select (select EXTRACT (MONTH from book_date)) as Місяць,(select EXTRACT (YEAR from book_date)) as Рік,count(book_name) as Загальна_кількість,
	   sum(book_price) as Загальна_вартість, 
	   avg(book_price::numeric)::money as Середня_вартість, 
	   MIN(book_price::numeric)::money as Мінімальна_вартість, 
	   MAX(book_price::numeric)::money as Максимальна_вартість from book
	   group by (select EXTRACT (MONTH from book_date)),(select EXTRACT (YEAR from book_date))
	   order by (select EXTRACT (YEAR from book_date)) DESC,(select EXTRACT (MONTH from book_date)) ASC
	   
-15.Вивести статистику для книг новинка / не новинка: загальна ціна, загальна ціна в грн. / Євро / руб. Колонкам запиту дати назви за змістом.

select book_new,sum(book_price) as загальна_ціна,
	   concat('₴',sum(book_price::numeric*23.00)) as загальна_ціна_грн ,
	   concat('€',sum(book_price::numeric*1.1)) as загальна_ціна_Євро,
	   concat('₽',sum(book_price::numeric*69)) as загальна_ціна_руб from book
	   group by book_new
	   
-16.Змінити п. 15 так щоб виводилася округлена до цілого числа (дол. / Грн. / Євро / руб.) Ціна.

select book_new,sum(book_price) as загальна_ціна,
	   concat('₴',round(sum(book_price::numeric*23.00))) as загальна_ціна_грн ,
	   concat('€',round(sum(book_price::numeric*1.1))) as загальна_ціна_Євро,
	   concat('₽',round(sum(book_price::numeric*69))) as загальна_ціна_руб from book
	   group by book_new

-17.Вивести статистику (див. 1) по видавництвах.

select book_publishing,count(book_name) as Загальна_кількість,
	   sum(book_price) as Загальна_вартість, 
	   avg(book_price::numeric)::money as Середня_вартість, 
	   MIN(book_price::numeric)::money as Мінімальна_вартість,
	   MAX(book_price::numeric)::money as Максимальна_вартість 
	   from book
	   group by book_publishing
	
-18.Вивести статистику (див. 1) за темами і видавництвам. Фільтр по видавництвам.

select book_publishing,book_topic,count(book_name) as Загальна_кількість,
	   sum(book_price) as Загальна_вартість, 
	   avg(book_price::numeric)::money as Середня_вартість, 
	   MIN(book_price::numeric)::money as Мінімальна_вартість,
	   MAX(book_price::numeric)::money as Максимальна_вартість 
	   from book
	   group by book_publishing,book_topic 
	   order by book_publishing
	   
-19.Вивести статистику (див. 1) за категоріями, тем і видавництвам. Фільтр по видавництвам, тем, категорій.

select book_publishing,book_topic,book_category,count(book_name) as Загальна_кількість,
	   sum(book_price) as Загальна_вартість, 
	   avg(book_price::numeric)::money as Середня_вартість, 
	   MIN(book_price::numeric)::money as Мінімальна_вартість,
	   MAX(book_price::numeric)::money as Максимальна_вартість 
	   from book
	   group by book_category,book_topic,book_publishing 
	   order by book_publishing, book_topic, book_category
	  
-20.Вивести список видавництв, у яких огруглено до цілого ціна однієї сторінки більше 10 копійок.

select book_publishing from book where round((book_price/book_pages)::numeric) > 0.10 

		
select * from book
