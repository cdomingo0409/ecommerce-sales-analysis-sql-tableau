/* ============================================================
   MONTHLY REVENUE TREND
   Business Question:
   How does monthly revenue change over time?
   ============================================================ */
/*
Purpose:

To analyze how montly revenue changes over time using transactional e-commerce data.


Why this approach?:
- In SQLite, date and time are stored as TEXT rather than a native data type, so the strftime function is used to extract year and month for the time-based analysis.
- Revenue is calculated at the item level to ensure orders with multiple products are fully captured.

Design choices:
- The orders and order_items tables are joined because order dates and pricing detailes live in separate tables.
- Grouping by month (YYYY-MM) makes overall revenue trends easier to identify without losing too much detail.
- Partial months at the beginning and end of the dataset are excluded to avoid skewing the trend.
*/


SELECT
  strftime('%Y-%m', order_purchase_timestamp) AS month,
  ROUND(SUM(oi.price), 2) AS monthly_revenue
FROM orders o
JOIN order_items oi
  ON o.order_id = oi.order_id
WHERE order_purchase_timestamp IS NOT NULL
  AND order_purchase_timestamp <> ''
GROUP BY month
ORDER BY month;





/* ============================================================
   REVENUE BY PRODUCT CATEGORY
   Business Question:
   Which product categories generate the most revenue?
   ============================================================ */

/*
Purpose:

To identify which product categories generate the highest total revenue.


Why this approach?:
- Revenue is calculated at the item level to accurately reflect product-level sales.
- Categories are used to group revenue and highlight the main drivers of overall sales.
- COALESCE is used to handle missing or untranslated category values by providing a fallback to the original category name, ensuring no records are excluded from the analysis.

Design choices:
- Order items are joined to products to associate each sale with a category
- Orders are joined to apply consistent date filters across analyses.
- Grouping and ranking categories by total revenue helps surface highest performing categories.
- Partial monghts are excluded to keep results consistent.
*/


SELECT
COALESCE (c.product_category_name_english, p.product_category_name) AS category,
ROUND(SUM(oi.price), 2) as total_revenue
FROM order_items oi
JOIN orders o
ON oi.order_id = o.order_id
JOIN products p
ON oi.product_id = p.product_id
LEFT JOIN product_category c
ON p.product_category_name = c.product_category_name
WHERE o.order_purchase_timestamp >= '2017-01-01'
AND o.order_purchase_timestamp < '2018-09-01'
GROUP BY category
ORDER BY total_revenue DESC;





/*
Purpose:

Calculate Average Order Value (AOV) to understand how much revenue an order generates on average.


Why this approach:
- Revenue is calculated at the item level (order_items) because orders can contain multiple products.
- AOV is computed as total revenue divided by total number of distinct orders.

Design choices:
- COUNT(DISTINCT order_id) is used to avoid double counting orders with multiple items.
- The same date range is used as other analyses to keep the results consistent and avoid partial months.
*/


SELECT 
ROUND(SUM(oi.price)/COUNT(DISTINCT o.order_id),2) AS average_order_value
FROM orders o
JOIN order_items oi
ON o.order_id = oi.order_id
WHERE o.order_purchase_timestamp >= '2017-01-01'
AND o.order_purchase_timestamp < '2018-09-01';





/*
Purpose:

Identify which state (Brazil) place the highest number of orders.


Why this approach:
- Order count is used instead of revenue to understand demand volume by location.
- Customer location data is sourced from customers table
- Counting distinct orders ensures each order is only counted once, even if it contains multiple items.

Design choices:
- Orders are joined to customers table to associate each order with a customer's state.
- Results are grouped by state to compare geographic demand.
- The same date range is applied to remain consistent with other analyses and avoid partial months.
*/


SELECT
c.customer_state AS state,
COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN customers c
ON o.customer_id = c.customer_id
WHERE o.order_purchase_timestamp >= '2017-01-01'
AND o.order_purchase_timestamp <  '2018-09-01'
GROUP BY state
ORDER BY total_orders DESC;





/*
Purpose:

To identify which payment methods are most commonly used by customers.


Why this approach:
- Payment type distribution helps identify customer payment preferences.
- Counting distinct orders ensures each order is only counted once, even if it includes multiple payment records.
- Records with undfined payment types were excluded to focus the analysis on clearly identified customer payment behavior.

Design Choices:
- The order_payments table is joined to orders to connect payment information with purchase dates.
- DISTINCT order counts are used to avoid overcoutning orders split across multiple payment methods.
- Results are grouped by payment type to allow direct comparison.
- The same date range is applied to remain consistent with other analyses and avoid partial months.
*/


SELECT
p.payment_type,
COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
JOIN order_payments p
ON o.order_id = p.order_id
WHERE o.order_purchase_timestamp >= '2017-01-01'
AND o.order_purchase_timestamp <  '2018-09-01'
AND p.payment_type IS NOT NULL
AND p.payment_type <> 'not_defined'
GROUP BY p.payment_type
ORDER BY total_orders DESC;
