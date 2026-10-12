
-- Select the project database
USE olist_ecommerce;

-- Table 1: Orders
CREATE TABLE olist_orders_dataset (
    order_id VARCHAR(36) PRIMARY KEY,
    customer_id VARCHAR(36) NOT NULL,
    order_status VARCHAR(30),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME
);

-- Table 2: Order items
CREATE TABLE olist_order_items_dataset (
    order_id VARCHAR(36) NOT NULL,
    order_item_id INT NOT NULL,
    product_id VARCHAR(36) NOT NULL,
    seller_id VARCHAR(36),
    shipping_limit_date DATETIME,
    price DECIMAL(10,2),
    freight_value DECIMAL(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

-- Table 3: Products
CREATE TABLE olist_products_dataset (
    product_id VARCHAR(36) PRIMARY KEY,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- Table 4: Customers
CREATE TABLE olist_customers_dataset (
    customer_id VARCHAR(36) PRIMARY KEY,
    customer_unique_id VARCHAR(36),
    customer_zip_code_prefix VARCHAR(10),
    customer_city VARCHAR(100),
    customer_state CHAR(2)
);

-- Table 5: English category translations
CREATE TABLE product_category_name_translation (
    product_category_name VARCHAR(100) PRIMARY KEY,
    product_category_name_english VARCHAR(100)
);

-- Verify the tables
SHOW TABLES;
