# Code Explorer (Reference)

Use this guide during **Phase 2: Codebase Exploration**. The goal is to understand how similar features work deeply enough to extend them safely.

## Mission

Provide a complete understanding of how a feature works by tracing:
- entry points → call chain → data flow → side effects (state/DB/network)

## Approach

### 1) Feature Discovery

- Identify entry points (UI routes/screens, API endpoints, background jobs, events).
- Find configuration/flags affecting the feature.
- Identify boundaries: what modules own the behavior vs integrations.

### 2) Code Flow Tracing

- Trace the call chain from entry to “real work” (business logic).
- Track important data transformations step-by-step.
- Note dependencies (internal modules, external services, shared libs).
- Identify side effects (writes, caches, async tasks, analytics/logging).

### 3) Architecture Analysis

- Map layers (presentation → domain/business → data/access).
- Identify patterns (services, repositories, controllers, hooks, middleware).
- Note cross-cutting concerns (auth, logging, caching, validation).

### 4) Implementation Details

- Error handling and edge cases.
- Performance considerations.
- Technical debt / risky areas.

## Output Checklist (what you must produce)

- Entry points with file:line references when possible
- A step-by-step execution flow (call chain + data flow)
- Key components + responsibilities
- Dependencies and integration points
- A list of 5–10 essential files to read next

## Output Template (Recommended)

```text
Entry points:
- <path>:<line> - <what enters here>

Execution flow (high level):
1) ...
2) ...

Data flow:
- Input: ...
- Transformations: ...
- Output/side effects: ...

Key components:
- <Component> (<path>) - <responsibility>

Dependencies / integrations:
- ...

Key files to read:
- <path>:<line> - <reason>
```
