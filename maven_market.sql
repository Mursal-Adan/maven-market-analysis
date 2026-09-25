-- Setting up  the database and Importing tables

CREATE DATABASE maven_market;
USE maven_market;

CREATE TABLE transactions_1997 (
    transaction_date DATE,
    stock_date DATE,
    product_id INT,
    customer_id INT,
    store_id INT,
    quantity INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/MavenMarket_Transactions_1997.csv'
INTO TABLE transactions_1997
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@transaction_date, @stock_date, product_id, customer_id, store_id, quantity)
SET
    transaction_date = STR_TO_DATE(@transaction_date, '%m/%d/%Y'),
    stock_date = STR_TO_DATE(@stock_date, '%m/%d/%Y');
    
CREATE TABLE transactions_1998 (
    transaction_date DATE,
    stock_date DATE,
    product_id INT,
    customer_id INT,
    store_id INT,
    quantity INT
);
    
SHOW VARIABLES LIKE 'secure_file_priv';
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/MavenMarket_Transactions_1998.csv'
INTO TABLE transactions_1998
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@transaction_date, @stock_date, product_id, customer_id, store_id, quantity)
SET
    transaction_date = STR_TO_DATE(@transaction_date, '%m/%d/%Y'),
    stock_date = STR_TO_DATE(@stock_date, '%m/%d/%Y');
    
    
CREATE TABLE calendar (
    calendar_date DATE
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/MavenMarket_Calendar.csv'
INTO TABLE calendar
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@calendar_date)
SET calendar_date = STR_TO_DATE(@calendar_date, '%m/%d/%Y');

-- Investigation

SHOW TABLES;

RENAME TABLE `returns_1997-1998` TO returns;

DESCRIBE customers;
DESCRIBE products;
DESCRIBE stores;
DESCRIBE regions;
DESCRIBE returns;
DESCRIBE calendar;
DESCRIBE transactions_1997;
DESCRIBE transactions_1998;

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM stores;
SELECT COUNT(*) FROM regions;
SELECT COUNT(*) FROM returns;
SELECT COUNT(*) FROM transactions_1997;
SELECT COUNT(*) FROM transactions_1998;
SELECT COUNT(*) FROM calendar;

SELECT 
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN birthdate IS NULL THEN 1 ELSE 0 END) AS null_birthdate,
    SUM(CASE WHEN yearly_income IS NULL THEN 1 ELSE 0 END) AS null_income,
    SUM(CASE WHEN gender IS NULL THEN 1 ELSE 0 END) AS null_gender
FROM customers;
SELECT 
    SUM(CASE WHEN recyclable IS NULL THEN 1 ELSE 0 END) AS null_recyclable,
    SUM(CASE WHEN low_fat IS NULL THEN 1 ELSE 0 END) AS null_low_fat,
    SUM(CASE WHEN product_retail_price IS NULL THEN 1 ELSE 0 END) AS null_price,
    SUM(CASE WHEN product_cost IS NULL THEN 1 ELSE 0 END) AS null_cost
FROM products;

SELECT recyclable, COUNT(*) 
FROM products 
GROUP BY recyclable;

SELECT low_fat, COUNT(*) 
FROM products 
GROUP BY low_fat;

SELECT marital_status, COUNT(*) 
FROM customers 
GROUP BY marital_status;

SELECT yearly_income, COUNT(*) 
FROM customers 
GROUP BY yearly_income
ORDER BY yearly_income;

SELECT education, COUNT(*) FROM customers GROUP BY education;
SELECT occupation, COUNT(*) FROM customers GROUP BY occupation;
SELECT member_card, COUNT(*) FROM customers GROUP BY member_card;
SELECT homeowner, COUNT(*) FROM customers GROUP BY homeowner;
SELECT COUNT(DISTINCT product_brand) FROM products;
SELECT product_brand, COUNT(*) FROM products GROUP BY product_brand ORDER BY COUNT(*) DESC LIMIT 15;

SELECT store_country, COUNT(*) FROM stores GROUP BY store_country;
SELECT store_type, COUNT(*) FROM stores GROUP BY store_type;

SELECT customer_id, product_id, store_id, transaction_date, quantity, COUNT(*)
FROM transactions_1997
GROUP BY customer_id, product_id, store_id, transaction_date, quantity
HAVING COUNT(*) > 1;

SELECT COUNT(*) FROM (
    SELECT customer_id, product_id, store_id, transaction_date, quantity
    FROM transactions_1997
    GROUP BY customer_id, product_id, store_id, transaction_date, quantity
    HAVING COUNT(*) > 1
) AS dupes;

SELECT COUNT(*) FROM (
    SELECT customer_id, product_id, store_id, transaction_date, quantity
    FROM transactions_1998
    GROUP BY customer_id, product_id, store_id, transaction_date, quantity
    HAVING COUNT(*) > 1
) AS dupes;

SELECT COUNT(*) 
FROM transactions_1997 t
LEFT JOIN customers c ON t.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) 
FROM transactions_1997 t
LEFT JOIN products p ON t.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) 
FROM transactions_1997 t
LEFT JOIN stores s ON t.store_id = s.store_id
WHERE s.store_id IS NULL;

SELECT COUNT(*) 
FROM transactions_1998 t
LEFT JOIN customers c ON t.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

SELECT COUNT(*) 
FROM transactions_1998 t
LEFT JOIN products p ON t.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) 
FROM transactions_1998 t
LEFT JOIN stores s ON t.store_id = s.store_id
WHERE s.store_id IS NULL;

SELECT COUNT(*) 
FROM returns r
LEFT JOIN products p ON r.product_id = p.product_id
WHERE p.product_id IS NULL;

SELECT COUNT(*) 
FROM returns r
LEFT JOIN stores s ON r.store_id = s.store_id
WHERE s.store_id IS NULL;

SELECT MIN(quantity), MAX(quantity), AVG(quantity) FROM transactions_1997;
SELECT MIN(quantity), MAX(quantity), AVG(quantity) FROM transactions_1998;

SELECT MIN(product_retail_price), MAX(product_retail_price), AVG(product_retail_price) FROM products;
SELECT MIN(product_cost), MAX(product_cost), AVG(product_cost) FROM products;

SELECT COUNT(*) 
FROM products 
WHERE product_cost >= product_retail_price;

SELECT customer_country, customer_postal_code
FROM customers
WHERE customer_country != 'USA'
LIMIT 10;

SELECT customer_country, MIN(LENGTH(customer_postal_code)), MAX(LENGTH(customer_postal_code))
FROM customers
GROUP BY customer_country;

SELECT MIN(transaction_date), MAX(transaction_date) FROM transactions_1997;
SELECT MIN(transaction_date), MAX(transaction_date) FROM transactions_1998;

SELECT COUNT(*) FROM transactions_1997 WHERE transaction_date < stock_date;
SELECT COUNT(*) FROM transactions_1998 WHERE transaction_date < stock_date;

-- Cleanig

SELECT COUNT(birthdate_new) FROM customers;
ALTER TABLE customers ADD COLUMN birthdate_new DATE;
UPDATE customers SET birthdate_new = STR_TO_DATE(birthdate, '%m/%d/%Y');
ALTER TABLE customers DROP COLUMN birthdate;
ALTER TABLE customers CHANGE birthdate_new birthdate DATE;

ALTER TABLE customers ADD COLUMN acct_open_date_new DATE;
UPDATE customers SET acct_open_date_new = STR_TO_DATE(acct_open_date, '%m/%d/%Y');
ALTER TABLE customers DROP COLUMN acct_open_date;
ALTER TABLE customers CHANGE acct_open_date_new acct_open_date DATE;

ALTER TABLE stores ADD COLUMN first_opened_date_new DATE;
UPDATE stores SET first_opened_date_new = STR_TO_DATE(first_opened_date, '%m/%d/%Y');
ALTER TABLE stores DROP COLUMN first_opened_date;
ALTER TABLE stores CHANGE first_opened_date_new first_opened_date DATE;

ALTER TABLE stores ADD COLUMN last_remodel_date_new DATE;
UPDATE stores SET last_remodel_date_new = STR_TO_DATE(last_remodel_date, '%m/%d/%Y');
ALTER TABLE stores DROP COLUMN last_remodel_date;
ALTER TABLE stores CHANGE last_remodel_date_new last_remodel_date DATE;

ALTER TABLE returns ADD COLUMN return_date_new DATE;
UPDATE returns SET return_date_new = STR_TO_DATE(return_date, '%m/%d/%Y');
ALTER TABLE returns DROP COLUMN return_date;
ALTER TABLE returns CHANGE return_date_new return_date DATE;

UPDATE products SET recyclable = 0 WHERE recyclable = '';
UPDATE products SET low_fat = 0 WHERE low_fat = '';
ALTER TABLE products MODIFY recyclable INT;
ALTER TABLE products MODIFY low_fat INT;

DESCRIBE customers;
SELECT recyclable, COUNT(*) FROM products GROUP BY recyclable;
DESCRIBE stores;
DESCRIBE returns;
SELECT low_fat, COUNT(*) FROM products GROUP BY low_fat;

-- Analysis

SELECT ROUND(SUM(revenue),2) AS total_revenue
FROM (
    SELECT t.quantity * p.product_retail_price AS revenue
    FROM transactions_1997 t
    JOIN products p ON t.product_id = p.product_id
    
    UNION ALL
    
    SELECT t.quantity * p.product_retail_price AS revenue
    FROM transactions_1998 t
    JOIN products p ON t.product_id = p.product_id
) AS combined;

CREATE VIEW revenue_by_store AS
SELECT store_name, ROUND(SUM(revenue), 2) AS total_revenue
FROM (
    SELECT s.store_name, t.quantity * p.product_retail_price AS revenue
    FROM transactions_1997 t
    JOIN products p ON t.product_id = p.product_id
    JOIN stores s ON t.store_id = s.store_id
    
    UNION ALL
    
    SELECT s.store_name, t.quantity * p.product_retail_price AS revenue
    FROM transactions_1998 t
    JOIN products p ON t.product_id = p.product_id
    JOIN stores s ON t.store_id = s.store_id
) AS combined
GROUP BY store_name
ORDER BY total_revenue ASC;

CREATE VIEW revenue_by_region AS
SELECT r.sales_region, 
       COUNT(DISTINCT s.store_id) AS store_count,
       ROUND(SUM(t.quantity * p.product_retail_price), 2) AS total_revenue
FROM (
    SELECT store_id, product_id, quantity FROM transactions_1997
    UNION ALL
    SELECT store_id, product_id, quantity FROM transactions_1998
) t
JOIN products p ON t.product_id = p.product_id
JOIN stores s ON t.store_id = s.store_id
JOIN regions r ON s.region_id = r.region_id
GROUP BY r.sales_region
ORDER BY total_revenue DESC;

CREATE VIEW top_products_revenue AS
SELECT p.product_name, 
       ROUND(SUM(t.quantity * p.product_retail_price), 2) AS total_revenue
FROM (
    SELECT  product_id, quantity FROM transactions_1997
    UNION ALL
    SELECT  product_id, quantity FROM transactions_1998
) t
JOIN products p ON t.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;

CREATE VIEW top_products_profit AS
SELECT p.product_name, 
       ROUND(SUM((p.product_retail_price - p.product_cost) * t.quantity), 2) AS total_profit
FROM (
    SELECT  product_id, quantity FROM transactions_1997
    UNION ALL
    SELECT  product_id, quantity FROM transactions_1998
) t
JOIN products p ON t.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_profit DESC
LIMIT 10;

CREATE VIEW product_return_rate AS
SELECT 
    p.product_name,
    sold.total_sold,
    returned.total_returned,
    ROUND(returned.total_returned / sold.total_sold * 100, 2) AS return_rate_pct
FROM products p
JOIN (
    SELECT product_id, SUM(quantity) AS total_sold
    FROM (
        SELECT product_id, quantity FROM transactions_1997
        UNION ALL
        SELECT product_id, quantity FROM transactions_1998
    ) t
    GROUP BY product_id
) sold ON p.product_id = sold.product_id
JOIN (
    SELECT product_id, SUM(quantity) AS total_returned
    FROM returns
    GROUP BY product_id
) returned ON p.product_id = returned.product_id
ORDER BY return_rate_pct DESC
LIMIT 10;

CREATE VIEW revenue_by_country AS
SELECT s.store_country,
       ROUND(SUM(t.quantity * p.product_retail_price), 2) AS total_revenue
FROM (
    SELECT store_id, product_id, quantity FROM transactions_1997
    UNION ALL
    SELECT store_id, product_id, quantity FROM transactions_1998
) t
JOIN products p ON t.product_id = p.product_id
JOIN stores s ON t.store_id = s.store_id
GROUP BY s.store_country
ORDER BY total_revenue DESC;

CREATE VIEW revenue_by_income AS
SELECT c.yearly_income,
ROUND(SUM(t.quantity * p.product_retail_price),2) as total_revenue
FROM ( SELECT product_id, customer_id, quantity FROM transactions_1997
UNION ALL
SELECT product_id, customer_id, quantity FROM transactions_1998
) t
JOIN products p ON t.product_id = p.product_id
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.yearly_income
ORDER BY total_revenue DESC;

CREATE VIEW revenue_by_member_card AS
SELECT c.member_card,
ROUND(SUM(t.quantity * p.product_retail_price),2) as total_revenue
FROM ( SELECT product_id, customer_id, quantity FROM transactions_1997
UNION ALL
SELECT product_id, customer_id, quantity FROM transactions_1998
) t
JOIN products p ON t.product_id = p.product_id
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.member_card
ORDER BY total_revenue DESC;

SHOW FULL TABLES WHERE table_type = 'VIEW';

CREATE USER 'powerbi_user'@'localhost' IDENTIFIED BY 'LPOlpo(00)';
GRANT ALL PRIVILEGES ON maven_market.* TO 'powerbi_user'@'localhost';
FLUSH PRIVILEGES;

SELECT user, host, plugin FROM mysql.user WHERE user = 'powerbi_user';

DROP USER 'powerbi_user'@'localhost';
CREATE USER 'powerbi_user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'LPOlpo(00)';
GRANT ALL PRIVILEGES ON maven_market.* TO 'powerbi_user'@'localhost';
FLUSH PRIVILEGES;