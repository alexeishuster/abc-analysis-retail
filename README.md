📊 Multi-Dimensional ABC Analysis of a Pharmacy Chain's Assortment
📌 Business Problem
A pharmacy chain wants to optimize its assortment and inventory management. A classic single-metric ABC analysis (e.g., based only on revenue) doesn't provide the full picture: a product can be a revenue leader but bring minimal profit due to low markups or large discounts.
Goal: Conduct a multi-dimensional ABC analysis across three key metrics simultaneously:
Units Sold (amount) — product popularity
Profit (profit) — financial contribution of the product
Revenue (revenue) — total sales volume of the product

This allows us to identify:
🌟 "Stars" — Class A products across all three metrics
💰 "Cash Cows" — Class A in profit, but B/C in revenue (high-margin items)
📉 "Dead Weight" — Class C products across all metrics (candidates for delisting)
⚠️ "Problematic" — products with class discrepancies (e.g., Class A in revenue, but Class C in profit)

---

## 🗂️ Data

The raw sales table contains line items from sales receipts:

| Field | Description |
|------|----------|
| `dr_ndrugs` | Quantity of units sold (can be negative — product returns) |
| `dr_kol` | Retail price per unit |
| `dr_croz` | Purchase (cost) price per unit |
| `dr_czak` | Закупочная цена за единицу |
| `dr_sdisc` | Total discount amount applied to the entire receipt line |
| `dr_dat` | Receipt date |

Important: Negative values in dr_kol represent product returns. They are included in the calculations on par with regular sales, which accurately reflects the real turnover.

---

### Metric Calculation Formulas
Revenue  = Σ(dr_kol × dr_croz) − Σ(dr_sdisc)
Profit   = Σ(dr_kol × (dr_croz − dr_czak)) − Σ(dr_sdisc)
Amount   = Σ(dr_kol)
