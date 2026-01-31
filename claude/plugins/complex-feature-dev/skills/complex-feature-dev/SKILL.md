---
name: complex-feature-dev
version: "1.0.1"
description: Full-cycle 7-phase feature development workflow with persistent file-based planning (task_plan.md, findings.md, progress.md).
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
hooks:
  PreToolUse:
    - matcher: "Write|Edit|Bash|Read|Glob|Grep"
      hooks:
        - type: command
          command: |
            HOME_DIR="$(cd ~ 2>/dev/null && pwd)"
            SCRIPT_DIR="$(ls -dt "${HOME_DIR}/.claude/plugins/cache/complex-dev-skills/complex-feature-dev"/*/scripts 2>/dev/null | head -1)"
            if [ -z "${SCRIPT_DIR}" ]; then
              CAND="${HOME_DIR}/.claude/plugins/marketplaces/complex-dev-skills/claude/plugins/complex-feature-dev/scripts"
              if [ -d "${CAND}" ]; then
                SCRIPT_DIR="${CAND}"
              fi
            fi
            if [ -z "${SCRIPT_DIR}" ]; then
              echo "[complex-feature-dev] ERROR: cannot locate plugin scripts directory." >&2
              echo "[complex-feature-dev] Expected either:" >&2
              echo "  - ~/.claude/plugins/cache/complex-dev-skills/complex-feature-dev/<version>/scripts" >&2
              echo "  - ~/.claude/plugins/marketplaces/complex-dev-skills/claude/plugins/complex-feature-dev/scripts" >&2
              exit 0
            fi
            IS_WINDOWS=0
            if [ "${OS-}" = "Windows_NT" ]; then
              IS_WINDOWS=1
            else
              UNAME_S="$(uname -s 2>/dev/null || echo '')"
              case "$UNAME_S" in
                CYGWIN*|MINGW*|MSYS*) IS_WINDOWS=1 ;;
              esac
            fi

            ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
            PLAN_FILE="${ROOT}/task_plan.md"
            FINDINGS_FILE="${ROOT}/findings.md"
            PROGRESS_FILE="${ROOT}/progress.md"

            print_plan_head() {
              local file="$1"
              if command -v head >/dev/null 2>&1; then
                head -30 "$file"
              elif command -v sed >/dev/null 2>&1; then
                sed -n '1,30p' "$file"
              elif command -v pwsh >/dev/null 2>&1; then
                pwsh -NoProfile -Command "Get-Content -Path \"$file\" -TotalCount 30"
              elif command -v powershell >/dev/null 2>&1; then
                powershell -NoProfile -Command "Get-Content -Path \"$file\" -TotalCount 30"
              else
                cat "$file"
              fi
            }

            init_plan_files() {
              if [ "$IS_WINDOWS" -eq 1 ]; then
                if command -v pwsh >/dev/null 2>&1; then
                  pwsh -NoProfile -ExecutionPolicy Bypass -File "$SCRIPT_DIR/init-session.ps1" >/dev/null 2>&1 && return 0
                fi
                if command -v powershell >/dev/null 2>&1; then
                  powershell -NoProfile -ExecutionPolicy Bypass -File "$SCRIPT_DIR/init-session.ps1" >/dev/null 2>&1 && return 0
                fi
              fi

              if command -v bash >/dev/null 2>&1; then
                bash "$SCRIPT_DIR/init-session.sh" >/dev/null 2>&1 && return 0
              fi

              if [ -x "$SCRIPT_DIR/init-session.sh" ]; then
                "$SCRIPT_DIR/init-session.sh" >/dev/null 2>&1 && return 0
              fi

              return 1
            }

            if [ -f "$PLAN_FILE" ] && [ -f "$FINDINGS_FILE" ] && [ -f "$PROGRESS_FILE" ]; then
              print_plan_head "$PLAN_FILE"
            else
              echo "[complex-feature-dev] Planning files not found (task_plan.md/findings.md/progress.md). Initializing..."
              init_plan_files || true

              ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
              PLAN_FILE="${ROOT}/task_plan.md"
              FINDINGS_FILE="${ROOT}/findings.md"
              PROGRESS_FILE="${ROOT}/progress.md"

              if [ -f "$PLAN_FILE" ] && [ -f "$FINDINGS_FILE" ] && [ -f "$PROGRESS_FILE" ]; then
                echo "[complex-feature-dev] Initialized planning files."
                print_plan_head "$PLAN_FILE"
              else
                echo "[complex-feature-dev] Init failed. Run manually:"
                echo "  bash \"$SCRIPT_DIR/init-session.sh\""
                echo "  pwsh -ExecutionPolicy Bypass -File \"$SCRIPT_DIR/init-session.ps1\""
              fi
            fi
  PostToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: "echo '[complex-feature-dev] If you completed a phase, update task_plan.md status and record notes in findings.md/progress.md.'"
  Stop:
    - hooks:
        - type: command
          command: |
            HOME_DIR="$(cd ~ 2>/dev/null && pwd)"
            SCRIPT_DIR="$(ls -dt "${HOME_DIR}/.claude/plugins/cache/complex-dev-skills/complex-feature-dev"/*/scripts 2>/dev/null | head -1)"
            if [ -z "${SCRIPT_DIR}" ]; then
              CAND="${HOME_DIR}/.claude/plugins/marketplaces/complex-dev-skills/claude/plugins/complex-feature-dev/scripts"
              if [ -d "${CAND}" ]; then
                SCRIPT_DIR="${CAND}"
              fi
            fi
            if [ -z "${SCRIPT_DIR}" ]; then
              echo "[complex-feature-dev] ERROR: cannot locate plugin scripts directory." >&2
              echo "[complex-feature-dev] Expected either:" >&2
              echo "  - ~/.claude/plugins/cache/complex-dev-skills/complex-feature-dev/<version>/scripts" >&2
              echo "  - ~/.claude/plugins/marketplaces/complex-dev-skills/claude/plugins/complex-feature-dev/scripts" >&2
              exit 0
            fi
            IS_WINDOWS=0
            if [ "${OS-}" = "Windows_NT" ]; then
              IS_WINDOWS=1
            else
              UNAME_S="$(uname -s 2>/dev/null || echo '')"
              case "$UNAME_S" in
                CYGWIN*|MINGW*|MSYS*) IS_WINDOWS=1 ;;
              esac
            fi

            if [ "$IS_WINDOWS" -eq 1 ]; then
              if command -v pwsh >/dev/null 2>&1; then
                pwsh -NoProfile -ExecutionPolicy Bypass -File "$SCRIPT_DIR/check-complete.ps1"
                exit $?
              fi
              if command -v powershell >/dev/null 2>&1; then
                powershell -NoProfile -ExecutionPolicy Bypass -File "$SCRIPT_DIR/check-complete.ps1"
                exit $?
              fi
            fi

            if command -v bash >/dev/null 2>&1; then
              bash "$SCRIPT_DIR/check-complete.sh"
              exit $?
            fi

            if [ -x "$SCRIPT_DIR/check-complete.sh" ]; then
              "$SCRIPT_DIR/check-complete.sh"
              exit $?
            fi

            echo "ERROR: Unable to run completion check (no bash/pwsh found)" >&2
            exit 1
metadata:
  short-description: Full-cycle feature development
---

# Feature Development (Complex Tasks)

A codebase-agnostic workflow for building new features safely:
- 7 phases (discovery → exploration → questions → architecture → implement → review → summary)
- Persistent planning files for long tasks (so goals and discoveries don’t get lost)

## Inputs

Minimum input:
- A 1–2 sentence feature description (what to build + who/why).

Helpful extras (optional):
- Acceptance criteria / examples
- Related files or modules
- Docs / tickets / prototypes (if inaccessible, ask user to paste key parts)

## Non-Negotiable Rules

1. **Never skip Phase 3 (Clarifying Questions).** If anything is underspecified, ask and **wait**.
2. **Never start Phase 5 (Implementation) without explicit approval.**
3. **Use the planning files as persistent memory.** Update them throughout.
4. **Read before decide.** Before major decisions, re-read `task_plan.md`.
5. **Log all errors + don’t repeat failures.** If an action fails, change the approach.

## Quick Start (Planning Files)

This workflow requires these files in the **repo root**:
- `task_plan.md`
- `findings.md`
- `progress.md`

To initialize them, run:
- `/complex-feature-dev:init` (recommended)

Or via terminal:
- macOS/Linux (or Windows Git Bash): `bash "$(ls -dt ~/.claude/plugins/cache/complex-dev-skills/complex-feature-dev/*/scripts/init-session.sh 2>/dev/null | head -1)"`
- Windows PowerShell: `pwsh -ExecutionPolicy Bypass -File "~/.claude/plugins/cache/complex-dev-skills/complex-feature-dev/<version>/scripts/init-session.ps1"`

## Project Guidelines

- Follow `AGENTS.md` / `CLAUDE.md` / `CONTRIBUTING.md` / `README.md` if present.
- Prefer matching existing code patterns over introducing new abstractions.
- Write important conventions you discover into `findings.md`.

---

## Phase 1: Discovery

**Goal:** Make the request concrete and testable.

- If planning files are missing, run the initializer script via the Bash tool and do not proceed until the files exist.
- Restate the request as acceptance criteria; confirm scope and non-goals.
- Capture constraints (compatibility, performance, time, rollout).
- Write confirmed requirements + acceptance criteria to `findings.md`.

## Phase 2: Codebase Exploration

**Goal:** Identify the correct integration points and existing patterns.

Do 2–3 independent exploration passes:
- Pass A: find similar features and trace end-to-end
- Pass B: map architecture boundaries and extension points
- Pass C: identify testing/build/lint/config/observability conventions

For each pass:
- record entry points, call chain, and key files (prefer file:line) in `findings.md`.

Also:
- locate and follow `AGENTS.md` instructions (if present).

## Phase 3: Clarifying Questions (Hard Stop)

**Goal:** Resolve all ambiguity before architecture and implementation.

Ask questions grouped by:
- behavior definition (inputs/outputs/state)
- edge cases (empty values, duplicates, concurrency, ordering, permissions)
- error handling (timeouts, retries, idempotency, rollback)
- integrations (APIs, data models, config, feature flags)
- backward compatibility & migration
- performance assumptions
- observability
- testing & acceptance plan

Wait for answers (or propose defaults and get explicit confirmation). Record final answers in `findings.md`.

## Phase 4: Architecture Design

**Goal:** Present 2–3 viable approaches and let the user choose.

Provide at least:
- Minimal changes (reuse, low risk)
- Pragmatic balance (cleaner boundaries)
- Optional clean architecture (more refactor, higher long-term clarity)

For each approach include:
- files to create/modify
- key abstractions + data flow
- trade-offs (risk/time/testability/maintainability)

Write the chosen approach + rationale to `findings.md` and `task_plan.md`.

## Phase 5: Implementation (Requires Approval)

**Goal:** Implement the chosen approach.

- Implement in small verifiable increments.
- Follow existing conventions; avoid unrelated refactors.
- Log actions/files/tests in `progress.md`.
- Log errors in `task_plan.md` (and resolution in `progress.md`).

## Phase 6: Quality Review

**Goal:** Catch high-impact issues before delivery.

Default review scope:
- Prefer reviewing `git diff` (or specified files).

Focus areas:
- correctness, security/permissions, error handling, observability, conventions, simplicity

Confidence filtering:
- score issues 0–100
- report only issues ≥ 80 confidence, with concrete fixes (file:line)

## Phase 7: Summary

**Goal:** Deliver a clean handoff.

- Summarize what was built, key decisions, and files modified.
- Provide verification steps (commands/endpoints/UI paths).
- Call out risks and suggested next steps.

