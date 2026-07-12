# KPI Definitions

This is the single source of truth for every metric cited in the README, Excel workbook, SQL output, and notebooks. If a number in any of those artifacts doesn't match the definition here, the artifact is wrong — not this document.

| KPI | Formula | Notes |
|---|---|---|
| **Revenue** | SUM(invoice amount) WHERE status = 'paid' | Never includes pending/failed invoices |
| **MRR** | Recognized revenue normalized to a monthly recurring basis, per active subscription | Excludes one-time/non-recurring charges |
| **ARR** | MRR × 12 | Run-rate, not trailing-twelve-months actual |
| **Total Customers** | COUNT(DISTINCT customer_id) in customers table | Includes free-tier and inactive customers |
| **Active (Revenue) Customers** | COUNT(DISTINCT customer_id) WHERE subscription status = 'active' | Only paying, currently active accounts |
| **Churned Customers** | COUNT(DISTINCT customer_id) in churn_events | All-time count |
| **Cumulative Churn Rate** | Churned Customers ÷ Total Revenue Customers (all-time) | Lifetime indicator only — not a trend metric |
| **Monthly Logo Churn Rate** | Customers churned in month M ÷ active customers at start of month M | The correct figure for trend/forecast use |
| **GRR (Gross Revenue Retention)** | (Starting MRR − Contraction MRR − Churned MRR) ÷ Starting MRR, per cohort-month | Never exceeds 100% by definition |
| **NRR (Net Revenue Retention)** | (Starting MRR − Contraction MRR − Churned MRR + Expansion MRR) ÷ Starting MRR, per cohort-month | Can exceed 100% if expansion outpaces losses |
| **Revenue per Active Customer** | Total Revenue ÷ Active Customers | Blended across all plans |
| **Top 10 / Top 20 Revenue Share** | SUM(revenue, top N customers by revenue) ÷ Total Revenue | Concentration risk indicator |
| **LTV** | Avg Revenue per Customer × (1 ÷ Monthly Churn Rate) × Assumed Gross Margin % | Margin is an explicit assumption, not observed |
| **CAC** | Not yet calculable — requires channel-level acquisition spend data not present in the source dataset | See `Analysis_Methodology.md` |

## Why Two Churn Numbers Exist
This is a deliberate design choice, not an inconsistency. "Cumulative churn" answers *"of everyone who ever paid us, what fraction eventually left?"* — a lifetime health check. "Monthly logo churn" answers *"are we losing customers faster or slower than last month?"* — the actionable, trend-relevant number. Citing either without its label is treated as an error in this project.

## Version Control
Any change to a formula in this document must be reflected simultaneously in the SQL script, the Python notebooks, and the Excel `KPI_Model` sheet. This document is the arbiter in case of disagreement between the three.
