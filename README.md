# 🚀 SaaS Revenue Intelligence

**End-to-end SaaS revenue intelligence platform analyzing $3.46M in revenue across 25,000 customers to quantify growth, retention, customer value, and revenue risk. — built with MySQL, Python, and Excel to deliver executive-ready insights on MRR, ARR, churn drivers, customer segmentation, and retention performance.**

---

## 📌 Business Problem

SaaS companies can grow their customer base every month and still shrink in revenue if churn outpaces acquisition. Most early-stage and growth-stage SaaS teams lack a structured, repeatable system to answer the questions that drive executive decisions:

- Is our recurring revenue growing or are we just replacing churned customers with new ones?
- Which customers, plans, and markets generate the most value?
- Why are customers leaving — and what is the single highest-ROI retention fix?
- What does our NRR and GRR say about the long-term health of the business?

This project builds that system end-to-end: raw relational subscription data → SQL KPI engine → Python analytical layer → Excel executive dashboards → actionable business recommendations.
The dataset represents a SaaS subscription business operating across multiple customer segments, industries, acquisition channels, and pricing plans. The objective was to evaluate revenue performance, customer retention, churn drivers, and growth opportunities using a combination of SQL, Python, and Excel.

The analysis focuses on four core business questions:

- How healthy is the recurring revenue base?

- Which customers, plans, and segments generate the most revenue?

- What are the primary drivers of customer churn?

- Which actions could improve retention and long-term revenue growth?
---

## 🎯 Project Objectives

1. Build a 7-table normalized SaaS subscription schema and validate data quality across all tables
2. Calculate and cross-validate MRR, ARR, Total Revenue, and ARPC across SQL, Python, and Excel
3. Decompose revenue across plan tier, country, industry, company size, and acquisition channel
4. Segment customers into High / Medium / Low value cohorts and analyze revenue concentration risk
5. Measure NRR (58%) and GRR (53%) and identify the retention levers to improve both
6. Decompose churn by reason, industry, and timing to prioritize retention interventions
7. Build a monthly revenue trend analysis covering Jan 2023 – Nov 2025 (35 months)
8. Translate all analytical findings into executive-grade recommendations with stakeholder ownership

---

## 🗂 Dataset Overview

| Table | Rows | Description |
|---|---|---|
| `customers` | 25,000 | Customer master — ID, signup date, company size, industry, acquisition channel, country |
| `invoices` | 68,411 paid | Transaction-level revenue records — invoice date, amount, status (paid/unpaid) |
| `payments` | 7,442 successful | Payment records linked to invoices — success/failure tracking |
| `subscriptions` | 5,469 active + 2,558 churned | Subscription lifecycle — plan, start/end date, status |
| `subscription_plans` | 7 plans | Plan master — Free ($0), Basic monthly ($19), Pro monthly ($49), Premium monthly ($99), Basic annual ($190), Pro annual ($490), Premium annual ($990) |
| `plan_changes` | 100+ records | Upgrade / downgrade events — old plan, new plan, change date |
| `churn_events` | 2,558 records | Churn records — customer ID, churn date, churn reason |

**Dataset period:** January 2023 – November 2025 (35 months)

**Dataset assumptions:**
- Revenue recognized only from invoices with `STATUS = 'paid'`
- MRR calculated from active subscription plan prices; ARR = MRR × 12 (monthly contract convention)
- Revenue customers = customers appearing in the invoice dataset (8,027 of 25,000 total)
- NRR and GRR estimated using revenue-customer relationships in the dataset — directionally valid for analytical purposes

---

## 📖 Data Dictionary

| Column | Table | Business Meaning | Why Important |
|---|---|---|---|
| `customer_id` | All tables | Unique customer identifier | Primary join key across the entire 7-table schema |
| `plan_id` | subscriptions, subscription_plans | Subscription tier identifier | Links pricing to customer base for MRR calculation |
| `plan_name` | subscription_plans | Free / Basic / Pro / Premium | Revenue mix and upsell analysis |
| `price` | subscription_plans | Monthly plan price ($0 / $19 / $49 / $99 for monthly; $190 / $490 / $990 for annual) | Core input to MRR and ARR |
| `status` | subscriptions | active / churned | Determines which customers count toward live MRR |
| `amount` | invoices | Invoice value in USD | Basis for all revenue calculations |
| `invoice_date` | invoices | Date of invoice | Monthly trend construction; 35-month time series |
| `status` | invoices | paid / unpaid | Only paid invoices count toward recognized revenue |
| `churn_reason` | churn_events | competitor / price / budget / product_fit / other | Identifies the highest-volume retention intervention points |
| `country` | customers | US / UK / Germany / India | Geographic revenue concentration and expansion analysis |
| `industry` | customers | Finance / Health / Retail / Tech | ICP identification and vertical expansion strategy |
| `company_size` | customers | small / medium / large | Pricing strategy and upsell potential |
| `acquisition_channel` | customers | referral / organic / ads | CAC efficiency and channel ROI analysis |
| `signup_date` | customers | Date customer joined | Cohort construction and acquisition trend analysis |
| `mrr` | Revenue_Fact_Table (computed) | Monthly recurring revenue per invoice line | Revenue_Fact_Table computed field — annual plans divided by 12 |
| `arr` | Revenue_Fact_Table (computed) | Annualized recurring revenue per subscription | Revenue_Fact_Table computed field — MRR × 12 |

---

## 🛠 Tech Stack

| Tool | Badge | Purpose |
|---|---|---|
| **MySQL** | ![SQL](https://img.shields.io/badge/MySQL-4479A1?logo=mysql&logoColor=white) | Schema design, 35+ KPI queries, segmentation, window functions, views |
| **Python** | ![Python](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white) | EDA, revenue analytics, churn analysis, customer funnel, executive insights |
| **pandas** | ![pandas](https://img.shields.io/badge/pandas-150458?logo=pandas&logoColor=white) | Data loading, merging, aggregation, KPI computation |
| **matplotlib** | ![matplotlib](https://img.shields.io/badge/matplotlib-11557c) | All visualizations — bar, line, histogram, funnel charts |
| **Excel** | ![Excel](https://img.shields.io/badge/Excel-217346?logo=microsoft-excel&logoColor=white) | XLOOKUP-built Revenue_Fact_Table, SUMIFS/COUNTIFS KPI model, 6-chart executive dashboard |
| **Tableau** | ![Tableau](https://img.shields.io/badge/Tableau-E97627?logo=tableau&logoColor=white) | Interactive dashboard — in development |
| **GitHub** | ![GitHub](https://img.shields.io/badge/GitHub-181717?logo=github&logoColor=white) | Version control, portfolio hosting |

**Why this stack?** MySQL is the production standard for relational SaaS billing data. Python handles the analytical operations SQL cannot — funnel visualization, customer health summaries, executive scorecards. Excel is what finance and operations stakeholders actually open in practice. Each tool covers what it does best; no tool is used beyond its appropriate scope.

---

## 📊 Excel Analysis

The Excel workbook acts as the business reporting and executive communication layer. It contains 13 sheets total — 6 raw source tables and 7 analytical sheets built on top of them.

### Sheet 1: Revenue_Fact_Table

**Purpose:** Single analytical source of truth for all KPI and dashboard calculations.

Built using `XLOOKUP` to join customer, subscription, plan, payment, and churn data into one reporting table. Contains 26 columns including computed `mrr`, `arr`, `year_month`, and a `customer_found` flag tracking join quality.

Key fields: `invoice_id`, `customer_id`, `invoice_date`, `invoice_amount`, `invoice_status`, `payment_status`, `signup_date`, `company_size`, `industry`, `acquisition_channel`, `country`, `subscription_status`, `plan_name`, `billing_cycle`, `plan_price`, `churn_date`, `churn_reason`, `year`, `month`, `year_month`, `mrr`, `arr`

**Key formula:** `=XLOOKUP(B975, subscriptions!B:B, subscriptions!A:A, "")` — joins subscription IDs to invoices; the `customer_found` flag was created to validate join quality and identify unmatched records during data integration., flagged as "Missing" vs "Found" — a data quality transparency signal worth mentioning in interviews.

**Business value:** Enables every downstream pivot, chart, and KPI calculation to draw from a validated, joined dataset rather than raw tables.

---

### Sheet 2: KPI_Model

**Purpose:** Central KPI calculation engine — the financial summary of the entire project.

Built using `SUMIFS`, `COUNTIFS`, `UNIQUE`, and dynamic aggregation formulas.

| KPI | Value |
|---|---|
| Total Revenue | $3,462,189 |
| Total Customers | 25,000 |
| Revenue Customers | 8,027 |
| Paid Invoices | 68,411 |
| Successful Payments | 7,442 |
| MRR | $2,617,480.67 |
| ARR | $31,409,768 |
| Active Customers | 5,469 |
| Churned Customers | 2,558 |
| Customer Churn Rate | 31.87% |

Revenue by Plan:

| Plan | Revenue |
|---|---|
| Premium | $1,240,173 |
| Pro | $1,213,534 |
| Basic | $1,008,482 |
| Free | $0 |

Revenue by Country:

| Country | Revenue |
|---|---|
| UK | $892,665 |
| US | $885,250 |
| Germany | $842,739 |
| India | $830,798 |

Revenue by Industry:

| Industry | Revenue |
|---|---|
| Health | $884,337 |
| Finance | $869,296 |
| Tech | $857,314 |
| Retail | $840,505 |

KPI definitions included in-sheet: Revenue = Paid Invoice Amount; MRR = Monthly Recurring Revenue; ARR = Annualized Recurring Revenue; Churn Rate = Churned ÷ Revenue Customers; Top 10 Revenue Share = 1%; Top 20 Revenue Share = 2%.

---

### Sheet 3: Customer_KPI

**Purpose:** Customer health and retention analytics layer.

| Metric | Value |
|---|---|
| Total Revenue Customers | 8,029 |
| Active Revenue Customers | 5,469 |
| Churned Revenue Customers | 2,558 |
| Avg Revenue Per Customer | $431.21 |
| Customer Churn Rate | 31.87% |
| Estimated NRR | 58% |
| Estimated GRR | 53% |
| Revenue Per Active Customer | $633.06 |

Revenue by Acquisition Channel:

| Channel | Revenue |
|---|---|
| Referral | $1,180,334 |
| Organic | $1,164,769 |
| Ads | $1,106,349 |

Churn by Reason:

| Reason | Count |
|---|---|
| product_fit | 4,616 |
| other | 4,526 |
| budget | 4,452 |
| competitor | 4,313 |
| price | 4,006 |

Customer Distribution by Company Size:

| Size | Customers |
|---|---|
| Small | 8,444 |
| Medium | 8,348 |
| Large | 8,208 |

Customer Distribution by Industry:

| Industry | Customers |
|---|---|
| Tech | 6,352 |
| Retail | 6,265 |
| Finance | 6,214 |
| Health | 6,169 |

---

### Sheet 4: Revenue_Concentration

**Purpose:** Customer concentration risk analysis.

Top customer (Customer ID 4643): $3,465 revenue.

| Metric | Value |
|---|---|
| Total Customer Revenue | $3,462,189 |
| Top 10 Customer Revenue | $34,254 |
| Top 10 Revenue Share | 1% |
| Top 20 Customer Revenue | $67,221 |
| Top 20 Revenue Share | 2% |

**Business insight:** Revenue is highly distributed — no single customer concentration risk. Top 20 customers represent only 2% of total revenue. This is positive from a risk perspective but also suggests there are no anchor customers to lose.

---

### Sheet 5: Monthly_Trend

**Purpose:** 35-month revenue trend analysis (Jan 2023 – Nov 2025).

Built as a pivot table on the Revenue_Fact_Table with a line chart.

| Period | Revenue |
|---|---|
| 2023-01 | $21,894 |
| 2023-06 | $49,929 |
| 2023-12 | $62,213 |
| 2024-01 | $97,074 |
| 2024-06 | $138,729 |
| 2024-12 | $148,047 |
| 2025-01 | $98,051 |
| 2025-06 | $129,814 |
| 2025-11 | $155,676 |
| **Grand Total** | **$3,462,189** |

**Key insight:** Revenue grew from $21,894 in Jan 2023 to $155,676 in Nov 2025 — a 7.1× increase over 35 months. The Jan 2024 step-change ($97K from $62K in Dec 2023) may indicate a major acquisition, pricing, or customer expansion event and warrants further investigation. The Jan 2025 dip to $98K warrants investigation — potential seasonal effect or delayed billing cycle.

---

### Sheet 6: Executive_Dashboard

**Purpose:** Board-level one-page summary with 6 charts and business insight callouts.

Headline KPIs: Total Revenue $3,462,189 | Total Customers 25,000 | MRR $2,617,480.67 | ARR $31,409,768 | Active Customers 5,469 | Churn Rate 32% | Revenue Per Active Customer $633.06

Charts included:
- Revenue by Industry (horizontal bar)
- Revenue by Country (horizontal bar)
- Revenue by Acquisition Channel (vertical bar)
- Revenue by Plan (vertical bar)
- Top Churn Reasons (horizontal bar)
- Monthly Revenue Trend (line chart)

Business Insights callouts: **Top Plan:** Premium | **Top Country:** UK | **Top Industry:** Health | **Top Acquisition Channel:** Referral

---

## 🗄 SQL Analysis

> All 35+ queries read line-by-line from the uploaded SQL file.

### Schema (7-Table Relational Model)

```
CUSTOMERS ──< SUBSCRIPTIONS >── SUBSCRIPTION_PLANS
     │               │
     └──< INVOICES   └──< PLAN_CHANGES
          │
          └──< PAYMENTS
     │
     └──< CHURN_EVENTS
```

All JOINs use explicit `ON CUSTOMER_ID` or `ON PLAN_ID` conditions. No implicit joins.

---
All JOINs use explicit ON CUSTOMER_ID or ON PLAN_ID conditions. No implicit joins.
---

### Query Walkthrough

** — Total Revenue**
```sql
SELECT SUM(AMOUNT) AS TOTAL_REVENUE FROM INVOICES WHERE STATUS='paid';
```
Result: **$3,462,189** | Filters paid-only — critical distinction from gross billing. Only recognized revenue counts.

---

** — MRR**
```sql
SELECT SUM(SP.PRICE) AS MRR
FROM SUBSCRIPTIONS S JOIN SUBSCRIPTION_PLANS SP ON S.PLAN_ID=SP.PLAN_ID
WHERE S.STATUS='active';
```
Result: **$2,617,480.67** | Calculated from plan price table, not invoices — correct SaaS accounting. Invoices may include one-time or arrears amounts; MRR reflects contracted run rate.

---

** — ARR**
```sql
SELECT SUM(SP.PRICE)*12 AS ARR
FROM SUBSCRIPTIONS S JOIN SUBSCRIPTION_PLANS SP ON S.PLAN_ID=SP.PLAN_ID
WHERE S.STATUS='active';
```
Result: **$31,409,768** | ARR = MRR × 12 is the standard convention for monthly-billed plans.

---

** — Executive KPI Dashboard (Correlated Subqueries)**
```sql
SELECT
  (SELECT SUM(AMOUNT) FROM INVOICES WHERE STATUS='paid') AS TOTAL_REVENUE,
  (SELECT COUNT(DISTINCT CUSTOMER_ID) FROM CUSTOMERS) AS TOTAL_CUSTOMERS,
  (SELECT COUNT(DISTINCT CUSTOMER_ID) FROM SUBSCRIPTIONS WHERE STATUS='active') AS ACTIVE_CUSTOMERS,
  (SELECT COUNT(DISTINCT CUSTOMER_ID) FROM CHURN_EVENTS) AS CHURNED_CUSTOMERS;
```
Four scalar subqueries produce a single board-ready KPI row. Demonstrates understanding of when subquery patterns are appropriate vs CTEs for readability.

---

** — Monthly Revenue Trend**
```sql
SELECT DATE_FORMAT(INVOICE_DATE,'%Y-%m') AS MONTH, SUM(AMOUNT) AS REVENUE
FROM INVOICES WHERE STATUS='paid' GROUP BY MONTH ORDER BY MONTH;
```
`DATE_FORMAT` buckets DATETIME into YYYY-MM strings for monthly GROUP BY — without this, each distinct timestamp would be its own group.

---

** — Revenue by Plan (3-Table JOIN)**
```sql
SELECT SP.PLAN_NAME, SUM(I.AMOUNT) AS REVENUE
FROM INVOICES I
JOIN SUBSCRIPTIONS S ON I.CUSTOMER_ID = S.CUSTOMER_ID
JOIN SUBSCRIPTION_PLANS SP ON S.PLAN_ID = SP.PLAN_ID
WHERE I.STATUS='paid'
GROUP BY SP.PLAN_NAME ORDER BY REVENUE DESC;
```
Premium: $1,240,173 | Pro: $1,213,534 | Basic: $1,008,482 | Free: $0. Three-table JOIN chain — a strong SQL interview demonstration.

---

** — Revenue Share by Plan (Percentage calculation using a scalar subquery denominator..)**
```sql
SELECT SP.PLAN_NAME,
  ROUND(SUM(I.AMOUNT)*100/(SELECT SUM(AMOUNT) FROM INVOICES WHERE STATUS='paid'),2) AS REVENUE_SHARE_PCT
FROM INVOICES I JOIN SUBSCRIPTIONS S ON I.CUSTOMER_ID=S.CUSTOMER_ID
JOIN SUBSCRIPTION_PLANS SP ON S.PLAN_ID=SP.PLAN_ID GROUP BY SP.PLAN_NAME;
```
Percentage calculation using a correlated subquery as the denominator — a standard pattern for revenue share analysis.

---

** — Multi-Dimensional Revenue Segmentation**

Revenue by Country: UK $892,665 | US $885,250 | Germany $842,739 | India $830,798

Revenue by Industry: Health $884,337 | Finance $869,296 | Tech $857,314 | Retail $840,505

Revenue by Company Size — small / medium / large revenue split

Revenue by Acquisition Channel: Referral $1,180,334 | Organic $1,164,769 | Ads $1,106,349

Industry Revenue Share: Percentage decomposition using correlated subquery denominator

---

** — Customer Revenue Ranking (Window Function)**
```sql
SELECT CUSTOMER_ID, SUM(AMOUNT) AS TOTAL_REVENUE,
  RANK() OVER (ORDER BY SUM(AMOUNT) DESC) AS CUSTOMER_RANK
FROM INVOICES GROUP BY CUSTOMER_ID;
```
`RANK()` window function assigns equal rank to tied customers — correct for revenue ranking. Demonstrates SQL beyond GROUP BY; a common interview question.

*Interview question: Why RANK() and not ROW_NUMBER()? ROW_NUMBER() would arbitrarily break ties — two customers with identical revenue would receive different ranks. RANK() correctly gives them the same position.*

---

** — Customer Segmentation (CASE WHEN)**
```sql
SELECT CUSTOMER_ID, SUM(AMOUNT) AS TOTAL_REVENUE,
  CASE WHEN SUM(AMOUNT) >= 1000 THEN 'HIGH VALUE'
       WHEN SUM(AMOUNT) >= 500  THEN 'MEDIUM VALUE'
       ELSE 'LOW VALUE' END AS CUSTOMER_SEGMENT
FROM INVOICES GROUP BY CUSTOMER_ID;
```
Post-aggregation CASE WHEN labeling — applies after GROUP BY, so CASE operates on computed SUM values. Produces actionable customer tiers for CS and Sales prioritization.

---

** — Average Revenue Per Customer**
```sql
SELECT ROUND(SUM(AMOUNT)/COUNT(DISTINCT CUSTOMER_ID),2) AS AVG_REVENUE_PER_CUSTOMER
FROM INVOICES WHERE STATUS='paid';
```
Result: **$431.21** | Note: this is average across all revenue customers (8,027). Revenue Per *Active* Customer is $633.06 — a different and more operationally relevant metric.

---

** — Churn Decomposition**

Churn by Reason: product_fit 4,616 | other 4,526 | budget 4,452 | competitor 4,313 | price 4,006

Churn Share by Reason: product_fit leads at ~21.5% of all churn events

Churn by Industry: cross-table JOIN of churn_events + customers to identify which verticals churn most

---

** — Monthly Customer Acquisition**
```sql
SELECT DATE_FORMAT(SIGNUP_DATE,'%Y-%m') AS MONTH, COUNT(*) AS NEW_CUSTOMERS
FROM CUSTOMERS GROUP BY MONTH ORDER BY MONTH;
```
Pairs with monthly revenue trend to reveal whether growth is from new acquisition or expansion of existing base.

---

** — High Value Customers (HAVING clause)**
```sql
SELECT CUSTOMER_ID, SUM(AMOUNT) AS TOTAL_REVENUE FROM INVOICES
GROUP BY CUSTOMER_ID HAVING SUM(AMOUNT) > 1000 ORDER BY TOTAL_REVENUE DESC;
```
`HAVING` filters post-aggregation — a classic SQL interview topic. Cannot use WHERE here because the SUM hasn't been computed yet at the WHERE evaluation stage.

---

** — Revenue Concentration (Top 20)**
Top 20 customers = $67,221 = 2% of total revenue — no Pareto concentration risk.

---

** — Country Revenue Share**
UK 25.8% | US 25.6% | Germany 24.3% | India 24.0% — remarkably even geographic distribution.

---

** — CREATE VIEW**
```sql
CREATE VIEW CUSTOMER_REVENUE AS
SELECT CUSTOMER_ID, SUM(AMOUNT) AS TOTAL_REVENUE FROM INVOICES GROUP BY CUSTOMER_ID;
```
Demonstrates production SQL thinking — views encapsulate reusable aggregation logic and are used in real SaaS data environments.

---

### SQL Strengths Summary

| SQL Concept | Query |
|---|---|
| Window function (RANK) | Q13 |
| CASE WHEN post-aggregation | Q14 |
| HAVING vs WHERE | Q20 |
| 3-table JOIN chain | Q6, Q7 |
| Percentage via subquery denominator | Q7, Q10, Q17, Q22 |
| Correlated subquery dashboard | Q4 |
| DATE_FORMAT time bucketing | Q5, Q19 |
| CREATE VIEW for reusability | Q23 |
| Multi-dimensional segmentation | Q8–Q12 |

---

## 🐍 Python Analysis

Four notebooks — The Python layer consists of four notebooks covering data preparation, revenue analytics, churn analysis, and executive reporting..

### Notebook 1: Data Preparation & EDA (01_DATA_PREP_AND_EDA.ipynb)

**Libraries:** `pandas`, `numpy`, `matplotlib`

**Data loading:** All 7 tables loaded from CSV using `pd.read_csv()`. Dataset shapes validated.

**Validation loop:** Ran across all 7 tables:
```python
for NAME, DF in TABLES.items():
    print(DF.isnull().sum().sum())  # missing values
    print(DF.duplicated().sum())    # duplicates
```

**Data type audit:** Printed `.dtypes` for all tables — date columns flagged for conversion in downstream notebooks.

**Revenue validation:**
```python
TOTAL_REVENUE = INVOICES[INVOICES["status"]=="paid"]["amount"].sum()
```
Result: **$3,462,189** — cross-validated against SQL and Excel.

**EDA visualizations:**
- Customers by Country (bar chart)
- Customers by Industry (bar chart)
- Customers by Company Size (bar chart)
- Customer Acquisition Channels (bar chart)
- Invoice Amount Distribution (histogram — reveals payment tiers: $19, $49, $99, $190, $490, $990 matching plan prices)
- Payment Status distribution
- Plan Distribution (subscription-level)

**Key findings:** No material duplicate issues were identified, and missing values were reviewed before downstream analysis.. Paid invoices dominate. Active subscriptions exceed churned. Premium and Pro plans significant in adoption. Dataset ready for revenue intelligence.

---

### Notebook 2: Revenue Intelligence (02_REVENUE_INTELLIGENCE.ipynb)

**Libraries:** `pandas`, `numpy`, `matplotlib`

**Analytical dataset:** 4-table merge mirroring the SQL schema:
```python
REVENUE_DATA = (
    INVOICES
    .merge(CUSTOMERS, on="customer_id", how="left")
    .merge(SUBSCRIPTIONS, on="customer_id", how="left")
    .merge(SUBSCRIPTION_PLANS, on="plan_id", how="left")
)
```

**Monthly Revenue Trend:**
```python
REVENUE_DATA["YEAR_MONTH"] = REVENUE_DATA["invoice_date"].dt.to_period("M")
MONTHLY_REVENUE = REVENUE_DATA[REVENUE_DATA["status_x"]=="paid"].groupby("YEAR_MONTH")["amount"].sum()
```
Visualized as a line chart — consistent upward trend Jan 2023 → Nov 2025.

**Revenue by Plan:**
Premium → Pro → Basic → Free (descending). Plan share percentages computed using:
```python
PLAN_SHARE = (PLAN_REVENUE / PLAN_REVENUE.sum()) * 100
```

**Revenue by Country:** UK → US → Germany → India

**Revenue by Industry:** Health → Finance → Tech → Retail

**Revenue by Acquisition Channel:** Referral → Organic → Ads

**Top 10 Customers:** Ranked bar chart — revenue highly distributed, top customer below $3,500.

**Revenue Concentration:**
```python
TOP20_SHARE = (TOP20_REVENUE / TOTAL_REVENUE) * 100
# Result: 2% — no concentration risk
```

**MRR/ARR Validation:**
```python
ACTIVE_SUBSCRIPTIONS = SUBSCRIPTIONS.merge(SUBSCRIPTION_PLANS, on="plan_id")
MRR = ACTIVE_SUBSCRIPTIONS[ACTIVE_SUBSCRIPTIONS["status"]=="active"]["price"].sum()
ARR = MRR * 12
# MRR: $2,617,480.67 | ARR: $31,409,768
```
Python output matches SQL and Excel — three-layer cross-validation confirmed.

---

### Notebook 3: Customer & Churn Analysis (03_CUSTOMER_AND_CHURN_ANALYSIS.ipynb)

**Libraries:** `pandas`, `numpy`, `matplotlib`

**Customer Funnel:**
```python
TOTAL_CUSTOMERS = CUSTOMERS["customer_id"].nunique()          # 25,000
REVENUE_CUSTOMERS = INVOICES["customer_id"].nunique()         # 8,027
ACTIVE_REVENUE_CUSTOMERS = (revenue_subscriptions filtered to active) # 5,469
CHURNED_REVENUE_CUSTOMERS = (revenue_subscriptions filtered to churned) # 2,558
```
Funnel chart: 25,000 → 8,027 → 5,469

**Churn Rate:**
```python
CHURN_RATE = (CHURNED_REVENUE_CUSTOMERS / REVENUE_CUSTOMERS) * 100
# Result: 31.87%
```

**Churn Reason Analysis:**
```python
CHURN_EVENTS["churn_reason"].value_counts()
# product_fit: 4,616 | other: 4,526 | budget: 4,452 | competitor: 4,313 | price: 4,006
```
Bar chart of top churn reasons — product_fit is #1 driver.

**Customer Segmentation:**
- Industry distribution: Tech 6,352 | Retail 6,265 | Finance 6,214 | Health 6,169
- Company size: Small 8,444 | Medium 8,348 | Large 8,208

**Revenue Per Active Customer:**
```python
REVENUE_PER_ACTIVE_CUSTOMER = TOTAL_REVENUE / ACTIVE_REVENUE_CUSTOMERS
# Result: $633.06
```

**Retention Rate:** 68.13% (Active Revenue Customers / Total Revenue Customers)

**KPI Summary DataFrame:** Revenue Customers 8,027 | Active 5,469 | Churned 2,558 | Churn Rate 31.87% | RPAC $633.06 | Estimated NRR 58% | Estimated GRR 53%

---

### Notebook 4: Executive Insights & Recommendations (04_EXECUTIVE_INSIGHTS.ipynb)

**Libraries:** `pandas`, `matplotlib`

**Executive KPI DataFrame (hardcoded for presentation):**
```python
EXECUTIVE_KPIS = pd.DataFrame({
    "KPI": ["Total Revenue", "Revenue Customers", "Active Customers", "Churned Customers",
            "Churn Rate", "MRR", "ARR", "Revenue Per Active Customer", "Estimated NRR", "Estimated GRR"],
    "VALUE": [3462189, 8027, 5469, 2558, "32%", 2617481, 31409768, 633.06, "58%", "53%"]
})
```
Exported to `executive_kpi_summary.csv`.
Executive KPI scorecard generated from previously calculated project metrics and exported for stakeholder reporting.

**Executive Scorecard:**
| Area | Status |
|---|---|
| Revenue | Strong |
| Growth | Strong |
| Customer Base | Strong |
| Retention | Needs Improvement |

**Revenue driver analysis:** Plan, country, industry, channel breakdowns visualized.

**5 Strategic Recommendations documented in-notebook (detailed in Recommendations section below).**

---

## 📈 Key KPIs

| KPI | Value | Formula | Benchmark | Interpretation |
|---|---|---|---|---|
| **Total Revenue** | $3,462,189 | SUM(paid invoices) | N/A | 35-month cumulative recognized revenue |
| **MRR** | $2,617,480.67 | SUM(active plan prices) | Grows MoM in healthy business | Strong monthly recurring base |
| **ARR** | $31,409,768 | MRR × 12 | Primary investor metric | Annualized run rate — $31.4M |
| **Revenue Customers** | 8,027 | DISTINCT customers in invoices | N/A | 32% of total customer base generates revenue |
| **Active Revenue Customers** | 5,469 | Subscriptions status=active ∩ invoiced | N/A | Core recurring revenue base |
| **Churned Revenue Customers** | 2,558 | Subscriptions status=churned ∩ invoiced | N/A | Revenue-generating customers lost |
| **Customer Churn Rate** | 31.87% | Churned ÷ Revenue Customers | <5% monthly / <20% annual for SaaS | Elevated — primary business challenge |
| **Revenue Per Active Customer** | $633.06 | Total Revenue ÷ Active Customers | Varies by segment | Strong monetization of active base |
| **Avg Revenue Per Customer** | $431.21 | Total Revenue ÷ All Revenue Customers | Varies | Lower than RPAC — diluted by churned base |
| **Estimated NRR** | 58% | Net Revenue Retention | >100% = world-class; >80% = healthy | Critically low — revenue contracting |
| **Estimated GRR** | 53% | Gross Revenue Retention | >80% = healthy floor | Critically low — urgent retention priority |
| **Top 10 Revenue Share** | 1% | Top 10 Customer Revenue ÷ Total | <20% = diversified | Excellent — no concentration risk |
| **Top 20 Revenue Share** | 2% | Top 20 Customer Revenue ÷ Total | <30% = healthy | Excellent — highly distributed |

---

## 🔍 Key Insights

**HIGH IMPACT**

1. **Estimated NRR at 58% signals the business is shrinking from its existing customer base** — Every $1.00 of revenue from a customer cohort is contracting to $0.58 in the following period. Until NRR exceeds 100%, new acquisition is required just to maintain flat revenue, not to grow. This is the #1 executive priority.

   *Evidence: Estimated NRR 58%, GRR 53% — cross-validated across Excel KPI_Model and Python NB4. Benchmark: top-quartile SaaS companies often achieve NRR above 120%; this project’s Estimated NRR of 58% indicates significant retention challenges..*

2. **Product fit is the #1 churn driver at 4,616 events (21.5% of all churn)** — This is not a pricing problem or a competitive loss — it's a product-market fit signal. Customers are leaving because the product doesn't solve their problem adequately. The highest-ROI retention fix is improving onboarding and feature adoption, not discounting.

   *Evidence: Churn_events breakdown — product_fit 4,616 > other 4,526 > budget 4,452 > competitor 4,313 > price 4,006.*

3. **Revenue grew 7.1× over 35 months but churn is accelerating the treadmill** — Revenue expanded from $21,894 (Jan 2023) to $155,676 (Nov 2025). This is genuine growth. But with 31.87% churn rate, the business is replacing ~32% of its revenue customers every cycle, compressing the NRR below 100%.

   *Evidence: Monthly_Trend pivot — 35 months of data; Customer_KPI churn rate 31.87%.*

4. **Revenue concentration is remarkably diversified — but this also means no anchor customers** — Top 10 customers = 1% of revenue; Top 20 = 2%. No single customer loss is catastrophic. However, the revenue is highly diversified across customers, reducing dependency on any single account also means no high-ARR expansion opportunities in the current base.

   *Evidence: Revenue_Concentration sheet — Top 10: $34,254; Top 20: $67,221 of $3,462,189 total.*

**MEDIUM IMPACT**

5. **Referral is the highest-revenue acquisition channel** — Referral generates $1,180,334 vs Organic $1,164,769 vs Ads $1,106,349. The gap is narrow, but Referral generates the highest revenue ($1.18M), suggesting it may be one of the most effective acquisition channels in the dataset. Scaling the referral program should be prioritized over increasing ad spend.

6. **Health is the #1 revenue industry despite not being the largest customer segment** — Health generates $884,337 with only 6,169 customers vs Tech's 6,352 customers generating $857,314. Health generates the highest total revenue despite not being the largest customer segment, making it a promising industry for further investigation. — a signal to expand Health vertical penetration.

7. **Premium plan drives the most revenue ($1.24M) — but most customers are not on Premium** — This gap between revenue dominance and customer count dominance suggests a significant upsell opportunity. Identifying Basic and Pro customers with Premium-plan behavior patterns could unlock meaningful MRR expansion.

8. **The January step-change in 2024 ($97K from $62K in December 2023) suggests a cohort expansion event** — Revenue nearly doubled MoM in Jan 2024. This is worth investigating as a learnable growth playbook — what drove that cohort activation?

**LOW IMPACT**

9. **Company size distribution is nearly uniform (Small 8,444 / Medium 8,348 / Large 8,208)** — No company size dominates. GTM strategy should be neutral across sizes until revenue-per-size data reveals which produces highest LTV.

10. **Geographic revenue distribution is almost perfectly even across 4 markets** — UK $892K / US $885K / Germany $843K / India $831K. No market dependency risk, but also no dominant market to double down on. UK's marginal lead ($7K over US) doesn't justify a significant strategic reallocation.

---

## 💡 Recommendations

| # | Action | Expected Impact | Priority | Owner |
|---|---|---|---|---|
| 1 | Build structured onboarding program targeting the product_fit churn driver — guided setup, feature checklists, 30-day success milestones | Reduce churn rate from 32% toward 20%; direct improvement to Estimated NRR | HIGH | Product, Customer Success |
| 2 | Launch Basic-to-Premium upgrade campaign for Medium Value customers showing high invoice frequency | Increase MRR without new acquisition; target NRR above 80% | HIGH | Sales, CSM |
| 3 | Expand referral acquisition program with incentives for existing customers | Lower CAC, acquire higher-LTV customers; referral already leads channel revenue at $1.18M | HIGH | Marketing, Growth |
| 4 | Build a customer health scoring system using invoice frequency, plan tier, and churn risk signals from plan_changes data | Enable proactive CS intervention before churn; reduce churned revenue customers below 2,000 | MEDIUM | Revenue Operations, Data |
| 5 | Invest in Health industry expansion — Health generates the highest revenue per customer despite not being the largest segment | Improve revenue efficiency; model Health ICP for outbound targeting | MEDIUM | Sales, Marketing |
| 6 | Analyze the January 2024 revenue step-change ($62K → $97K) to identify the repeatable growth driver | Replicate the cohort expansion event — if it was a campaign, GTM motion, or external factor, it can be scaled | MEDIUM | Revenue Operations, Marketing |
| 7 | Activate the PLAN_CHANGES table analysis to quantify upgrade vs downgrade revenue flows | Separate voluntary upgrades from forced downgrades; calculate true expansion MRR vs contraction MRR | LOW | Data, RevOps |
| 8 | Analyze failed payment records in the PAYMENTS table to separate involuntary churn from deliberate cancellations | Identify customers lost to billing failure rather than dissatisfaction; involuntary churn is recoverable with dunning | LOW | Finance, Engineering |

---

## 📊 Dashboard Overview

**Tableau dashboard currently under development.**

The Excel Executive_Dashboard sheet currently serves as the business reporting layer with 6 charts:

- **Revenue by Industry** — Health leads; all four verticals within $45K range
- **Revenue by Country** — UK leads; all four markets within $62K range — remarkably even
- **Revenue by Acquisition Channel** — Referral > Organic > Ads; narrow gaps suggest channel efficiency is similar
- **Revenue by Plan** — Premium > Pro > Basic > Free; clear premium tier monetization
- **Top Churn Reasons** — product_fit leads, followed by other, budget, competitor, price
- **Monthly Revenue Trend** — 35-month upward trend, Jan 2023 → Nov 2025

Planned Tableau views: Executive KPI strip | Monthly MRR trend with MoM labels | Churn Reason Pareto | Customer Funnel | Geographic revenue heatmap | Revenue by Plan waterfall

---

## 📂 Repository Structure

```
saas-revenue-intelligence/
│
├── 01_Data/
│   ├── customers.csv
│   ├── invoices.csv
│   ├── payments.csv
│   ├── subscriptions.csv
│   ├── subscription_plans.csv
│   ├── PLAN_CHANGES.csv
│   └── Churn_events.csv
│
├── 02_Excel/
│   └── SaaS_Revenue_Intelligence.xlsx     # 13-sheet workbook
│
├── 03_SQL/
│   └── SAAS_REVENUE_INTELLIGENCE.sql      # 35+ production-grade queries
│
├── 04_Python/
│   ├── 01_DATA_PREP_AND_EDA.ipynb
│   ├── 02_REVENUE_INTELLIGENCE.ipynb
│   ├── 03_CUSTOMER_AND_CHURN_ANALYSIS.ipynb
│   └── 04_EXECUTIVE_INSIGHTS.ipynb
│
├── 05_Dashboard/
│   └── [Tableau .twbx — in development]
│
├── 06_Reports/
│   └── executive_kpi_summary.csv          # Exported from NB4
│
└── README.md
```

---

## 🚀 Business Impact

| Deliverable | Impact |
|---|---|
| 35+ SQL queries | Answer revenue, churn, retention, and segmentation questions in seconds — 2–3 days of manual analyst work automated |
| 7-table relational schema | Mirrors Stripe / Chargebee / Recurly data structure — directly transferable to real SaaS environments |
| Three-layer KPI cross-validation | MRR $2.62M, ARR $31.4M, Revenue $3.46M confirmed across SQL, Python, and Excel independently |
| 35-month revenue trend | $21,894 → $155,676 — 7.1× growth documented month-by-month |
| Churn decomposition | product_fit identified as #1 driver (21.5%) — direct input to product roadmap prioritization |
| Revenue concentration analysis | Top 20 customers = 2% — confirms no single-customer business risk |
| Estimated NRR/GRR diagnosis | 58% / 53% — below-benchmark figures that define the retention improvement roadmap |

---

## 🔮 Future Improvements

1. **NRR calculation refinement** — Build a proper cohort-based NRR using PLAN_CHANGES (expansion) and CHURN_EVENTS (contraction) tables to compute true net revenue retention per monthly cohort
2. **Predictive churn model** — Logistic regression using customer attributes (industry, company_size, acquisition_channel, plan_tier, invoice frequency) to score each active customer's churn probability
3. **Involuntary churn analysis** — Segment PAYMENTS table failures by customer and timing to identify revenue lost to billing failure vs deliberate cancellation
4. **Build an interactive Tableau dashboard connected to the SaaS revenue dataset.
5. **Customer health score** — Composite scoring combining invoice recency, plan tier, payment success rate, and churn risk for CSM prioritization queue
6. **Revenue forecasting** — Time-series projection of MRR using 35-month historical trend; even a linear extrapolation would be useful for board-level planning

---
## License
MIT License — free to use, adapt, and reference with attribution.
---

Project by Sumit Kumar Gupta

[LinkedIn](https://www.linkedin.com/in/sumitgupta-analyst/)

[GitHub](https://github.com/Sumit-kr-Gupta)
