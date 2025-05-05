USE magist123;

-- 1. How many orders are there in the dataset?

SELECT COUNT(*) AS "Amount of Orders" FROM orders;
-- Answer: There are 99441 orders in the dataset.

-- 2. Are orders actually delivered?

SELECT order_status, COUNT(order_status) AS "Amount" FROM orders GROUP BY order_status;
-- Answer: 
-- Yes 96478 orders have already been delivered. 
-- 625 have been canceled. 
-- 609 are unavailable.

-- 3. Is Magist having user growth?

SELECT YEAR(order_purchase_timestamp) AS year_, MONTH(order_purchase_timestamp) AS month_, COUNT(*) FROM orders GROUP BY year_, month_;
-- Answer: Yes, Magist seems to be growing every year since they started in 2016.

-- 4. How many products are there on the products table?

SELECT DISTINCT product_id FROM products;
SELECT product_id FROM products;
-- Answer: There are 32951 products in the products table.

-- 5. Which are the categories with the most products?

SELECT product_category_name, COUNT(product_category_name) AS "Category Total" FROM products GROUP BY product_category_name ORDER BY COUNT(product_category_name) DESC;
-- Answer: Cama_mesa_banho (bed_bath_table)

-- 6. How many of those products were present in actual transactions?

SELECT count(DISTINCT product_id) FROM order_items;
SELECT product_id FROM products;
-- Answer: All of them were in transactions.

-- 7. What’s the price for the most expensive and cheapest products?

SELECT MAX(price) AS "Max price in €", MIN(price) AS "Min price in €" FROM order_items;
-- Answer: The most expensive product costs 6735€ and the least expensive product costs 0.85€.

-- 8. What are the highest and lowest payment values?

SELECT MAX(payment_value), MIN(payment_value) FROM order_payments;
SELECT payment_value FROM order_payments;

SELECT
    order_id, SUM(payment_value) AS highest_order
FROM
    order_payments
GROUP BY
    order_id
ORDER BY
    highest_order DESC
LIMIT
    1;
-- Answer: The highest payment value is 13664.1 and the lowest is 0 (or 0.01)

-- ------------------> Part 2.1 Products

-- 1. What categories of tech products does Magist have?

SELECT product_category_name_english, COUNT(product_category_name_english) from products LEFT JOIN product_category_name_translation USING (product_category_name)
WHERE product_category_name_english 
IN ("consoles_games", "electronics", "small_appliances", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony", "fixed_telephony")
GROUP BY product_category_name;

-- Answer: consoles_games, electronics, small_appliances, computers_accessories, pc_gamer, computers, tablets_printing_image, telephony, fixed_telephony

-- 2. How many products of these tech categories have been sold (within the time window of the database snapshot)? 
-- What percentage does that represent from the overall number of products sold?

SELECT COUNT(product_id) from products LEFT JOIN product_category_name_translation USING (product_category_name)
WHERE product_category_name_english 
IN ("consoles_games", "electronics", "small_appliances", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony", "fixed_telephony");

SELECT (3996/32951) * 100;

-- Answer: All have been sold. IT makes up 12% of all products sold.

-- 3. What’s the average price of the products being sold?

SELECT ROUND(AVG(price),2) FROM order_items;

-- Answer: 120.65

-- 4. Are expensive tech products popular? 

SELECT 
	CASE 
    WHEN oi.price > 1000 THEN "Expensive"
    WHEN oi.price > 100 THEN "Medium"
    ELSE "Cheap"
    END AS price_range,
    COUNT(oi.product_id)
FROM order_items AS oi LEFT JOIN products AS p USING (product_id) LEFT JOIN product_category_name_translation AS p_eng USING (product_category_name)
WHERE product_category_name_english 
IN ("consoles_games", "electronics", "small_appliances", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony", "fixed_telephony")
GROUP BY price_range;

-- Answer: Not really.

-- ------------------> Part 2.2 Sellers

-- 1. How many months of data are included in the magist database?

SELECT TIMESTAMPDIFF(MONTH, MIN(order_purchase_timestamp), MAX(order_purchase_timestamp)) AS "Months" FROM orders;

-- Answer:	25 Months are included in the database.

-- 2. How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?

SELECT COUNT(seller_id) FROM sellers;
SELECT COUNT(DISTINCT seller_id) FROM sellers AS s
JOIN order_items AS oi USING (seller_id)
JOIN products AS p USING (product_id)
JOIN product_category_name_translation AS p_eng USING (product_category_name)
WHERE product_category_name_english 
IN ("consoles_games", "electronics", "small_appliances", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony", "fixed_telephony");
SELECT (557/3095) * 100;

-- Answer: There are 3095 sellers overall. There are 557 tech sellers overall. Tech sellers make up about 18% of all sellers.

-- 3. What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?

SELECT order_status FROM orders GROUP BY order_status;

SELECT ROUND(SUM(price), 2) AS "Sum of Price" FROM order_items 
LEFT JOIN orders USING (order_id)
WHERE order_status NOT IN ("unavailable", "canceled");

-- 13 494 400.74

SELECT ROUND(SUM(oi.price), 2) AS "Sum of Price" FROM order_items AS oi
LEFT JOIN orders AS o USING (order_id) 
JOIN products AS p USING (product_id)
JOIN product_category_name_translation AS p_eng USING (product_category_name)
WHERE product_category_name_english 
IN ("consoles_games", "electronics", "small_appliances", "computers_accessories", "pc_gamer", "computers", "tablets_printing_image", "telephony", "fixed_telephony")
AND order_status NOT IN ("unavailable", "canceled");

-- 2 016 201.43

-- 4. Can you work out the average monthly income of all sellers? Can you work out the average monthly income of Tech sellers?

-- Average income per Seller
SELECT s.seller_id, AVG(price) AS "Sum of Price" FROM sellers AS s
JOIN geo AS g ON seller_zip_code_prefix = zip_code_prefix
JOIN customers As c ON zip_code_prefix = customer_zip_code_prefix
JOIN orders AS o USING(customer_id)
JOIN order_items As oi USING(order_id)
WHERE order_status NOT IN ("unavailable", "canceled")
GROUP BY s.seller_id;

-- ------------------> Part 2.2 Delivery Time

-- 1. What’s the average time between the order being placed and the product being delivered?

SELECT AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)) FROM orders WHERE order_status = "delivered";

-- Answer: An average delivery takes 12.5 days.

-- 2. How many orders are delivered on time vs orders delivered with a delay?

SELECT 
CASE 
	WHEN DATEDIFF(order_estimated_delivery_date, order_delivered_customer_date) <= 0 THEN "delivered on time"
    ELSE "delayed"
    END AS delivery_status,
    COUNT(order_id)
FROM orders
GROUP BY delivery_status;

-- Answer:	91441 were on time and 8000 were delayed

SELECT (8000/91441) * 100;

-- Answer: At least 8.7% of all deliverys are delayed. 
