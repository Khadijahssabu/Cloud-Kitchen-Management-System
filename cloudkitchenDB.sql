-- Create the new database if it does not exist already
drop DATABASE CloudKitchen
IF NOT EXISTS (
    SELECT [name]
        FROM sys.databases
        WHERE [name] = N'CloudKitchen'
)
CREATE DATABASE CloudKitchen
GO

use CloudKitchen

--DOWN

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_dish_kitchen_name')
    ALTER TABLE dish DROP CONSTRAINT fk_dish_kitchen_name
DROP TABLE if EXISTS dish

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_orders_dish_dish_id')
    ALTER TABLE orders DROP CONSTRAINT fk_order_dish_dish_id
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_order_order_kitchen_id')
    ALTER TABLE orders DROP CONSTRAINT fk_order_order_kitchen_id
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_order_customer_customer_id')
    ALTER TABLE orders DROP CONSTRAINT fk_order_customer_customer_id
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_orders_deliverer_pickup_id')
    ALTER TABLE orders DROP CONSTRAINT fk_orders_deliverer_pickup_id
DROP TABLE if EXISTS orders

if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_review_review_by')
    ALTER TABLE reviews DROP CONSTRAINT fk_review_review_by
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_review_review_for')
    ALTER TABLE reviews DROP CONSTRAINT fk_review_review_for
if exists(select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS
    WHERE CONSTRAINT_NAME='fk_review_review_deliverer_rating')
    ALTER TABLE reviews DROP CONSTRAINT fk_review_review_deliverer_rating

DROP TABLE if EXISTS reviews
DROP TABLE if EXISTS deliverer
DROP TABLE if EXISTS customers
DROP TABLE if EXISTS kitchen

-- UP Metadata

CREATE TABLE customers (
    customer_id INT UNIQUE IDENTITY not null,
    customer_first_name varchar(30) not null,
    customer_last_name  varchar(30) not nulL,
    customer_address  varchar(50) not null,
    customer_phone_number int not null,
    customer_email  varchar(20) UNIQUE not null,
    customer_age INT not null
    Constraint pk_customers_customer_id PRIMARY KEY(customer_id)
)
ALTER table customers alter COLUMN customer_phone_number bigint not null

CREATE TABLE Kitchen (
    kitchen_id INT UNIQUE IDENTITY NOT NULL,
    kitchen_name varchar(100) UNIQUE NOT NULL,
    kitchen_dish_name varchar(100) not null,
    kitchen_address  varchar(50) NOT NULL,
    kitchen_email varchar(30) NOT NULL,
    kitchen_phonenumber varchar(10) NOT NULL,
    Constraint pk_kitchen_kitchen_id PRIMARY KEY(kitchen_id)
)


/*CREATE TABLE location (
    location_id int not null,
    location_address varchar(50) not null,
    location_city varchar(25) not null, 
    location_state VARCHAR(25) not null,
    location_country VARCHAR(10) not null,
    constraint pk_location_location_id PRIMARY KEY(location_id)
); */

CREATE TABLE Deliverer(
    deliverer_id INT UNIQUE IDENTITY NOT NULL,
    deliverer_first_name varchar(30) NOT NULL,
    deliverer_last_name varchar(30) NOT NULL,
    deliverer_number varchar(10) NOT NULL,
    deliverer_address varchar(50) NOT NULL,
    deliverer_email varchar(30) NOT NULL,
    Constraint pk_deliverer_deliverer_id primary key(deliverer_id),
)

CREATE TABLE Dish (
    dish_id  INT unique IDENTITY NOT NULL,
    dish_name varchar(50) NOT NULL,
    dish_cuisine  varchar(50) NOT NULL,
    dish_category varchar(50) NOT NULL,
    dish_kitchen_id INT not null,
    dish_price SMALLINT NOT NULL,
    dish_portions INT NOT NULL,
    Constraint pk_dish_dish_id PRIMARY KEY (dish_id),
    Constraint fk_dish_kitchen_id FOREIGN KEY(dish_kitchen_id) REFERENCES kitchen(kitchen_id)
);


CREATE TABLE Reviews (
    review_id int unique identity not null,
    review_dish_id INT,
    review_comment varchar(50) NOT NULL,
    review_by INT NULL,
    review_for INT NULL,
    review_deliverer_rating INT NOT NULL,
    Constraint pk_reviews_review_id primary key(review_id),
    Constraint fk_review_review_by FOREIGN KEY(review_by) REFERENCES customers(customer_id),
    Constraint fk_review_review_for FOREIGN KEY(review_for) REFERENCES kitchen(kitchen_id),
    Constraint fk_review_review_deliverer_rating FOREIGN KEY(review_deliverer_rating) REFERENCES deliverer(deliverer_id)
)

CREATE TABLE Orders (
    order_id int IDENTITY not null,
    order_dish_id  INT NOT NULL,
    order_customer_id  INT NOT NULL,
    order_time FLOAT NULL,
    order_quantity  SMALLINT NOT NULL DEFAULT 1,
    order_kitchen_id  int NOT NULL,
    order_pickup_time FLOAT NOT NULL,
    order_pickup_id INTEGER NOT NULL,
    Constraint pk_orders_order_id PRIMARY KEY(order_id),
    Constraint fk_orders_dish_dish_id foreign key(order_dish_id) REFERENCES dish(dish_id),
    Constraint fk_order_order_kitchen_id FOREIGN KEY(order_kitchen_id) REFERENCES kitchen(kitchen_id),
    Constraint fk_order_customer_customer_id FOREIGN KEY(order_customer_id) REFERENCES customers(customer_id),
    Constraint fk_orders_deliverer_pickup_id foreign key(order_pickup_id) REFERENCES deliverer(deliverer_id)
)

--UP Data
INSERT INTO customers (customer_first_name, customer_last_name, customer_address, customer_phone_number, customer_email, customer_age) 
VALUES ('Hannah','Baker', '2230 NORTHSIDE, APT 11, ALBANY, NY', 8080367290, 'hbaker@gmail.com', 19);
INSERT INTO customers (customer_first_name, customer_last_name, customer_address, customer_phone_number, customer_email, customer_age) 
VALUES ('LINDA','GOODMAN', '731 Fondren, Houston, TX', 4356789345, 'lgoodman@ams.com', 20);
INSERT INTO customers (customer_first_name, customer_last_name, customer_address, customer_phone_number, customer_email, customer_age) 
VALUES ('JOHNY','PAUL','638 Voss, Houston, TX',9834561995, 'jpaul@gmail.com', 17);
INSERT INTO customers (customer_first_name, customer_last_name, customer_address, customer_phone_number, customer_email, customer_age) 
VALUES ('JAMES','BOND','3321 Castle, Spring, TX',9834666995, 'jbond@gmail.com', 43);
INSERT INTO customers (customer_first_name, customer_last_name, customer_address, customer_phone_number, customer_email, customer_age) 
VALUES ('SHERLOCK','HOLMES','123 TOP HILL, SAN Francisco,CA',8089654321,'sholmes@gmail.com', 50);
INSERT INTO customers (customer_first_name, customer_last_name, customer_address, customer_phone_number, customer_email, customer_age) 
VALUES ('SHELDON','COOPER','345 CHERRY PARK, HESSE,GERMANY',1254678903,'scooper@gmail.com', 19);
INSERT INTO customers (customer_first_name, customer_last_name, customer_address, customer_phone_number, customer_email, customer_age) 
VALUES('RAJ','SHARMA','345 FLOYDS, MUMBAI,INDIA',4326789031,'rsharma@gmail.com', 18);
INSERT INTO customers (customer_first_name, customer_last_name, customer_address, customer_phone_number, customer_email, customer_age) 
VALUES ('RAJ','SHARMA','345 FLOYDS, MUMBAI,INDIA',4326789031,'rssharma@gmail.com', 16);
INSERT INTO customers (customer_first_name, customer_last_name, customer_address, customer_phone_number, customer_email, customer_age) 
VALUES ('SHUBHAM','GUPTA','567 CHANDANI CHOWK, DELHI, INDIA',8566778890,'sgupta@gmail.com', 53);
INSERT INTO customers (customer_first_name, customer_last_name, customer_address, customer_phone_number, customer_email, customer_age) 
VALUES ('PRATIK','GOMES','334 VITRUVIAN PARK, ALBANY, NY',4444678903,'pgomes@gmail.com', 18);


INSERT INTO kitchen (kitchen_name,kitchen_dish_name,kitchen_address,kitchen_email,kitchen_phonenumber) 
VALUES ('KBs Kitchen','Dal Makhni','Westcott','kb@gmail.com','9090909090');
INSERT INTO kitchen (kitchen_name,kitchen_dish_name,kitchen_address,kitchen_email,kitchen_phonenumber) 
VALUES ('AKs Kitchen','Pav Bhaji','South Beech','ak@gmail.com','9090109090');
INSERT INTO kitchen (kitchen_name,kitchen_dish_name,kitchen_address,kitchen_email,kitchen_phonenumber) 
VALUES ('KSs Kitchen','Pasta','Sumner','kzs@gmail.com','9033909090');
INSERT INTO kitchen (kitchen_name,kitchen_dish_name,kitchen_address,kitchen_email,kitchen_phonenumber) 
VALUES ('HSs Kitchen','Noodles','Genesse','hs@gmail.com','9190909090');
INSERT INTO kitchen (kitchen_name,kitchen_dish_name,kitchen_address,kitchen_email,kitchen_phonenumber) 
VALUES ('SPs Kitchen','Pani Puri','Eastcott','sp@gmail.com','9090907770');
INSERT INTO kitchen (kitchen_name,kitchen_dish_name,kitchen_address,kitchen_email,kitchen_phonenumber) 
VALUES ('SSs Kitchen','Aloo Paratha','Chennai St','ss@gmail.com','9095909090');
INSERT INTO kitchen (kitchen_name,kitchen_dish_name,kitchen_address,kitchen_email,kitchen_phonenumber) 
VALUES ('JCs Kitchen','Chole','Cherry St','jc@gmail.com','9090767690');
INSERT INTO kitchen (kitchen_name,kitchen_dish_name,kitchen_address,kitchen_email,kitchen_phonenumber) 
VALUES ('SLs Kitchen','Hakka Noodles','Sion','SL@gmail.com','9088909090');
INSERT INTO kitchen (kitchen_name,kitchen_dish_name,kitchen_address,kitchen_email,kitchen_phonenumber) 
VALUES ('90s Kitchen','Wok Chinese','Southcott','wok@gmail.com','9011111090');
INSERT INTO kitchen (kitchen_name,kitchen_dish_name,kitchen_address,kitchen_email,kitchen_phonenumber) 
VALUES ('K9s Kitchen','Egg Curry','Norstcott','K9@gmail.com','9931523090');


INSERT INTO deliverer (deliverer_first_name, deliverer_last_name,deliverer_number,deliverer_address, deliverer_email) 
VALUES ('Vishal','Pandey','3030303030','Euclid Ave','hu@yahoo.com') ;
INSERT INTO deliverer (deliverer_first_name, deliverer_last_name,deliverer_number,deliverer_address, deliverer_email) 
VALUES ('Jackda','niels','3030303080','Kensington','ja@yahoo.com') ;
INSERT INTO deliverer (deliverer_first_name, deliverer_last_name,deliverer_number,deliverer_address, deliverer_email) 
VALUES ('Hen','Ishe','33230303030','Redwood','hiu@yahoo.com') ;
INSERT INTO deliverer (deliverer_first_name, deliverer_last_name,deliverer_number,deliverer_address, deliverer_email) 
VALUES ('Buck','Hardy','3078303030','Heaven Island','bh@yahoo.com') ;
INSERT INTO deliverer (deliverer_first_name, deliverer_last_name,deliverer_number,deliverer_address, deliverer_email) 
VALUES ('pop','tates','3030909030','Queensland Pl','qp@yahoo.com') ;
INSERT INTO deliverer (deliverer_first_name, deliverer_last_name,deliverer_number,deliverer_address, deliverer_email) 
VALUES ('Car','Owna','3030309030','Avondale','co@ygmail.com') ;
INSERT INTO deliverer (deliverer_first_name, deliverer_last_name,deliverer_number,deliverer_address, deliverer_email) 
VALUES ('Bus','Light','5030303030','optima st','bl@yahoo.com') ;
INSERT INTO deliverer (deliverer_first_name, deliverer_last_name,deliverer_number,deliverer_address, deliverer_email) 
VALUES ('Lee','Mon','30303899890','Clarendon','LM@yahoo.com') ;
INSERT INTO deliverer (deliverer_first_name, deliverer_last_name,deliverer_number,deliverer_address, deliverer_email) 
VALUES ('shal','dey','39030303030','Quiet Pl','sd@yahoo.com') ;
INSERT INTO deliverer (deliverer_first_name, deliverer_last_name,deliverer_number,deliverer_address, deliverer_email) 
VALUES ('Hal','mack','303083030','Euclidson Ave','hm@yahoo.com') ;


INSERT INTO dish ( dish_name, dish_cuisine, dish_category,dish_kitchen_id,dish_price, dish_portions) 
VALUES ('Pav Bhaji','Indian','Breakfast',1,20,10) ;
INSERT INTO dish ( dish_name, dish_cuisine, dish_category,dish_kitchen_id,dish_price, dish_portions) 
VALUES ('Pasta','Italian','Lunch',2,30,10) 
INSERT INTO dish ( dish_name, dish_cuisine, dish_category,dish_kitchen_id,dish_price, dish_portions) 
VALUES ('Dal Makhni','Indian','Dinner',3,20,10) 
INSERT INTO dish ( dish_name, dish_cuisine, dish_category,dish_kitchen_id,dish_price, dish_portions) 
VALUES ('Noodles','Indo-Chinese','Lunch',4,20,15) 
INSERT INTO dish ( dish_name, dish_cuisine, dish_category,dish_kitchen_id,dish_price, dish_portions) 
VALUES ('Hakka Noodles','Indian','Dinner',5,20,25) 
INSERT INTO dish ( dish_name, dish_cuisine, dish_category,dish_kitchen_id,dish_price, dish_portions) 
VALUES ('Pani Puri','Indian','Snack',6,20,9) 
INSERT INTO dish ( dish_name, dish_cuisine, dish_category,dish_kitchen_id,dish_price, dish_portions) 
VALUES ('Chole','Indian','Lunch',7,20,12) 
INSERT INTO dish ( dish_name, dish_cuisine, dish_category,dish_kitchen_id,dish_price, dish_portions) 
VALUES ('Aloo Paratha','Indian','Breakfast',8,20,7) 
INSERT INTO dish ( dish_name, dish_cuisine, dish_category,dish_kitchen_id,dish_price, dish_portions) 
VALUES ('Wok Chinese','Chinese','Meal',9,20,19) 
INSERT INTO dish ( dish_name, dish_cuisine, dish_category,dish_kitchen_id,dish_price, dish_portions) 
VALUES ('Egg Curry','Indian','Brunch',10,20,13) 

INSERT INTO reviews (review_dish_id,review_comment,review_by, review_for, review_deliverer_rating) 
VALUES (1,'Okay',2,1,1) ;
INSERT INTO reviews (review_dish_id,review_comment,review_by, review_for, review_deliverer_rating) 
VALUES (2,'Good',1,3,10)
INSERT INTO reviews (review_dish_id,review_comment,review_by, review_for, review_deliverer_rating) 
VALUES (3,'Bad',3,2,9)
INSERT INTO reviews (review_dish_id,review_comment,review_by, review_for, review_deliverer_rating) 
VALUES (4,'Worse',4,1,8)
INSERT INTO reviews (review_dish_id,review_comment,review_by, review_for, review_deliverer_rating) 
VALUES (5,'Average',5,2,7)
INSERT INTO reviews (review_dish_id,review_comment,review_by, review_for, review_deliverer_rating) 
VALUES (6,'Very Good',6,4,6)
INSERT INTO reviews (review_dish_id,review_comment,review_by, review_for, review_deliverer_rating) 
VALUES (7,'Okay',7,5,5)
INSERT INTO reviews (review_dish_id,review_comment,review_by, review_for, review_deliverer_rating) 
VALUES (8,'Good',8,8,4)
INSERT INTO reviews (review_dish_id,review_comment,review_by, review_for, review_deliverer_rating) 
VALUES (9,'Okayish',9,6,3)
INSERT INTO reviews (review_dish_id,review_comment,review_by, review_for, review_deliverer_rating) 
VALUES (11,'Worse',10,9,2)

INSERT INTO Orders (order_dish_id,order_customer_id,order_time,order_quantity,order_kitchen_id,order_pickup_time,order_pickup_id) 
VALUES (2,1,0.5,3,1,0.3,1);
INSERT INTO Orders (order_dish_id,order_customer_id,order_time,order_quantity,order_kitchen_id,order_pickup_time,order_pickup_id) 
VALUES (3,2,1.15,2,2,0.4,2);
INSERT INTO Orders (order_dish_id,order_customer_id,order_time,order_quantity,order_kitchen_id,order_pickup_time,order_pickup_id) 
VALUES (1,3,0.6,4,3,0.4,6);
INSERT INTO Orders (order_dish_id,order_customer_id,order_time,order_quantity,order_kitchen_id,order_pickup_time,order_pickup_id) 
VALUES (4,4,0.3,5,4,0.3,4);
INSERT INTO Orders (order_dish_id,order_customer_id,order_time,order_quantity,order_kitchen_id,order_pickup_time,order_pickup_id) 
VALUES (6,5,1.5,8,5,0.5,5);
INSERT INTO Orders (order_dish_id,order_customer_id,order_time,order_quantity,order_kitchen_id,order_pickup_time,order_pickup_id) 
VALUES (5,6,0.5,3,6,0.3,6);
INSERT INTO Orders (order_dish_id,order_customer_id,order_time,order_quantity,order_kitchen_id,order_pickup_time,order_pickup_id) 
VALUES (7,7,2.3,10,7,0.5,7);
INSERT INTO Orders (order_dish_id,order_customer_id,order_time,order_quantity,order_kitchen_id,order_pickup_time,order_pickup_id) 
VALUES (9,8,0.6,5,8,0.5,5);
INSERT INTO Orders (order_dish_id,order_customer_id,order_time,order_quantity,order_kitchen_id,order_pickup_time,order_pickup_id) 
VALUES (8,6,2,15,9,0.6,10);
INSERT INTO Orders (order_dish_id,order_customer_id,order_time,order_quantity,order_kitchen_id,order_pickup_time,order_pickup_id) 
VALUES (10,9,0.8,11,7,0.7,10);

--Verification


select * from customers
select * from Kitchen
select * from Deliverer
select * from dish
select * from reviews
select * from Orders




