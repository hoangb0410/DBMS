use sakila;
# 1
SELECT c.customer_id, c.first_name, c.last_name, f.title as film_title, r.rental_date, r.return_date
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN store s ON i.store_id = s.store_id
WHERE s.store_id = 2
AND YEAR(r.rental_date) = 2006 AND MONTH(r.rental_date) = 2
AND r.return_date IS NULL;

# 2.a
SELECT *
FROM film_text
WHERE description LIKE '%drama%' AND description LIKE '%teacher%';
# 2.b
ALTER TABLE film_text
ADD FULLTEXT(description);
SELECT *
FROM film_text
WHERE MATCH(description) AGAINST ('+drama +teacher' IN BOOLEAN MODE);

# 3. Cách 1: Truy van con
SELECT f.title as film_title, COUNT(r.rental_id) AS total_rentals
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
WHERE YEAR(r.rental_date) = 2006 AND MONTH(r.rental_date) = 2
GROUP BY f.title
ORDER BY total_rentals DESC
LIMIT 10;
# 3. Cach 2: Noi bang
SELECT f.title, total_rentals
FROM (
    SELECT i.film_id, COUNT(r.rental_id) AS total_rentals
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    WHERE YEAR(r.rental_date) = 2006 AND MONTH(r.rental_date) = 2
    GROUP BY i.film_id
    ORDER BY total_rentals DESC
    LIMIT 10
) AS top_films
JOIN film f ON top_films.film_id = f.film_id;

# 4
SELECT s.store_id, COUNT(r.rental_id) AS total_rentals
FROM store s
JOIN inventory i ON s.store_id = i.store_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE YEAR(r.rental_date) = 2006 AND MONTH(r.rental_date) = 2
GROUP BY s.store_id
ORDER BY total_rentals DESC;

#5
SELECT i.inventory_id, f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
WHERE i.store_id = 1 AND f.title LIKE '%dinosaur%';