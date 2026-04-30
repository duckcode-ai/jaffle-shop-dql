# Jaffle Shop Use Cases

This repo is organized around business workflows, not isolated syntax examples.
Each workflow shows the same DQL path:

```text
dbt model or metric -> DQL block -> notebook -> App dashboard -> lineage -> AI grounding
```

## Use Case Map

| Use case | Primary user | App | Notebook | Blocks |
| --- | --- | --- | --- | --- |
| Finance monthly business review | CFO / FP&A | `finance-cxo` | `notebooks/revenue_review.dqlnb` | `Monthly Revenue`, `Revenue Mix by Month`, `Semantic Order Total by Month` |
| Customer cohort review | VP CS / Growth | `customer-success` | `notebooks/customer_cohorts.dqlnb` | `Customer Segments`, `Customer Cohort Returning Rate` |
| Product performance review | Product lead / PM | `product-team` | `notebooks/product_performance.dqlnb` | `Top Products by Revenue`, `Product Type Margin` |
| Governed AI Q&A | Analyst / stakeholder | any App | `notebooks/chat_with_data.dqlnb` | certified block-first retrieval |

## Scenario 1: Finance Monthly Business Review

Business questions:

- How much revenue did we book by month?
- How did gross profit and margin quality trend?
- Is food or drink driving more revenue?
- Which certified blocks should be cited in the board pack?

Flow:

1. dbt builds `fct_orders`.
2. DQL certifies `blocks/finance/monthly_revenue.dql`.
3. DQL certifies `blocks/finance/revenue_mix_by_month.dql`.
4. The analyst notebook `notebooks/revenue_review.dqlnb` shows the full analysis.
5. The Finance App dashboard uses the certified blocks for the stakeholder view.
6. AI answers about revenue should ground on finance blocks first.

Try:

```bash
npm run dql:app:show
npm exec -- dql lineage --block "Revenue Mix by Month"
npm exec -- dql lineage --app finance-cxo
```

Tutorial: [tutorials/01-finance-monthly-review.md](tutorials/01-finance-monthly-review.md).

## Scenario 2: Customer Success Cohort Review

Business questions:

- How many customers are in each segment?
- Which cohorts have strong returning-customer rates?
- How does lifetime spend differ by customer type?
- What should CS leaders review weekly?

Flow:

1. dbt builds `dim_customers`.
2. `Customer Segments` defines the stable customer rollup.
3. `Customer Cohort Returning Rate` promotes cohort analysis into a reusable block.
4. `customer-success` attaches the cohort notebook for analyst context.
5. The dashboard page combines segment KPIs and cohort returning-rate trend.

Try:

```bash
npm exec -- dql app show customer-success
npm exec -- dql lineage --block "Customer Cohort Returning Rate"
npm exec -- dql lineage --app customer-success
```

Tutorial: [tutorials/02-customer-cohorts.md](tutorials/02-customer-cohorts.md).

## Scenario 3: Product Weekly Performance Review

Business questions:

- What are the top products by revenue?
- Which product type drives the strongest gross margin?
- Which products should merchandising promote?
- Is food vs drink mix changing the weekly review?

Flow:

1. dbt builds `order_items` and `stg_products`.
2. `Top Products by Revenue` certifies the ranked product list.
3. `Product Type Margin` certifies margin quality by product type.
4. The product notebook keeps the deeper analyst workflow.
5. The Product App packages the weekly stakeholder dashboard.

Try:

```bash
npm exec -- dql app show product-team
npm exec -- dql lineage --block "Product Type Margin"
npm exec -- dql lineage --app product-team
```

Tutorial: [tutorials/03-product-performance.md](tutorials/03-product-performance.md).

## Scenario 4: dbt Semantic Metric To DQL Semantic Block

Business questions:

- How can a user build from a dbt semantic metric without writing raw SQL?
- Where does metric ownership stay?
- How is this different from a custom SQL block?

Flow:

1. dbt defines the semantic metric in `models/metrics/order_items.yml`.
2. DQL imports semantic metadata into `semantic-layer/metrics/finance/order_total.yaml`.
3. `Semantic Order Total by Month` references `metric = "order_total"`.
4. Block Studio can create the same pattern from `Create Semantic Block from dbt Metric`.

Try:

```bash
npm run dql:validate
npm exec -- dql lineage --block "Semantic Order Total by Month"
```

Tutorial: [tutorials/04-semantic-metric-block.md](tutorials/04-semantic-metric-block.md).

## Scenario 5: Governed AI Chat

Business questions:

- Can AI answer from certified blocks before generating SQL?
- Can AI explain which block and dbt model supports the answer?
- Can a generated answer be promoted into a reviewed DQL block?

Flow:

1. `dql agent reindex` builds the local knowledge graph.
2. The agent searches certified blocks first.
3. If no certified block fits, generated SQL is marked review-only.
4. Useful proposals are saved as draft blocks, validated, then certified by a user.

Try:

```bash
npm run dql:agent:reindex
npm exec -- dql agent ask "which product type has the best gross margin?"
```

Tutorial: [tutorials/05-ai-lineage-certification.md](tutorials/05-ai-lineage-certification.md).

## Demo Order

Use this sequence when showing the repo to a new user:

1. Run `npm run dql:doctor`.
2. Open `notebooks/welcome.dqlnb`.
3. Open `Finance - CXO Review` and show dashboard plus attached notebook.
4. Open `blocks/finance/revenue_mix_by_month.dql`.
5. Run `npm exec -- dql lineage --block "Revenue Mix by Month"`.
6. Open Block Studio and show SQL block vs semantic block paths.
7. Run `npm run dql:agent:reindex`.
8. Ask a governed question in `notebooks/chat_with_data.dqlnb`.

## Full Smoke Check

Run this before demoing or publishing changes:

```bash
npm run dql:doctor
npm run dql:validate
npm run dql:compile
npm run dql:app:build
npm run dql:lineage
npm run dql:agent:reindex
```

Expected result: all commands exit successfully with no unresolved dashboard
block references.
