USE magist123;

-- How many areas does Magist service in?

SELECT COUNT(seller_zip_code_prefix) FROM sellers;
SELECT COUNT(DISTINCT seller_id) FROM sellers;
-- Both give the same result

-- How many sellers are in which state?

SELECT DISTINCT state FROM geo;
SELECT city, COUNT(seller_id), state FROM geo 
JOIN sellers ON zip_code_prefix = seller_zip_code_prefix 
GROUP BY city, state;

-- How many Tech sellers are in which state?

SELECT city, COUNT(DISTINCT s.seller_id), state FROM geo 
JOIN sellers AS s ON zip_code_prefix = seller_zip_code_prefix
JOIN order_items USING (seller_id)
JOIN products USING (product_id)
JOIN product_category_name_translation USING (product_category_name)
WHERE product_category_name_english LIKE ('%electronic%')
OR product_category_name_english LIKE ('%technolog%')
OR product_category_name_english LIKE ('%computer%')
OR product_category_name_english LIKE ('%software%')
OR product_category_name_english LIKE ('%information%')
OR product_category_name_english LIKE ('%tele%')
OR product_category_name_english LIKE ('%audio%')
OR product_category_name_english LIKE ('%tablet%')
OR product_category_name_english LIKE ('%game%')
GROUP BY city, state;

-- How many Tech sellers are there in total?

SELECT count(DISTINCT oi.seller_id)
FROM order_items AS oi
JOIN products AS p ON oi.product_id=p.product_id
JOIN product_category_name_translation AS pcnt ON p.product_category_name=pcnt.product_category_name
WHERE product_category_name_english LIKE ('%electronic%')
OR product_category_name_english LIKE ('%technolog%')
OR product_category_name_english LIKE ('%computer%')
OR product_category_name_english LIKE ('%software%')
OR product_category_name_english LIKE ('%information%')
OR product_category_name_english LIKE ('%tele%')
OR product_category_name_english LIKE ('%audio%')
OR product_category_name_english LIKE ('%tablet%')
OR product_category_name_english LIKE ('%game%');

-- Give a list of all Tech sellers per ID Number

SELECT DISTINCT oi.seller_id FROM order_items AS oi
JOIN products AS p ON oi.product_id=p.product_id
JOIN product_category_name_translation AS pcnt ON p.product_category_name=pcnt.product_category_name
WHERE product_category_name_english LIKE ('%electronic%')
OR product_category_name_english LIKE ('%technolog%')
OR product_category_name_english LIKE ('%computer%')
OR product_category_name_english LIKE ('%software%')
OR product_category_name_english LIKE ('%information%')
OR product_category_name_english LIKE ('%tele%')
OR product_category_name_english LIKE ('%audio%')
OR product_category_name_english LIKE ('%tablet%')
OR product_category_name_english LIKE ('%game%');

-- All order count

SELECT COUNT(order_id) FROM orders; -- 99441

-- All Tech order count

SELECT COUNT(order_id) FROM orders
JOIN order_items AS oi USING(order_id)
JOIN products AS p ON oi.product_id=p.product_id
JOIN product_category_name_translation AS pcnt ON p.product_category_name=pcnt.product_category_name
WHERE product_category_name_english LIKE ('%electronic%')
OR product_category_name_english LIKE ('%technolog%')
OR product_category_name_english LIKE ('%computer%')
OR product_category_name_english LIKE ('%software%')
OR product_category_name_english LIKE ('%information%')
OR product_category_name_english LIKE ('%tele%')
OR product_category_name_english LIKE ('%audio%')
OR product_category_name_english LIKE ('%tablet%')
OR product_category_name_english LIKE ('%game%'); -- 17199

-- Percentage of all Tech orders

Select 17199/99441; -- 17.3%

-- What is most often being sold in curitiba(Potential positive statistic)?

SELECT city, s.seller_id, state, product_category_name_english FROM geo 
JOIN sellers AS s ON zip_code_prefix = seller_zip_code_prefix 
JOIN order_items USING (seller_id)
JOIN products USING (product_id)
JOIN product_category_name_translation USING (product_category_name)
WHERE city = "curitiba";

-- Insight Curitiba has most sellers in the sport or furniture category.

-- How many order were delayed?

SELECT 
CASE 
	WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) <= 0 THEN "delivered on time"
    ELSE "delayed"
    END AS delivery_status,
    COUNT(order_id)
FROM orders
GROUP BY delivery_status;

-- Average costumer satisfaction per city

SELECT state, city, AVG(review_score), COUNT(review_score) FROM order_reviews
JOIN orders USING (order_id) JOIN customers USING(customer_id) JOIN geo ON customer_zip_code_prefix = zip_code_prefix
GROUP BY state, city;

-- Average customer score per area with amount of Orders

SELECT state, AVG(review_score), COUNT(review_score) FROM order_reviews 
JOIN orders USING (order_id) JOIN customers USING(customer_id) JOIN geo ON customer_zip_code_prefix = zip_code_prefix
JOIN sellers ON zip_code_prefix = seller_zip_code_prefix JOIN order_items USING (seller_id) 
JOIN products USING (product_id) JOIN product_category_name_translation USING (product_category_name)
WHERE product_category_name_english LIKE ('%electronic%')
OR product_category_name_english LIKE ('%technolog%')
OR product_category_name_english LIKE ('%computer%')
OR product_category_name_english LIKE ('%software%')
OR product_category_name_english LIKE ('%information%')
OR product_category_name_english LIKE ('%tele%')
OR product_category_name_english LIKE ('%audio%')
OR product_category_name_english LIKE ('%tablet%')
OR product_category_name_english LIKE ('%game%')
GROUP BY state;

-- Average delivery time per city

SELECT AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS "Average delivery time", city, state FROM orders 
JOIN customers USING (customer_id) JOIN geo ON customer_zip_code_prefix = zip_code_prefix
WHERE order_status = "delivered"
GROUP BY city, state;

-- Average delivery time per state

SELECT AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) AS "Average delivery time", state FROM orders 
JOIN customers USING (customer_id) JOIN geo ON customer_zip_code_prefix = zip_code_prefix
WHERE order_status = "delivered"
GROUP BY state;

-- Price Preference in Tech products

SELECT 
	CASE 
    WHEN oi.price > 1000 THEN "Expensive"
    WHEN oi.price > 100 THEN "Medium"
    ELSE "Cheap"
    END AS price_range,
    COUNT(oi.product_id)
FROM order_items AS oi LEFT JOIN products AS p USING (product_id) LEFT JOIN product_category_name_translation AS p_eng USING (product_category_name)
WHERE product_category_name_english LIKE ('%electronic%')
OR product_category_name_english LIKE ('%technolog%')
OR product_category_name_english LIKE ('%computer%')
OR product_category_name_english LIKE ('%software%')
OR product_category_name_english LIKE ('%information%')
OR product_category_name_english LIKE ('%tele%')
OR product_category_name_english LIKE ('%audio%')
OR product_category_name_english LIKE ('%tablet%')
OR product_category_name_english LIKE ('%game%')
GROUP BY price_range;

-- Cheap 12305 = 71.5%
-- Medium 4686 = 27.3%
-- Expensive 208 = 1.2%
-- Sum = 17199 orders
