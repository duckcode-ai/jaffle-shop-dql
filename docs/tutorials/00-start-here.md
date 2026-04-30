# 00. Start Here

Goal: get the sample running and understand where each DQL artifact lives.

## 1. Install

Use Docker for the fastest path:

```bash
docker compose up --build
```

Or use native setup:

```bash
npm install
npm run setup:warehouse
npm run dql:compile
npm run dql:app:build
npm run dql:notebook
```

Open [http://127.0.0.1:3474](http://127.0.0.1:3474).

## 2. Run The Health Checks

```bash
npm run dql:doctor
npm run dql:validate
npm run dql:compile
npm run dql:app:build
```

Expected result: all commands exit successfully and `dql-manifest.json` is
generated locally.

## 3. Read The Layout

```text
models/                 dbt staging, marts, and semantic definitions
semantic-layer/         DQL-readable metrics and dimensions imported from dbt
blocks/                 reusable DQL answer blocks
notebooks/              analyst workbench and review narratives
apps/                   business-facing Apps and dashboard pages
.dql/skills/            local AI grounding skills
```

## 4. Open The First Notebook

Open `notebooks/welcome.dqlnb`.

Run the cells top to bottom. The notebook shows:

- raw SQL against the local DuckDB warehouse
- KPI and chart cells
- a SQL cell bound to `blocks/customer/customer_segments.dql`
- the first lineage path from dbt mart to DQL block

## 5. Know The Core Flow

```text
dbt build
  -> DQL sync/compile
  -> create or edit blocks
  -> validate/certify
  -> use blocks in notebooks and Apps
  -> ask AI against certified context
```

Next: [Finance Monthly Review](01-finance-monthly-review.md).
