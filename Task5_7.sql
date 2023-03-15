
-- Используя базу данных carsshop создайте функцию для нахождения минимального возраста клиента, 
-- затем сделайте выборку всех машин, которые он купил.


drop database carsshop; 

create database carsshop; 

use carsshop; 


create table marks(
   id int not null auto_increment primary key,
   mark varchar(20) unique
); 
CREATE TABLE cars(
  id INT NOT NULL auto_increment primary key,
  mark_id INT NOT NULL,
  model varchar(20) NOT NULL,
  price INT NOT NULL,
  foreign key(mark_id) references marks(id)
); 

CREATE TABLE clients
(
	
	 id INT AUTO_INCREMENT NOT NULL,
     name VARCHAR(30),
     age TINYINT,
     phone VARCHAR(15),
     PRIMARY KEY (id)
); 

create table orders(
     id int not null primary key auto_increment,
     car_id int not null,
     client_id int not null,
     foreign key(car_id) references cars(id),
     foreign key(client_id) references clients(id)
); 

INSERT into marks(mark) values('Audi');
INSERT into marks(mark) values('Porsche'); 

insert into cars(mark_id, model, price) values (1, 'A5', 50000); 
insert into cars(mark_id, model, price) values (2, 'panamera', 100000); 
insert into cars(mark_id, model, price) values (2, 'cayen S', 88000); 

insert into clients(name, age) values ('petro', 20), ('vasya', 25), ('vitaly', 75); 

insert into orders(car_id, client_id) values(1, 1), (2, 2), (1, 3); 
select * from clients;

    
drop function findminage;
delimiter |
CREATE FUNCTION FindMinAge() 
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (SELECT Min(cl.age) FROM clients cl);
            
END
 |
 
 SELECT 
    name, mark, model, age
FROM
    clients
        INNER JOIN
    orders ON orders.client_id = clients.id
        JOIN
    cars ON orders.car_id = cars.id
        JOIN
    marks ON cars.mark_id = marks.id
WHERE
    clients.age = findminage();
 



