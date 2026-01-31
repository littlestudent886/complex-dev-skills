# complex-dev-skills

Personal marketplace repo for AI development workflows.

This repo currently ships the same workflow for:
- Codex (skills)
- Claude Code (plugin marketplace)

## Layout

- `codex/skills/` — Codex skills
- `claude/plugins/` — Claude plugins (installed via Claude plugin marketplace)
- `other-ai/` — Placeholder for future platforms
- `.claude-plugin/marketplace.json` — Claude marketplace manifest

## Install

### Codex (recommended)

Install directly from GitHub:

```bash
python ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo littlestudent886/complex-dev-skills \
  --path codex/skills/complex-feature-dev
```

Restart Codex to pick up new skills.

### Codex (manual)

Copy a skill folder into your Codex skills directory (defaults to `~/.codex/skills`):

```bash
cp -R codex/skills/complex-feature-dev ~/.codex/skills/
```

Note: copy into the parent `~/.codex/skills/` directory (not into `~/.codex/skills/complex-feature-dev/`), otherwise you may end up with a nested duplicate folder.

Restart Codex to pick up new skills.

### Claude Code (plugin marketplace, recommended)

In Claude Code, run:

```text
/plugin marketplace add littlestudent886/complex-dev-skills
/plugin install complex-feature-dev@complex-dev-skills
```

To update later:

```text
/plugin update complex-feature-dev@complex-dev-skills
```

### Claude Code (local path)

For local development/testing, add the local repo path as a marketplace:

```text
/plugin marketplace add /path/to/complex-dev-skills
/plugin install complex-feature-dev@complex-dev-skills
```

## Use

`complex-feature-dev` is a full workflow for complex feature development.

It uses 3 planning files in your repo root:
- `task_plan.md` — phases + status + decisions + errors
- `findings.md` — requirements, discoveries, decisions
- `progress.md` — session log + tests + results

Notes:
- Planning files are created in the git repo root by default.
- Phase 5 (Implementation) requires explicit approval.

### 1) Initialize planning files (recommended)

- Codex: `$complex-feature-dev init`
- Claude Code: `/complex-feature-dev:init`

#### Alternative: initialize via terminal

- Codex (macOS/Linux or Windows Git Bash): `bash ~/.codex/skills/complex-feature-dev/scripts/init-session.sh`
- Codex (Windows PowerShell): `pwsh -ExecutionPolicy Bypass -File "~/.codex/skills/complex-feature-dev/scripts/init-session.ps1"`
- Claude Code (macOS/Linux or Windows Git Bash): `bash "$(ls -dt ~/.claude/plugins/cache/complex-dev-skills/complex-feature-dev/*/scripts/init-session.sh 2>/dev/null | head -1)"`
- Claude Code (Windows PowerShell): `pwsh -ExecutionPolicy Bypass -File "~/.claude/plugins/cache/complex-dev-skills/complex-feature-dev/<version>/scripts/init-session.ps1"`

### 2) Start the workflow

- Codex: `$complex-feature-dev <feature description>`
- Claude Code: `/complex-feature-dev <feature description>`

Example:
- Codex: `$complex-feature-dev Add a dark mode toggle to the settings page`
- Claude Code: `/complex-feature-dev Add a dark mode toggle to the settings page`

### 3) The 7 phases (what to expect)

- Phase 1: clarify requirements + acceptance criteria
- Phase 2: explore the codebase and identify the right integration points
- Phase 3: ask clarifying questions (hard stop until answered/confirmed)
- Phase 4: propose 2–3 architecture approaches and ask you to choose
- Phase 5: implement (only after you explicitly approve)
- Phase 6: review changes and report only high-confidence issues
- Phase 7: summary + verification steps
