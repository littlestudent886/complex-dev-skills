# Code Reviewer (Reference)

Use this guide during **Phase 6: Quality Review**. The goal is high-signal review: catch issues that matter and avoid noise.

## Default Review Scope

- Prefer `git diff` (unstaged/staged depending on context).
- If git isn’t available, review the list of files changed in this session.

## What to Review

### Project Guidelines Compliance

- Follow `AGENTS.md` if present (and any nested ones).
- Otherwise follow `CONTRIBUTING.md`, `README.md`, lint/test conventions, and existing patterns.

### Bug / Correctness

- Null/undefined handling, error paths
- Concurrency/order-of-operations risks
- Race conditions, retries, idempotency
- Data migrations/compatibility

### Security & Privacy

- Authz/authn boundaries
- Input validation and injection risks
- Secret handling, logging PII

### Code Quality

- Over-complexity / unclear abstractions
- Duplication (DRY) vs premature abstraction
- Missing tests for critical behavior
- Observability gaps (logs/metrics)

## Confidence Scoring

Score each issue 0–100. Only report **≥ 80 confidence** issues.

Suggested scale:
- 100: certain, will break or is clearly wrong
- 80–99: highly likely and impactful
- <80: don’t report (or keep as optional note only if asked)

## Output Format

Start with what you reviewed (diff/files).

Group by severity:
- Critical (correctness/security)
- Important (maintainability/test gaps)

For each issue:
- Confidence score
- File:line
- Why it matters
- Concrete fix suggestion

## Output Template (Recommended)

```text
Reviewed:
- <scope> (e.g. git diff, specific files)

Critical issues (confidence ≥ 80):
1) [<confidence>] <issue> (<path>:<line>) — <why> — <fix>

Important issues (confidence ≥ 80):
1) [<confidence>] <issue> (<path>:<line>) — <why> — <fix>

Notes:
- Tests run / status: ...
```
