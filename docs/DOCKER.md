# Docker Reference

Docker is the preferred demo path because it hides the Python, dbt, Meltano,
and Node setup behind one command.

## Services

| Service | Profile | Purpose |
| --- | --- | --- |
| `notebook` | default | Builds the warehouse and runs DQL Notebook on port 3474 |
| `ollama` | `ollama` | Optional local LLM service for AI chat |

## Commands

Start:

```bash
docker compose up --build
```

Start with Ollama:

```bash
docker compose --profile ollama up --build
docker compose --profile ollama exec ollama ollama pull llama3.1
```

Run one-off DQL commands inside the container:

```bash
docker compose exec notebook dql app ls
docker compose exec notebook dql agent reindex
docker compose exec notebook dql compile .
docker compose exec notebook dql app build
```

Open a shell:

```bash
docker compose exec notebook bash
```

Reset:

```bash
docker compose down -v
rm -f jaffle_shop.duckdb jaffle_shop.duckdb.wal dql-manifest.json
docker compose up --build
```

## What The Entrypoint Does

The entrypoint in `scripts/docker-entrypoint.sh` is idempotent:

1. If `jaffle_shop.duckdb` does not exist, it installs Meltano plugins.
2. It runs the tap and loads raw tables into DuckDB.
3. It runs dbt deps/build.
4. It compiles DQL and builds App manifest entries.
5. It starts the notebook server.

If the DuckDB file already exists, seeding is skipped.
