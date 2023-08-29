
Select * FROM Dish

---1. Type of Cuisine
CREATE VIEW cuisine_type AS
SELECT dish_name,dish_category,dish_price
FROM Dish
WHERE dish_cuisine = 'Indian';

select * FROM cuisine_type

drop PROCEDURE change_deliverer_number

---2. Updating Deliverer Phone Number


create PROCEDURE change_deliverer_number (
    @deliv_id int, @deliv_no varchar(10)
) as begin 
    update deliverer
        set deliverer_number = @deliv_no
        where deliverer_id = @deliv_id
  end  
----
exec change_deliverer_number
    @deliv_id = 5,
    @deliv_no = '9794209845'
----
select * FROM Deliverer


drop PROCEDURE change_customer_email

---3. Updating Customer Email 
create PROCEDURE change_customer_email (
    @cust_id int, @cust_email varchar(20)
) as begin 
    update customers
        set customer_email = @cust_email
        where customer_id = @cust_id
  end  

----
exec change_customer_email
    @cust_id = 1,
    @cust_email = 'pggggggggggomess@gmail.com'
GO
----
select * from customers



---4. Reviews for all dishes from a Kitchen
CREATE VIEW kitchen_review AS
SELECT  d.dish_name,d.dish_cuisine, r.review_comment
FROM Reviews r
INNER JOIN kitchen k on k.kitchen_id = r.review_for
INNER JOIN dish d on dish_kitchen_id =  kitchen_id
WHERE k.kitchen_name = 'KBs Kitchen' ;

SELECT * FROM kitchen_review



---5. Customer details for all orders more than 3
CREATE VIEW orders_more_than AS
SELECT c.customer_first_name+ ' ' + c.customer_last_name as customer_name, 
c.customer_email, c.customer_phone_number, k.kitchen_name
FROM Orders o
JOIN Customers c ON c.customer_id = o.order_customer_id
JOIN Kitchen k ON o.order_kitchen_id = k.kitchen_id
Where o.order_quantity > 3

SELECT * FROM orders_more_than

---6. Kitchen known for? (Customer POV)
CREATE PROCEDURE kitch_info (
    @k_id INT
) as BEGIN
        DECLARE @kitch_n VARCHAR (25)
        DECLARE @kitch_dn VARCHAR (25)
        DECLARE @kitch_ad VARCHAR (50)
            SELECT
                @kitch_n = kitchen_name,
                @kitch_dn =  kitchen_dish_name,
                @kitch_ad = kitchen_address
            from Kitchen
            WHERE @k_id = kitchen_id
        PRINT @kitch_n + ' is known for ' + @kitch_dn + ' and is at ' + @kitch_ad
    END

EXEC kitch_info
    @k_id = 3
GO




