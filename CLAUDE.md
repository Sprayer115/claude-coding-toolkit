# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

The Vibe Coding Toolkit (VCTK) is a collection of Claude skills, slash commands, project templates, and a bash installer that deploys those files into a target project's `.claude/` directory. It is **not a runnable application** — all source files are markdown prompts and shell scripts.

Current version: `VERSION` file at repo root (currently `0.2.0`).

## Repository Structure

```
skills/               # All 12 Claude skill definitions (primary system)
  feature-brief/      # Core workflow phases (have references/ subdirs)
  technical-spec/
  implement-feature/
  review-code/
  vctk-challenge/     # Quality + session + maintenance skills
  vctk-techdebt/
  vctk-init-session/
  vctk-save-session/
  vctk-learn/
  vctk-init/
  vctk-update/
  vctk-sync-docs/
commands/             # Thin /slash-command stubs (backward compat)
project-templates/    # Parameterized templates users copy and customize
  context-skill/
  explore-skill/
  agent-profiles/
memory/               # Memory scaffolding templates
  templates/
dist/                 # Pre-built .skill bundles (not hand-edited)
install.sh            # Interactive installer
uninstall.sh
VERSION
```

## Skills-First Architecture (v0.2.0)

Skills are the primary system. Commands are thin backward-compat stubs. Every skill has:

```yaml
---
name: skill-name
user-invocable: true          # allows /skill-name invocation
description: "..."            # Claude uses this for auto-triggering — must include trigger phrases
metadata:
  author: Sprayer115
  version: "0.2.0"
  category: workflow|quality|session|maintenance
  tags: [vctk, dev-workflow]
---
```

The `description` field is the most critical part of a skill file. It must follow the pattern:
> "[What it does]. Use when user [3–5 trigger phrases]. [Key output/result]."

Keep descriptions under 1024 chars and free of XML tags.

## Workflow Phases and Their Gates

| Phase | Skill | Gate |
|-------|-------|------|
| 1 Discovery | `feature-brief` | None |
| 2 Design | `technical-spec` | Requires `BRIEF-*.md` in `.agent/briefs/` |
| 3 Build | `implement-feature` | Requires `SPEC-*.md` with `status: APPROVED FOR IMPLEMENTATION` |
| 4 Verify | `review-code` | Requires `SPEC-*.md` |

Gates are enforced via `ls` inside the skill. If the gate check fails, the skill stops immediately with a plain-text error — no silent fallbacks.

## Skill Categories and Roles

Each skill declares an agent role that has explicit forbidden actions:

- **`feature-brief`** — INTERVIEWER. Never make technical suggestions, never fill gaps with assumptions.
- **`technical-spec`** — RESEARCHER. Presents options, does NOT decide; requires human approval for each decision.
- **`implement-feature`** — EXECUTOR. No creativity, no scope expansion, no error handling beyond spec. Most restrictive role.
- **`review-code`** — AUDITOR. Only reports findings ≥80 confidence. Human makes final decision.
- **`vctk-challenge`** — SENIOR STAFF ENGINEER. Interrogates decisions, max 12 questions per session.
- **`vctk-techdebt`** — TECH DEBT ANALYST. Prioritizes P0–P4 by Impact × Effort matrix.

## Document Output Paths (in target project)

All workflow documents are written to the **target project's** `.agent/` directory (never this repo):

- `.agent/briefs/BRIEF-[name]-[YYYY-MM-DD].md`
- `.agent/specs/SPEC-[name]-[YYYY-MM-DD].md`
- `.agent/sessions/{dev}/last_session.md`
- `.agent/System/` — architecture docs
- `.agent/SOP/` — standard operating procedures

## Install Script Behavior

`install.sh` is interactive (v0.2.0). Key behaviors:

- Detects local vs remote install mode (`local` when run from the cloned repo)
- Presents a grouped toggle menu; user types component names to toggle, Enter to confirm
- Non-interactive fallback (`VCTK_NON_INTERACTIVE=true`) uses defaults
- Writes `.version` file to `$INSTALL_DIR`
- Installs memory scaffold to `~/.claude/projects/{project-slug}/memory/`
- Creates `.agent/{briefs,specs,sessions,Tasks,System,SOP}` in target project

When adding a new skill/command:
1. Add `skills/{name}/SKILL.md`
2. Add `commands/{name}.md` stub
3. Add to `COMPONENT_LABELS` and `DEFAULTS` arrays in `install.sh`
4. Update `vctk-init` required counts

## What Needs Staying in Sync

- The 4 core workflow skills (`feature-brief`, `technical-spec`, `implement-feature`, `review-code`) have matching command stubs. Gate behavior, output paths, and role constraints must not contradict between skill and command.
- `vctk-init` checks for 12 commands and 12 skills — update these counts when adding components.
- `VERSION` is the single source of truth for version strings. The install script and `vctk-update` both read it.
- The `dist/` pre-built `.skill` bundles are not hand-edited; they are built from `skills/` sources.

## CLAUDE.md Learning Convention

`vctk-learn` and `vctk-save-session` both append to the **target project's** `CLAUDE.md` under a `## Learned Rules` section with `<!-- learned YYYY-MM-DD -->` comments. Rules are always shown to the user before writing — never auto-saved.

## Project Templates Convention

Templates in `project-templates/` use `PROJECT_*` placeholder naming throughout and include a **Customization Checklist** at the bottom of each `SKILL.md`. The checklist must be deleted before deployment. Template READMEs explain use cases and customization steps.
