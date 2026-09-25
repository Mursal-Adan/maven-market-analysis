# Maven Market Sales & Product Analysis

## Business Problem
Maven Market operates grocery stores across the USA, Canada, and Mexico. This project analyzes sales performance and profitability by store, region, product, and customer segment, and measures return rates to identify problem products — using SQL for data cleaning and analysis, and Power BI for visualization.

## Dataset
**Maven Market Datasets** — 8 related tables: Transactions (1997 & 1998, 269,720 rows combined), Customers (10,281), Products (1,560), Stores (24), Regions (109), Returns (7,087), Calendar.
Source: [Kaggle](https://www.kaggle.com/datasets/ukveteran/maven-market-datasets)

## Tools
MySQL (cleaning, analysis, views) · Power BI (visualization)

## Process
1. **Investigation** — checked structure, row counts, nulls, duplicates, referential integrity, and value consistency across all 8 tables using SQL.
2. **Cleaning** — converted 5 text-stored date columns to proper `DATE` type; standardized `recyclable` and `low_fat` product flags from blank/1 to 0/1.
3. **Analysis** — wrote SQL queries covering revenue and profit by store, region, country, product, income bracket, and membership tier, plus product return rates; saved each as a SQL View.
4. **Visualization** — connected Power BI directly to the MySQL views and built an 8-chart, 2-page dashboard.

## Key Findings
- Total revenue: **$1,764,546** | Total profit: **$1,052,819** (~60% margin)
- **North West** region leads with $848K (9 stores), far ahead of the next region
- **Store 13** is the top individual store ($170K); **Store 5** the weakest ($4.9K)
- **USA** generates ~67% of total revenue, more than 2x Mexico and 6x Canada
- Top revenue and top profit products only partly overlap — some high-revenue items have thin margins, and vice versa
- **Shady Lake Spaghetti** has the highest return rate (2.93%), though no top-seller shows a high return rate
- Revenue concentrates in the **$30K-$50K income bracket** (33%) and **Bronze membership tier** (56%) — likely reflecting group size, not necessarily higher individual spend

## Recommendations
- Investigate why Store 5 underperforms so heavily compared to peers in the same region
- Prioritize inventory and marketing support for North West, the strongest-performing region
- Use profit (not just revenue) rankings when deciding which products to promote
- Review sourcing or packaging for high-return products like Shady Lake Spaghetti
- Validate whether income/membership revenue concentration reflects group size or true spending behavior, using per-customer averages

## Dashboard
Two-page Power BI dashboard:
- **Products** — Total Revenue by Store, Top 10 Products by Revenue, Top 10 Products by Return Rate, Top 10 Products by Profit
- **Sales Overview** — Total Revenue by Country, by Income, by Member Card, by Region

## Files
- `maven_market.sql` — full SQL script: table creation, cleaning, analysis queries, and views
- `maven_market_dashboard.pbix` — Power BI dashboard
- `Visuals/` — dashboard screenshots

## Limitations
- `customer_postal_code` stored as integer in the source data, causing loss of leading zeros and Canadian letter-postal codes — not recoverable from this dataset
- Revenue by income bracket and membership tier reflects total group revenue, not average spend per customer, and may be influenced by group size
- Negligible transaction duplicates found (1 in 1997, 8 in 1998) — left as-is, not a systemic issue
