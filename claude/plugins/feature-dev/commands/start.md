---
description: Guided feature development with file-based planning (task_plan.md/findings.md/progress.md)
argument-hint: Optional feature description
---

# Feature Development (with Planning Files)

You are helping a developer implement a new feature. Follow a systematic approach:
1) understand the codebase deeply, 2) identify and ask about all underspecified details, 3) design an elegant architecture, 4) implement in small verifiable steps, 5) review, 6) summarize.

This workflow uses **persistent planning files** (in the project root) to avoid losing context in long sessions:
- `task_plan.md` — phases + status + decisions + errors
- `findings.md` — requirements, discoveries, decisions
- `progress.md` — chronological log + tests/results

## Before You Start (Required)

If any of these are missing in the project root: `task_plan.md`, `findings.md`, `progress.md`:

1. Run `/feature-dev:init`
2. Confirm the files exist.
3. Stop (do not proceed into Phase 1 until they exist).

## Non-Negotiable Rules

1. **Never skip Phase 3 (Clarifying Questions).** If anything is underspecified, ask and **wait**.
2. **Never start Phase 5 (Implementation) without explicit approval.**
3. **Use the planning files as persistent memory.** Update them throughout.
4. **Read before decide.** Before major decisions, re-read `task_plan.md`.
5. **Log all errors + don’t repeat failures.** If an action fails, change the approach.

## Project Guidelines

- Follow `AGENTS.md` / `CLAUDE.md` / `CONTRIBUTING.md` / `README.md` if present.
- Prefer matching existing code patterns over introducing new abstractions.

---

## Phase 1: Discovery

**Goal**: Understand what needs to be built.

Initial request: $ARGUMENTS

**Actions**:
1. Create a todo list with all phases.
2. Restate the request as acceptance criteria; confirm scope and non-goals.
3. Capture constraints (compatibility, performance, timeline, rollout).
4. Record confirmed requirements + acceptance criteria in `findings.md`.

---

## Phase 2: Codebase Exploration

**Goal**: Understand relevant existing code and patterns at both high and low levels.

**Actions**:
1. Launch 2–3 `code-explorer` agents in parallel. Each agent should:
   - trace execution end-to-end and map abstractions/layers
   - focus on a different lens (similar features, architecture boundaries, UX/testing patterns)
   - return a list of 5–10 key files to read (with file:line)
2. Read the key files returned by agents to build deep context.
3. Summarize findings (entry points, call chains, data flow, conventions) and write them to `findings.md`.

---

## Phase 3: Clarifying Questions (Hard Stop)

**Goal**: Resolve all ambiguity before architecture and implementation.

**CRITICAL**: DO NOT SKIP.

**Actions**:
1. Review the Phase 2 findings and the original request.
2. Identify underspecified behavior: edge cases, error handling, integration points, scope boundaries, backward compat/migrations, performance, observability, testing.
3. Present **all** questions in a clear, organized numbered list.
4. **Wait for answers** before proceeding to architecture design.

If the user says “whatever you think is best”, propose reasonable defaults and get explicit confirmation.

---

## Phase 4: Architecture Design

**Goal**: Present 2–3 implementation approaches with different trade-offs.

**Actions**:
1. Launch 2–3 `code-architect` agents in parallel with different focuses:
   - minimal change (maximum reuse, lowest risk)
   - pragmatic balance (speed + quality)
   - cleaner architecture (more refactor, better long-term maintainability)
2. Consolidate: summarize each approach + trade-offs + your recommendation.
3. Ask the user which approach they prefer.
4. Record the chosen approach + rationale in `findings.md` and update `task_plan.md`.

---

## Phase 5: Implementation (Requires Approval)

**Goal**: Build the feature.

**DO NOT START WITHOUT USER APPROVAL**

**Actions**:
1. Wait for explicit approval.
2. Implement in small verifiable increments; follow existing conventions.
3. Continuously run the smallest relevant validations (tests/build/lint) as you go.
4. Log actions/files/tests in `progress.md`.
5. Update `task_plan.md` phase status.

---

## Phase 6: Quality Review

**Goal**: Catch high-impact issues before delivery.

**Actions**:
1. Launch 2–3 `code-reviewer` agents in parallel with different focuses:
   - correctness/bugs
   - security/permissions/error handling
   - conventions/simplicity/maintainability
2. Consolidate findings and report **only high-confidence issues** with concrete fixes (file:line).
3. Ask the user what they want to do (fix now / defer / proceed).
4. Address issues per user decision; log results to `progress.md`.

---

## Phase 7: Summary

**Goal**: Deliver a clean handoff.

**Actions**:
1. Mark todos complete.
2. Summarize:
   - what was built
   - key decisions
   - files modified
   - verification steps
   - risks + suggested next steps
