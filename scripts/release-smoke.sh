#!/usr/bin/env bash
set -euo pipefail

read -r -a DQL_CMD <<< "${DQL_BIN:-dql}"

run_dql() {
  printf '\n[dql-smoke] %s %s\n' "${DQL_CMD[*]}" "$*"
  "${DQL_CMD[@]}" "$@"
}

run_dql doctor .
run_dql validate .
run_dql compile .
run_dql sync dbt .
run_dql lineage
run_dql agent reindex

printf '\n[dql-smoke] Release smoke passed.\n'
