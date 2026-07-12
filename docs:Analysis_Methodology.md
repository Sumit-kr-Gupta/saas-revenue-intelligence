# Analysis Methodology

## Guiding Principle
Every metric in this project is built bottom-up from the transaction and event tables — never estimated top-down from a summary number. If a metric can't be traced back to specific rows in `invoices`, `subscriptions`, `plan_changes`, or `churn_events`, it isn't used.

## Data Validation (Precedes All Analysis)
Before any KPI is calculated, the SQL layer runs three checks: duplicate `customer_id`/`invoice_id` detection, orphaned `payments` (no matching invoice), and orphaned `subscriptions` (no matching plan). Only after these pass clean does analysis begin — a discipline borrowed from data engineering, not typically present in analyst-built dashboards.

## Revenue & MRR
Revenue is recognized only from invoices with `status = 'paid'`. MRR is derived by normalizing recognized revenue to a monthly recurring basis per active subscription; ARR is MRR × 12.

## Churn Rate
Two distinct churn figures are maintained deliberately:
- **Cumulative churn** (churned customers ÷ total revenue customers, all-time) — a lifetime health indicator, not a trend indicator.
- **Monthly logo churn** — churned customers in month M ÷ active customers at the start of month M, computed per month from `churn_events` joined against `subscriptions`. This is the figure used whenever "churn rate" is cited without qualification in a trend or forecast context.

## NRR / GRR — MRR Bridge Method
Calculated per monthly cohort (customers active at the start of each month), not as a single lifetime ratio:

1. **Starting MRR** — MRR from the cohort at month start
2. **+ Expansion MRR** — additional MRR from upgrades within the cohort (`plan_changes`, change_type = upgrade)
3. **− Contraction MRR** — MRR lost to downgrades within the cohort (`plan_changes`, change_type = downgrade)
4. **− Churned MRR** — MRR lost to customers who churned within the cohort (`churn_events`)

```
GRR = (Starting MRR − Contraction − Churned) ÷ Starting MRR
NRR = (Starting MRR − Contraction − Churned + Expansion) ÷ Starting MRR
```

This is run per month and then presented both as a monthly trendline and a blended average — the trendline is the primary artifact, since a single blended NRR can mask an improving or worsening trajectory.

## Revenue Concentration
Customers are ranked by cumulative revenue contribution; Top 10 and Top 20 revenue share are calculated as a percentage of total recognized revenue, to quantify single-account concentration risk independent of segment-level concentration (country/industry).

## Segment-Level Churn Drivers
Differences in churn rate across acquisition channel, industry, and company size are tested for statistical significance (chi-square / proportion tests) before being cited as drivers — descriptive differences alone are not treated as findings.

## LTV (Modeled, With Stated Assumptions)
```
LTV = Avg Revenue per Customer × Avg Customer Lifetime (1 ÷ monthly churn rate) × Assumed Gross Margin %
```
Gross margin is not present in the source data and is explicitly assumed and stated wherever LTV is cited — never presented as an observed figure.

## CAC (Blocked — Explicitly Documented)
CAC by channel requires marketing/sales spend data not present in this dataset. Rather than fabricate a cost assumption, this is documented as an open data requirement. LTV:CAC will be completed once channel-level spend data is available or reasonably estimated with a stated source.
