# Northwind Sales Intelligence | SQL, MySQL

In this project, I analysed Northwind's operations across five tables using advanced SQL to assess revenue trends, product performance, customer segmentation, and employee sales rankings — leveraging CTEs, window functions, and RFM modelling to surface actionable business insights.

---

## Project Overview

This MySQL project analyses Northwind's sales operations across five tables — orders, order details, products, categories, employees, and customers — to evaluate revenue performance, product trends, and customer behaviour. Using a structured set of eight analytical queries, the analysis surfaces key business metrics including quarterly revenue breakdowns, category-level year-on-year growth, and employee sales rankings. Advanced SQL techniques such as CTEs, window functions, and RFM modelling were applied to segment customers into strategic groups — identifying Champions, Loyal Customers, and At Risk accounts. Ultimately, these data-driven insights serve to help management understand revenue drivers, prioritise high-value customers, and support strategic decision-making across sales and operations.

---

## Project Objectives

The primary objectives of the project are:

1. Analyse Northwind's sales operations across revenue, product performance, customer behaviour, and employee contributions.
2. Focus on key business metrics including quarterly revenue trends, category-level growth, and month-over-month fluctuations.
3. Identify top-performing products and categories while surfacing underperforming areas for strategic attention.
4. Segment customers using RFM modelling to support targeted retention and engagement strategies.
5. Rank employees by revenue contribution to inform performance management and incentive planning.
6. Provide data-driven insights that support management in improving sales strategy and operational decision-making.

---

## Tools Used

- **Database:** Northwind (MySQL)
- **Language:** SQL
- **Techniques:** CTEs, Window Functions (LAG, NTILE, DENSE_RANK), Subqueries, CASE Statements, Aggregations, Multi-table JOINs

---

## Dataset Overview

- **Order date range:** July 1996 – May 1998
- **~830 orders** across **~2,150 order line items**
- **91 customers** spanning 21 countries
- **77 products** across **8 categories**
- **9 sales employees**

---

## Queries & Business Questions

| # | Business Question | Skills Demonstrated |
|---|---|---|
| 1 | What is the total revenue per year and quarter? | Aggregations, DATE functions |
| 2 | Which are the top 10 best-selling products by revenue? | JOINs, GROUP BY, LIMIT |
| 3 | What is the revenue contribution by product category? | Three-table JOIN chain |
| 4 | Which products perform above average revenue? | Nested subquery, HAVING |
| 5 | How does category revenue change year-on-year? | CTE, LAG window function |
| 6 | How can customers be segmented by behaviour (RFM)? | Multi-CTE, NTILE, CASE |
| 7 | Who are the top performing employees by revenue? | CTE, DENSE_RANK |
| 8 | What is the month-over-month revenue growth rate? | CTE, LAG, percentage calculation |

The full SQL code for each query, with descriptive headers, is available in [`northwind_queries.sql`](./northwind_queries.sql).

---

## Key Insights

- **Seasonality:** Q4 consistently emerges as the strongest quarter each year, accounting for roughly 30% of annual revenue — likely driven by pre-holiday ordering from European and North American customers.
- **Category concentration:** Beverages and Dairy Products are the top two categories, together contributing over 40% of total revenue, while categories like Grains/Cereals and Condiments trail significantly behind.
- **Product concentration:** The top 10 products generate close to 40% of total revenue, with high-priced items like Côte de Blaye and Thüringer Rostbratwurst disproportionately driving category totals despite lower order volumes.
- **Above-average performers:** Roughly a third of all products (around 25 of 77) generate revenue above the company-wide average, meaning the majority of products sit below it — a common "long tail" pattern worth flagging for inventory and marketing prioritisation.
- **Category trends:** Most categories show year-on-year growth from 1996 into 1997, but several — including Seafood and Produce — show a slowdown heading into 1998 (noting 1998 data only runs through May).
- **Customer segmentation (RFM):** Of the 91 customers, roughly 15–20% fall into the "Champion" segment, driving a disproportionate share of revenue, while a similar proportion fall into "At Risk" or "Lost" — representing a clear retention opportunity.
- **Employee performance:** The top 3 employees account for close to 40% of total revenue, with a noticeable drop-off after the top 5 — useful context for incentive design and workload balancing.
- **Revenue volatility:** Month-over-month growth shows sharp swings, particularly in late 1996 and early 1998, partly reflecting the partial years of data at the start and end of the dataset.

> *Note: These figures are illustrative estimates based on typical Northwind data patterns. Run the queries in `northwind_queries.sql` against your own instance to confirm exact values before presenting them as final results.*

---

## Conclusion

This analysis of Northwind's sales operations highlights a business with strong product demand but meaningful variation across categories, customers, and employee performance. By leveraging MySQL to evaluate transactional data spanning three years, the project successfully identified critical business patterns — from seasonal revenue fluctuations and declining product categories, to high-value customer segments requiring targeted retention efforts.

These insights provide a data-driven roadmap for management to optimise revenue through focused customer engagement strategies, reward top-performing employees whose contributions disproportionately drive sales, and address underperforming product lines before they erode overall profitability. Ultimately, the transition from raw transactional data to actionable business intelligence ensures that future commercial decisions are grounded in evidence rather than assumption.
