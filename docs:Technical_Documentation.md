# Technical Documentation

## Pipeline Overview
```
Raw relational tables (SQL)
        │
        ▼
Data validation & quality checks (SQL Section 1)
        │
        ▼
KPI aggregation & business views (SQL Sections 2–10)
        │
        ▼
Python EDA, statistical testing, MRR-bridge modeling (Notebooks 1–4)
        │
        ▼
Excel workbook: Revenue_Fact_Table + KPI/Customer_KPI/Monthly_Trend + Executive_Dashboard
        │
        ▼
Tableau executive dashboard (In Progress)
```

## SQL Layer
- **Engine:** MySQL/PostgreSQL-compatible standard SQL
- **File:** `sql/SAAS_REVENUE_INTELLIGENCE.sql` (859 lines, 10 sections)
- **Structure:** Every section opens with a `Business Goal` and `Business Questions` comment block before any query — queries are written to answer a stated question, not as ad hoc exploration.
- **Key patterns used:** correlated subqueries for the Executive KPI snapshot, LEFT JOIN-based orphan detection for referential integrity checks, window functions for cohort and running-total logic in Sections 7–9, and materialized business views in Section 10 for reuse across the Python and Excel layers.

## Python Layer
- **Environment:** pandas, numpy, matplotlib/seaborn, scipy (for significance testing)
- **Notebook 1 (Data Prep & EDA):** loads and profiles all 7 source tables, engineers time-dimension features (signup month, invoice month, tenure), and produces a business health scorecard as a sanity check before deeper analysis.
- **Notebook 2 (Revenue Intelligence):** builds MRR/ARR trends, revenue concentration analysis, and plan/geo/industry breakdowns.
- **Notebook 3 (Customer & Churn Analysis):** segments churn by channel, industry, and company size, and runs statistical significance tests (chi-square/proportion tests) rather than relying on descriptive differences alone.
- **Notebook 4 (Executive Insights):** implements the MRR bridge for NRR/GRR, builds a risk matrix, and synthesizes findings into the executive narrative reflected in the README.

## Excel Layer
- **File:** `excel/SaaS_Revenue_Intelligence.xlsx` (13 sheets)
- **Raw layer:** `customers`, `invoices`, `payments`, `subscriptions`, `subscription_plans`, `plan_changes`, `Churn_events` — direct table exports
- **Modeled layer:** `Revenue_Fact_Table` (flattened join across raw tables for fast pivoting), `Revenue_Concentration`, `KPI_Model`, `Customer_KPI`, `Monthly_Trend`
- **Presentation layer:** `Executive_Dashboard` — single-page summary of headline KPIs and top-line business insights, built to be screenshot-ready for a deck without further formatting.
- **Note:** given file size (68K+ row fact table), the workbook was built and validated programmatically via `openpyxl` rather than manual Excel editing, to keep formula/reference integrity intact across a large row count.

## Tableau Layer (In Progress)
Planned views: MRR bridge waterfall (starting MRR → expansion → contraction → churn → ending MRR), cohort retention heatmap, and a revenue concentration Pareto view.

## Reproducing This Analysis
1. Provision a MySQL/PostgreSQL database and run `sql/SAAS_REVENUE_INTELLIGENCE.sql` end to end — Section 0 creates the schema, Section 1 validates it.
2. Export or connect the validated tables into the Python environment; run Notebooks 1 → 4 in order, as each depends on feature engineering performed in the prior notebook.
3. Open the Excel workbook to explore the modeled/presentation layers interactively, or to rebuild them from the `Revenue_Fact_Table` sheet.

## Design Decisions Worth Defending in an Interview
- **Why two churn numbers?** See `KPI_Definitions.md` — cumulative churn and monthly logo churn answer different questions and are never used interchangeably.
- **Why MRR bridge instead of a simple ratio for NRR/GRR?** A snapshot ratio conflates "how big is the base now" with "how much of the base we started with survived" — the bridge method isolates the latter, which is what NRR/GRR are supposed to measure.
- **Why validate data quality before computing any KPI?** Because a clean-looking KPI built on dirty joins is worse than an obviously incomplete one — it fails silently.
