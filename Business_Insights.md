# Business Insights

## Insight 1: Retention, Not Acquisition, Is the Binding Constraint
NRR of 58% and GRR of 53% mean the existing customer base is shrinking in dollar terms faster than expansion revenue can offset it. The 5-point gap between NRR and GRR shows expansion (upsells/upgrades) is a minor factor — most of the movement is churn and contraction. **Implication:** every dollar spent on acquisition is currently working against a headwind, not a tailwind. Fixing retention has more leverage than accelerating acquisition.

## Insight 2: Revenue Is Concentrated in a Narrow Band
The Premium plan, the UK market, and the Health industry vertical each rank as the single largest contributor in their category. Combined with Top 10/Top 20 customer revenue share tracked explicitly in `Revenue_Concentration`, this shows the business's revenue is not evenly distributed — a small set of accounts, geographies, and one plan tier carry disproportionate weight. **Implication:** this concentration is either a defensible moat (strong product-market fit in a specific niche) or a risk (over-exposure to a single segment's macro conditions) — worth a targeted follow-up analysis before treating it as either.

## Insight 3: Referral Outperforms Paid Acquisition on Revenue
Referral is the top-revenue acquisition channel, ahead of Organic and Ads. On its own this looks like a growth-efficiency win. **Caveat:** this is a revenue-only view — it doesn't yet account for retention by channel. A channel that generates strong initial revenue but churns fast is not actually "efficient." This is the direct handoff to the CAC/LTV model once acquisition-cost data is available.

## Insight 4: Data Quality Was Verified, Not Assumed
Duplicate-record and referential-integrity checks (SQL Section 1) came back clean — no orphaned payments, no orphaned subscriptions, no duplicate customer or invoice IDs. This matters because it means the KPIs above are not artifacts of dirty data; they reflect real patterns in the business.

## Insight 5: Churn Reasons Cluster Around Competitive and Price Pressure
Churn reason data (`competitor`, `price`, `budget`, `product_fit`, `other`) shows losses are not dominated by any single catastrophic cause — they're distributed across competitive, pricing, and budget pressure fairly evenly. **Implication:** there's no single "fix this one thing" lever; retention improvement likely requires a combination of competitive positioning, pricing strategy, and product investment rather than one initiative.

## What's Still Open
- Whether the UK/Health concentration is a strength or a risk (requires a follow-up segment deep-dive)
- Whether Referral's revenue advantage holds up once retention-by-channel is layered in
- The true LTV:CAC picture, pending acquisition-cost data
