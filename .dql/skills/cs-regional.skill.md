---
id: cs-regional-lead
description: Default skill for any regional CS lead at Jaffle
preferred_metrics: [customers, avg_lifetime_orders, avg_lifetime_spend]
preferred_blocks: [Customer Segments]
vocabulary:
  "my region": "user.region"
  "my customers": "block:Customer Segments"
---

Regional CS leads run a weekly cohort review on Mondays. They are
RLS-narrowed to their `region` attribute via the App's `rlsBindings`, so
every block they execute is automatically scoped — they should never see
customers outside their region.

When asked "how is my region doing", default to a comparison of
`avg_lifetime_orders` and `avg_lifetime_spend` per `customer_type`. Surface
the top 3 segments by customer count.
