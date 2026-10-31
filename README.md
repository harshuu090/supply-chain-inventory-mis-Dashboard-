# Supply Chain & Inventory Control MIS Dashboard

An end-to-end MIS (Management Information System) dashboard built with **MySQL** and **Power BI Desktop**. It analyzes order fulfillment, inventory, backorders, warehouse utilization, supplier performance, and transportation/COGS costs, so that management can quickly see what is happening, where the problems are, and where to act.

---

## Business Problem

Supply chain data usually sits in database tables, and managers cannot easily see how operations are performing. This project turns that data into a 4-page interactive report that answers:

- How many units were sold, and how accurate and timely are orders?
- What is the backorder rate, and where is it highest?
- Which warehouses and categories hold the most stock?
- Which suppliers perform better or worse?
- How do COGS, transportation cost, and lead time move over time?

---

## Tech Stack

| Tool | Purpose |
|---|---|
| MySQL 8.0 | Data storage and reporting views |
| MySQL Workbench | Querying and data validation |
| Power BI Desktop | Data modeling, DAX, dashboard design |
| DAX | Calculated column (`Month Date`) |

---

## Data Model

Database: `supply_chain_mis` (connected to Power BI in Import mode)

| View | Grain | Used for |
|---|---|---|
| `vw_inventory_exceptions` | One row per order/inventory record (500 records) | Order status, inventory by category, backorders by region, exceptions table |
| `vw_monthly_mis` | One row per month | KPI cards and monthly trends |
| `vw_supplier_scorecard` | One row per supplier (4 suppliers) | Supplier comparison |
| `vw_warehouse_mis` | One row per warehouse (3 warehouses) | Capacity utilization, inventory, backorder rate |

**Calculated column:** `Month Date` was created from the text field `report_month` so that trend charts show a proper date axis.

```
Month Date = DATE(VALUE(LEFT([report_month], 4)), VALUE(MID([report_month], 6, 2)), 1)
```

**Aggregation choices:** percentage and average fields (order accuracy, backorder rate, lead time) use **Average**, not Sum. Pre-aggregated monthly values are not summed across the wrong grain.

---

## Dashboard Pages

### 1. Executive Overview
KPI cards: Total Units Sold, Total COGS, Total Transportation Cost, Order Accuracy %, Backorder Rate %, Average Lead Time (Days).
Charts: Monthly Units Sold Trend, Order Status Distribution, Inventory Level by Category, Backorders by Region.

### 2. Inventory & Warehouse
Capacity Utilization by Warehouse, Average Inventory Level by Warehouse, Backorder Rate % by Warehouse, and an Inventory Exceptions table sorted by backorder count.

### 3. Supplier Performance
Backorder Rate %, Order Accuracy % and Average Lead Time by supplier, plus a Supplier Scorecard table.

### 4. Cost & Efficiency
Monthly trends of Transportation Cost, Total COGS, Backorder Rate % and Average Lead Time.

---

## Key Results

| KPI | Value |
|---|---|
| Total Units Sold | 6,40,671 |
| Total COGS | 7,12,44,576 |
| Total Transportation Cost | 92,68,222 |
| Order Accuracy | 91.9% |
| Backorder Rate | 8.9% |
| Average Lead Time | 15.4 days |

---

## Key Insights

1. **Half of all orders are Pending.** Of 500 orders, 248 (49.6%) are Pending, 138 (27.6%) Fulfilled and 114 (22.8%) Canceled. The large pending share is a fulfillment concern.
2. **Supplier A is the most reliable; Supplier D needs attention.** Supplier A has the lowest backorder rate (7.1%), the lowest lead time (15.2 days) and the best accuracy (92.3%). Supplier D has the highest backorder rate (12.2%). Supplier C has the lowest order accuracy (89.5%).

| Supplier | Avg Lead Time (Days) | Backorder Rate % | Order Accuracy % |
|---|---|---|---|
| A | 15.2 | 7.1 | 92.3 |
| B | 16.2 | 10.3 | 91.9 |
| C | 15.5 | 9.1 | 89.5 |
| D | 16.0 | 12.2 | 91.4 |

3. **Warehouse 1 has the highest backorder rate (about 11%)**, while Warehouse 3 has the lowest (about 8.5%). Stock levels are similar across warehouses (about 2,480 to 2,615 units on average), and capacity utilization is about 35 to 37%.
4. **Backorders are highest in the North region** (35 backorders), followed by South and West (29 each) and East (23). 116 backorders in total.
5. **Clothing holds the most inventory** (about 0.35M units) and Accessories the least (about 0.28M).
6. **Backorder rate was volatile in 2022 to 2023** (peaking near 29%) and more stable in 2024. Average lead time also rose from roughly 9 to 10 days in early 2020 to about 15 to 18 days after 2022. These move together, but this does not prove that one causes the other.

---

## Data Limitation

The monthly view only contains data for **2020-11, 2021-12, and every month from 2022-01 onward**. The months in between are missing from the database, so the trend lines connect across the gap. Trends should be read from **2022 onward**. A note is shown on the Cost & Efficiency page.

---

## How to Run

1. Install MySQL and create the `supply_chain_mis` database with the four views listed above.
2. Open `Supply_Chain_Inventory_MIS.pbix` in Power BI Desktop.
3. If asked, update the data source: `localhost:3306` / `supply_chain_mis`, then click **Refresh**.

---

## Repository Structure

```
├── README.md
├── Supply_Chain_Inventory_MIS.pbix
├── screenshots/
│   ├── 01_executive_overview.png
│   ├── 02_inventory_warehouse.png
│   ├── 03_supplier_performance.png
│   └── 04_cost_efficiency.png
└── sql/            
```

## Dashboard Preview

![Executive Overview](screenshots/01_executive_overview.png)
![Inventory & Warehouse](screenshots/02_inventory_warehouse.png)
![Supplier Performance](screenshots/03_supplier_performance.png)
![Cost & Efficiency](screenshots/04_cost_efficiency.png)

---

## What I Learned

- Connecting Power BI to MySQL and choosing the right aggregation for each field.
- Checking the grain of each view to avoid double counting.
- Creating a date column with DAX so trend charts sort correctly.
- Validating data in SQL and spotting a data gap rather than reporting it as a real drop.
- Designing a consistent, management-style dashboard.

## Author

**Your Name**
LinkedIn: add your link | GitHub: add your link
