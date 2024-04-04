use sakila;
# 2.a
select table_name, is_updatable
from information_schema.views
where table_schema = 'sakila';

# 2.b
show create view customer_list;

# 2.c
select * from customer_list;

# 2.d
update customer_list
set address = 'Bac Tu Liem, Ha Noi'
where country = 'Vietnam';

update customer_list
set phone = '0123456789'
where country = 'Vietnam';

update customer_list
set city = 'Hai Duong'
where country = 'Vietnam';

select id, name, address, phone, city, country
from customer_list
where country = 'Vietnam';

# 2.e
create view film_details as
select film.title, film.description, film.release_year, language.name, film.rating
from film join language on film.language_id = language.language_id;

# 2.f
create view category_amount as
select category.name, count(film_category.category_id) as amount
from category join film_category on category.category_id = film_category.category_id
group by category.category_id;


# 2.g
create view staff_info as
select staff.staff_id, concat(staff.first_name, ' ', staff.last_name) as staff_name, count(distinct film.film_id) as amount
from staff
left join rental on staff.staff_id = rental.staff_id
left join inventory on inventory.inventory_id = rental.inventory_id
left join film on film.film_id = inventory.film_id
group by staff_id;

# 2.h
create view top_rent as
select film.film_id, film.title, count(rental.rental_id) as amount
from film
join inventory on inventory.film_id = film.film_id
join rental on rental.inventory_id = inventory.inventory_id
group by film.film_id
order by amount desc, film_id desc
limit 10;

