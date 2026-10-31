<!-- Animated header banner -->
<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:283C18,100:626F3B&height=220&section=header&text=Supply%20Chain%20%26%20Inventory%20Control&fontSize=42&fontColor=ffffff&animation=fadeIn&fontAlignY=38&desc=MIS%20Dashboard%20using%20MySQL%20%2B%20Power%20BI&descSize=20&descAlignY=60" width="100%" alt="Header banner"/>

<!-- Typing animation -->
<a href="https://git.io/typing-svg">
  <img src="https://readme-typing-svg.demolab.com?font=Segoe+UI&weight=600&size=22&duration=3000&pause=1000&color=626F3B&center=true&vCenter=true&width=700&lines=Track+orders%2C+inventory+%26+backorders;Compare+suppliers+and+warehouses;Turn+SQL+data+into+business+decisions" alt="Typing animation"/>
</a>

<br/>

![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Power BI](https://img.shields.io/badge/Power%20BI-Desktop-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![DAX](https://img.shields.io/badge/DAX-Calculated%20Column-283C18?style=for-the-badge)
![Pages](https://img.shields.io/badge/Report%20Pages-4-626F3B?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)

</div>

---

## 📌 Table of Contents

- [Business Problem](#-business-problem)
- [Tech Stack](#-tech-stack)
- [Data Model](#-data-model)
- [Dashboard Pages](#-dashboard-pages)
- [Key Results](#-key-results)
- [Key Insights](#-key-insights)
- [Data Limitation](#-data-limitation)
- [How to Run](#-how-to-run)
- [Repository Structure](#-repository-structure)
- [What I Learned](#-what-i-learned)

---

## 🎯 Business Problem

Supply chain data usually sits in database tables, and managers cannot easily see how operations are performing. This project turns that data into a **4-page interactive Power BI report** that answers:

| # | Question |
|---|---|
| 1 | How many units were sold, and how accurate and timely are orders? |
| 2 | What is the backorder rate, and where is it highest? |
| 3 | Which warehouses and categories hold the most stock? |
| 4 | Which suppliers perform better or worse? |
| 5 | How do COGS, transportation cost, and lead time move over time? |

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| 🐬 MySQL 8.0 | Data storage and reporting views |
| 🔎 MySQL Workbench | Querying and data validation |
| 📊 Power BI Desktop | Data modeling and dashboard design |
| 🧮 DAX | Calculated column (`Month Date`) |

---

## 🗂️ Data Model

Database: `supply_chain_mis` (Power BI Import mode)

| View | Grain | Used for |
|---|---|---|
| `vw_inventory_exceptions` | One row per order/inventory record (500 records) | Order status, inventory by category, backorders by region, exceptions table |
| `vw_monthly_mis` | One row per month | KPI cards and monthly trends |
| `vw_supplier_scorecard` | One row per supplier (4 suppliers) | Supplier comparison |
| `vw_warehouse_mis` | One row per warehouse (3 warehouses) | Capacity utilization, inventory, backorder rate |

**Calculated column:** `Month Date` converts the text field `report_month` into a real date so trend charts sort correctly.

```dax
Month Date = DATE(VALUE(LEFT([report_month], 4)), VALUE(MID([report_month], 6, 2)), 1)
```

> 💡 **Aggregation choice:** percentage and average fields (order accuracy, backorder rate, lead time) use **Average**, not Sum, to avoid wrong totals.

---

## 📊 Dashboard Pages

| Page | What it shows |
|---|---|
| **1. Executive Overview** | 6 KPI cards, Monthly Units Sold Trend, Order Status Distribution, Inventory Level by Category, Backorders by Region |
| **2. Inventory & Warehouse** | Capacity Utilization, Average Inventory Level, Backorder Rate by warehouse, Inventory Exceptions table |
| **3. Supplier Performance** | Backorder Rate, Order Accuracy and Lead Time by supplier, Supplier Scorecard |
| **4. Cost & Efficiency** | Monthly trends of Transportation Cost, COGS, Backorder Rate and Lead Time |

### 🖼️ Preview

<div align="center">

**Executive Overview**

<img src="screenshots/01_executive_overview.png" width="90%" alt="Executive Overview"/>

**Inventory & Warehouse**

<img src="screenshots/02_inventory_warehouse.png" width="90%" alt="Inventory and Warehouse"/>

**Supplier Performance**

<img src="screenshots/03_supplier_performance.png" width="90%" alt="Supplier Performance"/>

**Cost & Efficiency**

<img src="screenshots/04_cost_efficiency.png" width="90%" alt="Cost and Efficiency"/>

</div>

---

## 🏆 Key Results

| KPI | Value |
|---|---|
| 📦 Total Units Sold | **6,40,671** |
| 💰 Total COGS | **7,12,44,576** |
| 🚚 Total Transportation Cost | **92,68,222** |
| ✅ Order Accuracy | **91.9%** |
| ⚠️ Backorder Rate | **8.9%** |
| ⏱️ Average Lead Time | **15.4 days** |

---

## 💡 Key Insights

1. **Half of all orders are Pending.** Of 500 orders, 248 (49.6%) are Pending, 138 (27.6%) Fulfilled and 114 (22.8%) Canceled. The large pending share is a fulfillment concern.
2. **Supplier A is the most reliable; Supplier D needs attention.** Supplier A has the lowest backorder rate (7.1%), the lowest lead time (15.2 days) and the best accuracy (92.3%). Supplier D has the highest backorder rate (12.2%). Supplier C has the lowest order accuracy (89.5%).

| Supplier | Avg Lead Time (Days) | Backorder Rate % | Order Accuracy % |
|---|---|---|---|
| A | 15.2 | 7.1 | 92.3 |
| B | 16.2 | 10.3 | 91.9 |
| C | 15.5 | 9.1 | 89.5 |
| D | 16.0 | 12.2 | 91.4 |

3. **Warehouse 1 has the highest backorder rate (about 11%)**, while Warehouse 3 has the lowest (about 8.5%). Stock levels are similar across warehouses (about 2,480 to 2,615 units on average), and capacity utilization is about 35 to 37%.
4. **Backorders are highest in the North region** (35), followed by South and West (29 each) and East (23). 116 backorders in total.
5. **Clothing holds the most inventory** (about 0.35M units) and Accessories the least (about 0.28M).
6. **Backorder rate was volatile in 2022 to 2023** (peaking near 29%) and more stable in 2024. Average lead time also rose from roughly 9 to 10 days in early 2020 to about 15 to 18 days after 2022. These move together, but this does not prove that one causes the other.

---

## ⚠️ Data Limitation

The monthly view only contains data for **2020-11, 2021-12, and every month from 2022-01 onward**. The months in between are missing from the database, so trend lines connect across the gap. Trends should be read from **2022 onward**. A note is shown on the Cost & Efficiency page.

---

## ▶️ How to Run

1. Install MySQL and create the `supply_chain_mis` database with the four views listed above.
2. Open `Supply_Chain_Inventory_MIS.pbix` in Power BI Desktop.
3. If asked, update the data source (`localhost:3306` / `supply_chain_mis`) and click **Refresh**.

---

## 📁 Repository Structure

```
├── README.md
├── Supply_Chain_Inventory_MIS.pbix
├── screenshots/
│   ├── 01_executive_overview.png
│   ├── 02_inventory_warehouse.png
│   ├── 03_supplier_performance.png
│   └── 04_cost_efficiency.png
└── sql/            (optional: your table and view scripts)
```

---

## 🎓 What I Learned

- Connecting Power BI to MySQL and choosing the right aggregation for each field.
- Checking the grain of each view to avoid double counting.
- Creating a date column with DAX so trend charts sort correctly.
- Validating data in SQL and spotting a data gap instead of reporting it as a real drop.
- Designing a consistent, management-style dashboard.

---

## 👤 Author

HARSH KUSHWAH 
🔗 [LinkedIn](https://www.linkedin.com/in/harsh-kushwah-/) &nbsp;|&nbsp; 💻 [GitHub](https://github.com/your-username)

<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:626F3B,100:283C18&height=120&section=footer" width="100%" alt="Footer"/>

</div>
