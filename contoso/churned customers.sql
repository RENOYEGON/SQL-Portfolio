-- Step 1: Get the last purchase for each customer
WITH customer_last_purchase AS (
    SELECT
        customerkey,
        cleaned_name,
        orderdate,
        first_purchase_date,
        cohort_year,
        ROW_NUMBER() OVER (
            PARTITION BY customerkey 
            ORDER BY orderdate DESC
        ) AS rn
    FROM cohort_analysis
),

-- Step 2: Identify churned and active customers
churned_customers AS (
    SELECT
        clp.customerkey,
        clp.cleaned_name,
        clp.orderdate AS last_purchase_date,
        clp.cohort_year,
        CASE
            WHEN clp.orderdate < DATE_SUB((SELECT MAX(orderdate) FROM sales), INTERVAL 6 MONTH)
                THEN 'Churned'
            ELSE 'Active'
        END AS customer_status
    FROM customer_last_purchase clp
    WHERE clp.rn = 1
      AND clp.first_purchase_date < DATE_SUB((SELECT MAX(orderdate) FROM sales), INTERVAL 6 MONTH)
)

-- Step 3: Count churned and active customers by cohort
SELECT
    cohort_year,
    customer_status,
    COUNT(customerkey) AS num_customers,
    SUM(COUNT(customerkey)) OVER (PARTITION BY cohort_year) AS total_customers,
    ROUND(
        COUNT(customerkey) * 1.0 / SUM(COUNT(customerkey)) OVER (PARTITION BY cohort_year),
        2
    ) AS status_percentage
FROM churned_customers
GROUP BY cohort_year, customer_status
ORDER BY cohort_year, customer_status;
