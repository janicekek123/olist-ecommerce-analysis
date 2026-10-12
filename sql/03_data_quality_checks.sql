
-- Olist E-commerce Sales Analysis
-- Step 1: Confirm row counts for all five tables

USE olist_ecommerce;

SELECT 'Orders' AS dataset, COUNT(*) AS total_rows
FROM olist_orders_dataset

UNION ALL

SELECT 'Order Items', COUNT(*)
FROM olist_order_items_dataset

UNION ALL

SELECT 'Products', COUNT(*)
FROM olist_products_dataset

UNION ALL

SELECT 'Customers', COUNT(*)
FROM olist_customers_dataset

UNION ALL

SELECT 'Category Translations', COUNT(*)
FROM product_category_name_translation;


-- Step 2: Check duplicate primary keys

-- 1. Orders: order_id should be unique
SELECT
    order_id,
    COUNT(*) AS occurrences
FROM olist_orders_dataset
GROUP BY order_id
HAVING COUNT(*) > 1;

-- 2. Order items: order_id + order_item_id should be unique
SELECT
    order_id,
    order_item_id,
    COUNT(*) AS occurrences
FROM olist_order_items_dataset
GROUP BY order_id, order_item_id
HAVING COUNT(*) > 1;

-- 3. Products: product_id should be unique
SELECT
    product_id,
    COUNT(*) AS occurrences
FROM olist_products_dataset
GROUP BY product_id
HAVING COUNT(*) > 1;

-- 4. Customers: customer_id should be unique
SELECT
    customer_id,
    COUNT(*) AS occurrences
FROM olist_customers_dataset
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- 5. Category translations: category name should be unique
SELECT
    product_category_name,
    COUNT(*) AS occurrences
FROM product_category_name_translation
GROUP BY product_category_name
HAVING COUNT(*) > 1;


-- Step 3: Check missing values in important columns

SELECT
    'Orders' AS dataset,
    SUM(order_id IS NULL) AS missing_order_id,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(order_purchase_timestamp IS NULL) AS missing_purchase_date
FROM olist_orders_dataset

UNION ALL

SELECT
    'Order Items',
    SUM(order_id IS NULL),
    SUM(product_id IS NULL),
    SUM(price IS NULL)
FROM olist_order_items_dataset

UNION ALL

SELECT
    'Products',
    SUM(product_id IS NULL),
    SUM(product_category_name IS NULL),
    NULL
FROM olist_products_dataset

UNION ALL

SELECT
    'Customers',
    SUM(customer_id IS NULL),
    SUM(customer_state IS NULL),
    NULL
FROM olist_customers_dataset;


-- Step 4: Investigate missing product categories

SELECT
    COUNT(*) AS total_products,
    SUM(product_category_name IS NULL) AS missing_categories,
    SUM(product_category_name = '') AS blank_categories
FROM olist_products_dataset;

-- Check whether products with missing categories have sales records
SELECT
    COUNT(DISTINCT p.product_id) AS missing_category_products,
    COUNT(DISTINCT oi.product_id) AS missing_category_products_with_sales,
    COUNT(*) AS order_item_rows,
    ROUND(SUM(oi.price), 2) AS sales_revenue
FROM olist_products_dataset AS p
LEFT JOIN olist_order_items_dataset AS oi
    ON p.product_id = oi.product_id
WHERE p.product_category_name IS NULL
   OR p.product_category_name = '';


-- Step 5: Check category translation coverage

SELECT
    COALESCE(p.product_category_name, 'Unknown') AS category_name,
    COUNT(DISTINCT p.product_id) AS total_products
FROM olist_products_dataset AS p
LEFT JOIN product_category_name_translation AS t
    ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IS NULL
   OR t.product_category_name IS NULL
GROUP BY COALESCE(p.product_category_name, 'Unknown')
ORDER BY total_products DESC;


-- Step 6: Inspect categories without English translations

SELECT
    product_category_name,
    COUNT(*) AS total_products
FROM olist_products_dataset
WHERE product_category_name IN (
    'portateis_cozinha_e_preparadores_de_alimentos',
    'pc_gamer'
)
GROUP BY product_category_name;


-- Step 7: Check order statuses

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;

-- Check purchase date range
SELECT
    MIN(order_purchase_timestamp) AS first_purchase_date,
    MAX(order_purchase_timestamp) AS last_purchase_date,
    SUM(order_purchase_timestamp IS NULL) AS missing_purchase_dates
FROM olist_orders_dataset;


-- Step 8: Count orders by status

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM olist_orders_dataset
GROUP BY order_status
ORDER BY total_orders DESC;


-- Step 9: Check order-item relationships

SELECT
    COUNT(*) AS total_order_items,
    SUM(o.order_id IS NOT NULL) AS items_with_matching_orders,
    SUM(o.order_id IS NULL) AS items_without_matching_orders
FROM olist_order_items_dataset AS oi
LEFT JOIN olist_orders_dataset AS o
    ON oi.order_id = o.order_id;
    
    
-- Step 10: Check whether order items match products

SELECT
    COUNT(*) AS total_order_items,
    SUM(p.product_id IS NOT NULL) AS items_with_matching_products,
    SUM(p.product_id IS NULL) AS items_without_matching_products
FROM olist_order_items_dataset AS oi
LEFT JOIN olist_products_dataset AS p
    ON oi.product_id = p.product_id;

-- Step 11: Check whether orders match customers

SELECT
    COUNT(*) AS total_orders,
    SUM(c.customer_id IS NOT NULL) AS orders_with_matching_customers,
    SUM(c.customer_id IS NULL) AS orders_without_matching_customers
FROM olist_orders_dataset AS o
LEFT JOIN olist_customers_dataset AS c
    ON o.customer_id = c.customer_id;

