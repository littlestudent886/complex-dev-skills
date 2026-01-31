#!/usr/bin/env bash
set -euo pipefail

if [ "${#}" -ge 1 ]; then
  PLAN_FILE="${1}"
else
  ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
  PLAN_FILE="${ROOT}/task_plan.md"
fi

if [ ! -f "${PLAN_FILE}" ]; then
  echo "ERROR: ${PLAN_FILE} not found" >&2
  exit 1
fi

echo "=== Complex-Feature-Dev Completion Check ==="

total="$(grep -cE '^### Phase ' "${PLAN_FILE}" || true)"
complete="$(grep -cF '**Status:** complete' "${PLAN_FILE}" || true)"
in_progress="$(grep -cF '**Status:** in_progress' "${PLAN_FILE}" || true)"
pending="$(grep -cF '**Status:** pending' "${PLAN_FILE}" || true)"

: "${total:=0}"
: "${complete:=0}"
: "${in_progress:=0}"
: "${pending:=0}"

echo "Total phases:   ${total}"
echo "Complete:       ${complete}"
echo "In progress:    ${in_progress}"
echo "Pending:        ${pending}"

echo ""

if [ "${total}" -gt 0 ] && [ "${complete}" -eq "${total}" ]; then
  echo "ALL PHASES COMPLETE"
  exit 0
fi

echo "TASK NOT COMPLETE"
exit 1
