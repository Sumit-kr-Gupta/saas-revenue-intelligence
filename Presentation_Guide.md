# Presentation Guide

How to walk an interviewer or recruiter through this project, depending on the room you're in. The goal in every version is the same: show that you can move from data → defensible metric → business judgment, not just that you can write SQL.

## The 60-Second Version (Any Role)
"I built an end-to-end SaaS analytics project on a 25,000-customer dataset — SQL for data validation and KPI logic, Python for statistical analysis, Excel for the executive dashboard. The headline finding is that Net Revenue Retention is 58%, meaning the business is losing more in churn and downgrades than it's gaining in expansion revenue — so the real story isn't the $31M ARR number, it's that retention, not acquisition, is the actual growth constraint. I built the NRR/GRR calculation as a proper MRR bridge — starting MRR adjusted for expansion, contraction, and churn — because a simple ratio would have given a misleading number."

## For a Data / BI Analyst Interview
Lead with the SQL structure: data validation before KPIs, referential integrity checks, and the 10-section business-question-driven organization. Be ready to walk through the exact MRR bridge query — expect to be asked to write it live or explain each join. Know the difference between `payments`, `invoices`, and `subscriptions` cold, and why each exists as a separate table.

**Likely question:** "Walk me through how you'd calculate churn." Answer with both numbers (cumulative vs. monthly logo churn) and explain why you keep them separate — this signals rigor, not just recall.

## For a Strategy & Operations / Founder's Office Interview
Lead with the business insight, not the tooling: retention is the binding constraint, revenue is concentrated in UK/Health/Premium, and here's the sequenced recommendation set (retention first, expansion motion second, channel reallocation once CAC data exists). Be ready to defend the sequencing logic — why retention before expansion, why concentration analysis before channel reallocation.

**Likely question:** "What would you do first with a limited budget?" Answer: retention interventions tied to churn-reason data, because it requires no new data infrastructure and the dollar impact (~$550K+ MRR at stake) is already quantified.

## For a Consulting Interview (McKinsey/Bain/BCG-style)
Frame it as a case: business problem → hypothesis → analysis → recommendation → impact sizing. Emphasize the explicit "Challenges & Assumptions" section — naming what you don't know (CAC, gross margin) and how you handled it (assumption-labeled LTV, explicitly blocked CAC) demonstrates the same rigor consultants are trained to show in a live case.

**Likely question:** "What's your #1 recommendation and why?" Answer: retention-first investment, because it's the only lever with both the largest quantified impact and zero dependency on data you don't have.

## For a Growth / Product Analytics Interview
Lead with the expansion-revenue gap (NRR vs. GRR) and the channel analysis caveat — Referral looks best on revenue alone, but you flagged that this is incomplete without retention-by-channel data. This shows you don't over-claim from partial data, which matters more than having a clean answer.

**Likely question:** "How would you improve NRR?" Answer with the expansion motion recommendation, tied to the `plan_changes` data already available to trigger usage-based upgrade prompts.

## Universal Rule for Any Room
Never state the NRR/GRR/churn numbers without being able to say, in one sentence, exactly how they were calculated. These are the numbers most likely to be challenged — know the MRR bridge and the two-churn-number logic well enough to explain them without looking at notes.
