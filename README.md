# Olist E-Commerce Sales Analysis

## Table of Contents

- [Project Overview](#project-overview)
- [Business Objectives](#business-objectives)
- [Tools and Technologies](#tools-and-technologies)
- [Dataset](#dataset)
- [Technical Implementation](#technical-implementation)
- [Executive Summary](#executive-summary)
- [Project Workflow](#project-workflow)
- [Author](#author)

## Project Overview

This project analyses the Brazilian E-Commerce Public Dataset by Olist to understand sales performance and identify useful business insights.

MySQL was used for data preparation, data quality checks, table joins, and sales analysis. Power BI Desktop was used to develop an interactive dashboard to present key performance indicators (KPIs) and explore sales trends across different business dimensions.

## Business Questions

1. What is the overall sales performance of the Olist e-commerce business?
2. How does total sales value change over time?
3. Which product categories generate the highest and lowest sales values?
4. How does average order value differ across product categories, and which categories have the highest and lowest average order values?
5. Which Brazilian states generate the highest and lowest sales values?

## Tools and Technologies

- **MySQL:** Data preparation, data quality checks, joins, aggregations, and sales analysis.
- **Power BI Desktop:** Data modelling, DAX measures, dashboard development, and visualisation.
- **GitHub:** Project documentation, SQL scripts, and version control.

## Dataset

**Source:** [Brazilian E-Commerce Public Dataset by Olist on Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

Five datasets were used in this project:

| Dataset                             | Purpose                                                             |
| ----------------------------------- | ------------------------------------------------------------------- |
| `olist_customers_dataset`           | Customer information, including customer IDs and geographic details |
| `olist_order_items_dataset`         | Order items, product IDs, item prices, and freight values           |
| `olist_orders_dataset`              | Order IDs, purchase dates, and order statuses                       |
| `olist_products_dataset`            | Product information and product category names                      |
| `product_category_name_translation` | Translates product category names from Portuguese into English      |

These datasets were joined using relevant identifiers to prepare the data for sales analysis.

## Technical Implementation

### 1. SQL Data Preparation and Analysis

MySQL was used to work with the relational dataset and prepare the data required for sales analysis.

Key tasks included:

- Exploring the available tables and checking the structure of the dataset.
- Joining related tables using common identifiers, such as order IDs, product IDs, and customer IDs.
- Filtering records to include delivered orders in the sales measures.
- Aggregating sales values by month, year, product category, and Brazilian state.
- Counting unique delivered orders separately from individual order items.
- Calculating average order value using total item sales value divided by delivered orders.
- Preparing query results to answer the business questions.

SQL techniques applied include:

- `SELECT` and `WHERE` for selecting and filtering records.
- `INNER JOIN` and other relevant joins to combine related tables.
- `GROUP BY` for summarising sales across different dimensions.
- `SUM()` and `COUNT()` for sales and item counts.
- `COUNT(DISTINCT ...)` for counting unique orders.
- `CASE WHEN` and date functions where required by the analysis.

### 2. Power BI Data Modelling and DAX

Power BI Desktop was used to develop the sales dashboard. The data tables were connected through relationships so that sales measures could be analysed by product category, purchase date, and customer state.

**Total Item Sales Value**

```dax
Total Item Sales Value =
CALCULATE(
    SUM('olist_ecommerce olist_order_items_dataset'[price]),
    'olist_ecommerce olist_orders_dataset'[order_status] = "delivered"
)
```

Calculates the total item price for delivered orders, excluding freight charges.

**Delivered Orders**

```dax
Delivered Orders =
CALCULATE(
    DISTINCTCOUNT('olist_ecommerce olist_orders_dataset'[order_id]),
    'olist_ecommerce olist_orders_dataset'[order_status] = "delivered"
)
```

Counts unique delivered orders rather than counting each product item as a separate order.

**Total Order Items**

```dax
Total Order Items =
CALCULATE(
    COUNTROWS('olist_ecommerce olist_order_items_dataset'),
    'olist_ecommerce olist_orders_dataset'[order_status] = "delivered"
)
```

Counts order-item records associated with delivered orders.

**Average Order Value**

```dax
Average Order Value =
DIVIDE(
    [Total Item Sales Value],
    [Delivered Orders]
)
```

Calculates average item sales value per delivered order. `DIVIDE()` handles division safely when the denominator is zero or blank.

Using reusable DAX measures allows the sales metrics to respond to report filters and slicers, subject to the configured model relationships.

### 3. Dashboard Development

The Power BI dashboard was designed to provide an overview of sales performance and allow users to explore results by different business dimensions.

The dashboard includes:

- **KPI cards:** Total Item Sales Value, Delivered Orders, Total Order Items, and Average Order Value.
- **Product category slicer:** Allows users to filter relevant visuals by category.
- **Monthly sales chart:** Examines changes in sales over time.
- **Yearly sales chart:** Compares sales values across years.
- **Product category chart:** Compares sales contributions across categories.
- **Geographic map:** Displays sales distribution across Brazilian states.

The dashboard combines summary KPIs with detailed charts to help users move from an overall view of performance to specific sales patterns.

## Executive Summary

This project analyses the Brazilian E-Commerce Public Dataset by Olist to evaluate sales performance, identify high-performing product categories, and explore geographic sales distribution from 2016 to 2018. MySQL was used for data preparation and sales analysis, while Power BI Desktop was used to develop an interactive dashboard.

### Overview of Findings

#### Sales Insights

The initial SQL analysis recorded **R$13.22 million in total item sales value** across **96,478 delivered orders** and **110,197 order items**, with an average order value of **R$137.04**. These metrics provide a baseline overview of sales performance during the period covered by the dataset.

At the product category level, **Health & Beauty** generated the highest item sales value at approximately **R$1.23 million**, followed by **Watches & Gifts** at R$1.17 million and **Bed Bath Table** at R$1.02 million. The top five categories collectively contributed approximately **39.83% of total item sales value**, indicating that these categories represented a substantial share of the platform's sales.

The dashboard also enables users to explore monthly sales patterns and compare sales distribution across Brazilian states. Further investigation of sales by year, order volume, average order value across categories, and geographic performance could help explain the factors behind the observed results.

The reported sales figures represent item prices for delivered orders and exclude freight charges. They measure sales value rather than profit, as product costs and profit margins were not included in the calculations.

### Business Recommendations

**1. Strengthen the performance of leading categories.** Health & Beauty, Watches & Gifts, and Bed Bath Table recorded the highest item sales values. The business could review product availability, customer demand, and marketing performance in these categories to identify opportunities to maintain or improve sales.

**2. Investigate lower-performing product categories.** Compare categories with lower sales values to determine whether performance differences are associated with order volume, item prices, or customer demand before deciding whether changes to promotions or product offerings are appropriate.

**3. Monitor order value and order volume together.** Track average order value alongside delivered order counts and total item sales value to distinguish changes associated with order volume from changes in spending per order.

**4. Explore geographic sales opportunities.** Use the state-level sales map to identify regions with relatively high or low sales contributions. Combine these findings with customer counts, order volumes, and marketing costs before deciding where to focus promotional activities.

**5. Investigate monthly and yearly sales patterns.** Compare sales across months and years to identify potential seasonality and changes in performance. Validate recurring patterns before using them to guide inventory planning or promotional timing.

These recommendations are proposed areas for further investigation. Additional data and analysis would be needed to validate the opportunities and assess their potential business impact.

### Interactive Power BI Dashboard



The interactive Power BI dashboard combines summary metrics, category comparisons, and geographic visualisation to make sales performance easier to explore. The dashboard file can be downloaded [here](https://drive.google.com/file/d/1S9vMOBnVeD-Jqpp__08A2FAXToGaAEJm/view?usp=sharing).

Download the `.pbix` file and open it in Power BI Desktop to explore the interactive report. Access depends on the Google Drive sharing settings.

## Project Workflow

1. Create the database tables in MySQL.
2. Import the five datasets.
3. Perform data quality checks.
4. Join relevant tables and analyse sales performance using SQL.
5. Create data relationships and DAX measures in Power BI.
6. Develop an interactive dashboard.
7. Interpret the findings and propose business recommendations.
8. Document the project and publish the code and dashboard preview on GitHub.

## Author

**Janice Kek Kai Lin**

## Disclaimer

This project was created for educational and portfolio purposes. The analysis is based on the publicly available Brazilian E-Commerce Public Dataset by Olist and is intended to demonstrate the application of SQL, data analysis, and business intelligence techniques. The findings and recommendations are for illustrative purposes and should not be considered professional business or financial advice.
