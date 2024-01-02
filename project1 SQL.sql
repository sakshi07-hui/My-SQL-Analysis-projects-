1.who is the senior most employee based on job titles?
Ans-select first_name ,last_name, title from employee
order by levels desc
limit 1
2.Which country have the most invoice
select billing_country,count(invoice_id) as numbers_invoice from invoice
group by billing_country order by numbers_invoice
  
  
Ans 3- select billing_country,max(total) as total_in from invoice 
 group by billing_country
 order by total_in desc
 limit 3
 
 Ans4- select billing_city , sum(total) as total_invoice from invoice
       group by billing_city
	   order by total_invoice desc
	   limit 1
 
Ans 5- select c.first_name, c.last_name,c.customer_id,sum(i.total) as total_price from customer as c
       inner join invoice as i on c.customer_id = i.customer_id
	   group by c.customer_id
	   order by total_price desc
	   limit 1
SET2 MODERATE QUESTIONS:
Ans1- select distinct c.email,c.first_name, c.last_name from customer as c
join invoice as i on c.customer_id= i.customer_id
join invoice_line as il on i.invoice_id = il.invoice_id
where  track_id   in(
select t.track_id from track as t
join genre as g on t.genre_id= g.genre_id
where g.name = 'Rock')
order by c.email


Ans2- select at.artist_id , at.name, count(at.artist_id) as num_of_songs from track as t
      join album as a on t.album_id = a.album_id
	  join artist as at on a.artist_id = at.artist_id
	  join genre as g on t.genre_id = g.genre_id
	  where g.name= 'Rock'
	  group by at.artist_id
	  order by num_of_songs desc
	  limit 10
Ans3- select name, milliseconds from track 
      where milliseconds > (
	  select avg(milliseconds) as song_length from track)
	  order by milliseconds desc



SET3 ADVANCE QUESTIONS:
/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */

/* Steps to Solve: First, find which artist has earned the most according to the InvoiceLines. Now use this artist to find 
which customer spent the most on this artist. For this query, you will need to use the Invoice, InvoiceLine, Track, Customer, 
Album, and Artist tables. Note, this one is tricky because the Total spent in the Invoice table might not be on a single product, 
so you need to use the InvoiceLine table to find out how many of each product was purchased, and then multiply this by the price
for each artist. */
Ans1- with best_selling_artist as(
      select at.artist_id as artist_id, at.name as artist_name, sum(il.unit_price*il.quantity)
	   as total_sales from invoice_line as il
	join track t on t.track_id = il.track_id
	join album a on a.album_id = t.album_id
	join artist at on at.artist_id = a.artist_id
	group by 1
	order by 3 desc
	limit 1 )
select c.customer_id, c.first_name,c.last_name,bsa.artist_name,
 sum(il.unit_price*il.quantity) as amount_spent 
from invoice_line as il
join invoice i on i.invoice_id = il.invoice_id
join customer c on c.customer_id = i.customer_id
join track t on t.track_id = il.track_id 
join album a on a.album_id= t.album_id
join best_selling_artist bsa on bsa.artist_id = a.artist_id
group by 1,2,3,4
order by 5 desc


/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

/* Steps to Solve:  There are two parts in question- first most popular music genre and second need data at country level. */

/* Method 1: Using CTE */
Ans2- with popular_gen as( 
      select count(il.quantity) as purchases ,c.country, g.genre_id,g.name ,
	  row_number()over(partition by c.country order by count(il.quantity)desc) as ranking
	  from invoice_line as il
      join track t on t.track_id= il.track_id
      join genre g on g.genre_id= t.genre_id
      join invoice i on i.invoice_id = il.invoice_id
	  join customer c on c.customer_id=i.customer_id
	  group by c.country, g.genre_id
	  order by purchases desc
      )
	  select * from popular_gen where ranking <= 1


/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

/* Steps to Solve:  Similar to the above question. There are two parts in question- 
first find the most spent on music for each country and second filter the data for respective customers. */
Ans3- with recursive 
      customer_country as(
      select c.first_name,c.last_name,i.billing_country,c.customer_id, sum(i.total) as total_spent 
	  from invoice i 
	  join customer c on c.customer_id = i.customer_id
	  group by 1,2,3,4
	  order by total_spent desc ),
	  
	  max_spend_country as (
	  select billing_country, max(total_spent)as max_spent
	  from customer_country
	  group by billing_country)
	  
	  select cc.first_name,cc.last_name, cc.total_spent, cc.customer_id,cc.billing_country
	  from customer_country cc
	  join max_spend_country ms on ms.billing_country  = cc.billing_country
	  order by total_spent desc
	  







































 
 
 
 
 
 
 
 
 
 