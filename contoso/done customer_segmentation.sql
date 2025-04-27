-- This SQL script performs customer segmentation using RFM (Recency, Frequency, Monetary) analysis.
WITH customer_metrics AS (
    SELECT
        customerkey,
        cleaned_name,
        MAX(orderdate) AS last_purchase_date,
        COUNT(num_orders) AS frequency,
        SUM(total_net_revenue) AS monetary
    FROM cohort_analysis
    GROUP BY
        customerkey,
        cleaned_name
),recency_calculation AS (
    SELECT
        cm.*,
        DATEDIFF(cm.last_purchase_date, cm.last_purchase_date) AS recency
    FROM customer_metrics cm
),
rfm_scores AS (
    SELECT
        customerkey,
        cleaned_name,
        recency,
        frequency,
        monetary,
        -- Recency Score: based on 30-day intervals
        CASE 
            WHEN recency <= 30 THEN 5
            WHEN recency <= 60 THEN 4
            WHEN recency <= 90 THEN 3
            WHEN recency <= 120 THEN 2
            ELSE 1
        END AS r_score,
        -- Frequency Score: assuming maximum 8 orders
        CASE 
            WHEN frequency >= 7 THEN 5
            WHEN frequency >= 6 THEN 4
            WHEN frequency >= 4 THEN 3
            WHEN frequency >= 2 THEN 2
            ELSE 1
        END AS f_score,
        -- Monetary Score: revenue up to 6498
        CASE 
            WHEN monetary >= 5000 THEN 5
            WHEN monetary >= 4000 THEN 4
            WHEN monetary >= 3000 THEN 3
            WHEN monetary >= 1500 THEN 2
            ELSE 1
        END AS m_score
    FROM recency_calculation
),
customer_segmentation AS (
    SELECT
        *,
        CASE
            WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN 'Champions'
            WHEN f_score >= 4 AND m_score >= 4 THEN 'Loyal Customers'
            WHEN r_score >= 4 AND f_score BETWEEN 2 AND 3 THEN 'Potential Loyalists'
            WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
            ELSE 'Lost'
        END AS customer_segment
    FROM rfm_scores
)
SELECT
    customer_segment,
    COUNT(customerkey) AS customer_count,
    SUM(monetary) AS total_revenue,
    ROUND(AVG(monetary), 2) AS avg_revenue_per_customer
FROM customer_segmentation
GROUP BY customer_segment
ORDER BY customer_segment DESC;


SELECT * FROM customer_segmentation;
