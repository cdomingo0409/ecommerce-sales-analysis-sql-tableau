-- Monthly Revenue Trend Over Time
-- How does montly revenue change over time?

/*
Purpose:

To analyze how montly revenue changes over time using transactional e-commerce data.
Why this approach?:
- SQLite stores date/time values as TEXT rather than a native DATA type.
- The strftime function is used to extract year and month from timestamps for time-based aggregation.
- Revenue is calculated at the item level to accrurately reflect multi-item orders.

Design choices:
- Orders and order_items are joined because purchase timestamps and prices reside in separate tables.
- Monthly grouping (YYYY-MM) provides a balance between trend visibility and data granularity.
- Partial months at the beginning and end of the dataset are excluded to avoid skewed results.
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


