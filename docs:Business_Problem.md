# Business Problem

## The Core Problem
SaaS companies are valued on the durability of their revenue, not just its size. A dollar of revenue from a customer who renews for five years is worth far more than a dollar from a customer who churns in month two — but a standard revenue report treats both dollars identically. Without a retention-aware view of the business, leadership can be making decisions off a number (total revenue, or even MRR) that is actively hiding the problem that matters most.

This project exists to close that gap: to build a single, trustworthy analytical layer that separates "how much revenue came in" from "how much of our revenue base is actually durable" — and to surface that distinction before it becomes a board-level surprise.

## Why This Is Hard in Practice
The information needed to answer this question doesn't live in one table. It requires reconciling:
- **Billing data** (invoices, payments) — what was actually charged and collected
- **Subscription state** (subscriptions, subscription_plans) — what a customer is currently paying for
- **Change events** (plan_changes) — when a customer upgraded or downgraded
- **Exit events** (churn_events) — when and why a customer left

Most first-pass SaaS dashboards only use the first of these — billing data — because it's the easiest to pull. That produces a revenue chart, not a retention diagnosis. This project deliberately joins all four sources together to build a metric (NRR/GRR via MRR bridge) that most internal dashboards get wrong on the first attempt.

## The Business Questions This Was Built to Answer
1. Is our revenue growing because we're acquiring well, or in spite of losing existing customers?
2. If we stopped acquiring new customers tomorrow, would revenue grow, flatten, or shrink?
3. Where is our revenue concentrated, and what happens if that concentration turns?
4. Which acquisition channel is actually worth investing in, once retention (not just revenue) is accounted for?

## Who This Analysis Is For
A CFO deciding where to allocate the next funding round. A VP of Growth deciding whether to spend on acquisition or retention. A Founder's Office team building the board deck. This project is structured to serve all three from the same underlying model — which is why the SQL layer validates data quality before a single KPI is calculated: none of these audiences can act on a number they can't trust.
