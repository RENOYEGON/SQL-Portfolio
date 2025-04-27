
-- This SQL script performs cohort analysis on the Contoso database to analyze customer behavior over time.
WITH initial_revenue AS (
    SELECT
        cohort_year,
        SUM(total_net_revenue) AS initial_revenue,
        COUNT(DISTINCT customerkey) AS total_customers
    FROM cohort_analysis
    WHERE orderdate = first_purchase_date
    GROUP BY cohort_year
),
lifetime_revenue AS (
    SELECT
        cohort_year,
        SUM(total_net_revenue) AS lifetime_revenue,
        COUNT(DISTINCT customerkey) AS total_customers
    FROM cohort_analysis
    GROUP BY cohort_year
)

SELECT 
    i.cohort_year,
    i.initial_revenue,
    l.lifetime_revenue,
    l.lifetime_revenue - i.initial_revenue AS repeat_revenue,
    ROUND(l.lifetime_revenue / l.total_customers, 2) AS avg_lifetime_per_customer,
    ROUND(i.initial_revenue / i.total_customers, 2) AS avg_initial_per_customer
FROM initial_revenue i
JOIN lifetime_revenue l ON i.cohort_year = l.cohort_year;

-- contribution of different cohorts over the years

SELECT cohort_year, YEAR(orderdate) AS revenue_year, SUM(total_net_revenue) AS yearly_revenue
FROM cohort_analysis
GROUP BY cohort_year, revenue_year
ORDER BY cohort_year, revenue_year;


