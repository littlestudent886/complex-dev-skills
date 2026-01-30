#!/usr/bin/env bash
set -euo pipefail

DATE="$(date +%Y-%m-%d)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
TEMPLATES_DIR="${SKILL_DIR}/assets/templates"

if [ ! -d "${TEMPLATES_DIR}" ]; then
  echo "ERROR: templates directory not found: ${TEMPLATES_DIR}" >&2
  exit 1
fi

usage() {
  cat <<'EOF'
init-session.sh: initialize feature-dev planning files in your project

By default, files are created in the git repo root (if inside a git repo),
otherwise in the current directory.

Usage:
  init-session.sh [--here] [--dir PATH] [--agents] [--force]

Options:
  --here        Create files in the current directory (skip git root detection)
  --dir PATH    Create files in a specific directory
  --agents      Also create AGENTS.md (optional) if missing
  --force       Overwrite existing files
  -h, --help    Show this help
EOF
}

DEST_DIR=""
COPY_AGENTS=0
FORCE=0

while [ "${#}" -gt 0 ]; do
  case "${1}" in
    --here)
      DEST_DIR="$(pwd)"
      shift
      ;;
    --dir)
      if [ "${#}" -lt 2 ]; then
        echo "ERROR: --dir requires a PATH" >&2
        usage >&2
        exit 2
      fi
      DEST_DIR="${2}"
      shift 2
      ;;
    --agents)
      COPY_AGENTS=1
      shift
      ;;
    --force)
      FORCE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: unknown argument: ${1}" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if [ -z "${DEST_DIR}" ]; then
  if GIT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"; then
    DEST_DIR="${GIT_ROOT}"
  else
    DEST_DIR="$(pwd)"
  fi
fi

if [ ! -d "${DEST_DIR}" ]; then
  echo "ERROR: destination directory not found: ${DEST_DIR}" >&2
  exit 1
fi

copy_template() {
  local filename="$1"
  local dst="${DEST_DIR}/${filename}"

  if [ -f "${dst}" ] && [ "${FORCE}" -ne 1 ]; then
    echo "${filename} already exists in ${DEST_DIR}, skipping"
    return 0
  fi

  if [ ! -f "${TEMPLATES_DIR}/${filename}" ]; then
    echo "ERROR: missing template: ${TEMPLATES_DIR}/${filename}" >&2
    exit 1
  fi

  cp "${TEMPLATES_DIR}/${filename}" "${dst}"
  echo "Created ${dst}"
}

copy_template "task_plan.md"
copy_template "findings.md"
copy_template "progress.md"

# Optional: create AGENTS.md
if [ "${COPY_AGENTS}" -eq 1 ]; then
  copy_template "AGENTS.md"
fi

# Fill in date placeholder (if present)
if [ -f "${DEST_DIR}/progress.md" ]; then
  perl -pi -e "s/\\{\\{DATE\\}\\}/${DATE}/g" "${DEST_DIR}/progress.md" 2>/dev/null || true
fi

echo ""
echo "Planning files ready in: ${DEST_DIR}"
echo "  - task_plan.md"
echo "  - findings.md"
echo "  - progress.md"
