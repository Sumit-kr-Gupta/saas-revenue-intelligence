/*==========================================================
PROJECT  : SaaS Revenue Intelligence
AUTHOR   : Sumit Kumar Gupta
DATABASE : SAAS_REVENUE_INTELLIGENCE

OBJECTIVE:Analyze SaaS revenue performance, customer growth, retention,churn, subscription health,
and executive KPIs to support strategic business decisions.

CONTENTS:
  SECTION 0  - Database Setup
  SECTION 1  - Data Validation & Data Quality
  SECTION 2  - Executive Business Snapshot
  SECTION 3  - Revenue Intelligence
  SECTION 4  - Customer Intelligence
  SECTION 5  - Subscription Intelligence
  SECTION 6  - Churn Intelligence
  SECTION 7  - Growth & Cohort Intelligence
  SECTION 8  - Strategic Revenue Risk
  SECTION 9  - Advanced SQL Analytics
  SECTION 10 - Business Views
==========================================================*/

/*==========================================================
SECTION 0 — DATABASE SETUP
Business Goal:
  Initialize the database and confirm all source tables are
  present and populated before running any analysis.
Business Questions:
  1. Does the database and schema exist?
  2. Are all expected tables populated with data?
==========================================================*/
CREATE DATABASE SAAS_REVENUE_INTELLIGENCE;
USE SAAS_REVENUE_INTELLIGENCE;
SHOW TABLES;
SELECT COUNT(*) AS ROW_COUNT FROM INVOICES;
SELECT COUNT(*) AS ROW_COUNT FROM PAYMENTS;
SELECT COUNT(*) AS ROW_COUNT FROM SUBSCRIPTIONS;
SELECT COUNT(*) AS ROW_COUNT FROM SUBSCRIPTION_PLANS;
SELECT COUNT(*) AS ROW_COUNT FROM PLAN_CHANGES;
SELECT COUNT(*) AS ROW_COUNT FROM CHURN_EVENTS;
SELECT COUNT(*) AS ROW_COUNT FROM CUSTOMERS;

/*==========================================================
SECTION 1 — DATA VALIDATION & DATA QUALITY
Business Goal:
  Confirm the underlying data is clean and trustworthy before it is used to drive revenue, churn, or executive reporting.
Business Questions:
  1. Are there duplicate customer or invoice records?
  2. Are there payments, invoices, or subscriptions that fail
     to reference a valid parent record?
==========================================================*/
/*Duplicate Customers*/
SELECT CUSTOMER_ID,
COUNT(*) AS RECORDS
FROM CUSTOMERS
GROUP BY CUSTOMER_ID
HAVING COUNT(*)>1;

/*Duplicate INVOICE_ID*/
SELECT INVOICE_ID,
COUNT(*) AS RECORD_COUNT
FROM INVOICES
GROUP BY INVOICE_ID
HAVING COUNT(*) > 1
ORDER BY RECORD_COUNT DESC;

/* Payments Without a Matching Invoice */
SELECT P.PAYMENT_ID,P.INVOICE_ID
FROM PAYMENTS P
LEFT JOIN INVOICES I
ON P.INVOICE_ID = I.INVOICE_ID
WHERE I.INVOICE_ID IS NULL;

/* Subscriptions Without a Matching Plan */
SELECT S.CUSTOMER_ID,S.PLAN_ID
FROM SUBSCRIPTIONS S
LEFT JOIN SUBSCRIPTION_PLANS SP
    ON S.PLAN_ID = SP.PLAN_ID
WHERE SP.PLAN_ID IS NULL;

/*==========================================================
SECTION 2 — EXECUTIVE BUSINESS SNAPSHOT
Business Goal:
  Provide a single, high-level view of business health that executives can scan in under a minute.
Business Questions:
  1. How much revenue has the business generated overall?
  2. How many customers are active vs. churned?
  3. What is the current MRR and ARR run rate?
==========================================================*/
/*EXECUTIVE KPI DASHBOARD*/
SELECT
(SELECT SUM(AMOUNT) FROM INVOICES
WHERE STATUS='paid') AS TOTAL_REVENUE,
(SELECT COUNT(DISTINCT CUSTOMER_ID)
	FROM CUSTOMERS) AS TOTAL_CUSTOMERS,
(SELECT COUNT(DISTINCT CUSTOMER_ID)
FROM SUBSCRIPTIONS WHERE STATUS='active') AS ACTIVE_CUSTOMERS,
(SELECT COUNT(DISTINCT CUSTOMER_ID)
FROM CHURN_EVENTS) AS CHURNED_CUSTOMERS;

/*Total Revenue*/
SELECT SUM(AMOUNT) AS TOTAL_REVENUE
FROM INVOICES WHERE STATUS='paid';

/*Active , Churned Customers*/
SELECT 
(SELECT COUNT(DISTINCT CUSTOMER_ID)
FROM SUBSCRIPTIONS
WHERE STATUS = 'active') AS ACTIVE_CUSTOMERS,
(SELECT COUNT(DISTINCT CUSTOMER_ID)
FROM CHURN_EVENTS) AS CHURNED_CUSTOMERS;
     
/*Customer Distribution by Company Size*/
SELECT COMPANY_SIZE,
COUNT(DISTINCT CUSTOMER_ID) AS CUSTOMERS
FROM CUSTOMERS
GROUP BY COMPANY_SIZE
ORDER BY CUSTOMERS DESC;

/*Customer Distribution by Industry*/
SELECT INDUSTRY,
COUNT(DISTINCT CUSTOMER_ID) AS CUSTOMERS
FROM CUSTOMERS
GROUP BY INDUSTRY
ORDER BY CUSTOMERS DESC;

/*Monthly Recurring Revenue (MRR)*/
SELECT SUM(SP.PRICE) AS MRR
FROM SUBSCRIPTIONS S
JOIN SUBSCRIPTION_PLANS SP
ON S.PLAN_ID=SP.PLAN_ID
WHERE S.STATUS='active';

/*Annual Recurring Revenue (ARR)*/
SELECT SUM(SP.PRICE)*12 AS ARR
FROM SUBSCRIPTIONS S
JOIN SUBSCRIPTION_PLANS SP
ON S.PLAN_ID=SP.PLAN_ID
WHERE S.STATUS='active';

/*==========================================================
SECTION 3 — REVENUE INTELLIGENCE
Business Goal:
  Analyze where revenue comes from and identify the highest-performing products, industries, and regions.
Business Questions:
  1. Which plans generate the highest revenue?
  2. Which industries, countries, and company sizes drive
     the most revenue?
  3. Which acquisition channels perform best?
==========================================================*/
/*Monthly Revenue Trend*/
SELECT
    DATE_FORMAT(INVOICE_DATE,'%Y-%m') AS MONTH,
    SUM(AMOUNT) AS REVENUE
FROM INVOICES
WHERE STATUS='paid'
GROUP BY MONTH
ORDER BY MONTH;

/*Revenue by Plan*/
SELECT SP.PLAN_NAME,
    SUM(I.AMOUNT) AS REVENUE
FROM INVOICES I
JOIN SUBSCRIPTIONS S
    ON I.CUSTOMER_ID = S.CUSTOMER_ID
JOIN SUBSCRIPTION_PLANS SP
    ON S.PLAN_ID = SP.PLAN_ID
WHERE I.STATUS='paid'
GROUP BY SP.PLAN_NAME
ORDER BY REVENUE DESC;

/*Revenue Share by Plan*/
SELECT
    SP.PLAN_NAME,
    ROUND(
        SUM(I.AMOUNT)*100/
        (SELECT SUM(AMOUNT)
         FROM INVOICES
         WHERE STATUS='paid'),
         2
    ) AS REVENUE_SHARE_PCT
FROM INVOICES I
JOIN SUBSCRIPTIONS S
    ON I.CUSTOMER_ID=S.CUSTOMER_ID
JOIN SUBSCRIPTION_PLANS SP
    ON S.PLAN_ID=SP.PLAN_ID
GROUP BY SP.PLAN_NAME;

/*Revenue by Country*/
SELECT C.COUNTRY,SUM(I.AMOUNT) AS REVENUE
FROM CUSTOMERS C JOIN INVOICES I
ON C.CUSTOMER_ID=I.CUSTOMER_ID
WHERE I.STATUS='paid'
GROUP BY C.COUNTRY ORDER BY REVENUE DESC;

/* Country Revenue Share */
SELECT COUNTRY,
ROUND(SUM(I.AMOUNT) * 100 /(SELECT SUM(AMOUNT) FROM INVOICES WHERE STATUS = 'paid'),2) AS REVENUE_SHARE_PCT
FROM CUSTOMERS C JOIN INVOICES I
    ON C.CUSTOMER_ID = I.CUSTOMER_ID
WHERE I.STATUS = 'paid'
GROUP BY COUNTRY
ORDER BY REVENUE_SHARE_PCT DESC;

/*Revenue by Industry*/
SELECT C.INDUSTRY, SUM(I.AMOUNT) AS REVENUE FROM CUSTOMERS C
JOIN INVOICES I ON C.CUSTOMER_ID=I.CUSTOMER_ID
WHERE I.STATUS='paid'
GROUP BY C.INDUSTRY ORDER BY REVENUE DESC;

/*INDUSTRY REVENUE SHARE*/
SELECT INDUSTRY,
ROUND(SUM(I.AMOUNT)*100/
(SELECT SUM(AMOUNT)
FROM INVOICES WHERE STATUS='paid'),2) AS REVENUE_SHARE_PCT
FROM CUSTOMERS C
JOIN INVOICES I
ON C.CUSTOMER_ID=I.CUSTOMER_ID
WHERE I.STATUS='paid'
GROUP BY INDUSTRY
ORDER BY REVENUE_SHARE_PCT DESC;

/*REVENUE BY COMPANY SIZE*/
SELECT C.COMPANY_SIZE,
SUM(I.AMOUNT) AS REVENUE
FROM CUSTOMERS C
JOIN INVOICES I
ON C.CUSTOMER_ID = I.CUSTOMER_ID
WHERE I.STATUS='paid'
GROUP BY C.COMPANY_SIZE
ORDER BY REVENUE DESC;

/*Revenue by Acquisition Channel*/
SELECT C.ACQUISITION_CHANNEL, SUM(I.AMOUNT) AS REVENUE
FROM CUSTOMERS C JOIN INVOICES I
ON C.CUSTOMER_ID=I.CUSTOMER_ID
WHERE I.STATUS='paid'
GROUP BY C.ACQUISITION_CHANNEL
ORDER BY REVENUE DESC;

/*==========================================================
SECTION 4 — CUSTOMER INTELLIGENCE
Business Goal:
  Understand which customers drive the most value so the
  business can prioritize retention and account growth.
Business Questions:
  1. Who are the top customers by revenue?
  2. How is the customer base segmented by value?
  3. What is the average revenue per customer?
==========================================================*/

/*Top 10 Customers by Revenue*/
SELECT CUSTOMER_ID,
SUM(AMOUNT) AS REVENUE
FROM INVOICES 
WHERE STATUS='paid'
GROUP BY CUSTOMER_ID
ORDER BY REVENUE DESC LIMIT 10;

/*Customer Lifetime Revenue*/
SELECT
    CUSTOMER_ID,
    COUNT(*) AS TOTAL_INVOICES,
    SUM(AMOUNT) AS LIFETIME_REVENUE
FROM INVOICES
GROUP BY CUSTOMER_ID;

/*CUSTOMER REVENUE RANKING*/
SELECT CUSTOMER_ID,SUM(AMOUNT) AS TOTAL_REVENUE,
RANK() OVER (ORDER BY SUM(AMOUNT) DESC) AS CUSTOMER_RANK
FROM INVOICES GROUP BY CUSTOMER_ID;

/*Customer Segmentation*/
 SELECT CUSTOMER_ID,
SUM(AMOUNT) AS TOTAL_REVENUE,
CASE WHEN SUM(AMOUNT) >= 1000 THEN 'HIGH VALUE'
     WHEN SUM(AMOUNT) >= 500 THEN 'MEDIUM VALUE'
ELSE 'LOW VALUE'
END AS CUSTOMER_SEGMENT
FROM INVOICES
GROUP BY CUSTOMER_ID;

/*AVERAGE REVENUE PER CUSTOMER*/
SELECT ROUND(
SUM(AMOUNT) /COUNT(DISTINCT CUSTOMER_ID),2) AS AVG_REVENUE_PER_CUSTOMER
FROM INVOICES
WHERE STATUS='paid';

/* High Value Customers */
SELECT CUSTOMER_ID,
SUM(AMOUNT) AS TOTAL_REVENUE
FROM INVOICES
GROUP BY CUSTOMER_ID
HAVING SUM(AMOUNT) > 1000
ORDER BY TOTAL_REVENUE DESC;

/*==========================================================
SECTION 5 — SUBSCRIPTION INTELLIGENCE
Business Goal:
  Track the health of the subscription base, including plan mix, expansion, and contraction dynamics.
Business Questions:
  1. What is the mix of customers across plans?
  2. How much revenue is gained through upgrades vs. lost
     through downgrades?
  3. Which plans carry the healthiest margins?
==========================================================*/
/*Plan Mix Analysis*/
SELECT SP.PLAN_NAME,COUNT(*) AS CUSTOMERS
FROM SUBSCRIPTIONS S
JOIN SUBSCRIPTION_PLANS SP
ON S.PLAN_ID = SP.PLAN_ID
GROUP BY SP.PLAN_NAME
ORDER BY CUSTOMERS DESC;

/*Active vs Churned Customers*/
SELECT STATUS, COUNT(DISTINCT CUSTOMER_ID) AS CUSTOMERS
FROM SUBSCRIPTIONS GROUP BY STATUS;

/*Expansion Revenue*/
SELECT
DATE_FORMAT(CHANGE_DATE,'%Y-%m') AS MONTH,
COUNT(*) AS UPGRADES,
SUM(P2.PRICE-P1.PRICE) AS EXPANSION_REVENUE
FROM PLAN_CHANGES PC
JOIN SUBSCRIPTION_PLANS P1
ON PC.OLD_PLAN_ID=P1.PLAN_ID
JOIN SUBSCRIPTION_PLANS P2
ON PC.NEW_PLAN_ID=P2.PLAN_ID
WHERE P2.PRICE>P1.PRICE
GROUP BY MONTH
ORDER BY MONTH;

/*Contraction Revenue*/
SELECT DATE_FORMAT(CHANGE_DATE,'%Y-%m') AS MONTH,
COUNT(*) AS DOWNGRADES,
SUM(P1.PRICE-P2.PRICE) AS CONTRACTION_REVENUE
FROM PLAN_CHANGES PC
JOIN SUBSCRIPTION_PLANS P1
ON PC.OLD_PLAN_ID=P1.PLAN_ID
JOIN SUBSCRIPTION_PLANS P2
ON PC.NEW_PLAN_ID=P2.PLAN_ID
WHERE P2.PRICE<P1.PRICE
GROUP BY MONTH
ORDER BY MONTH;

/* Revenue & List Price by Plan — NOT MARGIN
   NOTE: This schema has no cost/COGS table (hosting cost, support cost,
   payment-processing fees, etc.), so true margin cannot be computed from
   this data. Renamed from "Margin by Plan" because that label overstated
   what the query does — it shows revenue and list price, not profitability.
   Fix for a real margin view: add a PLAN_COGS or COST_PER_CUSTOMER table
   and compute (REVENUE - COST) / REVENUE per plan. Until that table exists,
   do not report this as "margin" in the README or to stakeholders. */
SELECT SP.PLAN_NAME,
SUM(I.AMOUNT)   AS REVENUE,
AVG(SP.PRICE)   AS PLAN_PRICE
FROM SUBSCRIPTIONS S
JOIN SUBSCRIPTION_PLANS SP
    ON S.PLAN_ID = SP.PLAN_ID
JOIN INVOICES I
    ON S.CUSTOMER_ID = I.CUSTOMER_ID
WHERE I.STATUS = 'paid'
GROUP BY SP.PLAN_NAME
ORDER BY REVENUE DESC;

/*==========================================================
SECTION 6 — CHURN INTELLIGENCE
Business Goal:
  Understand why and where customers churn so the business
  can prioritize retention initiatives.
Business Questions:
  1. What are the leading reasons customers churn?
  2. Which industries see the most churn, and is that
     difference statistically significant or just noise?
  3. How does churn trend across signup cohorts?
  4. How much churn is involuntary (failed payments) vs.
     voluntary (customer choice), since the two need
     completely different fixes?
==========================================================*/
/*Churn by Reason*/
SELECT CHURN_REASON, COUNT(*) AS CHURN_COUNT
FROM CHURN_EVENTS GROUP BY CHURN_REASON ORDER BY CHURN_COUNT DESC;

/*CHURN SHARE BY REASON*/
SELECT
    CHURN_REASON,
    COUNT(*) AS CHURN_COUNT,
    ROUND(
        COUNT(*)*100/
        (SELECT COUNT(*) FROM CHURN_EVENTS),
        2
    ) AS CHURN_SHARE_PCT
FROM CHURN_EVENTS
GROUP BY CHURN_REASON
ORDER BY CHURN_COUNT DESC;

/*CHURN BY INDUSTRY*/
SELECT
    C.INDUSTRY,
    COUNT(DISTINCT CE.CUSTOMER_ID) AS CHURNED_CUSTOMERS
FROM CHURN_EVENTS CE
JOIN CUSTOMERS C
    ON CE.CUSTOMER_ID=C.CUSTOMER_ID
GROUP BY C.INDUSTRY
ORDER BY CHURNED_CUSTOMERS DESC;

/* Churn Type */
SELECT CHURN_REASON,
COUNT(*) AS CUSTOMERS
FROM CHURN_EVENTS
GROUP BY CHURN_REASON
ORDER BY CUSTOMERS DESC;

/* Cohort Churn */
SELECT DATE_FORMAT(C.SIGNUP_DATE, '%Y-%m') AS COHORT,
COUNT(DISTINCT CE.CUSTOMER_ID)      AS CHURNED_CUSTOMERS
FROM CUSTOMERS C
LEFT JOIN CHURN_EVENTS CE
    ON C.CUSTOMER_ID = CE.CUSTOMER_ID
GROUP BY COHORT
ORDER BY COHORT;

/* Churn by Industry — Chi-Square Test for Independence (contribution table)
   H0: churn is independent of industry (industry differences are just noise)
   Observed churned/active per industry vs. expected counts if every
   industry churned at the OVERALL churn rate. A large contribution means
   that industry is the one driving any real (non-random) effect.
   This is computed directly in SQL since a chi-square statistic is just
   arithmetic — SUM((observed-expected)^2/expected). No Python needed here;
   Python would only be needed to convert the final statistic into a p-value. */
WITH INDUSTRY_CHURN AS (
    SELECT C.INDUSTRY,
           COUNT(DISTINCT C.CUSTOMER_ID)  AS TOTAL_CUSTOMERS,
           COUNT(DISTINCT CE.CUSTOMER_ID) AS CHURNED_CUSTOMERS
    FROM CUSTOMERS C
    LEFT JOIN CHURN_EVENTS CE
        ON C.CUSTOMER_ID = CE.CUSTOMER_ID
    GROUP BY C.INDUSTRY
),
OVERALL AS (
    SELECT SUM(TOTAL_CUSTOMERS)   AS GRAND_TOTAL,
           SUM(CHURNED_CUSTOMERS) AS GRAND_CHURNED
    FROM INDUSTRY_CHURN
),
EXPECTED AS (
    SELECT
        IC.INDUSTRY,
        IC.TOTAL_CUSTOMERS,
        IC.CHURNED_CUSTOMERS                         AS OBSERVED_CHURNED,
        (IC.TOTAL_CUSTOMERS - IC.CHURNED_CUSTOMERS)  AS OBSERVED_ACTIVE,
        IC.TOTAL_CUSTOMERS * (O.GRAND_CHURNED / O.GRAND_TOTAL)       AS EXPECTED_CHURNED,
        IC.TOTAL_CUSTOMERS * (1 - (O.GRAND_CHURNED / O.GRAND_TOTAL)) AS EXPECTED_ACTIVE
    FROM INDUSTRY_CHURN IC
    CROSS JOIN OVERALL O
)
SELECT
    INDUSTRY,
    TOTAL_CUSTOMERS,
    OBSERVED_CHURNED,
    ROUND(EXPECTED_CHURNED, 2) AS EXPECTED_CHURNED,
    OBSERVED_ACTIVE,
    ROUND(EXPECTED_ACTIVE, 2)  AS EXPECTED_ACTIVE,
    ROUND(
        POWER(OBSERVED_CHURNED - EXPECTED_CHURNED, 2) / NULLIF(EXPECTED_CHURNED, 0)
      + POWER(OBSERVED_ACTIVE  - EXPECTED_ACTIVE,  2) / NULLIF(EXPECTED_ACTIVE, 0)
    , 4) AS CHI_SQUARE_CONTRIBUTION
FROM EXPECTED
ORDER BY CHI_SQUARE_CONTRIBUTION DESC;

/* Churn by Industry — Total Chi-Square Statistic + Degrees of Freedom
   Sum the contributions above, then compare CHI_SQUARE_STATISTIC against a
   chi-square critical value table at DEGREES_OF_FREEDOM and alpha = 0.05
   (e.g., df=5 -> critical value 11.07). Statistic > critical value means
   the industry differences in churn are unlikely to be random noise. */
WITH INDUSTRY_CHURN AS (
    SELECT C.INDUSTRY,
           COUNT(DISTINCT C.CUSTOMER_ID)  AS TOTAL_CUSTOMERS,
           COUNT(DISTINCT CE.CUSTOMER_ID) AS CHURNED_CUSTOMERS
    FROM CUSTOMERS C
    LEFT JOIN CHURN_EVENTS CE
        ON C.CUSTOMER_ID = CE.CUSTOMER_ID
    GROUP BY C.INDUSTRY
),
OVERALL AS (
    SELECT SUM(TOTAL_CUSTOMERS)   AS GRAND_TOTAL,
           SUM(CHURNED_CUSTOMERS) AS GRAND_CHURNED
    FROM INDUSTRY_CHURN
),
EXPECTED AS (
    SELECT
        IC.CHURNED_CUSTOMERS                         AS OBSERVED_CHURNED,
        (IC.TOTAL_CUSTOMERS - IC.CHURNED_CUSTOMERS)  AS OBSERVED_ACTIVE,
        IC.TOTAL_CUSTOMERS * (O.GRAND_CHURNED / O.GRAND_TOTAL)       AS EXPECTED_CHURNED,
        IC.TOTAL_CUSTOMERS * (1 - (O.GRAND_CHURNED / O.GRAND_TOTAL)) AS EXPECTED_ACTIVE
    FROM INDUSTRY_CHURN IC
    CROSS JOIN OVERALL O
)
SELECT
    ROUND(SUM(
        POWER(OBSERVED_CHURNED - EXPECTED_CHURNED, 2) / NULLIF(EXPECTED_CHURNED, 0)
      + POWER(OBSERVED_ACTIVE  - EXPECTED_ACTIVE,  2) / NULLIF(EXPECTED_ACTIVE, 0)
    ), 4) AS CHI_SQUARE_STATISTIC,
    (SELECT COUNT(*) FROM INDUSTRY_CHURN) - 1 AS DEGREES_OF_FREEDOM
FROM EXPECTED;

/* Involuntary vs. Voluntary Churn
   Involuntary = the customer had a failed payment on record before/at
   churn (billing problem, not a decision to leave — fixable with dunning
   / card retry logic). Voluntary = churned with no failed payment on
   file (a product/pricing/fit decision). This split matters because the
   two require completely different remediation: retry/recovery flows
   vs. retention or win-back campaigns. */
WITH CHURNED_PAYMENT_STATUS AS (
    SELECT CE.CUSTOMER_ID,
           MAX(CASE WHEN P.STATUS = 'failed' THEN 1 ELSE 0 END) AS HAD_FAILED_PAYMENT
    FROM CHURN_EVENTS CE
    JOIN INVOICES I
        ON CE.CUSTOMER_ID = I.CUSTOMER_ID
    JOIN PAYMENTS P
        ON I.INVOICE_ID = P.INVOICE_ID
    GROUP BY CE.CUSTOMER_ID
)
SELECT
    CASE WHEN HAD_FAILED_PAYMENT = 1 THEN 'INVOLUNTARY (PAYMENT FAILURE)'
         ELSE 'VOLUNTARY' END AS CHURN_TYPE,
    COUNT(*) AS CHURNED_CUSTOMERS,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS SHARE_PCT
FROM CHURNED_PAYMENT_STATUS
GROUP BY CHURN_TYPE
ORDER BY CHURNED_CUSTOMERS DESC;

/*==========================================================
SECTION 7 — GROWTH & COHORT INTELLIGENCE
Business Goal:
  Track how the customer base grows over time and how different signup cohorts perform.
Business Questions:
  1. How many new customers are acquired each month?
  2. How does revenue evolve within each signup cohort?
  3. What is each cohort's actual Net Revenue Retention (NRR)
     and Gross Revenue Retention (GRR) — the single number an
     investor or exec asks for first?
  4. Which acquisition channels bring in the highest value
     customers, and where are we losing signups before they
     ever become paying customers?
==========================================================*/
/*MONTHLY CUSTOMER ACQUISITION*/
SELECT DATE_FORMAT(SIGNUP_DATE,'%Y-%m') AS MONTH,
COUNT(*) AS NEW_CUSTOMERS
FROM CUSTOMERS
GROUP BY MONTH
ORDER BY MONTH;

/* Signup Cohorts */
SELECT DATE_FORMAT(SIGNUP_DATE, '%Y-%m') AS SIGNUP_COHORT,
COUNT(*)AS CUSTOMERS
FROM CUSTOMERS
GROUP BY SIGNUP_COHORT
ORDER BY SIGNUP_COHORT;

/* Cohort Revenue */
SELECT DATE_FORMAT(C.SIGNUP_DATE, '%Y-%m') AS COHORT,
DATE_FORMAT(I.INVOICE_DATE, '%Y-%m') AS REVENUE_MONTH,
SUM(I.AMOUNT)AS REVENUE
FROM CUSTOMERS C
JOIN INVOICES I
    ON C.CUSTOMER_ID = I.CUSTOMER_ID
WHERE I.STATUS = 'paid'
GROUP BY COHORT, REVENUE_MONTH
ORDER BY COHORT, REVENUE_MONTH;
 
/* Acquisition Channels */
SELECT ACQUISITION_CHANNEL,
COUNT(*)AS CUSTOMERS,
AVG(SP.PRICE)AS AVG_PLAN_PRICE
FROM CUSTOMERS C
JOIN SUBSCRIPTIONS S
    ON C.CUSTOMER_ID = S.CUSTOMER_ID
JOIN SUBSCRIPTION_PLANS SP
    ON S.PLAN_ID = SP.PLAN_ID
GROUP BY ACQUISITION_CHANNEL;

/* Cohort Net Revenue Retention (NRR) & Gross Revenue Retention (GRR)
   ---------------------------------------------------------------
   THE ACTUAL FORMULA:
     NRR = (Starting MRR + Expansion - Contraction - Churned MRR) / Starting MRR
     GRR = (Starting MRR - Contraction - Churned MRR) / Starting MRR   [capped at 100% by construction, since expansion is excluded]*/
WITH FIRST_PLAN_CHANGE AS (
    SELECT PC.CUSTOMER_ID, PC.OLD_PLAN_ID,
           ROW_NUMBER() OVER (PARTITION BY PC.CUSTOMER_ID ORDER BY PC.CHANGE_DATE ASC) AS RN
    FROM PLAN_CHANGES PC
),
STARTING_PLAN AS (
    SELECT S.CUSTOMER_ID,
           COALESCE(FPC.OLD_PLAN_ID, S.PLAN_ID) AS STARTING_PLAN_ID
    FROM SUBSCRIPTIONS S
    LEFT JOIN FIRST_PLAN_CHANGE FPC
        ON S.CUSTOMER_ID = FPC.CUSTOMER_ID AND FPC.RN = 1
),
STARTING_MRR AS (
    SELECT DATE_FORMAT(C.SIGNUP_DATE, '%Y-%m') AS COHORT,
           SUM(SP.PRICE) AS STARTING_MRR
    FROM CUSTOMERS C
    JOIN STARTING_PLAN SPX
        ON C.CUSTOMER_ID = SPX.CUSTOMER_ID
    JOIN SUBSCRIPTION_PLANS SP
        ON SPX.STARTING_PLAN_ID = SP.PLAN_ID
    GROUP BY COHORT
),
EXPANSION AS (
    SELECT DATE_FORMAT(C.SIGNUP_DATE, '%Y-%m') AS COHORT,
           SUM(P2.PRICE - P1.PRICE) AS EXPANSION_MRR
    FROM PLAN_CHANGES PC
    JOIN CUSTOMERS C ON PC.CUSTOMER_ID = C.CUSTOMER_ID
    JOIN SUBSCRIPTION_PLANS P1 ON PC.OLD_PLAN_ID = P1.PLAN_ID
    JOIN SUBSCRIPTION_PLANS P2 ON PC.NEW_PLAN_ID = P2.PLAN_ID
    WHERE P2.PRICE > P1.PRICE
    GROUP BY COHORT
),
CONTRACTION AS (
    SELECT DATE_FORMAT(C.SIGNUP_DATE, '%Y-%m') AS COHORT,
           SUM(P1.PRICE - P2.PRICE) AS CONTRACTION_MRR
    FROM PLAN_CHANGES PC
    JOIN CUSTOMERS C ON PC.CUSTOMER_ID = C.CUSTOMER_ID
    JOIN SUBSCRIPTION_PLANS P1 ON PC.OLD_PLAN_ID = P1.PLAN_ID
    JOIN SUBSCRIPTION_PLANS P2 ON PC.NEW_PLAN_ID = P2.PLAN_ID
    WHERE P2.PRICE < P1.PRICE
    GROUP BY COHORT
),
CHURNED AS (
    SELECT DATE_FORMAT(C.SIGNUP_DATE, '%Y-%m') AS COHORT,
           SUM(SP.PRICE) AS CHURNED_MRR
    FROM CHURN_EVENTS CE
    JOIN CUSTOMERS C ON CE.CUSTOMER_ID = C.CUSTOMER_ID
    JOIN SUBSCRIPTIONS S ON CE.CUSTOMER_ID = S.CUSTOMER_ID
    JOIN SUBSCRIPTION_PLANS SP ON S.PLAN_ID = SP.PLAN_ID
    GROUP BY COHORT
)
SELECT
    SM.COHORT,
    SM.STARTING_MRR,
    COALESCE(E.EXPANSION_MRR, 0)   AS EXPANSION_MRR,
    COALESCE(CT.CONTRACTION_MRR,0) AS CONTRACTION_MRR,
    COALESCE(CH.CHURNED_MRR, 0)    AS CHURNED_MRR,
    ROUND(
        (SM.STARTING_MRR + COALESCE(E.EXPANSION_MRR,0) - COALESCE(CT.CONTRACTION_MRR,0) - COALESCE(CH.CHURNED_MRR,0))
        * 100.0 / NULLIF(SM.STARTING_MRR, 0)
    , 2) AS NRR_PCT,
    ROUND(
        (SM.STARTING_MRR - COALESCE(CT.CONTRACTION_MRR,0) - COALESCE(CH.CHURNED_MRR,0))
        * 100.0 / NULLIF(SM.STARTING_MRR, 0)
    , 2) AS GRR_PCT
FROM STARTING_MRR SM
LEFT JOIN EXPANSION   E  ON SM.COHORT = E.COHORT
LEFT JOIN CONTRACTION CT ON SM.COHORT = CT.COHORT
LEFT JOIN CHURNED     CH ON SM.COHORT = CH.COHORT
ORDER BY SM.COHORT;

/* Conversion Leak by Acquisition Channel & Industry */
SELECT
    C.ACQUISITION_CHANNEL,
    C.INDUSTRY,
    COUNT(DISTINCT S.CUSTOMER_ID) AS SUBSCRIBED_CUSTOMERS,
    COUNT(DISTINCT CASE WHEN PI.CUSTOMER_ID IS NOT NULL THEN S.CUSTOMER_ID END) AS PAYING_CUSTOMERS,
    COUNT(DISTINCT CASE WHEN PI.CUSTOMER_ID IS NULL THEN S.CUSTOMER_ID END)     AS LEAKED_CUSTOMERS,
    ROUND(
        COUNT(DISTINCT CASE WHEN PI.CUSTOMER_ID IS NULL THEN S.CUSTOMER_ID END) * 100.0
        / NULLIF(COUNT(DISTINCT S.CUSTOMER_ID), 0)
    , 2) AS LEAK_RATE_PCT
FROM SUBSCRIPTIONS S
JOIN CUSTOMERS C
    ON S.CUSTOMER_ID = C.CUSTOMER_ID
LEFT JOIN (SELECT DISTINCT CUSTOMER_ID FROM INVOICES WHERE STATUS = 'paid') PI
    ON S.CUSTOMER_ID = PI.CUSTOMER_ID
GROUP BY C.ACQUISITION_CHANNEL, C.INDUSTRY
ORDER BY LEAK_RATE_PCT DESC;

/*==========================================================
SECTION 8 — STRATEGIC REVENUE RISK
Business Goal:
  Quantify how concentrated revenue is among a small group of
  customers, countries, or industries, to flag dependency risk.
Business Questions:
  1. How much of total revenue comes from the top 20 customers?
  2. Is the business overly dependent on any single country or
     industry?
==========================================================*/
/* Revenue Concentration — Top 20 Customers */
SELECT CUSTOMER_ID,
SUM(AMOUNT) AS REVENUE
FROM INVOICES
WHERE STATUS = 'paid'
GROUP BY CUSTOMER_ID
ORDER BY REVENUE DESC
LIMIT 20;

/*Top 20 Revenue Share*/
WITH top20 AS (SELECT CUSTOMER_ID,SUM(AMOUNT) AS REVENUE
FROM INVOICES WHERE STATUS='paid'GROUP BY CUSTOMER_ID
ORDER BY REVENUE DESC LIMIT 20)
SELECT SUM(REVENUE) AS TOP20_REVENUE,
ROUND(SUM(REVENUE) * 100 /(SELECT SUM(AMOUNT)
FROM INVOICES WHERE STATUS='paid'),2) AS TOP20_SHARE_PCT
FROM top20;

/*Country Dependency — Revenue Share by Country */
SELECT COUNTRY,
ROUND(SUM(I.AMOUNT)*100/
(SELECT SUM(AMOUNT)
FROM INVOICES WHERE STATUS='paid'),2)
AS REVENUE_SHARE_PCT
FROM CUSTOMERS C
JOIN INVOICES I
ON C.CUSTOMER_ID=I.CUSTOMER_ID
WHERE I.STATUS='paid'
GROUP BY COUNTRY
ORDER BY REVENUE_SHARE_PCT DESC;

/* Industry Dependency — Revenue Share by Industry */
SELECT INDUSTRY,
ROUND(SUM(I.AMOUNT) * 100 /(SELECT SUM(AMOUNT) FROM INVOICES WHERE STATUS = 'paid'),2) AS REVENUE_SHARE_PCT
FROM CUSTOMERS C
JOIN INVOICES I
    ON C.CUSTOMER_ID = I.CUSTOMER_ID
WHERE I.STATUS = 'paid'
GROUP BY INDUSTRY
ORDER BY REVENUE_SHARE_PCT DESC;

/*==========================================================
SECTION 9 — ADVANCED SQL ANALYTICS
Business Goal:
  Demonstrate window-function fluency while surfacing revenue
  trends that simple aggregates cannot show — momentum,
  ranking, and rolling performance.
Business Questions:
  1. How does month-over-month revenue growth trend?
  2. How is cumulative revenue building over time?
  3. What does recent (3-month rolling) revenue momentum
     look like?
==========================================================*/
/* Month-over-Month Revenue Growth (CTE + LAG) */
WITH MONTHLY_REVENUE AS (
SELECT DATE_FORMAT(INVOICE_DATE, '%Y-%m') AS MONTH,
SUM(AMOUNT)AS REVENUE
FROM INVOICES
WHERE STATUS = 'paid'
GROUP BY MONTH)
SELECT MONTH,REVENUE,LAG(REVENUE) OVER (ORDER BY MONTH) AS PREV_REVENUE,
ROUND((REVENUE - LAG(REVENUE) OVER (ORDER BY MONTH)) /LAG(REVENUE) OVER (ORDER BY MONTH) * 100,2) AS MOM_GROWTH_PCT
FROM MONTHLY_REVENUE;
 
/* Customer Revenue Ranking with ROW_NUMBER() */
SELECT CUSTOMER_ID,SUM(AMOUNT) AS TOTAL_REVENUE,
ROW_NUMBER() OVER (ORDER BY SUM(AMOUNT) DESC) AS REVENUE_ROW_NUM
FROM INVOICES
WHERE STATUS = 'paid'
GROUP BY CUSTOMER_ID;
 
/* Customer Revenue Ranking with DENSE_RANK() */
SELECT CUSTOMER_ID,
SUM(AMOUNT) AS TOTAL_REVENUE,
DENSE_RANK() OVER (ORDER BY SUM(AMOUNT) DESC) AS REVENUE_DENSE_RANK
FROM INVOICES
WHERE STATUS = 'paid'
GROUP BY CUSTOMER_ID;
 
/* Running (Cumulative) Revenue by Month */
WITH MONTHLY_REVENUE AS (
SELECT DATE_FORMAT(INVOICE_DATE, '%Y-%m') AS MONTH,
SUM(AMOUNT)AS REVENUE
FROM INVOICES
WHERE STATUS = 'paid'
GROUP BY MONTH)
SELECT MONTH,REVENUE,
SUM(REVENUE) OVER (ORDER BY MONTH) AS RUNNING_REVENUE
FROM MONTHLY_REVENUE
ORDER BY MONTH;
 
/* Rolling 3-Month Revenue by Month */
WITH MONTHLY_REVENUE AS (
SELECT DATE_FORMAT(INVOICE_DATE, '%Y-%m') AS MONTH,
SUM(AMOUNT)AS REVENUE
FROM INVOICES
WHERE STATUS = 'paid'
GROUP BY MONTH)
SELECT MONTH,REVENUE,
ROUND(AVG(REVENUE) OVER (ORDER BY MONTH ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS ROLLING_3MO_AVG_REVENUE
FROM MONTHLY_REVENUE ORDER BY MONTH;

/*==========================================================
SECTION 10 — BUSINESS VIEWS
Business Goal:
  Package the most important recurring metrics into reusable
  views so BI tools (e.g., Tableau) and stakeholders can query
  clean, pre-aggregated data without rewriting logic.
Business Questions:
  1. What is each customer's lifetime revenue at a glance?
  2. What does the current-state executive KPI dashboard show?
  3. Which customers are healthy vs. at risk right now?
==========================================================*/
/* View 1: Customer Revenue (lifetime revenue per customer) */
CREATE VIEW CUSTOMER_REVENUE AS
SELECT CUSTOMER_ID,
SUM(AMOUNT) AS TOTAL_REVENUE
FROM INVOICES
GROUP BY CUSTOMER_ID;
 
/* View 2: Revenue Master View (paid invoices enriched with customer, plan, and subscription context) */
CREATE VIEW REVENUE_MASTER_VIEW AS
SELECT I.INVOICE_ID,I.CUSTOMER_ID,I.INVOICE_DATE,I.AMOUNT,C.COUNTRY,C.INDUSTRY,C.COMPANY_SIZE,C.ACQUISITION_CHANNEL,SP.PLAN_NAME,SP.PRICE AS PLAN_PRICE,S.STATUS AS SUBSCRIPTION_STATUS
FROM INVOICES I
JOIN CUSTOMERS C
    ON I.CUSTOMER_ID = C.CUSTOMER_ID
LEFT JOIN SUBSCRIPTIONS S
    ON I.CUSTOMER_ID = S.CUSTOMER_ID
LEFT JOIN SUBSCRIPTION_PLANS SP
    ON S.PLAN_ID = SP.PLAN_ID
WHERE I.STATUS = 'paid';
 
/* View 3: Executive KPI View (single-row business snapshot) */
CREATE VIEW EXECUTIVE_KPI_VIEW AS
SELECT
(SELECT SUM(AMOUNT)FROM INVOICES WHERE STATUS = 'paid') AS TOTAL_REVENUE,
(SELECT COUNT(DISTINCT CUSTOMER_ID) FROM CUSTOMERS)AS TOTAL_CUSTOMERS,
(SELECT COUNT(DISTINCT CUSTOMER_ID)
FROM SUBSCRIPTIONS
WHERE STATUS = 'active')AS ACTIVE_CUSTOMERS,
(SELECT COUNT(DISTINCT CUSTOMER_ID)
FROM CHURN_EVENTS)AS CHURNED_CUSTOMERS,
(SELECT SUM(SP.PRICE)
FROM SUBSCRIPTIONS S
JOIN SUBSCRIPTION_PLANS SP ON S.PLAN_ID = SP.PLAN_ID
WHERE S.STATUS = 'active')AS MRR,
(SELECT SUM(SP.PRICE) * 12
FROM SUBSCRIPTIONS S
JOIN SUBSCRIPTION_PLANS SP ON S.PLAN_ID = SP.PLAN_ID
WHERE S.STATUS = 'active')AS ARR;
 
/* View 4: Customer Health View (per-customer revenue,subscription status, and churn flag) */
CREATE VIEW CUSTOMER_HEALTH_VIEW AS
SELECT C.CUSTOMER_ID,C.COUNTRY,C.INDUSTRY,C.COMPANY_SIZE,C.ACQUISITION_CHANNEL,
S.STATUS AS SUBSCRIPTION_STATUS,
SP.PLAN_NAME,
COALESCE(SUM(I.AMOUNT), 0)AS LIFETIME_REVENUE,
CASE
WHEN CE.CUSTOMER_ID IS NOT NULL THEN 'CHURNED'
WHEN S.STATUS = 'active' THEN 'ACTIVE'
ELSE 'UNKNOWN'
END AS HEALTH_STATUS
FROM CUSTOMERS C
LEFT JOIN SUBSCRIPTIONS S
    ON C.CUSTOMER_ID = S.CUSTOMER_ID
LEFT JOIN SUBSCRIPTION_PLANS SP
    ON S.PLAN_ID = SP.PLAN_ID
LEFT JOIN INVOICES I
    ON C.CUSTOMER_ID = I.CUSTOMER_ID AND I.STATUS = 'paid'
LEFT JOIN CHURN_EVENTS CE
    ON C.CUSTOMER_ID = CE.CUSTOMER_ID
GROUP BY
    C.CUSTOMER_ID, C.COUNTRY, C.INDUSTRY, C.COMPANY_SIZE,
    C.ACQUISITION_CHANNEL, S.STATUS, SP.PLAN_NAME, CE.CUSTOMER_ID;
