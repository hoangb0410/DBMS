#MySQL trigger example

-- First, create a new table called items:

CREATE TABLE items (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- Second, insert a row into the items table:

INSERT INTO items(id, name, price) 
VALUES (1, 'Item', 50.00);

-- Third, create the item_changes table to store the changes made to the data in the items table:

CREATE TABLE item_changes (
    change_id INT PRIMARY KEY AUTO_INCREMENT,
    item_id INT,
    change_type VARCHAR(10),
    change_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (item_id) REFERENCES items(id)
);

-- Fourth, create a trigger called update_items_trigger associated with the items table:

DELIMITER //

CREATE TRIGGER update_items_trigger
AFTER UPDATE
ON items
FOR EACH ROW
BEGIN
    INSERT INTO item_changes (item_id, change_type)
    VALUES (NEW.id, 'UPDATE');
END;
//

DELIMITER ;

-- Fifth, update a row in the items table:
UPDATE items
SET price = 60.00 
WHERE id = 1;

-- Finally, retrieve data from the item_changes table to see the logged changes:

SELECT * FROM item_changes;


#MySQL DROP TRIGGER

-- First, create a table called billings for demonstration:
CREATE TABLE billings (
    billingNo INT AUTO_INCREMENT,
    customerNo INT,
    billingDate DATE,
    amount DEC(10 , 2 ),
    PRIMARY KEY (billingNo)
);

-- Second, create a new trigger called BEFORE UPDATE that is associated with the billings table:
DELIMITER $$
CREATE TRIGGER before_billing_update
    BEFORE UPDATE 
    ON billings FOR EACH ROW
BEGIN
    IF new.amount > old.amount * 10 THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'New amount cannot be 10 times greater than the current amount.';
    END IF;
END$$    
DELIMITER ;

-- Third, show the triggers:

SHOW TRIGGERS;


-- Fourth, drop the before_billing_update trigger:

DROP TRIGGER before_billing_update;


-- Finally, show the triggers again to verify the removal:

SHOW TRIGGERS;


# MySQL BEFORE INSERT Trigger

-- First, create a new table called WorkCenters:

DROP TABLE IF EXISTS WorkCenters;

CREATE TABLE WorkCenters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    capacity INT NOT NULL
);

-- Second, create another table called WorkCenterStats that stores the summary of the capacity of the work centers:

DROP TABLE IF EXISTS WorkCenterStats;

CREATE TABLE WorkCenterStats(
    totalCapacity INT NOT NULL
);

-- Creating BEFORE INSERT trigger example
-- The following trigger updates the total capacity of the WorkCenterStats table before a new work center is inserted into the WorkCenter table:

DELIMITER $$

CREATE TRIGGER before_workcenters_insert
BEFORE INSERT
ON WorkCenters FOR EACH ROW
BEGIN
    DECLARE rowcount INT;
    
    SELECT COUNT(*) 
    INTO rowcount
    FROM WorkCenterStats;
    
    IF rowcount > 0 THEN
        UPDATE WorkCenterStats
        SET totalCapacity = totalCapacity + new.capacity;
    ELSE
        INSERT INTO WorkCenterStats(totalCapacity)
        VALUES(new.capacity);
    END IF; 

END $$

DELIMITER ;


-- If the table WorkCenterStats has a row, the trigger adds the capacity to the totalCapacity column. 
-- Otherwise, it inserts a new row into the WorkCenterStats table.

-- Testing the MySQL BEFORE INSERT trigger
-- First, insert a new row into the WorkCenter table:

INSERT INTO WorkCenters(name, capacity)
VALUES('Mold Machine',100);

-- Second, query data from the WorkCenterStats table:

SELECT * FROM WorkCenterStats;

-- The trigger has been invoked and inserted a new row into the WorkCenterStats table.

-- Third, insert a new work center:   

INSERT INTO WorkCenters(name, capacity)
VALUES('Packing',200);

-- Finally, query data from the WorkCenterStats:

SELECT * FROM WorkCenterStats;

-- The trigger has updated the total capacity from 100 to 200 as expected.


#MySQL AFTER INSERT triggers are automatically invoked after an insert event occurs on the table.

-- MySQL AFTER INSERT trigger example

-- First, create a new table called members:

DROP TABLE IF EXISTS members;

CREATE TABLE members (
    id INT AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255),
    birthDate DATE,
    PRIMARY KEY (id)
);

-- Second, create another table called reminders that stores reminder messages to members.

DROP TABLE IF EXISTS reminders;

CREATE TABLE reminders (
    id INT AUTO_INCREMENT,
    memberId INT,
    message VARCHAR(255) NOT NULL,
    PRIMARY KEY (id,memberId)
);


-- Creating AFTER INSERT trigger example
-- The following statement creates an AFTER INSERT trigger that inserts a reminder into the reminders table if the birth date of the member is NULL.

DELIMITER $$

CREATE TRIGGER after_members_insert
AFTER INSERT
ON members FOR EACH ROW
BEGIN
    IF NEW.birthDate IS NULL THEN
        INSERT INTO reminders(memberId, message)
        VALUES(new.id,CONCAT('Hi ', NEW.name, ', please update your date of birth.'));
    END IF;
END$$

DELIMITER ;

-- Creating AFTER INSERT trigger example
-- The following statement creates an AFTER INSERT trigger that inserts a reminder into the reminders table if the birth date of the member is NULL.

DELIMITER $$

CREATE TRIGGER after_members_insert
AFTER INSERT
ON members FOR EACH ROW
BEGIN
    IF NEW.birthDate IS NULL THEN
        INSERT INTO reminders(memberId, message)
        VALUES(new.id,CONCAT('Hi ', NEW.name, ', please update your date of birth.'));
    END IF;
END$$

DELIMITER ;


-- Second, query data from the members table:

SELECT * FROM members;    

SELECT * FROM reminders;  
-- We inserted two rows into the members table. 
--However, only the first row has a birth date value NULL, therefore, the trigger inserted only one row into the reminders table.












