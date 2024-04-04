use sakila;
# 1
SELECT
    IFNULL(rental_id, '') AS rental_id,
    IFNULL(rental_date, '') AS rental_date,
    IFNULL(inventory_id, '') AS inventory_id,
    IFNULL(customer_id, '') AS customer_id,
    IFNULL(return_date, '') AS return_date,
    IFNULL(staff_id, '') AS staff_id,
    IFNULL(last_update, '') AS last_update
INTO OUTFILE '/Applications/XAMPP/htdocs/DBMS/rental_data.txt'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
FROM rental;

LOAD DATA INFILE '/Applications/XAMPP/htdocs/DBMS/rental_data.txt'
INTO TABLE rental
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
(rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update);

# 2
CREATE TABLE rental_latest like rental;
INSERT INTO rental_latest (rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update)
SELECT rental_id, rental_date, inventory_id, customer_id, return_date, staff_id, last_update
FROM rental
WHERE DATE_FORMAT(rental_date, '%Y-%m') = DATE_FORMAT((SELECT MAX(rental_date) FROM rental), '%Y-%m');

# 3
mysqldump -u root -p --no-data --flush-logs sakila > "/Applications/XAMPP/htdocs/DBMS/sakila_schema.sql"
mysqldump -u root -p --no-create-info sakila > "/Applications/XAMPP/htdocs/DBMS/sakila_data.sql"

#4.i
# Mở tệp cấu hình my.ini, chỉnh sửa/thêm dòng sau để bật log-bin : log-bin=mysql-bin
SHOW BINARY LOGS;

#4.ii
# Mở tệp cấu hình my.ini, thêm dòng sau để chỉ log lại thay đổi trên CSDL sakila: binlog_do_db=sakila

#4.iii
ALTER TABLE film ADD new_column INT;
ALTER TABLE film MODIFY COLUMN new_column VARCHAR(50);

#4.iv
mysqlbinlog binlog.000001 > "/Applications/XAMPP/htdocs/DBMS/sakila_binlog.txt"

#4.v
# Mở tệp cấu hình my.ini, chỉnh sửa dòng sau để thiết lập định dạng bin log format thành row: binlog_format=row

# 5
mysql -u root -p sakila < "/Applications/XAMPP/htdocs/DBMS/sakila_schema.sql"
mysql -u root -p sakila < "/Applications/XAMPP/htdocs/DBMS/sakila_data.sql"
mysqlbinlog binlog.000001 | mysql -u root -p sakila


