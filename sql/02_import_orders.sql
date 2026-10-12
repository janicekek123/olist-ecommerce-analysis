
USE olist_ecommerce;

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_orders_dataset.csv'
INTO TABLE olist_orders_dataset
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    @order_id,
    @customer_id,
    @order_status,
    @purchase_timestamp,
    @approved_at,
    @carrier_date,
    @delivered_date,
    @estimated_date
)
SET
    order_id = @order_id,
    customer_id = @customer_id,
    order_status = @order_status,
    order_purchase_timestamp = NULLIF(@purchase_timestamp, ''),
    order_approved_at = NULLIF(@approved_at, ''),
    order_delivered_carrier_date = NULLIF(@carrier_date, ''),
    order_delivered_customer_date = NULLIF(@delivered_date, ''),
    order_estimated_delivery_date = NULLIF(@estimated_date, '');

-- Check the number of imported orders
SELECT COUNT(*) AS total_orders
FROM olist_orders_dataset;


-- Step 2: Import order items
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_order_items_dataset.csv'
INTO TABLE olist_order_items_dataset
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    order_id,
    order_item_id,
    product_id,
    seller_id,
    @shipping_limit_date,
    price,
    freight_value
)
SET
    shipping_limit_date = NULLIF(@shipping_limit_date, '');

-- Check the number of imported rows
SELECT COUNT(*) AS total_order_items
FROM olist_order_items_dataset;


-- Step 3: Import products
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_products_dataset.csv'
INTO TABLE olist_products_dataset
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_id,
    @product_category_name,
    @product_name_lenght,
    @product_description_lenght,
    @product_photos_qty,
    @product_weight_g,
    @product_length_cm,
    @product_height_cm,
    @product_width_cm
)
SET
    product_category_name = NULLIF(@product_category_name, ''),
    product_name_lenght = NULLIF(@product_name_lenght, ''),
    product_description_lenght = NULLIF(@product_description_lenght, ''),
    product_photos_qty = NULLIF(@product_photos_qty, ''),
    product_weight_g = NULLIF(@product_weight_g, ''),
    product_length_cm = NULLIF(@product_length_cm, ''),
    product_height_cm = NULLIF(@product_height_cm, ''),
    product_width_cm = NULLIF(@product_width_cm, '');

-- Check imported products
SELECT COUNT(*) AS total_products
FROM olist_products_dataset;


-- Step 4: Import customers
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/olist_customers_dataset.csv'
INTO TABLE olist_customers_dataset
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    customer_id,
    customer_unique_id,
    @customer_zip_code_prefix,
    customer_city,
    customer_state
)
SET
    customer_zip_code_prefix =
        NULLIF(@customer_zip_code_prefix, '');

-- Check imported customers
SELECT COUNT(*) AS total_customers
FROM olist_customers_dataset;


-- Step 5: Import English category translations
LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    product_category_name,
    product_category_name_english
);

-- Check imported translations
SELECT COUNT(*) AS total_translations
FROM product_category_name_translation;
