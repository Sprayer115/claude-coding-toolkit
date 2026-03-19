# Explore Skill Template

Use this template to create a guided codebase exploration skill for your project. This is especially useful for large or legacy codebases where context-building before changes is critical.

## What It Does

An explore skill:
1. Presents the project's subsystems as options to explore
2. Loads existing documentation first (avoiding redundant work)
3. Runs targeted file exploration for the selected scope
4. Synthesizes findings into a structured mental model
5. Offers to save the mental model to `.agent/` docs

## How to Use This Template

1. Copy this `explore-skill/` folder to your project's `.claude/skills/` directory
2. Rename it: `my-project-explore/`
3. Open `SKILL.md` and replace all `PROJECT_*` placeholders
4. List your project's real subsystems as the AskUserQuestion options
5. Set the actual file paths and extensions for your project

## When to Use

- Large codebases with many subsystems
- Legacy systems with undocumented areas
- Onboarding new developers (or new Claude sessions) to unfamiliar code
- Before starting work in a part of the codebase you haven't touched in a while
