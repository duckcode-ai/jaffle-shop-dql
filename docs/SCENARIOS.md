# Jaffle Shop Scenarios

The goal of this repo is not just to show syntax. It shows how reusable DQL
business logic becomes Apps, dashboards, schedules, lineage, and AI grounding.

## Scenario 1: CFO Monthly Business Review

**User:** Sara, CFO  
**App:** `finance-cxo`  
**Notebook:** `notebooks/revenue_review.dqlnb`  
**Dashboards:** `monthly-review`, `quarterly-board`  
**Blocks:** `Monthly Revenue`, `Customer Segments`

Business questions:

- How much revenue did we book by month?
- Which months missed the internal revenue floor?
- Are customer segments changing the revenue mix?
- What should go into the board pack?

Flow:

1. dbt builds `fct_orders` and `dim_customers`.
2. `blocks/finance/monthly_revenue.dql` certifies the monthly revenue definition.
3. `apps/finance-cxo/dashboards/monthly-review.dqld` lays out KPI, trend, and table tiles.
4. `apps/finance-cxo/dql.app.json` declares members, policies, schedules, and homepage.
5. AI chat grounds finance answers in `Monthly Revenue` before generating anything new.

Try:

```bash
npm run dql:app:show
dql lineage --block "Monthly Revenue"
dql agent ask "how did revenue trend over the last six months?"
```

## Scenario 2: Customer Success Regional Review

**User:** Maya, VP CS; Alice/Ben/Lin, regional CS leads  
**App:** `customer-success`  
**Notebook:** `notebooks/customer_cohorts.dqlnb`  
**Dashboard:** `segments-overview`  
**Block:** `Customer Segments`

Business questions:

- How many customers are in each segment?
- How does lifetime spend differ by customer type?
- Can regional leads see only their own view?

Flow:

1. `Customer Segments` defines the certified customer rollup.
2. `customer-success` declares `regional_lead` personas with region attributes.
3. The persona switcher previews the policy/RLS path for each regional user.
4. The weekly schedule delivers the CS digest to `#cs-leads`.

Try:

```bash
dql app show customer-success
dql lineage --app customer-success
```

## Scenario 3: Product Weekly Performance Review

**User:** Product lead, food PM, drinks PM, merchandising  
**App:** `product-team`  
**Notebook:** `notebooks/product_performance.dqlnb`  
**Dashboard:** `top-products`  
**Block:** `Top Products by Revenue`

Business questions:

- What are the top products by revenue?
- Which products have the strongest gross margin?
- Is beverage vs. food mix changing the weekly review?

Flow:

1. dbt builds `order_items` and `stg_products`.
2. `Top Products by Revenue` joins those models and certifies the product ranking.
3. The Product App packages KPI, bar, and table views from the same certified block.
4. New ad hoc product ideas can start in the notebook and then be promoted to blocks.

Try:

```bash
dql app show product-team
dql lineage --block "Top Products by Revenue"
```

## Scenario 4: Governed AI Chat

**User:** Analyst or stakeholder in any App  
**Notebook:** `notebooks/chat_with_data.dqlnb`  
**Skills:** `.dql/skills/cfo-monthly.skill.md`, `.dql/skills/cs-regional.skill.md`

Business questions:

- What was our revenue trend?
- Which customer segment looks strongest?
- What product drove margin?
- Can AI propose a reusable block?

Flow:

1. `dql agent reindex` builds the local SQLite/FTS knowledge graph.
2. The agent searches certified blocks first.
3. If no certified block fits, the agent proposes SQL marked uncertified.
4. Analysts review and promote useful proposals into DQL blocks.

Try:

```bash
npm run dql:agent:reindex
dql agent ask "which product categories are driving margin?"
```

## Scenario 5: End-To-End Setup Check

Run this before demoing the repo:

```bash
npm run dql:doctor
npm run dql:compile
npm run dql:app:build
npm run dql:agent:reindex
```

Expected result: all commands exit successfully, with no unresolved dashboard
block references.
