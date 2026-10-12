
-- Olist E-commerce Sales Analysis
-- Business Question 1: What is our baseline sales performance?

USE olist_ecommerce;

SELECT
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    COUNT(*) AS total_order_items,
    ROUND(SUM(oi.price), 2) AS total_item_sales_value,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM olist_orders_dataset AS o
INNER JOIN olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';


-- Business Question 2: How does sales value change monthly?

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS sales_month,
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    ROUND(SUM(oi.price), 2) AS monthly_sales_value,
    ROUND(
        SUM(oi.price) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM olist_orders_dataset AS o
INNER JOIN olist_order_items_dataset AS oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY sales_month;




-- Business Question 3:
-- How do all product categories rank by delivered-order item sales value,
-- and what percentage of total sales does each category contribute?

WITH category_sales AS (
    SELECT
        COALESCE(
            t.product_category_name_english,
            CASE
                WHEN p.product_category_name IS NULL
                     OR p.product_category_name = ''
                    THEN 'Unknown'
                WHEN p.product_category_name = 'pc_gamer'
                    THEN 'Gaming PCs'
                WHEN p.product_category_name =
                     'portateis_cozinha_e_preparadores_de_alimentos'
                    THEN 'Portable Kitchen Appliances'
                ELSE p.product_category_name
            END
        ) AS product_category,

        COUNT(DISTINCT o.order_id) AS delivered_orders,
        COUNT(*) AS order_item_count,
        SUM(oi.price) AS sales_value

    FROM olist_orders_dataset AS o

    INNER JOIN olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id

    INNER JOIN olist_products_dataset AS p
        ON oi.product_id = p.product_id

    LEFT JOIN product_category_name_translation AS t
        ON p.product_category_name = t.product_category_name

    WHERE o.order_status = 'delivered'

    GROUP BY product_category
),

category_sales_ranked AS (
    SELECT
        product_category,
        delivered_orders,
        order_item_count,
        sales_value,

        SUM(sales_value) OVER () AS total_sales,

        ROW_NUMBER() OVER (
            ORDER BY sales_value DESC, product_category
        ) AS sales_rank

    FROM category_sales
)

SELECT
    sales_rank,
    product_category,
    delivered_orders,
    order_item_count,
    ROUND(sales_value, 2) AS sales_value,
    ROUND(100 * sales_value / total_sales, 2) AS sales_percentage

FROM category_sales_ranked

ORDER BY sales_rank;


-- Business Question 4:
-- How do product categories rank by average sales value
-- per delivered order containing that category?

WITH category_sales AS (
    SELECT
        COALESCE(
            t.product_category_name_english,
            CASE
                WHEN p.product_category_name IS NULL
                     OR p.product_category_name = ''
                    THEN 'Unknown'
                WHEN p.product_category_name = 'pc_gamer'
                    THEN 'Gaming PCs'
                WHEN p.product_category_name =
                     'portateis_cozinha_e_preparadores_de_alimentos'
                    THEN 'Portable Kitchen Appliances'
                ELSE p.product_category_name
            END
        ) AS product_category,

        COUNT(DISTINCT o.order_id) AS orders_containing_category,
        COUNT(*) AS order_item_count,
        SUM(oi.price) AS sales_value

    FROM olist_orders_dataset AS o

    INNER JOIN olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id

    INNER JOIN olist_products_dataset AS p
        ON oi.product_id = p.product_id

    LEFT JOIN product_category_name_translation AS t
        ON p.product_category_name = t.product_category_name

    WHERE o.order_status = 'delivered'

    GROUP BY product_category
),

category_average AS (
    SELECT
        product_category,
        orders_containing_category,
        order_item_count,
        sales_value,

        sales_value / orders_containing_category
            AS average_sales_per_category_order

    FROM category_sales
)

SELECT
    ROW_NUMBER() OVER (
        ORDER BY average_sales_per_category_order DESC,
                 product_category
    ) AS average_sales_rank,

    product_category,
    orders_containing_category,
    order_item_count,
    ROUND(sales_value, 2) AS sales_value,
    ROUND(average_sales_per_category_order, 2)
        AS average_sales_per_category_order

FROM category_average

ORDER BY average_sales_rank;


-- Business Question 5:
-- Which Brazilian states generate the highest delivered-order item sales value,
-- and what percentage of total sales does each state contribute?

WITH state_sales AS (
    SELECT
        c.customer_state AS state,

        COUNT(DISTINCT o.order_id) AS delivered_orders,

        COUNT(*) AS order_item_count,

        SUM(oi.price) AS sales_value

    FROM olist_orders_dataset AS o

    INNER JOIN olist_order_items_dataset AS oi
        ON o.order_id = oi.order_id

    INNER JOIN olist_customers_dataset AS c
        ON o.customer_id = c.customer_id

    WHERE o.order_status = 'delivered'

    GROUP BY c.customer_state
),

state_sales_ranked AS (
    SELECT
        state,
        delivered_orders,
        order_item_count,
        sales_value,

        SUM(sales_value) OVER () AS total_sales,

        ROW_NUMBER() OVER (
            ORDER BY sales_value DESC, state
        ) AS sales_rank

    FROM state_sales
)

SELECT
    sales_rank,
    state,
    delivered_orders,
    order_item_count,
    ROUND(sales_value, 2) AS sales_value,
    ROUND(100 * sales_value / total_sales, 2) AS sales_percentage

FROM state_sales_ranked

ORDER BY sales_rank;
