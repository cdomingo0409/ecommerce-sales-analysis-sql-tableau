💡 **Tip:** Read this section first for an overview of the project, business questions, and key insights.




## 🛒 E-Commerce Sales & Delivery Analysis Project

Overview:
Analyzed real-world e-commerce transaction data from a large online marketplace to understand sales performance, customer behavior, and delivery trends. The project focuses on answering business-driven questions using SQL and presenting insights through Tableau dashboards.

**Key Features:**

- Joined multiple relational tables to create a unified analytical dataset
- Analyzed monthly sales and revenue trends
- Identified top-performing product categories and geographic regions
- Calculated key business metrics such as total revenue and average order value (AOV)
- Examined delivery time patterns to highlight potential operational bottlenecks

**Tools Used:**
- PostgreSQL
- SQLiteStudio
- SQL
- Tableau




📊 Key Business Question: How Does Monthly Revenue Change Over Time?

Monthly revenue was calculated by aggregating item-level sales and grouping orders by purchase month. Because dates are stored as TEXT in SQLite, date functions were used to extract year and month values for time-based analysis. Partial months at the start and end of the dataset were excluded to provide a clearer view of overall revenue trends.


Key Insight:

Revenue increased steadily through 2017, peaked in late 2017 and early 2018, and then stabilized through mid-2018, suggesting a period of sustained sales growth followed by normalization.




🧺 Key Business Question: Which Product Categories Generate the Most Revenue?

To understand which products contributes most to overall sales, item-level revenue was aggregated by product category. Some categories contained missing or untranslated values, so a fallback strategy was applied to ensure all transactions wer included in the analysis.

Key Insight:

Revenue is concentrated among a small number of product categories, indicating that a limited set of product types drives a significant portion of total sales. Handling missing category values helped maintain a complete and accurate view of category performance.





💳 Key Business Question: What Is the Average Order Value (AOV)?

Average Order Value (AOV) was calculated by summing item level revenue and dividing by the number of distinct orders. This metric helps estimate how much value each order generates on average and provides a useful baseline for evaluating changes in customer spending over time.


Key Insight:

AOV provides context alonside revenue trends, higher revenue can come from more orders, higher value orders, or both. Tracking AOV over time helps separate changes in order volume from changes in customer spend per order. The AOV during the analyzed period was $137.68, providing baseline for understanding overall customer purchasing behavior.





🗺️ Key Business Question: Which States Place the Most Orders?

To understand geopgraphic demand, orders were linked to customer location data and aggregated by state. Distinct orders were counted to ensure demand volume was measured accurately without inflating results due to multiple item purchaes.


Key Insight:

A small number of states accounts for a large share of total orders, indicating concentrated demand in specific regions. These states represent key markets for customer acquisition, logistics planning, and targeted growth strategies.





**SQLite date functions and fallback logic were used throughout the analysis to account for text-based timestamps and incomplete category data.**




