# Jaffle Shop DQL Docs

Use this repo as a complete DQL learning path, not just as a fixture.

## Start Here

1. Install and run the project: [INSTALL.md](INSTALL.md).
2. Open the product flow map: [SCENARIOS.md](SCENARIOS.md).
3. Walk the tutorials in order: [tutorials/README.md](tutorials/README.md).
4. Keep Docker-specific commands nearby: [DOCKER.md](DOCKER.md).

## What This Repo Teaches

| Topic | Where to look |
| --- | --- |
| Local setup with DuckDB, Meltano, dbt, and DQL | [INSTALL.md](INSTALL.md) |
| Finance monthly review App | [tutorials/01-finance-monthly-review.md](tutorials/01-finance-monthly-review.md) |
| Customer cohorts and retention | [tutorials/02-customer-cohorts.md](tutorials/02-customer-cohorts.md) |
| Product performance and margin | [tutorials/03-product-performance.md](tutorials/03-product-performance.md) |
| dbt semantic metric to DQL semantic block | [tutorials/04-semantic-metric-block.md](tutorials/04-semantic-metric-block.md) |
| Governed AI, lineage, and certification | [tutorials/05-ai-lineage-certification.md](tutorials/05-ai-lineage-certification.md) |

## Mental Model

```text
dbt models and metrics
  -> semantic-layer/
  -> DQL blocks
  -> notebooks
  -> Apps and dashboards
  -> AI grounding and lineage
```

dbt remains the source of truth for transformations and metrics. DQL packages
trusted answers, reusable blocks, notebooks, Apps, lineage, and review labels.
