select *  from trips;
select * from trips_details1
select * from duration
select * from payment


--total trips 
select count(distinct tripid) from trips_details1;
--total drivers
select count(distinct driverid) total_driver from trips;
--total earning
select sum(fare) total_earning from trips
--total searches = 2161
select count(searches) total_search from trips_details1;
--total searches which got estimated = 1758
select sum(searches_got_estimated) from trips_details1;
--total driver cancelled = 1021
select count(*)- sum(driver_not_cancelled) from trips_details1;
--which is the most used payment method
 select method from payment p inner join 
 (select faremethod,count(tripid) most_used_method from trips 
 group by 1
 order by most_used_method desc
 limit 1) a on p.id=a.faremethod
 --the highest payment was made through which method
 select method,a.payment from payment inner join
 (select  tripid,faremethod,sum(fare) payment from trips 
 group by 1,2
 order by payment desc)a on payment.id = a.faremethod
 limit 5
 --which two loacation had the most trips
 
 select loc_from,loc_to,count(loc_to) trip_completes from trips
 group by loc_from,loc_to
 order by trip_completes desc 
 limit 2

-- top 5 earning drivers
select b.* from 
(select s.*, rank() over(order by earning desc) rank from 
(select driverid,sum(fare) earning from trips
group by driverid
 order by earning desc)s)b
 where rank< 6
 
--which duration had more trips
select * from
(select m.*,rank() over(order by no_of_trips desc) rank from
(select duration,count(tripid) no_of_trips from trips
group by duration 
order by no_of_trips desc)m)s
where rank = 1

--which driver ,customer pair had more orders
select * from
(select * , rank() over(order by cnt desc )rank from
(select driverid,custid,count(distinct tripid) cnt from trips
group by 1,2)b)h
 where rank = 1;
 
 
 
 
 
 
 
 
 














