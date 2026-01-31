---
description: Initialize complex-feature-dev planning files (task_plan.md/findings.md/progress.md)
---

# Initialize Planning Files

Create the 3 planning files in the project root (git repo root by default):
- `task_plan.md`
- `findings.md`
- `progress.md`

Run the initializer:
- macOS/Linux (or Windows Git Bash): `bash "$(ls -dt ~/.claude/plugins/cache/complex-dev-skills/complex-feature-dev/*/scripts/init-session.sh 2>/dev/null | head -1)"`
- Windows PowerShell: `pwsh -ExecutionPolicy Bypass -File "~/.claude/plugins/cache/complex-dev-skills/complex-feature-dev/<version>/scripts/init-session.ps1"`

Confirm the files exist, then stop.
