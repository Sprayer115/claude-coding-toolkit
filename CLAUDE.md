# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

The Claude Coding Toolkit (CCT) is a set of Claude Code commands and skills that implement a 4-phase AI-augmented development workflow. It is **not a runnable application** — it is a collection of markdown prompt files and a bash installer that deploy those files into a target project's `.claude/` directory.

Current version: `VERSION` file at repo root (currently `0.1.0`).

## Repository Structure

```text
commands/       # Claude slash command definitions (vctk-*.md)
skills/         # Skill definitions loaded by Claude's skill system
  feature-brief/
  technical-spec/
  implement-feature/
  review-code/
  (each has SKILL.md + references/*.md)
dist/           # Pre-built .skill bundles (not hand-edited)
install.sh      # Installs commands + skills into target project's .claude/
uninstall.sh    # Removes installed files
.claude-plugin/ # Plugin manifest (plugin.json)
VERSION         # Single version string, read by install.sh and vctk-update
```

## The Two Parallel Systems

Commands (`commands/vctk-*.md`) and Skills (`skills/*/SKILL.md`) implement the same workflow phases but serve different invocation paths:

- **Commands** are invoked explicitly by the user via `/vctk-feature-brief` etc. They use `AskUserQuestion` heavily for interactive, multi-step interviews.
- **Skills** are triggered automatically by Claude based on context (the `description:` field in the frontmatter is what Claude uses for matching). Skills are more compact — no interactive prompts, strict protocols, direct output format.

When modifying a workflow phase, both the command and the corresponding skill usually need to stay in sync. The skill is typically the stricter, more disciplined version.

## Workflow Phases and Their Gates

| Phase | Command | Skill | Gate |
| --- | --- | --- | --- |
| 1 Discovery | `vctk-feature-brief` | `feature-brief` | None |
| 2 Design | `vctk-technical-spec` | `technical-spec` | Requires `BRIEF-*.md` in `.agent/briefs/` |
| 3 Build | `vctk-implement-feature` | `implement-feature` | Requires `SPEC-*.md` with `status: APPROVED FOR IMPLEMENTATION` |
| 4 Verify | `vctk-review-code` | `review-code` | Requires `SPEC-*.md` |

Gates are enforced by checking for files with `ls` inside the command/skill. If the gate check fails, the command stops immediately with a plain-text error — it does not silently continue.

## Document Output Paths

All workflow documents are written to the **target project's** `.agent/` directory (not this repo):

- `.agent/briefs/BRIEF-[name]-[YYYY-MM-DD].md` — feature briefs
- `.agent/specs/SPEC-[name]-[YYYY-MM-DD].md` — technical specs
- `.agent/sessions/{dev}/last_session.md` — session summaries
- `.agent/System/` — architecture docs (from `vctk-sync-docs`)
- `.agent/SOP/` — standard operating procedures

## Install Script Behavior

`install.sh` downloads files from the GitHub raw URL into the target project. Key behaviors:

- Migrates old unprefixed command names (`feature-brief.md` → `vctk-feature-brief.md`)
- Writes `.claude/skills/vibe-coding-toolkit/.version` from `VERSION`
- Touches `.claude/skills/vibe-coding-toolkit/.customized` as a marker
- `vctk-update` reads `.customized` to warn before overwriting local changes

When adding a new command, it must be added to the `COMMANDS` array in `install.sh` and the required count in `vctk-init.md` must be updated (currently expects 11).

## Key Design Constraints

**No silent fallbacks.** Every command either proceeds or stops with an explicit message. The pattern throughout is: check precondition → if missing, stop with a clear message → only then proceed.

**Role separation enforced in prompts.** Each command declares an agent role (INTERVIEWER, RESEARCHER, EXECUTOR, AUDITOR) and each role has explicit forbidden actions. The EXECUTOR (`implement-feature`) has the most restrictions: no error handling beyond spec, no refactoring, no logging, no type definitions beyond what's needed.

**Confidence threshold for review.** `vctk-review-code` and the `review-code` skill only report findings with ≥80 confidence as blocking. The rubric lives in `skills/review-code/references/confidence-scoring.md`.

**CLAUDE.md learning.** `vctk-learn` and `vctk-save-session` both append to the target project's `CLAUDE.md` under a `## Learned Rules` section, with `<!-- learned YYYY-MM-DD -->` comments. Rules are always shown to the user before writing — never auto-saved.

## Frontmatter Conventions

Commands use:

```yaml
---
description: "..."
allowed-tools: ["Read", "Write", ...]
---
```

Skills use:

```yaml
---
name: skill-name
description: "..."
---
```

The `description` field in skills is critical — Claude uses it for automatic skill matching. Keep it precise and include trigger phrases.

## What Needs Staying in Sync

When `implement-feature/SKILL.md` or its references change, the corresponding `commands/vctk-implement-feature.md` should be reviewed for consistency (and vice versa). The same applies to all four workflow phases. The command and skill for the same phase should never contradict each other on gate behavior, output paths, or role constraints.
