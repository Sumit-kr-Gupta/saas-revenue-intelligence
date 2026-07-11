# SaaS Revenue Intelligence

**End-to-end revenue, retention, and growth analytics on a 25,000-customer SaaS business — built across SQL, Python, and Excel to answer the questions a CFO, VP of Growth, and Board actually ask.**

---
# 📑 Table of Contents

- [1. Executive Summary](#1-executive-summary)
- [2. Business Problem](#2-business-problem)
- [3. Business Context](#3-business-context)
- [4. Objectives](#4-objectives)
- [5. Business Questions](#5-business-questions)
- [6. Dataset Overview](#6-dataset-overview)
- [7. Data Architecture](#7-data-architecture)
- [8. Technology Stack](#8-technology-stack)
- [9. SQL Analysis](#9-sql-analysis)
- [10. Python Analysis](#10-python-analysis)
- [11. Excel Dashboard](#11-excel-dashboard)
- [12. Tableau Dashboard](#12-tableau-dashboard)
- [13. KPI Framework](#13-kpi-framework)
- [14. Analytical Methodology](#14-analytical-methodology)
- [15. Business Insights](#15-business-insights)
- [16. Executive Recommendations](#16-executive-recommendations)
- [17. Revenue Impact](#17-revenue-impact)
- [18. Business Value](#18-business-value)
- [19. Repository & Folder Structure](#19-repository--folder-structure)
- [20. Key Skills Demonstrated](#20-key-skills-demonstrated)
- [21. Challenges & Assumptions](#21-challenges--assumptions)
- [22. Future Enhancements](#22-future-enhancements)
- [23. Screenshots](#23-screenshots)
- [24. How to Run This Project](#24-how-to-run-this-project)
- [25. Conclusion](#25-conclusion)

## 1. Executive Summary

This project models the full revenue lifecycle of a SaaS company — from customer acquisition through billing, subscription changes, and churn — using a relational dataset of 25,000 customers, 68,412 invoices, and 9,758 churn events spanning 2023–2025.

The objective was not to produce charts. It was to answer the questions that determine whether a SaaS business is healthy: *Is revenue durable? Where is it concentrated? Which customers are we losing, and why? What does the business need to fix first?*

**Headline numbers:**

| Metric | Value |
|---|---|
| Total Revenue | $3.46M |
| MRR (Monthly Recurring Revenue) | $2.62M |
| ARR Run Rate | $31.4M |
| Total Customers | 25,000 |
| Active Paying Customers | 5,469 |
| Revenue per Active Customer | $633 |
| Net Revenue Retention (NRR) | 58% |
| Gross Revenue Retention (GRR) | 53% |

NRR and GRR were calculated using a proper **MRR bridge methodology** — starting MRR adjusted for expansion, contraction, and churned revenue within each monthly cohort — not a simple point-in-time ratio. The result is a retention picture that is low enough to demand action, and defensible enough to present to an executive team without the numbers falling apart under questioning.

---

## 2. Business Problem

SaaS companies live or die by retention economics, not just top-line growth. A business can grow revenue every quarter while quietly bleeding out through churn and downgrades — a pattern invisible in a simple revenue chart. Leadership needs a single source of truth that connects billing, subscriptions, and churn data to answer: *are we growing efficiently, or are we refilling a leaking bucket?*

## 3. Business Context

The dataset represents a mid-market SaaS company operating across four pricing tiers (Free, Basic, Pro, Premium), four countries (US, UK, Germany, India), and four industry verticals (Finance, Health, Retail, Tech), acquiring customers through three channels (Referral, Organic, Ads).

## 4. Objectives

1. Establish a single, trusted view of revenue and retention health
2. Quantify churn and its revenue impact with defensible methodology
3. Identify where revenue is concentrated and where it's at risk
4. Translate findings into prioritized, executive-ready recommendations

## 5. Business Questions

- What is our actual MRR/ARR run rate, and is it growing or flattening?
- What is Net Revenue Retention, and what's driving it — churn, or downgrades?
- Which plans, countries, and industries generate the most durable revenue?
- What is our revenue concentration risk (are we exposed to a small number of accounts)?
- Which acquisition channel produces the highest-retaining customers?
- What should leadership fix first?

## 6. Dataset Overview

| Table | Rows | Purpose |
|---|---|---|
| `customers` | 25,000 | Customer demographics, industry, country, acquisition channel |
| `subscriptions` | 25,000 | Plan assignment and subscription status |
| `subscription_plans` | 8 | Plan pricing tiers |
| `invoices` | 68,412 | Billing events and amounts |
| `payments` | 68,412 | Payment status and reconciliation |
| `plan_changes` | 788 | Upgrade/downgrade events (drives expansion/contraction in NRR) |
| `churn_events` | 9,758 | Churn date and reason |

## 7. Data Architecture

Star-schema-oriented design: `customers` and `subscriptions` as dimension anchors, `invoices`/`payments` as the transactional fact layer, with `churn_events` and `plan_changes` as event tables that feed the retention bridge. A consolidated `Revenue_Fact_Table` (68,412 rows × 26 columns) flattens these relationships for fast pivoting and dashboarding in Excel.

## 8. Technology Stack

- **SQL** — data validation, KPI aggregation, cohort and retention logic (859 lines across 10 structured sections)
- **Python** (pandas, matplotlib/seaborn) — EDA, statistical testing, retention modeling across 4 notebooks
- **Excel** — 13-sheet interactive workbook with PivotTables, KPI model, and executive dashboard
- **Tableau** — executive dashboard *(In Progress)*

## 9. SQL Analysis

The SQL layer (`SAAS_REVENUE_INTELLIGENCE.sql`) is organized into 10 business-driven sections, each opening with a stated business goal and the questions it answers — not just queries:

0. Database Setup → 1. Data Validation & Quality → 2. Executive Snapshot → 3. Revenue Intelligence → 4. Customer Intelligence → 5. Subscription Intelligence → 6. Churn Intelligence → 7. Growth & Cohort Intelligence → 8. Strategic Revenue Risk → 9. Advanced Analytics → 10. Business Views

Data validation runs first, checking for duplicate customer/invoice records and orphaned foreign keys (payments without invoices, subscriptions without valid plans) — establishing data trust before any KPI is computed.

## 10. Python Analysis

Four notebooks, each scoped to a distinct layer of the business:

- **Notebook 1 — Data Prep & EDA**: data dictionary, time-dimension feature engineering, customer base profiling, revenue/billing analysis, business health scorecard
- **Notebook 2 — Revenue Intelligence**: MRR/ARR trending, revenue concentration, plan/geo/industry breakdowns
- **Notebook 3 — Customer & Churn Analysis**: churn driver analysis, statistical significance testing across customer segments
- **Notebook 4 — Executive Insights**: NRR/GRR MRR-bridge modeling, risk matrix, board-ready synthesis

## 11. Excel Dashboard

A 13-sheet workbook combining raw relational tables with modeled analysis layers: `KPI_Model`, `Customer_KPI`, `Revenue_Concentration`, `Monthly_Trend`, and a single-page `Executive_Dashboard` summarizing the headline metrics above with supporting business insights (top plan, top country, top industry, top acquisition channel).

## 12. Tableau Dashboard

**Status: In Progress.** Will surface the MRR bridge, cohort retention heatmap, and revenue concentration views interactively.

## 13. KPI Framework

| KPI | Definition |
|---|---|
| MRR | Monthly Recurring Revenue, normalized from paid invoices |
| ARR | MRR × 12 |
| NRR | (Starting MRR − Contraction − Churned MRR + Expansion) ÷ Starting MRR, per monthly cohort |
| GRR | (Starting MRR − Contraction − Churned MRR) ÷ Starting MRR, per monthly cohort |
| Revenue per Active Customer | Total Revenue ÷ Active Customers |
| Revenue Concentration | Top 10 / Top 20 customer revenue share vs. total |

## 14. Analytical Methodology

Retention metrics were deliberately built on a **cohort-based MRR bridge** rather than a snapshot ratio, joining `subscriptions`, `plan_changes`, and `churn_events` by month to isolate expansion, contraction, and churned revenue within each starting cohort. This is the same methodology SaaS finance teams use to report NRR/GRR to boards and investors, making the numbers interview-defensible line by line.

## 15. Business Insights

- NRR of 58% and GRR of 53% indicate retention, not acquisition, is the binding constraint on growth — the business is losing revenue faster than it's expanding existing accounts.
- Premium is the top-revenue plan, but revenue is meaningfully concentrated in the UK and the Health industry vertical — a geography/vertical concentration worth stress-testing.
- Referral is the top-performing acquisition channel by revenue, ahead of Organic and Ads — an efficiency signal worth validating against retention (not just revenue) by channel.
- The gap between NRR and GRR (58% vs. 53%) is narrow, implying expansion revenue (upsells/upgrades) is not yet offsetting churn — the fix is retention-first, not upsell-first.

## 16. Executive Recommendations

1. **Prioritize retention over acquisition.** With NRR below 100%, every new customer acquired is partially offsetting losses from the existing base rather than adding net growth.
2. **Investigate the UK/Health concentration.** Understand whether this is a strength to double down on or a risk to diversify away from.
3. **Build a expansion motion.** The narrow NRR-GRR gap shows upsell/cross-sell isn't yet a meaningful growth lever — there's clear headroom.
4. **Re-evaluate channel allocation** using retention-adjusted CAC by channel, not just top-line revenue by channel.

## 17. Revenue Impact

Closing the 42-point gap between current NRR (58%) and a healthy SaaS benchmark (~100–110%) on a $2.62M MRR base represents roughly **$1.1M+ in monthly recurring revenue** currently being lost to churn and contraction — the single largest value lever identified in this analysis.

## 18. Business Value

This analysis converts raw transactional data into a decision-ready retention and revenue framework — the kind of artifact a Revenue Operations, Strategy, or Founder's Office function would build to align a leadership team on where to invest next.

## 19–20. Folder / Repository Structure

```
saas-revenue-intelligence/
├── README.md
├── docs/
│   ├── Executive_Summary.md
│   ├── Business_Problem.md
│   ├── Business_Requirements.md
│   ├── Data_Dictionary.md
│   ├── Analysis_Methodology.md
│   ├── KPI_Definitions.md
│   ├── Business_Insights.md
│   ├── Executive_Recommendations.md
│   ├── Technical_Documentation.md
│   └── Presentation_Guide.md
├── sql/
│   └── SAAS_REVENUE_INTELLIGENCE.sql
├── notebooks/
│   ├── 01_Data_Prep_and_EDA.ipynb
│   ├── 02_Revenue_Intelligence.ipynb
│   ├── 03_Customer_and_Churn_Analysis.ipynb
│   └── 04_Executive_Insights.ipynb
├── excel/
│   └── SaaS_Revenue_Intelligence.xlsx
├── dashboard/
│   └── tableau_public_link.md
└── screenshots/
    └── (dashboard and workbook screenshots)
```

## 21. Key Skills Demonstrated

SQL (joins, subqueries, data validation, cohort logic) · Python (pandas, statistical hypothesis testing) · Excel (PivotTables, KPI modeling, dashboarding) · Retention & MRR-bridge modeling · Revenue concentration analysis · Executive communication and insight synthesis

## 22. Challenges & Assumptions

- Gross margin was not present in the source data; LTV modeling assumes a stated margin rather than an observed one.
- CAC by channel requires marketing spend data external to this dataset — flagged as a scoping constraint rather than an omission.
- NRR/GRR figures reflect the full observed period; a monthly trendline (rather than a single blended figure) is the next iteration.

## 23. Future Enhancements

- Complete Tableau Public dashboard
- Add cohort retention heatmap (signup-month cohorts × month-since-signup)
- Add LTV:CAC model once channel-level acquisition cost data is available
- Monthly (not blended) NRR/GRR trendline

## 24. Screenshots

*(Excel dashboard and Tableau visuals to be added here upon Tableau completion.)*

## 25. How to Run This Project

1. Run `sql/SAAS_REVENUE_INTELLIGENCE.sql` against a MySQL/PostgreSQL instance to build and validate the schema
2. Run notebooks 1 → 4 in sequence for the full analytical pipeline
3. Open `excel/SaaS_Revenue_Intelligence.xlsx` for the interactive KPI dashboard

## 26. Conclusion

This project demonstrates the full analytical stack required to run revenue operations at a SaaS company: trustworthy data validation, defensible retention methodology, and insights translated into prioritized executive action — not just a dashboard, but a decision-support tool.

---
*Author: Sumit Kumar Gupta*
