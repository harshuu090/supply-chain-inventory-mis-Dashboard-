# Data Dictionary — Supply Chain & Inventory MIS

Source file: `Inventory_SupplyChain_Dataset.csv`
Rows: 1,200 | Original columns: 15 | Missing values in source: 0
Date parsing: `DD-MM-YYYY` → ISO `YYYY-MM-DD`

| Field | Meaning | Type | Notes |
|---|---|---|---|
| date | Record date | Date | Parsed from day-month-year |
| region | Geographic region | Category | North, South, East, West |
| category | Product category | Category | Electronics, Clothing, Furniture, Accessories |
| supplier | Supplier label | Category | Supplier A–D |
| warehouse | Warehouse label | Category | Warehouse 1–3 |
| order_status | Order status | Category | Fulfilled, Pending, Canceled |
| units_sold | Units sold/recorded | Integer | Dataset does not specify SKU-level grain |
| inventory_level | Recorded inventory level | Integer | Snapshot-like field; grain needs confirmation |
| transportation_cost | Transportation cost | Decimal | Currency/unit not supplied |
| order_accuracy | Order accuracy flag | Boolean/0-1 | 1 = True |
| lead_time_days | Lead time in days | Integer | Actual vs planned definition not supplied |
| backorder | Backorder flag | Boolean/0-1 | 1 = True |
| cogs | Cost of goods sold | Decimal | Currency not supplied |
| average_inventory | Average inventory | Decimal | Period definition not supplied |
| warehouse_capacity | Warehouse capacity | Integer | Capacity unit not supplied |
| capacity_utilization_pct | inventory_level / warehouse_capacity * 100 | Derived % | Treat as estimated utilization |
| inventory_gap_vs_avg | inventory_level - average_inventory | Derived | Unit follows inventory fields |

## Important modeling limitations
- Each date appears once; the dataset has no SKU/Product ID and no explicit order ID.
- Supplier delivery performance can be summarized using available lead time and order accuracy, but on-time delivery cannot be calculated without promised and actual delivery dates.
- Reorder recommendations require a defensible demand-per-item history plus current stock and lead-time definition. Do not present a simulated reorder quantity as a real operational recommendation.
- Forecasting is not yet justified at product level because no product identifier or repeated item-level time series exists.
- Currency and units are not specified; show costs as dataset currency units unless confirmed.
