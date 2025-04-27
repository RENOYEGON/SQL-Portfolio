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