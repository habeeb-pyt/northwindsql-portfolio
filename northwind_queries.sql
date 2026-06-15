-- ============================================================
-- NORTHWIND SALES INTELLIGENCE
-- A SQL Portfolio Project | MySQL
-- ============================================================


-- ============================================================
-- Query 1: Annual Revenue Breakdown by Quarter
-- Description: Calculates total discounted revenue per year
--              and quarter, ordered chronologically.
-- ============================================================

SELECT 
    YEAR(o.OrderDate) AS Year,
    QUARTER(o.OrderDate) AS Quarter,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS Revenue_After_Discount
FROM orderdetails AS od
JOIN orders AS o ON od.OrderID = o.OrderID
GROUP BY Year, Quarter
ORDER BY Year, Quarter;


-- ============================================================
-- Query 2: Top 10 Best-Selling Products by Revenue
-- Description: Ranks products by total discounted revenue,
--              returning the top 10 performers.
-- ============================================================

SELECT 
    p.ProductName,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS Revenue_After_Discount
FROM products AS p
JOIN orderdetails AS od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY Revenue_After_Discount DESC
LIMIT 10;


-- ============================================================
-- Query 3: Revenue by Product Category
-- Description: Calculates total discounted revenue per product
--              category, ranked highest to lowest.
-- ============================================================

SELECT 
    c.CategoryName,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS Revenue_After_Discount
FROM categories AS c
JOIN products AS p ON c.CategoryID = p.CategoryID
JOIN orderdetails AS od ON p.ProductID = od.ProductID
GROUP BY c.CategoryName
ORDER BY Revenue_After_Discount DESC;


-- ============================================================
-- Query 4: Products Performing Above Average Revenue
-- Description: Identifies products whose total discounted
--              revenue exceeds the average revenue per product.
--              Uses a nested subquery to calculate the average
--              of product totals rather than raw order rows.
-- ============================================================

SELECT 
    p.ProductName,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalRevenue
FROM products AS p
JOIN orderdetails AS od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
HAVING TotalRevenue > (
    SELECT AVG(Revenue_After_Discount)
    FROM (
        SELECT 
            SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS Revenue_After_Discount
        FROM orderdetails AS od
        JOIN products AS p ON od.ProductID = p.ProductID
        GROUP BY p.ProductName
    ) AS ProductTotals
)
ORDER BY TotalRevenue DESC;


-- ============================================================
-- Query 5: Year-on-Year Revenue Change by Category
-- Description: Uses a CTE to calculate yearly revenue per
--              category, then applies LAG() to compare each
--              year against the previous year's revenue.
-- ============================================================

WITH Yearly_Categorical_Rev AS (
    SELECT 
        YEAR(o.OrderDate) AS Year,
        c.CategoryName,
        ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalRevenue
    FROM orders AS o
    JOIN orderdetails AS od ON o.OrderID = od.OrderID
    JOIN products AS p ON od.ProductID = p.ProductID
    JOIN categories AS c ON p.CategoryID = c.CategoryID
    GROUP BY Year, c.CategoryName
)
SELECT 
    Year,
    CategoryName,
    TotalRevenue,
    LAG(TotalRevenue) OVER (PARTITION BY CategoryName ORDER BY Year) AS LastYearRev,
    ROUND(TotalRevenue - LAG(TotalRevenue) OVER (PARTITION BY CategoryName ORDER BY Year), 2) AS YearlyDifference
FROM Yearly_Categorical_Rev
ORDER BY Year, CategoryName;


-- ============================================================
-- Query 6: Customer Segmentation using RFM Analysis
-- Description: Segments customers into behavioural groups
--              based on Recency, Frequency, and Monetary value.
--              Uses NTILE(4) to score each dimension 1-4,
--              then applies business logic to assign segments.
-- ============================================================

WITH RFM_Base AS (
    SELECT 
        c.CustomerID, 
        c.CompanyName,
        DATEDIFF((SELECT MAX(OrderDate) FROM orders), MAX(o.OrderDate)) AS Recency,
        COUNT(DISTINCT od.OrderID) AS Frequency,
        ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS Monetary
    FROM customers AS c 
    JOIN orders AS o ON c.CustomerID = o.CustomerID
    JOIN orderdetails AS od ON o.OrderID = od.OrderID
    GROUP BY c.CustomerID, c.CompanyName
),
RFM_Scores AS (
    SELECT 
        CustomerID, 
        CompanyName,
        Recency, 
        Frequency, 
        Monetary,
        NTILE(4) OVER (ORDER BY Recency DESC) AS R_Score,
        NTILE(4) OVER (ORDER BY Frequency ASC) AS F_Score,
        NTILE(4) OVER (ORDER BY Monetary ASC) AS M_Score
    FROM RFM_Base
)
SELECT 
    CustomerID,
    CompanyName,
    R_Score,
    F_Score,
    M_Score,
    CASE
        WHEN R_Score = 4 AND F_Score = 4 AND M_Score = 4 THEN 'Champion'
        WHEN R_Score >= 3 AND F_Score >= 3 THEN 'Loyal Customer'
        WHEN R_Score >= 3 AND F_Score <= 2 THEN 'Potential Loyalist'
        WHEN R_Score <= 2 AND F_Score >= 3 THEN 'At Risk'
        WHEN R_Score = 1 AND F_Score = 1 THEN 'Lost'
        ELSE 'Needs Attention'
    END AS Segment
FROM RFM_Scores
ORDER BY R_Score DESC, F_Score DESC, M_Score DESC;


-- ============================================================
-- Query 7: Employee Sales Performance Ranking
-- Description: Ranks employees by total discounted revenue
--              using DENSE_RANK() to handle ties fairly.
-- ============================================================

WITH EmployeeRevenue AS (
    SELECT 
        e.EmployeeID,
        CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
        ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalRevenue
    FROM orderdetails AS od
    JOIN orders AS o ON od.OrderID = o.OrderID
    JOIN employees AS e ON o.EmployeeID = e.EmployeeID
    GROUP BY e.EmployeeID, e.FirstName, e.LastName
)
SELECT 
    DENSE_RANK() OVER (ORDER BY TotalRevenue DESC) AS PerformanceRank,
    EmployeeID,
    EmployeeName,
    TotalRevenue
FROM EmployeeRevenue
ORDER BY PerformanceRank ASC;


-- ============================================================
-- Query 8: Month-over-Month Revenue Growth
-- Description: Calculates monthly revenue and compares each
--              month against the previous using LAG(), then
--              computes the percentage growth rate.
-- ============================================================

WITH MonthlyRevenue AS (
    SELECT 
        MONTH(o.OrderDate) AS MonthNum,
        MONTHNAME(o.OrderDate) AS Month,
        YEAR(o.OrderDate) AS Year,
        ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS TotalRevenue
    FROM orderdetails AS od
    JOIN orders AS o ON od.OrderID = o.OrderID
    GROUP BY Year, Month, MonthNum
)
SELECT 
    Month,
    Year,
    TotalRevenue,
    LAG(TotalRevenue) OVER (ORDER BY Year, MonthNum) AS LastMonthRevenue,
    ROUND(((TotalRevenue - LAG(TotalRevenue) OVER (ORDER BY Year, MonthNum))
        / LAG(TotalRevenue) OVER (ORDER BY Year, MonthNum)) * 100, 2) AS MoM_Growth_Pct
FROM MonthlyRevenue
ORDER BY Year, MonthNum;
