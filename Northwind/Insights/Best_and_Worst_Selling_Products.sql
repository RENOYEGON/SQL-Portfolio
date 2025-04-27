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









