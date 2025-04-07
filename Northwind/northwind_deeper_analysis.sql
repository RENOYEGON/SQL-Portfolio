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

--Is too much spent  on shipping?
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


--2️⃣ Best and Worst Selling Products
--To identify the best and worst-selling products, we need to analyze total sales volume and revenue.
--Approach:
--best-selling products:
SELECT 
    p.Product_ID, 
        p.Product_Name, 
        SUM(od.Quantity) AS TotalUnitsSold, 
        ROUND(SUM(od.Quantity * od.Unit_Price * (1 - od.Discount)), 2) AS TotalRevenue
FROM Order_Details od
JOIN Products p ON od.Product_ID = p.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY TotalRevenue DESC
LIMIT 5;

--worst-selling products:
SELECT 
    p.Product_ID, 
    p.Product_Name, 
    SUM(od.Quantity) AS TotalUnitsSold, 
    ROUND(SUM(od.Quantity * od.Unit_Price * (1 - od.Discount)) ,2)AS TotalRevenue
FROM Order_Details od
JOIN Products p ON od.Product_ID = p.Product_ID
GROUP BY p.Product_ID, p.Product_Name
ORDER BY TotalRevenue ASC
LIMIT 5;

--Discount Impact on Sales

--To analyze the impact of discounts on sales, we can calculate the average discount percentage and its correlation with total sales.
--Approach:

SELECT 
    CASE 
        WHEN od.Discount > 0 THEN 'Discounted Sales'
        ELSE 'Non-Discounted Sales'
    END AS SaleType,
    COUNT(DISTINCT o.Order_ID) AS NumberOfOrders,
    SUM(od.Quantity) AS TotalUnitsSold,
    SUM(od.Quantity * od.Unit_Price) AS GrossRevenue,
    SUM(od.Quantity * od.Unit_Price * (1 - od.Discount)) AS NetRevenue,
    (SUM(od.Quantity * od.Unit_Price * (1 - od.Discount)) / 
     SUM(od.Quantity * od.Unit_Price)) * 100 AS RevenueRetentionPercentage
FROM Order_Details od
JOIN Orders o ON od.Order_ID = o.Order_ID
GROUP BY SaleType;

--Are Discontinued Products Still Selling Well?

WITH SalesData AS (
    SELECT 
        p.Product_ID, 
        p.Product_Name, 
        p.Discontinued, 
        YEAR(o.Order_Date) AS OrderYear,
        MONTH(o.Order_Date) AS OrderMonth,
        SUM(od.Quantity) AS TotalUnitsSold,
        SUM(od.Quantity * od.Unit_Price * (1 - od.Discount)) AS TotalRevenue
    FROM Order_Details od
    JOIN Orders o ON od.Order_ID = o.Order_ID
    JOIN Products p ON od.Product_ID = p.Product_ID
    GROUP BY p.Product_ID, p.Product_Name, p.Discontinued, YEAR(o.Order_Date), MONTH(o.Order_Date)
)
SELECT 
    OrderYear,
    OrderMonth,
    Discontinued,
    COUNT(DISTINCT Product_ID) AS NumberOfProducts,
    SUM(TotalUnitsSold) AS TotalUnitsSold,
    SUM(TotalRevenue) AS TotalRevenue
FROM SalesData
GROUP BY OrderYear, OrderMonth, Discontinued
ORDER BY OrderYear DESC, OrderMonth DESC, Discontinued;

3️⃣ Key Customers & profitability
--To identify key customers, we can analyze total sales volume and revenue by customer.
--Top Customers by Profitability (Not Just Revenue)
--Some customers buy a lot but receive heavy discounts, reducing profitability.

SELECT 
    c.Customer_ID,
    c.Company_Name,
    ROUND(SUM(od.Quantity * od.Unit_Price),2) AS GrossRevenue,
    ROUND(SUM(od.Quantity * od.Unit_Price * (1 - od.Discount)),2) AS NetRevenue,
    ROUND(SUM(od.Quantity * od.Unit_Price * (1 - od.Discount)) / SUM(od.Quantity * od.Unit_Price) * 100,2) AS ProfitabilityRatiopercentage
FROM Customers c
JOIN Orders o ON c.Customer_ID = o.Customer_ID
JOIN Order_Details od ON o.Order_ID = od.Order_ID
GROUP BY c.Customer_ID, c.Company_Name
ORDER BY NetRevenue DESC
LIMIT 10;








