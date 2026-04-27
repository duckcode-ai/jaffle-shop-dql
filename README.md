<h1 align="center">Jaffle Shop - DQL end-to-end example</h1>

<p align="center">
  <em>A runnable DQL project with dbt, DuckDB, certified blocks, notebooks, Apps, schedules, lineage, and AI chat.</em>
</p>

<p align="center">
  <a href="LICENSE"><img alt="License" src="https://img.shields.io/badge/license-Apache%202.0-blue.svg"></a>
  <a href="https://www.npmjs.com/package/@duckcodeailabs/dql-cli"><img alt="DQL CLI" src="https://img.shields.io/npm/v/@duckcodeailabs/dql-cli?label=%40duckcodeailabs%2Fdql-cli&color=0a7"></a>
  <a href="https://www.getdbt.com/"><img alt="dbt" src="https://img.shields.io/badge/dbt-1.10-FF694B?logo=dbt&logoColor=white"></a>
  <a href="https://duckdb.org/"><img alt="DuckDB" src="https://img.shields.io/badge/DuckDB-ready-FFF000?logo=duckdb&logoColor=black"></a>
</p>

<p align="center">
  <img src="docs/hero.svg" alt="DQL notebook rendering the Jaffle Shop revenue review" width="880">
</p>

This repo is the full worked Jaffle Shop example for DQL OSS. It is larger
than the starter template on purpose: it shows how a single local user can
package trusted analytics into business-facing Apps while keeping everything
as source files.

## UI Walkthrough

**Finance App with live certified blocks** — the Apps Command Center packages
the monthly business review, dashboard tiles, persona preview, and certified
block citations from git-backed `apps/` and `blocks/` files.

![Finance App dashboard](docs/media/apps.gif)

**Certified Block Library** — search across block names, domains, owners,
tags, descriptions, and agent-facing context before reusing a block in a
notebook or App.

![Certified block library](docs/media/studio.gif)

**End-to-end lineage** — follow the path from source tables and dbt models to
DQL blocks and the Apps/notebooks that consume them.

![Jaffle lineage](docs/media/lineage.gif)

**AI provider setup** — configure Claude, OpenAI, Gemini, Ollama, Slack, and
email keys from Settings; missing providers stay optional until selected.

![AI provider settings](docs/media/agent.gif)

## What You Get

- DuckDB warehouse built from the canonical Jaffle Shop tap and dbt models
- Certified DQL blocks for `finance`, `customer`, and `product`
- Notebook workflows for revenue review, cohorts, product performance, and AI chat
- First-class Apps under `apps/<app-id>/dql.app.json`
- Dashboard `.dqld` files with certified block references
- Persona preview, policies, schedules, lineage, Skills, and MCP examples

Legacy note: `apps/q4_finance.dql-app/` is kept only as a backwards
compatibility example. New users should start with `finance-cxo`,
`customer-success`, and `product-team`.

## Quickstart

Pick one path.

### Option A: Docker

Use this if you want the least local setup. You only need Docker Desktop or a
compatible Docker engine.

```bash
git clone https://github.com/duckcode-ai/jaffle-shop-dql.git
cd jaffle-shop-dql
docker compose up --build
```

Open [http://127.0.0.1:3474](http://127.0.0.1:3474), then start with
`notebooks/welcome.dqlnb`.

First run builds the image, installs Meltano plugins, extracts the sample
Jaffle data, runs dbt, compiles DQL, and starts the notebook. Expect a few
minutes on a clean machine. Later starts reuse `jaffle_shop.duckdb`.

Reset the warehouse:

```bash
docker compose down -v
rm -f jaffle_shop.duckdb dql-manifest.json
docker compose up --build
```

Run local Ollama with the notebook:

```bash
docker compose --profile ollama up --build
docker compose --profile ollama exec ollama ollama pull llama3.1
```

### Option B: Native Install

Use this if you already have Node and Python installed.

```bash
git clone https://github.com/duckcode-ai/jaffle-shop-dql.git
cd jaffle-shop-dql

python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
pipx install meltano

meltano install
meltano run tap-jaffle-shop target-duckdb
dbt deps
dbt build --profiles-dir .

npm install
npm run dql:compile
npm run dql:app:build
npm run dql:agent:reindex
npm run dql:notebook
```

Open [http://127.0.0.1:3474](http://127.0.0.1:3474).

See [docs/INSTALL.md](docs/INSTALL.md) for detailed setup and troubleshooting.

## Business Scenarios

| Scenario | App | Notebook | Certified blocks |
| --- | --- | --- | --- |
| CFO monthly business review | `finance-cxo` | `notebooks/revenue_review.dqlnb` | `Monthly Revenue`, `Customer Segments` |
| Regional CS cohort review | `customer-success` | `notebooks/customer_cohorts.dqlnb` | `Customer Segments` |
| Product weekly performance review | `product-team` | `notebooks/product_performance.dqlnb` | `Top Products by Revenue` |
| Ask questions with governed AI | any App | `notebooks/chat_with_data.dqlnb` | block-first KG retrieval |

Read the full walkthrough in [docs/SCENARIOS.md](docs/SCENARIOS.md).

## Project Layout

```text
.
  apps/
    finance-cxo/
      dql.app.json
      dashboards/monthly-review.dqld
      dashboards/quarterly-board.dqld
    customer-success/
      dql.app.json
      dashboards/segments-overview.dqld
    product-team/
      dql.app.json
      dashboards/top-products.dqld
    q4_finance.dql-app/        # legacy compatibility example
  blocks/
    finance/monthly_revenue.dql
    customer/customer_segments.dql
    product/top_products.dql
  models/                      # dbt staging + marts
  notebooks/
  semantic-layer/
  .dql/skills/
```

## Useful Commands

```bash
npm run dql:doctor          # check project and connection health
npm run dql:compile         # write dql-manifest.json
npm run dql:app:build       # compile Apps and .dqld dashboards
npm run dql:agent:reindex   # build local KG/FTS index for AI chat
npm run dql:lineage         # print lineage graph
npm run dql:app:ls          # list first-class Apps
npm run dql:app:show        # show finance-cxo
npm run dql:schedule:list   # list App schedules
npm run dql:mcp             # start MCP server for external agents
```

## AI Chat Providers

The chat notebook can use any configured provider supported by DQL:

```bash
export ANTHROPIC_API_KEY=...
export OPENAI_API_KEY=...
export GEMINI_API_KEY=...
export OLLAMA_BASE_URL=http://127.0.0.1:11434
export OLLAMA_MODEL=llama3.1
```

The important behavior is provider-independent: certified blocks are searched
first, generated SQL is marked uncertified, and proposed blocks go through
review before becoming reusable business logic.

## Setup Check

After setup, this should pass:

```bash
npm run dql:doctor
npm run dql:compile
npm run dql:app:build
npm run dql:agent:reindex
```

## Support

- Main DQL project: https://github.com/duckcode-ai/dql
- DQL CLI: https://www.npmjs.com/package/@duckcodeailabs/dql-cli
- Example repo issues: https://github.com/duckcode-ai/jaffle-shop-dql/issues

Seeded from dbt Labs' Jaffle Shop sample. DQL blocks, notebooks, semantic
layer, Apps, schedules, and chat examples are licensed under Apache 2.0.
