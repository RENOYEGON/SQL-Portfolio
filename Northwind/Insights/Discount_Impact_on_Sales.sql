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

