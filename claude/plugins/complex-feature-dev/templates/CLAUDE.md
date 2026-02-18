# CLAUDE.md

This repo uses file-based planning. Your job is to keep the planning files synchronized with the conversation.

## Required persistent files (project root)

- `task_plan.md`
- `findings.md`
- `progress.md`

## Hard Rule: Update Every Turn

After **every** assistant response (even if it’s only questions), update the three files so they match the latest conversation state:

1) `task_plan.md`
- Keep `**Overall Status:** in_progress|complete` accurate.
- Optionally track `**Current Micro-Phase:** Phase X/7 — <name>` for orientation.
- Keep the macro summary and “Next Actions” list up to date.

2) `findings.md`
- Capture durable information only: confirmed requirements, constraints, key decisions, and key file pointers (prefer `path:line`).
- Keep “Open Questions” current (move resolved ones into “Decisions”).

3) `progress.md`
- Append a brief chronological log (what you did + what changed).
- Record commands/tests run and results.

## Style Constraints

- Keep everything **macro and concise** (no transcripts).
- Do **not** maintain per-phase (1–7) checklists in files; phases run in-chat.
- Prefer references (`path:line`, commands, links) over long dumps.
