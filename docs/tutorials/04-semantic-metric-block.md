# 04. Semantic Metric Block

Goal: show the difference between a SQL block and a semantic block.

## Why This Matters

DQL should not replace dbt. In this repo:

- dbt owns models and semantic definitions.
- `semantic-layer/` exposes imported metrics and dimensions to DQL.
- DQL semantic blocks reference metrics instead of writing raw `SELECT` SQL.

## Files Used

| Artifact | Path |
| --- | --- |
| dbt semantic model | `models/metrics/order_items.yml` |
| imported metric | `semantic-layer/metrics/finance/order_total.yaml` |
| imported time dimension | `semantic-layer/dimensions/finance/ordered_at.yaml` |
| semantic block | `blocks/finance/semantic_order_total_by_month.dql` |

## 1. Inspect The Metric

Open `semantic-layer/metrics/finance/order_total.yaml`.

The metric says order total is sourced from dbt and computed from the `orders`
semantic model.

## 2. Inspect The Semantic Block

Open `blocks/finance/semantic_order_total_by_month.dql`.

Notice what is missing: there is no `query = """ ... """`.

The block declares:

```text
type = "semantic"
metric = "order_total"
```

That is the key difference. A semantic block starts from metric metadata. A SQL
block starts from raw SQL.

In the UI, Block Studio can add the dimension and time-grain choices while
building the semantic slice. This file stays intentionally minimal so the
source-controlled block remains a clean pointer to the dbt-owned metric.

## 3. Validate

```bash
npm run dql:validate
npm exec -- dql lineage --block "Semantic Order Total by Month"
```

Expected result: DQL confirms the semantic block references a metric that exists
in the configured semantic layer and lineage connects the block to the imported
semantic metric.

## 4. When To Use Each Block Type

Use a SQL block when you need:

- joins across models
- custom filters
- derived columns
- dashboard-specific shaping
- migration from existing SQL

Use a semantic block when you need:

- a governed dbt metric
- selected dimensions
- a time grain
- no raw SQL editing
- easy metric-to-App lineage

## 5. Next Step In Block Studio

In the UI, open Blocks / Block Studio. From the start page:

1. Choose `Create Semantic Block from dbt Metric`.
2. Pick `order_total`.
3. Pick `ordered_at` as the time dimension.
4. Set grain to month.
5. Save as draft, then review before certification.
