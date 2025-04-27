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
