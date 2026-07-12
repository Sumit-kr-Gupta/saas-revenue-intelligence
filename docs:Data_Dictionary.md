# Data Dictionary

## customers (25,000 rows)
| Field | Description |
|---|---|
| customer_id | Unique customer identifier (primary key) |
| country | Customer's billing country (US, UK, Germany, India) |
| industry | Customer's industry vertical (Finance, Health, Retail, Tech) |
| company_size | Small / Medium / Large |
| acquisition_channel | Referral / Organic / Ads |
| signup_date | Date the customer account was created |

## subscriptions (25,000 rows)
| Field | Description |
|---|---|
| customer_id | Foreign key → customers |
| plan_id | Foreign key → subscription_plans |
| status | active / churned / inactive |
| start_date | Subscription start date |

## subscription_plans (8 rows)
| Field | Description |
|---|---|
| plan_id | Unique plan identifier |
| plan_name | Free / Basic / Pro / Premium |
| price | Monthly list price for the plan |

## invoices (68,412 rows)
| Field | Description |
|---|---|
| invoice_id | Unique invoice identifier (primary key) |
| customer_id | Foreign key → customers |
| amount | Invoiced amount |
| status | paid / pending / failed |
| invoice_date | Date the invoice was issued |

## payments (68,412 rows)
| Field | Description |
|---|---|
| payment_id | Unique payment identifier |
| invoice_id | Foreign key → invoices |
| status | Reconciliation status of the payment against its invoice |

## plan_changes (788 rows)
| Field | Description |
|---|---|
| customer_id | Foreign key → customers |
| old_plan_id / new_plan_id | Plan before and after the change |
| change_date | Date of the upgrade/downgrade |
| change_type | Upgrade or downgrade — drives Expansion/Contraction MRR |

## churn_events (9,758 rows)
| Field | Description |
|---|---|
| customer_id | Foreign key → customers |
| churn_date | Date the customer churned |
| churn_reason | competitor / price / budget / product_fit / other |

## Derived Tables

### Revenue_Fact_Table (68,412 rows × 26 columns)
A flattened, join-resolved table combining invoices, customers, subscriptions, and plan attributes into a single analysis-ready fact table — built to support fast PivotTable analysis in Excel without repeated joins.

### Revenue_Concentration
Ranks customers by cumulative revenue contribution to support Top 10 / Top 20 revenue share analysis.

### KPI_Model / Customer_KPI / Monthly_Trend / Executive_Dashboard
Modeled output sheets (not source data) — these hold the calculated KPIs (MRR, ARR, NRR, GRR, churn rate) referenced throughout the README and this documentation set. See `KPI_Definitions.md` for exact formulas.

## Known Data Limitations
- No marketing/sales spend data — blocks a data-driven CAC calculation (see `Analysis_Methodology.md`).
- No gross margin field — LTV modeling requires an assumed margin rather than an observed one.
- Single currency assumed across all `amount` fields.
