Create DATABASE MyFunkDB;

use MyFunkDB;
drop TABLE personnel;
CREATE TABLE personnel (

id INT not null AUTO_INCREMENT PRIMARY KEY,
lname VARCHAR(30) not NULL,
fname VARCHAR(30) NOT NULL,
phnumber VARCHAR(15) UNIQUE
);
drop TABLE off_info;
CREATE TABLE off_info (
off_id INT not null ,
salary INT not null,
position_name VARCHAR (50) not null,
foreign KEY (off_id) REFERENCES personnel(id) ON UPDATE CASCADE
);
drop TABLE pers_info;

create TABLE pers_info (
pers_id int not null REFERENCES personnel(id),
family_state VARCHAR(15) not null,
birthdate date not null,
address VARCHAR(50),
FOREIGN KEY (pers_id) REFERENCES personnel(id)
on update cascade
);


INSERT personnel 
(lname, fname, phnumber)
VALUES
('Smith', 'Will', '0123456789'),
('Alba','Jesica','08767845654'),
('Travolta','John','08534543654'),
('Jackson','Michael','087679074');


SELECT * from personnel;

INSERT off_info 
VALUES
(1, 10000, 'director'),
(2, 8000, 'manager'),
(3, 5000, 'worker'),
(4, 4500,'worker');

select * from off_info;

update personnel
set id = 222
where id = 2;


INSERT pers_info 
VALUES
(111, 'married', '2000-05-30','London, 23456'),
(2, 'single', '1995-12-24','Paris, 876565'),
(333, 'married', '1994-05-06','Berlin, 29956'),
(444, 'divorced', '1980-12-01','Rome, 23434');

select * from pers_info;

drop PROCEDURE personnel_contact_data;


-- 1) Требуется узнать контактные данные сотрудников (номера телефонов, место жительства).
delimiter |



CREATE PROCEDURE personnel_contact_data(in lname_par VARCHAR(20))
BEGIN
if (lname_par IS null)
then 
SELECT lname, fname, phnumber,
(SELECT address from pers_info where personnel.id = pers_info.pers_id) as address
from personnel
; 
ELSE 
SELECT lname, fname, phnumber,
(SELECT address from pers_info where personnel.id = pers_info.pers_id) as address
from personnel
where personnel.lname like lname_par; 
end if;
end;
|
call personnel_contact_data('Trav%'); |
call personnel_contact_data(null); |

-- 2) Требуется узнать информацию о дате рождения всех 
-- не женатых сотрудников и номера телефонов этих сотрудников.

drop PROCEDURE selectOnFamilyStatus; |

delimiter |



CREATE PROCEDURE selectOnFamilyStatus ()
begin

select lname, fname, phnumber, pers_info.birthdate, pers_info.family_state  from personnel
join
pers_info
on personnel.id = pers_info.pers_id
where family_state in ('single', 'divorced');

end |

call selectOnFamilyStatus (); |



-- 3) Требуется узнать информацию о дате рождения всех 
-- сотрудников с должностью менеджер и номера телефонов этих сотрудников.

 

drop PROCEDURE selectOnPosition; |


delimiter |
CREATE PROCEDURE selectOnPosition (in pos VARCHAR(20))

begin

select lname, fname, phnumber, pers_info.birthdate, off_info.position_name 
from personnel
join off_info
on personnel.id = off_info.off_id
join pers_info
on pers_info.pers_id = off_info.off_id

where off_info.position_name = pos;
end
|

call selectOnPosition('manager'); |


