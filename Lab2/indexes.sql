# MySQL CREATE INDEX

-- he following statement finds employees whose job title is Sales Rep:

SELECT 
    employeeNumber, 
    lastName, 
    firstName
FROM
    employees
WHERE
    jobTitle = 'Sales Rep';
    
-- To see how MySQL internally performed this query, you add the EXPLAIN clause at the beginning of the SELECT statement as follows:
EXPLAIN SELECT 
    employeeNumber, 
    lastName, 
    firstName
FROM
    employees
WHERE
    jobTitle = 'Sales Rep';
-- Now, let’s create an index for the  jobTitle column by using the CREATE INDEX statement:

CREATE INDEX jobTitle 
ON employees(jobTitle);

-- Execute the EXPLAIN statement again:
EXPLAIN SELECT 
    employeeNumber, 
    lastName, 
    firstName
FROM
    employees
WHERE
    jobTitle = 'Sales Rep';
    
-- To list all indexes of a table, you use the SHOW INDEXES statement, for example:

SHOW INDEXES FROM employees;

# MySQL DROP INDEX


DROP INDEX index_name 
ON table_name
[algorithm_option | lock_option];


-- The following shows the syntax of the algorithm_option clause:

-- ALGORITHM [=] {DEFAULT|INPLACE|COPY}

-- The following shows the syntax of the lock_option:

-- LOCK [=] {DEFAULT|NONE|SHARED|EXCLUSIVE}



#MySQL DROP INDEX statement examples
-- Let’s create a new table for the demonstration:

CREATE TABLE leads(
    lead_id INT AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    information_source VARCHAR(255),
    INDEX name(first_name,last_name),
    UNIQUE email(email),
    PRIMARY KEY(lead_id)
);

-- The following statement removes the name index from the leads table:

DROP INDEX name ON leads;

-- The following statement drops the email index from the leads table with a specific algorithm and lock:

DROP INDEX email ON leads
ALGORITHM = INPLACE 
LOCK = DEFAULT;

-- MySQL DROP PRIMARY KEY index
-- To drop the primary key whose index name is PRIMARY, you use the following statement:

DROP INDEX `PRIMARY` ON table_name;

# MySQL SHOW INDEXES

SHOW INDEXES FROM table_name;

SHOW INDEXES FROM table_name 
IN database_name;

SHOW KEYS FROM tablename
IN databasename;



-- We will create a new table named contacts to demonstrate the SHOW INDEXES command:

CREATE TABLE contacts(
    contact_id INT AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    PRIMARY KEY(contact_id),
    UNIQUE(email),
    INDEX phone(phone) INVISIBLE,
    INDEX name(first_name, last_name) comment 'By first name and/or last name'
);

-- The following command returns all index information from the contacts table:

SHOW INDEXES FROM contacts;


-- MySQL SHOW INDEXES - get all indexes
-- To get the invisible indexes of the contacts table, you add a WHERE clause as follows:

SHOW INDEXES FROM contacts
WHERE visible = 'NO';

#MySQL Prefix Index




    