-- Supply Chain & Inventory Control MIS
-- MySQL 8+ starter schema. Load the cleaned CSV into this table.
CREATE DATABASE IF NOT EXISTS supply_chain_mis;
USE supply_chain_mis;

DROP TABLE IF EXISTS inventory_supplychain;
CREATE TABLE inventory_supplychain (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE NOT NULL,
    region VARCHAR(20) NOT NULL,
    category VARCHAR(30) NOT NULL,
    supplier VARCHAR(30) NOT NULL,
    warehouse VARCHAR(30) NOT NULL,
    order_status VARCHAR(20) NOT NULL,
    units_sold INT NOT NULL,
    inventory_level INT NOT NULL,
    transportation_cost DECIMAL(14,2) NOT NULL,
    order_accuracy TINYINT(1) NOT NULL,
    lead_time_days INT NOT NULL,
    backorder TINYINT(1) NOT NULL,
    cogs DECIMAL(16,2) NOT NULL,
    average_inventory DECIMAL(14,2) NOT NULL,
    warehouse_capacity INT NOT NULL,
    capacity_utilization_pct DECIMAL(7,2) NOT NULL,
    inventory_gap_vs_avg DECIMAL(14,2) NOT NULL
);

-- After importing the cleaned CSV, run the following reports.


-- 1) Executive KPI summary
SELECT
    COUNT(*) AS total_records,
    SUM(units_sold) AS total_units_sold,
    SUM(cogs) AS total_cogs,
    SUM(transportation_cost) AS total_transportation_cost,
    AVG(order_accuracy) * 100 AS order_accuracy_pct,
    AVG(backorder) * 100 AS backorder_rate_pct,
    AVG(lead_time_days) AS avg_lead_time_days,
    SUM(CASE WHEN order_status = 'Pending' THEN 1 ELSE 0 END) AS pending_records,
    SUM(CASE WHEN order_status = 'Canceled' THEN 1 ELSE 0 END) AS canceled_records
FROM inventory_supplychain;

-- 2) Supplier performance scorecard
SELECT
    supplier,
    COUNT(*) AS record_count,
    ROUND(AVG(order_accuracy) * 100, 2) AS order_accuracy_pct,
    ROUND(AVG(lead_time_days), 2) AS avg_lead_time_days,
    ROUND(AVG(backorder) * 100, 2) AS backorder_rate_pct,
    ROUND(SUM(transportation_cost), 2) AS total_transportation_cost,
    ROUND(SUM(cogs), 2) AS total_cogs
FROM inventory_supplychain
GROUP BY supplier
ORDER BY order_accuracy_pct DESC;

-- 3) Warehouse capacity and inventory view
SELECT
    warehouse,
    ROUND(AVG(inventory_level), 2) AS avg_inventory_level,
    ROUND(AVG(warehouse_capacity), 2) AS avg_capacity,
    ROUND(AVG(capacity_utilization_pct), 2) AS avg_capacity_utilization_pct,
    SUM(backorder) AS backorder_records,
    COUNT(*) AS total_records
FROM inventory_supplychain
GROUP BY warehouse
ORDER BY avg_capacity_utilization_pct DESC;

-- 4) Category and region summary
SELECT
    region, category,
    SUM(units_sold) AS total_units_sold,
    ROUND(SUM(cogs), 2) AS total_cogs,
    ROUND(SUM(transportation_cost), 2) AS total_transportation_cost,
    ROUND(AVG(backorder) * 100, 2) AS backorder_rate_pct
FROM inventory_supplychain
GROUP BY region, category
ORDER BY total_cogs DESC;

-- 5) Monthly trends
SELECT
    DATE_FORMAT(date, '%Y-%m') AS month,
    SUM(units_sold) AS units_sold,
    ROUND(SUM(cogs), 2) AS total_cogs,
    ROUND(SUM(transportation_cost), 2) AS transportation_cost,
    ROUND(AVG(backorder) * 100, 2) AS backorder_rate_pct,
    ROUND(AVG(order_accuracy) * 100, 2) AS order_accuracy_pct
FROM inventory_supplychain
GROUP BY DATE_FORMAT(date, '%Y-%m')
ORDER BY month;

-- 6) Exception records to investigate
SELECT *
FROM inventory_supplychain
WHERE backorder = 1
   OR order_accuracy = 0
   OR order_status IN ('Pending', 'Canceled')
ORDER BY backorder DESC, order_accuracy ASC, lead_time_days DESC;
