#Partitioning
#1
ALTER TABLE customer
PARTITION BY HASH (address_id)
PARTITIONS 4;

EXPLAIN PARTITIONS SELECT * FROM customer WHERE address_id = 1;

#2a
ALTER TABLE rental
PARTITION BY RANGE(YEAR(rental_date)) (
    PARTITION p2005 VALUES LESS THAN (2006),
    PARTITION p2006 VALUES LESS THAN (2007),
    PARTITION p2007 VALUES LESS THAN (2008),
    PARTITION pMax VALUES LESS THAN MAXVALUE
);
#2b
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
SELECT rental_date, inventory_id, customer_id, return_date, staff_id, last_update
FROM rental
WHERE YEAR(rental_date) = 2007;

EXPLAIN PARTITIONS SELECT * FROM rental WHERE YEAR(rental_date) = 2007;

#Indexing
#3
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE 'N%';

EXPLAIN SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE 'N%';

#4
SELECT film.film_id, film.title, rental.rental_date
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE YEAR(rental.rental_date) = 2006 AND MONTH(rental.rental_date) = 2;

EXPLAIN SELECT film.film_id, film.title, rental.rental_date
FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE YEAR(rental.rental_date) = 2006 AND MONTH(rental.rental_date) = 2;

#5
# Join
SELECT
    s.store_id,
    COUNT(r.rental_id) AS total_rentals
FROM
    store AS s
INNER JOIN
    inventory AS i ON s.store_id = i.store_id
INNER JOIN
    rental AS r ON i.inventory_id = r.inventory_id
WHERE
    MONTH(r.rental_date) = 2 AND YEAR(r.rental_date) = 2006
GROUP BY
    s.store_id
ORDER BY
    total_rentals DESC;

#Subquery
SELECT
    s.store_id,
    (
        SELECT COUNT(r.rental_id)
        FROM rental AS r
        INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
        WHERE i.store_id = s.store_id
            AND MONTH(r.rental_date) = 2 AND YEAR(r.rental_date) = 2006
    ) AS total_rentals
FROM
    store AS s
ORDER BY
    total_rentals DESC;


