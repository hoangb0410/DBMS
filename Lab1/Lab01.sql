# 2
alter user 'root'@'localhost' identified by '123456';
flush privileges;

# 4
select host, user, authentication_string from mysql.user;

# 5
create user 'demo'@'localhost' identified by '123@abc';

# 6
grant all privileges on sakila.* to 'demo'@'localhost';
flush privileges;

# 7
create user 'guest'@'%' identified by '123@abc';

# 8
grant select on sakila.film to 'guest'@'%';
flush privileges;

# 9
show grants for 'demo'@'localhost';
show grants for 'guest'@'%';

# 10
mysqladmin -u root -p shutdown