1. What is the total amount of each customer spent on zomato?
 select s.userid , sum(p.price) as total_amt from product p
 join sales s on s.product_id = p.product_id
 group by s.userid
 order by total_amt desc
 
2. How many days has each customer visited zomato?
  select userid , count(distinct created_date ) as dis_days from sales group by userid
  
3. What was the first product purchased by each customer?
    select * from 
   (select *, rank() over( partition by userid order by created_date) as rank
	from sales) 
    as pro_rank where rank = 1;

4.What is the most purchased item on the menu and how many times it was purchased by all customers?
  select userid,count(product_id) from sales where product_id = 
  (select product_id from sales 
  group by product_id
  order by count(product_id) desc 
  limit 1)
  group by userid 
  
5.Which item was the most popular for each customers?
  select * from 
 (select * , rank() over(partition by userid order by count(product_id) desc ) rnk from 
 (select userid,product_id,
 count(product_id) pro_num from sales
  group by userid,product_id) sb) a

6. Which item was purchased first by the customer after they became a member?
select * from(
select userid,created_date,product_id , rank() over(
partition by userid order by created_date) rank from 
(select g.userid,s.created_date,s.product_id, g.gold_signup_date from goldusers_signup g
inner join sales s on s.userid = g.userid and s.created_date >g.gold_signup_date) a) d 
where rank <=1

7.What item was purchased just before the customer became a member?
 select g.userid , g.gold_signup_date, s.created_date, s.product_id from goldusers_signup g
 inner join sales s on s.userid=g.userid 
 where s.created_date<=g.gold_signup_date

8. What is the total order and amount spent for each member before they become a member?
select userid, count(created_date), sum(price)from
(select a.* , p.price from
(select g.userid , g.gold_signup_date, s.created_date, s.product_id from goldusers_signup g
 inner join sales s on s.userid=g.userid 
 where s.created_date<=g.gold_signup_date) a inner join product p on p.product_id= a.product_id)d
 group by userid
 order by userid
 


 
 
 9. If buying each product generates points for eg 5 rs=2 zomato point and each product has 
 different purchasing points for eg for p1 5rs=1 zomato point , for p2 10rs=5 zomato points 
 and p3 5rs=1 zomato points.
 
(a)- Calculate points collected by each customers and for which product most points have 
      been given till now ?
	  select userid,sum(points_collected)* 2.5 total_points_earns from 
	   (select x.*,amt/points as points_collected from
	(select d.*, case when product_id=1 then 5 when product_id= 2 then 2
	when product_id= 3 then 5 else 0 end  as points from
	( select a.userid,a.product_id,sum(a.price) amt from
	 (select s.* , p.price from sales s 
	  inner join product p on p.product_id = s.product_id)a
	 group by  a.userid,a.product_id)d) x)r group by userid
 
 (b)- select * from 
 (select n.*,rank() over(order by total_points_earns desc)rnk from
 (select product_id,sum(points_collected) total_points_earns from 
	   (select x.*,amt/points as points_collected from
	(select d.*, case when product_id=1 then 5 when product_id= 2 then 2
	when product_id= 3 then 5 else 0 end  as points from
	( select a.userid,a.product_id,sum(a.price) amt from
	 (select s.* , p.price from sales s 
	  inner join product p on p.product_id = s.product_id)a
	 group by  a.userid,a.product_id)d) x)r
	 group by product_id order by product_id)n )j where rnk=1
 
 
 
 
 10. In the fisrt one year after a customer joins the gold program (including their join date)
 irrespective of what the customer has purchased they earns 5 zomato points for every 10rs spent
 who earned more 1 or 3 and what was their points earning in their first yr?
 (1 zp = 2rs
 0.5zp=1rs)
 
 select d.* , p.price*0.5 tot_points_earned from 
 (select g.userid , g.gold_signup_date, s.created_date, s.product_id from goldusers_signup g
 inner join sales s on s.userid=g.userid 
 where s.created_date>=g.gold_signup_date and s.created_date<=g.gold_signup_date+365 ) d
 inner join product p on p.product_id = d.product_id
 
11. Rank all the transaction of the customer?
    select * , rank() over( partition by userid order by created_date ) rank from sales
	
	
12. Rank all the transactions for each member whenever they are a zomato gold member, for every
non gold member transaction mark as NA?


 select v.*, case when rnk=0 then 'na' else rnk end as rank from
(select c.*,cast((case when gold_signup_date is null then 0 else
 rank() over(partition by userid order by created_date desc)end)as varchar) rnk from 
(select s.userid , g.gold_signup_date, s.created_date, s.product_id from sales s
 left join goldusers_signup g on s.userid=g.userid 
 and s.created_date>=g.gold_signup_date) c)v











 
 
 
 
 
 
 
 



































