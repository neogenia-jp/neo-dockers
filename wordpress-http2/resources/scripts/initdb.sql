create database wordpress charset=utf8;
create user wordpress identified by 'Passw0rd';
grant all on wordpress.* to wordpress;

