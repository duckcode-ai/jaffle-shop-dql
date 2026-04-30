# Tutorials

These tutorials are meant to be followed in order the first time. Each one ends
with a specific DQL artifact you can inspect in the UI and on disk.

## Tutorial Path

| Step | Tutorial | You will learn |
| --- | --- | --- |
| 0 | [Start Here](00-start-here.md) | How the repo is structured and how to run the first smoke checks |
| 1 | [Finance Monthly Review](01-finance-monthly-review.md) | How dbt marts become certified finance blocks and an App dashboard |
| 2 | [Customer Cohorts](02-customer-cohorts.md) | How an analyst notebook becomes reusable customer blocks and a CS App |
| 3 | [Product Performance](03-product-performance.md) | How product SQL, charts, and margin blocks become a weekly App |
| 4 | [Semantic Metric Block](04-semantic-metric-block.md) | How to build from an imported dbt semantic metric without raw SQL |
| 5 | [AI, Lineage, And Certification](05-ai-lineage-certification.md) | How DQL grounds AI in certified blocks and traces dependencies |

## Command Style

Native commands use `npm run ...` where a script exists. For direct CLI
commands, use `npm exec -- dql ...` so you do not need a global `dql` install.

Docker users can run the same DQL commands inside the notebook service:

```bash
docker compose exec notebook dql app ls
docker compose exec notebook dql lineage
docker compose exec notebook dql agent reindex
```

## Files To Keep Open

```text
blocks/
apps/
notebooks/
semantic-layer/
docs/SCENARIOS.md
```

The UI is useful for exploration, but every important artifact is still a file.
