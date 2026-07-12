# Business Requirements

## Scope Requirements
1. All revenue figures must be traceable to `paid` status invoices only — invoices in `pending` or `failed` status must never be counted as recognized revenue.
2. Customer counts must distinguish between the full customer base (25,000, including free-tier and inactive) and active revenue-generating customers (5,469) — these are never to be used interchangeably in reporting.
3. Retention metrics (NRR/GRR) must be calculated on a monthly cohort basis using the MRR bridge method (starting MRR, expansion, contraction, churn), not as a single blended lifetime ratio.
4. Churn must be reported with an explicit time window (e.g., "monthly logo churn") — a churn rate with no stated period is not acceptable for executive reporting.
5. All KPI definitions must be documented in a single source of truth (`KPI_Definitions.md`) so that SQL, Python, and Excel outputs cannot silently diverge in what they mean by "MRR" or "churn."

## Data Quality Requirements
- No duplicate `customer_id` or `invoice_id` records may exist in the analysis layer (validated in SQL Section 1).
- Every `payment` must reference a valid `invoice`; every `subscription` must reference a valid `plan` — referential integrity is validated before any downstream KPI is built.
- Any known data limitation (e.g., absence of channel-level acquisition cost) must be explicitly documented, not silently assumed away.

## Analytical Requirements
- Every KPI must have a stated business question it answers (not calculated for its own sake).
- Revenue concentration must be quantified at both the Top 10 and Top 20 customer level to assess single-account risk.
- Segment-level churn drivers (channel, industry, company size) must be tested for statistical significance, not just descriptive difference, before being cited as a "cause."

## Reporting Requirements
- The Excel workbook must support both raw-data drill-down (for analyst use) and a single-page executive view (for leadership use) — these are two different audiences and cannot share one sheet.
- The Tableau dashboard must surface the MRR bridge and cohort retention visually, since neither translates well to a static table.

## Non-Requirements (Explicitly Out of Scope)
- CAC by channel is out of scope for this iteration; the dataset does not contain marketing/sales spend data. LTV:CAC will be modeled once that data is available (see `Analysis_Methodology.md`).
- Multi-currency handling was not required; all invoice amounts are treated as a single currency.
