# Feature Development Workflow (Reference)

This file is a more detailed reference for the `complex-feature-dev` Codex skill. It describes the same 7-phase workflow, with richer guidance and reusable prompt templates.

## Core Principles

- **Understand before acting**: explore the existing codebase and patterns first.
- **Ask clarifying questions**: resolve ambiguity early, before designing or implementing.
- **Design deliberately**: present alternatives and trade-offs; pick an approach with explicit approval.
- **Implement in small steps**: keep changes verifiable; avoid unrelated refactors.
- **Review for quality**: correctness, security, conventions, simplicity.
- **Use persistent planning files**: keep `task_plan.md`, `findings.md`, `progress.md` up to date at a **macro** level (status + summary + durable decisions).

## How to Run This in Codex

Codex skills don’t define separate “agent personas” the same way some other tools do. Instead, you simulate multi-agent parallelism by running **multiple independent passes**:

- Phase 2: 2–3 exploration passes (different angles)
- Phase 4: 2–3 architecture passes (different trade-offs)
- Phase 6: 2–3 review passes (different risk focus)

Use the reference prompts below or the role guides:
- `references/code-explorer.md`
- `references/code-architect.md`
- `references/code-reviewer.md`

## Phase Outputs

When presenting results to the user, use the following output templates. Keep them crisp; planning files should remain macro/concise (avoid pasting full phase outputs).

### Phase 1 Output Template (Discovery)

```text
Here’s my understanding of the request:
- Goal:
- In scope:
- Out of scope:
- Constraints / requirements:

Acceptance criteria (draft):
- ...

Before I proceed to codebase exploration, please confirm:
1) ...
2) ...
```

### Phase 2 Output Template (Codebase Exploration)

```text
Found similar features:
- <feature/module> (<path>): <why it’s similar / what pattern it uses>

Key files to understand:
- <path>:<line> - <why it matters>

Summary of patterns discovered:
- ...

Proposed integration points:
- ...
```

### Phase 3 Output Template (Clarifying Questions)

```text
Phase 3: Clarifying Questions

Before designing the architecture, I need to clarify:

1. <question>
2. <question>
3. <question>

After you answer, I will propose 2–3 architecture approaches (Phase 4).
```

### Phase 4 Output Template (Architecture Design)

```text
I've designed 3 approaches:

Approach 1: Minimal Changes
- ...
Pros: ...
Cons: ...

Approach 2: Clean Architecture
- ...
Pros: ...
Cons: ...

Approach 3: Pragmatic Balance
- ...
Pros: ...
Cons: ...

Recommendation: Approach <N> - <one-sentence why>

Which approach would you like to use?
```

### Phase 6 Output Template (Quality Review)

```text
Code Review Results:

High Priority Issues:
1. <issue> (<path>:<line>)
2. <issue> (<path>:<line>)

Medium Priority:
1. <issue> (<path>:<line>)

Test status:
- <what you ran / what passed / what is pending>

What would you like to do?
```

### Phase 7 Output Template (Summary)

```text
Feature Complete: <feature name>

What was built:
- ...

Key decisions:
- ...

Files modified:
- <path> (new/modified)

Suggested next steps:
- ...
```

## Phase 1: Discovery

**Goal:** convert the request into testable acceptance criteria.

Checklist:
- What is the user trying to achieve? What problem does it solve?
- What is in-scope vs out-of-scope?
- Constraints: compatibility, performance, security, rollout/feature flags, timelines.
- Definition of done: explicit acceptance criteria.

Write outcomes to `findings.md` (brief):
- Confirmed requirements
- Acceptance criteria
- Open questions to resolve in Phase 3

## Phase 2: Codebase Exploration

**Goal:** find the correct integration points and match existing conventions.

Run 2–3 independent passes:

### Pass A — Similar Feature Trace

Prompt template:
- “Find the closest existing feature to `<X>`. Trace it end-to-end from entry point to side effects (DB/network/state). List 5–10 key files to read with file:line where possible.”

### Pass B — Architecture & Boundaries

Prompt template:
- “Map the architecture relevant to `<X>`. Identify modules/layers, extension points, and how responsibilities are separated. List 5–10 key files to read.”

### Pass C — Quality & Delivery

Prompt template:
- “Identify how this codebase does tests, linting, builds, config, and observability for features like `<X>`. List the key files/commands the team expects.”

Then actually read the files you identified and summarize:
- Which files you will modify and why
- What conventions must be followed (capture in `findings.md`)

## Phase 3: Clarifying Questions (Hard Stop)

**Goal:** eliminate ambiguity so Phase 5 doesn’t thrash.

Ask questions grouped by:
- Behavior (inputs/outputs/state changes)
- Edge cases (empty values, duplicates, concurrency, ordering, permissions, i18n/timezones)
- Errors (timeouts, retries, idempotency, rollback)
- Integrations (APIs, data models, configs, feature flags)
- Compatibility & migration
- Performance assumptions
- Observability (logs/metrics/traces)
- Testing & acceptance plan

Wait for answers, or propose defaults and require explicit confirmation. Record final answers in `findings.md`.

## Phase 4: Architecture Design

**Goal:** propose approaches with trade-offs and get a choice.

Provide at least 2 approaches:
- **Minimal changes**: smallest surface area, maximum reuse
- **Pragmatic balance**: clearer boundaries without big refactors
- *(Optional)* **Clean architecture**: best long-term structure, larger change set

For each approach include:
- Files to create/modify
- Key abstractions + data flow
- Risks/trade-offs (time, complexity, testability, maintainability)

End with:
- Recommendation
- “Which approach should we implement?”
- “Do you approve starting implementation (Phase 5)?”

## Phase 5: Implementation (Requires Approval)

**Goal:** ship the chosen design in small, verifiable increments.

Guidelines:
- Keep steps small and testable.
- Prefer established patterns and reuse.
- Avoid drive-by refactors.
- Log (brief): key actions/files/tests in `progress.md`; errors in `task_plan.md`.

## Phase 6: Quality Review

**Goal:** catch high-impact issues before delivery.

Use `references/code-reviewer.md` as the checklist.

## Phase 7: Summary

**Goal:** clean handoff.

Include:
- What was built
- Key decisions
- Files modified
- How to verify
- Risks and suggested next steps
