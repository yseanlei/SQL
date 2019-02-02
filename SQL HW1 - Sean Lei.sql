use sakila;
-- 1a
select first_name, last_name from actor; 

-- 1b
select upper(concat(first_name," ",last_name)) "Actor Name" from actor;

-- 2a
select actor_id, first_name, last_name from actor
where first_name='Joe';

-- 2b
select actor_id, first_name, last_name from actor
where last_name like'%GEN%';

-- 2c
select actor_id, last_name,first_name from actor
where last_name like'%LI%'
order by last_name asc,first_name asc;

-- 2d
select country_id, country from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a
alter table actor
add column description blob;
select * from actor limit 10;

-- 3b
set sql_safe_updates=0;
alter table actor
drop column description;
select * from actor limit 10;

-- 4a
select last_name,count(last_name) as last_name_count from actor
group by last_name
order by last_name_count asc;

-- 4b
select last_name,count(last_name) as last_name_count from actor
group by last_name
having last_name_count >=2
order by last_name_count asc;

-- 4c
update actor
set first_name ='HARPO'
where first_name='GROUCHO' and last_name='WILLIAMS';

-- 4d
set sql_safe_updates=0;
update actor
set first_name ='GROUCHO'
where first_name='HARPO';

-- 5a
show create table address;
show create table staff;

-- 6a
select first_name, last_name, address, address2, district, city_id, postal_code 
from staff left join address
using (address_id);

-- 6b
select staff_id,first_name,last_name, sum(amount) as "total amount"
from staff join payment 
using (staff_id)
where payment_date between '2005-08-01' and '2005-08-31'
group by staff_id; 


-- 6c
select film_id, title,count(actor_id) as "Number of Actors"
from film join film_actor
using (film_id)
group by film_id;

-- 6d
select film_id,title,count(inventory_id) as "Total Copies"
from film join inventory
using (film_id)
group by film_id
having title = 'Hunchback Impossible';

-- 6e
select first_name, last_name, sum(amount) as "Total Amount Paid"
from payment join customer
using (customer_id)
group by customer_id 
order by last_name asc;

-- 7a 
select title from film
where (title like 'K%' or title like 'Q%') 
and language_id in (select language_id from language where name='English');  

-- 7b
select first_name, last_name 
from actor 
where actor_id in (select actor_id from film_actor where film_id in (
select film_id from film where title='Alone Trip'));

-- 7c
select first_name, last_name, email from customer
where address_id in(select address_id from address where city_id in(
select city_id from city where country_id in(
select country_id from country where country='Canada')));

-- 7d
select title, name 
from film join film_category
using (film_id)
join category
using (category_id)
where name='Family';

-- 7e
select film_id, title,count(rental_id) as "Number of Rents"
from rental join inventory
using (inventory_id)
join film
using (film_id)
group by film_id
order by count(rental_id) desc;

-- 7f 
select * from film_category;
select store_id, sum(p.amount) as "Total Amount"
from store as s join payment as p
on s.manager_staff_id and p.staff_id
group by store_id;


-- 7g
select store_id, city, country 
from store s join address
using (address_id)
join city 
using (city_id)
join country
using (country_id);

-- 7h
select name,sum(p.amount) as "Total Revenue" 
from payment p join rental
using (rental_id)
join inventory
using (inventory_id)
join film_category
using (film_id)
join category 
using (category_id)
group by name 
order by sum(p.amount) desc
limit 5;

-- 8a
create view top_5_genre_by_revenue as
select name,sum(p.amount) as "Total Revenue" 
from payment p join rental
using (rental_id)
join inventory
using (inventory_id)
join film_category
using (film_id)
join category 
using (category_id)
group by name 
order by sum(p.amount) desc
limit 5;

-- 8b
SELECT * FROM sakila.top_5_genre_by_revenue;

-- 8c
drop view if exists top_5_genre_by_revenue;
