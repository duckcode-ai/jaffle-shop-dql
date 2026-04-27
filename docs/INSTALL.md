# Installation Guide

This guide is intentionally explicit so new users do not have to know DQL,
dbt, Meltano, or DuckDB before starting.

## Recommended Path: Docker

Prerequisite: Docker Desktop or a compatible Docker engine.

```bash
git clone https://github.com/duckcode-ai/jaffle-shop-dql.git
cd jaffle-shop-dql
docker compose up --build
```

Open [http://127.0.0.1:3474](http://127.0.0.1:3474).

What Docker does:

1. Builds an image with Node, Python, dbt-duckdb, Meltano, and DQL CLI.
2. Installs Meltano plugins.
3. Loads Jaffle Shop raw data into `jaffle_shop.duckdb`.
4. Runs `dbt deps` and `dbt build --profiles-dir .`.
5. Runs `dql compile` and `dql app build`.
6. Starts `dql notebook --host 0.0.0.0 --no-open`.

The warehouse is bind-mounted into your checkout as `jaffle_shop.duckdb`, so
subsequent starts are faster.

### Reset Docker State

```bash
docker compose down -v
rm -f jaffle_shop.duckdb jaffle_shop.duckdb.wal dql-manifest.json
docker compose up --build
```

### Docker With Ollama

```bash
docker compose --profile ollama up --build
docker compose --profile ollama exec ollama ollama pull llama3.1
```

The notebook service receives:

```text
OLLAMA_BASE_URL=http://ollama:11434
OLLAMA_MODEL=llama3.1
```

## Native Install

Prerequisites:

| Tool | Version | Notes |
| --- | --- | --- |
| Node.js | 20+ | Runs DQL CLI and notebook UI |
| Python | 3.10+ | Runs dbt-duckdb and Meltano |
| pipx | current | Installs Meltano cleanly |
| git | current | Needed by dbt deps and Meltano plugin install |

Commands:

```bash
git clone https://github.com/duckcode-ai/jaffle-shop-dql.git
cd jaffle-shop-dql

python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

pipx install meltano
meltano lock --update
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

The DQL CLI is installed by `npm install` from this repo's `package.json`, so
you do not need a global `dql` command for the native path.

## Expected Files After Setup

```text
jaffle_shop.duckdb
dql-manifest.json
.dql/cache/agent-kg.sqlite
target/manifest.json
dbt_packages/
```

## Common Failures

| Symptom | Fix |
| --- | --- |
| `docker compose` cannot bind port 3474 | Stop the other process or change the host port in `docker-compose.yml`. |
| `meltano run` fails after a previous partial run | Remove `.meltano/` and rerun `meltano install`. Docker users can run the reset commands above. |
| `dbt build` cannot find `jaffle_raw` tables | Run `meltano run tap-jaffle-shop target-duckdb` first. |
| Notebook shows schema introspection errors | Confirm `jaffle_shop.duckdb` exists and is not locked by another process. |
| Chat cell reports missing provider credentials | Export an API key or use the Ollama profile. |
