# Jaffle Shop - DQL example, single-image build.
#
# Bundles every toolchain needed to run the demo:
#   - Python 3.11 + dbt-duckdb (warehouse build)
#   - Meltano 4.x (tap-jaffle-shop -> target-duckdb extract-load)
#   - Node 20 + @duckcodeailabs/dql-cli (notebook + agent)
#
# Entrypoint is smart: if `jaffle_shop.duckdb` already exists at
# `/workspace`, it skips the meltano + dbt build and goes straight to
# `dql notebook`. To rebuild the warehouse, `docker compose down -v`
# (clears the volume) or `docker compose exec notebook bash` and run
# `meltano run tap-jaffle-shop target-duckdb` + `dbt build` manually.
#
# Usage:
#   docker compose up
#   open http://127.0.0.1:3474

FROM node:20-bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PATH="/root/.local/bin:${PATH}" \
    DQL_HOST=0.0.0.0

# Python + build deps (better-sqlite3 / duckdb need them) + git for dbt deps.
RUN apt-get update && apt-get install -y --no-install-recommends \
      python3 python3-venv python3-pip pipx \
      build-essential \
      git curl ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# dbt-duckdb in its own venv keeps it isolated from system pip.
RUN python3 -m venv /opt/dbt-venv \
 && /opt/dbt-venv/bin/pip install --upgrade pip setuptools wheel \
 && /opt/dbt-venv/bin/pip install "dbt-duckdb~=1.10.0"
ENV PATH="/opt/dbt-venv/bin:${PATH}"

# Meltano via pipx - used for the tap-jaffle-shop EL. Keep this aligned with
# `requires_meltano` in meltano.yml; older 3.x images do not reliably resolve
# the Hub loader lock for target-duckdb.
RUN pipx install --pip-args="setuptools<82" meltano==4.1.2

# DQL CLI globally available - published to npm. Pinning to a compatible
# minor; bump alongside the example.
RUN npm i -g @duckcodeailabs/dql-cli@1.4.1

WORKDIR /workspace

# Entrypoint script that seeds the warehouse once, then runs dql notebook.
COPY scripts/docker-entrypoint.sh /usr/local/bin/dql-entrypoint
RUN chmod +x /usr/local/bin/dql-entrypoint

EXPOSE 3474

ENTRYPOINT ["dql-entrypoint"]
CMD ["dql", "notebook", "--host", "0.0.0.0", "--no-open"]
