# AGENTS.md (Optional)

These instructions help Codex stay consistent on long or complex tasks in this repo.

## File-Based Planning (Required for Complex Tasks)

- Keep 3 files in the **project root**:
  - `task_plan.md` — macro status + summary + next actions + decisions/errors
  - `findings.md` — durable findings + decisions (macro)
  - `progress.md` — short session notes + validations
- Keep them **macro and concise**. Do not maintain per-phase checklists in files.
- **Hard rule:** after every assistant response, update these files to match the latest conversation state.
- If missing, initialize them:
  - macOS/Linux (or Windows Git Bash): `bash "${CODEX_HOME:-$HOME/.codex}/skills/complex-feature-dev/scripts/init-session.sh"`
  - Windows PowerShell: `pwsh -ExecutionPolicy Bypass -File "~/.codex/skills/complex-feature-dev/scripts/init-session.ps1"`

## Workflow Guardrails

- For new features / multi-file changes, follow the 7-phase `complex-feature-dev` workflow.
- Do not start implementation until the user explicitly approves.
- Before major decisions, re-read `task_plan.md` to refresh goals.
- Update `task_plan.md` with macro summary + next actions; log key validations to `progress.md`.
