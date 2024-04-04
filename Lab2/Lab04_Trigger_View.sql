# 1
CREATE TABLE payment_log (
   payment_id smallint(5) DEFAULT NULL,
   customer_id smallint(5)  DEFAULT NULL ,
   staff_id tinyint(3) unsigned DEFAULT NULL,
   rental_id int(11) DEFAULT NULL,
   amount decimal(5,2) DEFAULT NULL,
   payment_date datetime DEFAULT NULL,
   changedate DATETIME DEFAULT NULL,
   action VARCHAR(50) DEFAULT NULL
   );
 
DELIMITER //
CREATE TRIGGER update_payment AFTER UPDATE ON payment
FOR EACH ROW
BEGIN
    INSERT INTO payment_log
    SET action = 'update',
            payment_id = OLD.payment_id,
            customer_id = OLD.customer_id,
            staff_id = OLD.staff_id,
            rental_id = OLD.rental_id,
            amount = OLD.amount,
            payment_date = OLD.payment_date,
            changedate = NOW();
END //
DELIMITER ;

# 2
DELIMITER //
CREATE TRIGGER update_inventory_availability
AFTER INSERT ON rental
FOR EACH ROW
BEGIN
    IF NEW.return_date IS NULL THEN
        UPDATE inventory
        SET is_available = FALSE
        WHERE inventory_id = NEW.inventory_id;
    ELSE
        UPDATE inventory
        SET is_available = TRUE
        WHERE inventory_id = NEW.inventory_id;
    END IF;
END;
//
DELIMITER ;

# 3
SHOW CREATE VIEW customer_list;

SELECT * FROM customer_list;

UPDATE customer_list
SET address ='123 Cau Giay'
WHERE ID = 1;

UPDATE customer_list
SET phone = '123-456-789'
WHERE ID = 1;

UPDATE customer_list
SET city = 'Ha Noi'
WHERE ID = 1;

# 4
CREATE VIEW actor_list AS
SELECT a.actor_id, a.first_name, a.last_name, GROUP_CONCAT(f.title SEPARATOR ', ') AS filmography
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
GROUP BY a.actor_id;

# 5
CREATE VIEW sales_by_customer AS
SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, SUM(p.amount) AS total_sales
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY total_sales DESC;
