# Claude Plugins

This folder contains plugins intended for Claude Code's plugin marketplace.

- Plugins live in `plugins/<plugin-name>/`
- The marketplace manifest is at `.claude-plugin/marketplace.json`

Quick install (in Claude Code):

```text
/plugin marketplace add littlestudent886/complex-dev-skills
/plugin install complex-feature-dev@complex-dev-skills
```

Use:

```text
/complex-feature-dev:init
/complex-feature-dev <feature description>
```
