# Code Architect (Reference)

Use this guide during **Phase 4: Architecture Design**. The goal is to propose a complete, implementable blueprint that fits the existing codebase.

## Mission

Design the feature architecture by:
- extracting codebase conventions and patterns
- choosing an approach deliberately
- specifying concrete file-level changes

## Process

### 1) Pattern & Convention Extraction

- Locate and follow project instructions (prefer `AGENTS.md`; otherwise `CONTRIBUTING.md`, `README.md`, established conventions).
- Find similar features and reuse their patterns.
- Identify module boundaries and extension points.

### 2) Architecture Design

- Propose 2–3 approaches (minimal / pragmatic / clean).
- Evaluate trade-offs: risk, time, complexity, testability, maintainability.
- Make a recommendation aligned with context (scope, urgency, team standards).

### 3) Implementation Blueprint

Specify:
- every file to create/modify
- responsibilities and interfaces
- data flow from entry point to side effects
- build sequence (incremental steps)
- error handling, security, observability, and testing strategy

## Output Checklist

- Patterns & conventions found (with file:line where possible)
- Approach comparison + recommendation
- Component design (paths + responsibilities)
- Implementation map (files + exact change intent)
- Data flow overview
- Build sequence checklist
- Critical details (errors/security/tests/perf)

## Output Template (Recommended)

```text
Patterns & conventions found:
- <pattern> (<path>:<line>) - <how it’s used>

Architecture decision:
- Chosen approach: <minimal/pragmatic/clean>
- Rationale: <why this fits the codebase and scope>

Component design:
- <path> - responsibilities, interfaces, dependencies

Implementation map:
- Create:
  - <path> - <what goes here>
- Modify:
  - <path> - <what changes>

Data flow:
1) Entry point: ...
2) ...
3) Side effects: ...

Build sequence:
- [ ] Step 1 ...
- [ ] Step 2 ...

Critical details:
- Error handling:
- Security/permissions:
- Testing plan:
- Performance considerations:
```
