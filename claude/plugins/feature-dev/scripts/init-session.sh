#!/usr/bin/env bash
set -euo pipefail

DATE="$(date +%Y-%m-%d)"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
TEMPLATES_DIR="${PLUGIN_DIR}/templates"

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
  init-session.sh [--here] [--dir PATH] [--force]

Options:
  --here        Create files in the current directory (skip git root detection)
  --dir PATH    Create files in a specific directory
  --force       Overwrite existing files
  -h, --help    Show this help
EOF
}

DEST_DIR=""
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
  local src="${TEMPLATES_DIR}/${filename}"
  local dst="${DEST_DIR}/${filename}"

  if [ -f "${dst}" ] && [ "${FORCE}" -ne 1 ]; then
    echo "${filename} already exists in ${DEST_DIR}, skipping"
    return 0
  fi

  if [ ! -f "${src}" ]; then
    echo "ERROR: missing template: ${src}" >&2
    exit 1
  fi

  cp "${src}" "${dst}"
  echo "Created ${dst}"
}

copy_template "task_plan.md"
copy_template "findings.md"
copy_template "progress.md"

# Fill in date placeholder (if present)
if [ -f "${DEST_DIR}/progress.md" ]; then
  perl -pi -e "s/\\{\\{DATE\\}\\}/${DATE}/g" "${DEST_DIR}/progress.md" 2>/dev/null || true
fi

echo ""
echo "Planning files ready in: ${DEST_DIR}"
echo "  - task_plan.md"
echo "  - findings.md"
echo "  - progress.md"

