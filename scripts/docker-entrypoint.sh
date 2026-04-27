#!/usr/bin/env bash
#
# DQL Jaffle Shop - Docker entrypoint.
#
# Idempotent warehouse seeding:
#   1. If /workspace/jaffle_shop.duckdb does NOT exist, run the meltano EL
#      job (tap-jaffle-shop -> target-duckdb) and `dbt build` to populate it.
#   2. If it already exists, skip. Mount a fresh volume to force a rebuild.
#
# The entrypoint then exec's into whatever CMD the image was given (default:
# `dql notebook --host 0.0.0.0 --no-open`).

set -euo pipefail

WAREHOUSE="/workspace/jaffle_shop.duckdb"

log() {
  printf '\033[1;36m[dql-jaffle]\033[0m %s\n' "$*"
}

if [[ ! -f "${WAREHOUSE}" ]]; then
  log "No warehouse found at ${WAREHOUSE} - seeding from scratch."

  # Step 1: pull raw tables via meltano. `meltano install` is idempotent and
  # keeps older local checkouts from failing when `.meltano/` exists but the
  # plugin venvs are missing or stale.
  log "Refreshing meltano plugin locks..."
  cd /workspace && meltano lock --update

  log "Installing/updating meltano plugins..."
  cd /workspace && meltano install

  log "Running tap-jaffle-shop -> target-duckdb..."
  cd /workspace && meltano run tap-jaffle-shop target-duckdb

  # Step 2: build the dbt models on top of the raw tables.
  log "Running dbt deps + dbt build..."
  cd /workspace && dbt deps && dbt build --profiles-dir .

  log "Warehouse ready at ${WAREHOUSE}"
else
  log "Warehouse already present at ${WAREHOUSE} - skipping seed."
  log "  (run \`docker compose down -v\` to force a rebuild)"
fi

# Optional: rebuild the dql-manifest.json if it's missing or stale.
if [[ ! -f "/workspace/dql-manifest.json" ]]; then
  log "Compiling dql-manifest.json..."
  cd /workspace && dql compile || log "  (compile failed; continuing - fix in the notebook)"
fi

log "Building App manifest entries..."
cd /workspace && dql app build || log "  (app build failed; continuing - inspect Apps in the notebook)"

log "Starting: $*"
exec "$@"
