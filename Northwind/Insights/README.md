## Insights
### 1. Revenue trends over time

🖥️ Query: 1-[Total_Sales_Revenue.sql](https://github.com/RENOYEGON/SQL-Portfolio/blob/main/Northwind/Insights/Total_Sales_Revenue.sql)

📈 Visualization:

<img src="https://github.com/RENOYEGON/SQL-Portfolio/blob/main/Northwind/Insights/images/Revenue%20generation%20%20over%20time.png?raw=true" alt="Revenue trends over time" width="50%" />

- **Total Revenue**: The total revenue reached an impressive $1,265,793.04, reflecting significant financial performance.

- **Year-Over-Year Growth**: There has been rapid revenue growth year over year, signaling a robust upward trajectory in business performance.

- **Seasonal Trends**:
   - In **2022**, revenue began in July and grew consistently throughout the year.
   - In **2023**, notable peaks were observed in **October** ($66.7K) and **December** ($71.4K), highlighting key months for revenue generation.
   - In **2024**, the first quarter witnessed exceptionally high revenue, setting a strong pace for the year ahead.





   
### 2. Is too much spent on shipping?Is shipping getting more expensive??


🖥️ Query: 2-[too_much_spent_on_shipping.sql](https://github.com/RENOYEGON/SQL-Portfolio/blob/main/Northwind/Insights/too_much_spent_on_shipping.sql)

📈 Visualization:

<img src="https://github.com/RENOYEGON/SQL-Portfolio/blob/main/Northwind/Insights/images/freight%20percentage%20over%20time.png?raw=true" alt="freight" width="50%" />


- **Freight Cost Analysis**: The average freight percentage change is **-0.01455%**, indicating a minimal change in freight costs over time.

- **Revenue and Freight Proportions**: The average total revenue stands at **$9,073.31**, with freight accounting for **16.26%** of this total. This suggests that nearly **1/6 of the revenue** is allocated to covering shipping costs.

- **Freight Cost Trends**: Although shipping costs have slightly decreased over time, **freight remains a major cost driver**, significantly impacting profits. A notable spike occurred in **May 2023**, where freight percentage rose to **22.8%**, indicating a surge in shipping costs during this period.

- **Freight Changes**:
   - Freight cost has been on a rise steadily
   - In **January 2024**, total freight costs peaked at **$19,027.55**, driven by an increase in total orders and quantities.
   - Freight costs then dropped to **$10,451.08**, followed by another increase to **$20,186.53** in **April 2024**, again primarily influenced by higher order volumes and quantities.
 


### 3. Do Discounts Drive Sales?

🖥️ Query: 3-[Discount_Impact_on_Sales.sql](https://github.com/RENOYEGON/SQL-Portfolio/blob/main/Northwind/Insights/Discount_Impact_on_Sales.sql)

   - Yes – On a per-order basis, discounted sales moved more units (59.78 units/order) than non-discounted (46.65 units/order).
    - Customers are likely buying more when offered discounts.

- **Are We Losing Revenue?**
    - Also yes – You're only retaining **85.31%** of the potential revenue on discounted orders.

     - That’s a **14.69%** drop in revenue due to discounting.

  -**Total lost revenue from discounts:**
     **603,759.98 - 515,094.43 = 88,665.55**

- **Volume vs. Value Trade-off**
     - Even though discounts help sell more units, they:

     - Don’t make up for the loss in price per unit.
     - Result in lower average revenue per order than non-discounted sales.

- **Avg Net Revenue per Order:**

     - Discounted: **515,094.43 / 380 = $1,355.52**

     - Non-Discounted: **750,698.61 / 613 = $1,224.70**

     - Discounted orders have higher revenue per order, likely due to bulk buying. However, you're still making less per 
     unit.

### 4. Best and Worst selling products

- **Top-Selling Products**: 

  🖥️ Query: 4 - [Best and Worst Selling Products](https://github.com/RENOYEGON/SQL-Portfolio/blob/main/Northwind/Insights/Best_and_Worst_Selling_Products.sql)

  
  📈 Visualization:

  <img src="https://github.com/RENOYEGON/SQL-Portfolio/blob/main/Northwind/Insights/images/top%20selling.png?raw=true" alt="customers" width="70%" />

- The top-selling product contributes **11.17%** of total revenue, while the second-best seller accounts for **6.35%**. Together, these two products play a significant role in driving overall sales.

- **Top 5 Products**: 

  <img src="https://github.com/RENOYEGON/SQL-Portfolio/blob/main/Northwind/Insights/images/worst%20selling.png?raw=true" alt="customers" width="70%" />


- The **top 5 products** combined make up **30.57%** of total revenue, showing a strong concentration of sales in this small group of high-performing items.



- **Underperforming Products**: On the flip side, the **worst 5 products** contribute less than **1%** of total revenue, indicating that these items have minimal impact on the overall financial performance.


### 5. Are Discontinued Products Still Selling Well?


🖥️ Query: 5-[Discontinued_Products_Still_Selling_Well.sql](https://github.com/RENOYEGON/SQL-Portfolio/blob/main/Northwind/Insights/Discontinued_Products_Still_Selling_Well.sql)

📈 Visualization:

<img src="https://github.com/RENOYEGON/SQL-Portfolio/blob/main/Northwind/Insights/images/Discontinued%20vs.%20non-discontinued.png?raw=true" alt="customers" width="50%" />


  - Discontinued products consistently contribute fewer units and less revenue, roughly:

    **16%** of total units sold

    **17–20%** of total monthly revenue

  - So in terms of pure volume and revenue share, these items are not the biggest contributors.
     - There was a strong push and good sales momentum through **late 2022** into **early 2023**, followed by noticeable 
     decline in **May–June 2023**.
     - some products were still selling well before being discontinued, but by **mid-2023**, their performance declined, 
      which may have justified the discontinuation.   
     - Showed declining sales trends  
     - Had lower revenue per product  
     - Were consistently underperforming compared to active products  
     - discontinuing them was likely the right decision.
   




### 6. Top Customers by Profitability (Not Just Revenue)


🖥️ Query: 6-[Key_Customers_&_profitability.sql](https://github.com/RENOYEGON/SQL-Portfolio/blob/main/Northwind/Insights/Key_Customers_%26_profitability.sql)

📈 Visualization:

<img src="https://github.com/RENOYEGON/SQL-Portfolio/blob/main/Northwind/Insights/images/Top%20Customers%20by%20Profitability.png?raw=true" alt="customers" width="70%" />


- Some customers buy a lot but receive heavy discounts, reducing profitability.  
- Top Customers by Gross Revenue
The top 3 contribute over **$110,000+** in gross revenue.

- Discount Impact
 - While gross revenue is high, Net Revenue shows some customers are heavily discounted:

   - SAVEA lost **$11,300+** due to discounts (profitability **90.2%**)

    - HUNGO has the lowest profitability at **87.2%**, suggesting frequent deep discounts

    - MEREP is also under **90%**, a red flag for margin erosion

- High Profitability Customers
   - RATTC, KOENE, and HANAR have **96–98%** profitability, meaning they pay nearly full price with minimal discounting.

 - These are quietly valuable customers even though their gross revenue is lower.

 - What This Tells Us
   - High revenue customers aren't always the most profitable.

- Discounts are helping drive volume for SAVEA, HUNGO, and MEREP, but at the cost of margin.

- It’s worth revisiting pricing strategies and maybe reserving discounts for customers with high order frequency or strategic value




