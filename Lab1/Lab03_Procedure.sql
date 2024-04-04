use sakila;
# 1
DELIMITER //
CREATE PROCEDURE displayFilmInfo (IN p_category_id INT, IN p_language_id INT)
BEGIN
    IF p_category_id = 0 AND p_language_id = 0 THEN
        SELECT * FROM film;
    ELSEIF p_category_id = 0 THEN
        SELECT * FROM film WHERE language_id = p_language_id;
    ELSEIF p_language_id = 0 THEN
        SELECT * FROM film WHERE category_id = p_category_id;
    ELSE
        SELECT * FROM film WHERE category_id = p_category_id AND language_id = p_language_id;
    END IF;
END //
DELIMITER ;

# 2
delimiter //
create function filmRentedByMonth (storeId int, dateQuery date) returns int
deterministic
reads sql data
begin
	declare totalRented int;
    declare exit handler for not found return null;
	select count(distinct i.film_id) into totalRented
    from store s
		join inventory i on i.store_id = s.store_id
        join rental r on r.inventory_id = i.inventory_id
    where s.store_id = storeId
		and month(dateQuery) = month(r.rental_date)
        and year(dateQuery) = year(r.rental_date);
    return totalRented;
end //
delimiter ;

# 3
DELIMITER //
CREATE PROCEDURE DisplayCustomersRentingOverdue()
BEGIN
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        r.rental_date,
        DATE_ADD(r.rental_date, INTERVAL 30 DAY) AS due_date
    FROM 
        rental r
    JOIN 
        customer c ON r.customer_id = c.customer_id
    WHERE 
        r.return_date IS NULL
        AND DATEDIFF(NOW(), r.rental_date) > 30;
END //
DELIMITER ;

# 4
DELIMITER //
CREATE PROCEDURE discountFilm (IN per INT, IN num INT, INT dateQuery DATE)
BEGIN
	DECLARE filmId INT;
    DECLARE cond INT DEFAULT 1;
	DECLARE filmCursor CURSOR FOR
		SELECT i.film_id
		FROM inventory i JOIN rental r ON i.inventory_id = r.inventory_id
		WHERE month(dateQuery) = month(rental_date) AND year(dateQuery) = year(rental_date)
		GROUP BY i.film_id
		ORDER BY COUNT(r.rental_id) ASC, i.film_id ASC
		LIMIT num;
	DECLARE EXIT HANDLER FOR NOT found SET cond = 0;
    OPEN filmCursor;
    getFilm: LOOP
		FETCH filmCursor INTO filmId;
		IF (cond = 0) THEN LEAVE getFilm;
		END IF;
        UPDATE film
			SET rental_rate = (1 - per/100) * rental_rate
            WHERE film.film_id = filmId;
	END LOOP;
    CLOSE filmCursor;
END //
DELIMITER ;