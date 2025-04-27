-- 1️⃣ Total Sales Revenue
--Question: How much revenue is generated over time?
--Approach:
--Compute the total revenue as SUM(unit_price * quantity * (1 - discount)) from order_details.
--Aggregate by month and year
SELECT 
    YEAR(o.order_date) AS order_year,
    MONTH(o.order_date) AS order_month,
    SUM(od.unit_price * od.quantity * (1 - od.discount)) AS total_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY order_year,order_month
ORDER BY order_year, order_month DESC;
