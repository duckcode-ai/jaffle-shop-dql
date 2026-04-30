# 03. Product Performance

Goal: package product revenue and margin analysis into a weekly Product App.

## Files Used

| Artifact | Path |
| --- | --- |
| dbt mart | `models/marts/order_items.sql` |
| staging model | `models/staging/jaffle_shop/stg_products.sql` |
| SQL block | `blocks/product/top_products.dql` |
| SQL block | `blocks/product/product_type_margin.dql` |
| Notebook | `notebooks/product_performance.dqlnb` |
| App | `apps/product-team/dql.app.json` |
| Dashboard page | `apps/product-team/dashboards/top-products.dqld` |

## 1. Open The Notebook

Open `notebooks/product_performance.dqlnb`.

This notebook is intentionally analyst-facing. It starts with SQL, adds KPI and
chart cells, filters high-margin products, and then shows the certified
`Top Products by Revenue` block.

## 2. Inspect The Product Blocks

Open:

```text
blocks/product/top_products.dql
blocks/product/product_type_margin.dql
```

Use `Top Products by Revenue` for ranked product lists. Use `Product Type
Margin` when the question is about product mix or margin quality by category.

## 3. Build And Open The App

```bash
npm run dql:app:build
```

Open `Product - Performance Review`.

The dashboard page includes:

- revenue KPI
- gross margin KPI
- units sold KPI
- top products chart
- product type margin chart
- detail tables

The attached notebook remains available for deeper analysis.

## 4. Ask Good Product Questions

Good questions for this App:

- Which products drive the most revenue?
- Which product type has the best gross margin?
- Which products should merchandising promote?
- Are food and drink behaving differently?

These should route to certified product blocks before any generated SQL.

## 5. Trace Lineage

```bash
npm exec -- dql lineage --block "Top Products by Revenue"
npm exec -- dql lineage --block "Product Type Margin"
npm exec -- dql lineage --app product-team
```

Expected path:

```text
stg_order_items + stg_products + stg_supplies -> order_items -> DQL product block -> Product App
```
