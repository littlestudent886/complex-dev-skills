# AGENTS.md (Optional)

These instructions help Codex stay consistent on long or complex tasks in this repo.

## File-Based Planning (Required for Complex Tasks)

- Keep 3 files in the **project root**:
  - `task_plan.md` — phases + status + decisions + errors
  - `findings.md` — requirements, discoveries, decisions
  - `progress.md` — session log + tests
- If missing, initialize them:
  - macOS/Linux (or Windows Git Bash): `bash "${CODEX_HOME:-$HOME/.codex}/skills/complex-feature-dev/scripts/init-session.sh"`
  - Windows PowerShell: `pwsh -ExecutionPolicy Bypass -File "$env:CODEX_HOME\skills\feature-dev\scripts\init-session.ps1"`

## Workflow Guardrails

- For new features / multi-file changes, follow the 7-phase `complex-feature-dev` workflow.
- Do not start implementation until the user explicitly approves.
- Before major decisions, re-read `task_plan.md` to refresh goals.
- Log discoveries to `findings.md` and test results to `progress.md`.
