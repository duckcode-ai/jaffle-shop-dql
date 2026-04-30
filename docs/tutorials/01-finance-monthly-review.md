# 01. Finance Monthly Review

Goal: understand the finance use case from dbt mart to certified blocks,
notebook, App dashboard, and lineage.

## Files Used

| Artifact | Path |
| --- | --- |
| dbt mart | `models/marts/fct_orders.sql` |
| SQL block | `blocks/finance/monthly_revenue.dql` |
| SQL block | `blocks/finance/revenue_mix_by_month.dql` |
| Semantic block example | `blocks/finance/semantic_order_total_by_month.dql` |
| Notebook | `notebooks/revenue_review.dqlnb` |
| App | `apps/finance-cxo/dql.app.json` |
| Dashboard page | `apps/finance-cxo/dashboards/monthly-review.dqld` |

## 1. Build The Data

```bash
npm run setup:warehouse
```

dbt creates `fct_orders`, which is the finance mart used by the finance DQL
blocks.

## 2. Inspect The Certified Blocks

Open:

```text
blocks/finance/monthly_revenue.dql
blocks/finance/revenue_mix_by_month.dql
```

Notice the structure:

- `domain = "finance"` makes the block discoverable under finance.
- `status = "certified"` marks it as trusted.
- `query = """ ... """` keeps the executable SQL in the block.
- `tests { assert row_count > 0 }` gives certification a basic quality gate.
- `llmContext`, `invariants`, and `examples` give AI enough business meaning.

## 3. Run The Notebook

Open `notebooks/revenue_review.dqlnb` in the notebook UI and run all cells.

This notebook is the analyst workbench. It can contain exploratory SQL, charts,
filters, pivots, and bound certified block cells.

## 4. Open The Finance App

Open the Apps section and select `Finance - CXO Review`.

The App is the stakeholder-facing package:

- dashboard page: `monthly-review`
- attached notebook: `Monthly Revenue Review`
- certified blocks: `Monthly Revenue`, `Revenue Mix by Month`, `Customer Segments`
- schedule examples: Monday MBR and quarter-end board pack

## 5. Validate The App

```bash
npm run dql:app:build
```

Expected result: the App build resolves the dashboard pages and block refs.

## 6. Trace Lineage

```bash
npm exec -- dql lineage --block "Monthly Revenue"
npm exec -- dql lineage --block "Revenue Mix by Month"
npm exec -- dql lineage --app finance-cxo
```

Read the path as:

```text
raw source -> dbt staging -> dbt mart fct_orders -> DQL block -> dashboard tile -> App
```

## 7. Decision Point

Use a SQL block when finance needs a curated answer that joins, filters, or
reshapes dbt models. Use a semantic block when finance only needs a governed
metric/dimension slice from dbt semantic metadata.
