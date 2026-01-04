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
- Revenue is calculated at the item level to accurately capture multi-item orders.
- Product categories are used to group sales and highlight primary revenue drivers.
- Aggregating by category helps identify areas for merchandising, inventory focus, and strategic invesment.
- COALESCE is used to handle missing or untranslated category values by providing a fallback to the original category name, ensuring no records are excluded from the analysis.

Design choices:
- Order items are joined to products to associate each sale with a category
- LEFT JOIN is used when applicable to prevent losing rows due to missing category mapping
- Revenue is grouped and ranked by category to surface top performing category.
- Partial months are exlcuded to ensure results reflect consistent sales activity.
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


