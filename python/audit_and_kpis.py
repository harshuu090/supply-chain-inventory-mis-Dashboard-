from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "inventory_supplychain_clean.csv"
df = pd.read_csv(RAW, parse_dates=["date"])

print("SHAPE:", df.shape)
print("\nDATE RANGE:", df["date"].min().date(), "to", df["date"].max().date())
print("\nMISSING VALUES:\n", df.isna().sum().to_string())
print("\nDUPLICATE ROWS:", df.duplicated().sum())
print("\nORDER STATUS:\n", df["order_status"].value_counts().to_string())

df["capacity_utilization_pct"] = (
    df["inventory_level"] / df["warehouse_capacity"] * 100
)

print("\nEXECUTIVE KPIs")
print("Total units sold:", int(df["units_sold"].sum()))
print("Total COGS:", round(df["cogs"].sum(), 2))
print("Total transportation cost:", round(df["transportation_cost"].sum(), 2))
print("Order accuracy %:", round(df["order_accuracy"].mean() * 100, 2))
print("Backorder rate %:", round(df["backorder"].mean() * 100, 2))
print("Average lead time days:", round(df["lead_time_days"].mean(), 2))

print("\nSUPPLIER SCORECARD")
scorecard = df.groupby("supplier").agg(
    records=("supplier", "size"),
    order_accuracy_pct=("order_accuracy", lambda x: x.mean() * 100),
    avg_lead_time_days=("lead_time_days", "mean"),
    backorder_rate_pct=("backorder", lambda x: x.mean() * 100),
    transportation_cost=("transportation_cost", "sum"),
).round(2).sort_values("order_accuracy_pct", ascending=False)
print(scorecard.to_string())

print("\nLIMITATION: This dataset does not contain SKU IDs, order IDs, promised/actual delivery dates, or item-level daily time series. Do not infer true on-time delivery or item-level forecasts from it.")
