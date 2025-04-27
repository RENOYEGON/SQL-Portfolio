-- Is too much spent  on shipping?
-- we need to compare freight costs relative to total revenue over time

WITH RevenueData AS (
    SELECT 
        o.Order_ID,
        SUM(od.Unit_Price * od.Quantity * (1 - od.Discount)) AS TotalRevenue,
        o.Freight,
        o.Order_Date
    FROM Orders o
    JOIN Order_Details od ON o.Order_ID = od.Order_ID
    GROUP BY o.Order_ID, o.Freight, o.Order_Date
)
SELECT 
    YEAR(Order_Date) AS Year,
    MONTH(Order_Date) AS Month,
    SUM(TotalRevenue) AS MonthlyRevenue,
    SUM(Freight) AS MonthlyFreightCost,
    (SUM(Freight) / SUM(TotalRevenue)) * 100 AS FreightPercentage
FROM RevenueData
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Year, Month;


SELECT 
    YEAR(o.Order_Date) AS Year,
    MONTH(o.Order_Date) AS Month
FROM orders o
GROUP BY YEAR(o.Order_Date), MONTH(o.Order_Date)
ORDER BY Year, Month;
SELECT 
    YEAR(o.Order_Date) AS Year,
    MONTH(o.Order_Date) AS Month,
    COUNT(o.Order_ID) AS TotalOrders,
    SUM(od.Quantity) AS TotalQuantity
FROM Orders o
JOIN Order_Details od ON o.Order_ID = od.Order_ID
GROUP BY YEAR(o.Order_Date), MONTH(o.Order_Date)
ORDER BY Year, Month;
JOIN Order_Details od ON o.Order_ID = od.Order_ID;

--Is shipping getting more expensive over time?
-- we need to compare freight costs relative to total revenue over time

WITH RevenueData AS ( 
    SELECT 
        YEAR(o.Order_Date) AS Year,
        MONTH(o.Order_Date) AS Month,
        SUM(od.Unit_Price * od.Quantity * (1 - od.Discount)) AS TotalRevenue,
        SUM(o.Freight) AS TotalFreight,
        (SUM(o.Freight) / SUM(od.Unit_Price * od.Quantity * (1 - od.Discount))) * 100 AS FreightPercentage
    FROM Orders o
    JOIN Order_Details od ON o.Order_ID = od.Order_ID
    GROUP BY YEAR(o.Order_Date), MONTH(o.Order_Date)
),
FreightTrend AS (
    SELECT 
        Year,
        Month,
        TotalRevenue,
        TotalFreight,
        FreightPercentage,
        LAG(FreightPercentage) OVER (PARTITION BY Year ORDER BY Month) AS PrevMonthFreightPercentage
    FROM RevenueData
)
SELECT 
    Year,
    Month,
    TotalRevenue,
    TotalFreight,
    FreightPercentage,
    -- % Change = Current Month Freight% - Previous Month Freight%
    CASE 
        WHEN PrevMonthFreightPercentage IS NOT NULL THEN 
            ROUND(FreightPercentage - PrevMonthFreightPercentage, 2)
        ELSE NULL 
    END AS Percentage_Change
FROM FreightTrend
ORDER BY Year, Month;
