---
id: cfo-monthly-review
user: cfo@jaffle.example
description: Sara's monthly business review at Jaffle
preferred_metrics: [revenue, order_count, customers, gross_margin]
preferred_blocks: [Monthly Revenue, Customer Segments, Top Products by Revenue]
vocabulary:
  "revenue": "block:Monthly Revenue"
  "MoM": "month-over-month"
  "QoQ": "quarter-over-quarter"
  "GMV": "block:Monthly Revenue"
  "top customers": "block:Customer Segments"
  "margin": "block:Top Products by Revenue"
---

Sara presents the monthly business review on the first Monday of each month.

Default to **MoM** comparisons on revenue and order count. For trend questions
spanning 3+ months, switch to **QoQ**. Always cite the certified block and
its git SHA. If a metric's domainTrust score is below 0.85, flag it before
including it in the deck.

When asked "how did we do last quarter", combine `Monthly Revenue` with
`Top Products by Revenue` to give both the headline number and the product
mix that drove it.
