# 02. Customer Cohorts

Goal: show how a growth analyst moves from notebook exploration to reusable
customer blocks and a Customer Success App.

## Files Used

| Artifact | Path |
| --- | --- |
| dbt mart | `models/marts/dim_customers.sql` |
| SQL block | `blocks/customer/customer_segments.dql` |
| SQL block | `blocks/customer/cohort_returning_rate.dql` |
| Notebook | `notebooks/customer_cohorts.dqlnb` |
| App | `apps/customer-success/dql.app.json` |
| Dashboard page | `apps/customer-success/dashboards/segments-overview.dqld` |

## 1. Start In The Notebook

Open `notebooks/customer_cohorts.dqlnb`.

Run the cells in order. The notebook computes:

- cohort month
- customer type
- cohort size
- average lifetime orders
- average lifetime spend
- percent returning

This is the right place to experiment before deciding what deserves to become a
certified block.

## 2. Compare Notebook SQL To Blocks

Open these blocks:

```text
blocks/customer/customer_segments.dql
blocks/customer/cohort_returning_rate.dql
```

The first block is a simple segment summary. The second block promotes the
cohort logic into a reusable definition for dashboards, Apps, and AI grounding.

## 3. Build The Customer App

```bash
npm run dql:app:build
```

Open `Customer Success - Cohort Ops` in the Apps section.

The dashboard now uses both:

- `Customer Segments`
- `Customer Cohort Returning Rate`

The attached notebook gives analysts the full context behind the dashboard.

## 4. Preview Personas

The OSS repo does not enforce enterprise RBAC, but the App document includes
personas and RLS-style bindings so users can understand the future commercial
flow:

```text
lead.na@jaffle.example
lead.emea@jaffle.example
lead.apac@jaffle.example
```

Use the App persona switcher to preview how a regional lead would see the
surface.

## 5. Trace The Dependency

```bash
npm exec -- dql lineage --block "Customer Cohort Returning Rate"
npm exec -- dql lineage --app customer-success
```

The key path is:

```text
stg_customers + fct_orders + order_items -> dim_customers -> DQL customer block -> CS App
```

## 6. Certification Checklist

Before moving a new cohort block to certified:

- owner is present
- domain is present
- description explains the business definition
- tests pass
- dashboard references resolve
- lineage reaches the dbt model you expect
