---
name: vctk-init
user-invocable: true
description: Preflight check that verifies VCTK installation, project folder structure, version, and git state. Use when user says 'check vctk setup', 'preflight check', 'verify installation', 'is everything installed', 'vctk status', or when troubleshooting toolkit issues. Outputs a readiness report with next steps.
metadata:
  author: Sprayer115
  version: "0.2.0"
  category: maintenance
  tags: [vctk, dev-workflow, maintenance]
allowed-tools: ["Bash", "Read", "Glob", "AskUserQuestion"]
---

# VCTK Preflight Check

Verify that the Vibe Coding Toolkit is properly installed and the project is ready for the workflow.

## Step 1: Check VCTK Installation

```bash
ls -1 .claude/commands/vctk-*.md 2>/dev/null
ls -1 .claude/skills/vibe-coding-toolkit/*/SKILL.md 2>/dev/null
```

Required: 12 commands, 12 skills (all vctk-*).

## Step 2: Check .agent Folder Structure

```bash
for dir in .agent .agent/briefs .agent/specs .agent/sessions .agent/Tasks .agent/System .agent/SOP; do
  if [ -d "$dir" ]; then echo "[ok] $dir"; else echo "[missing] $dir"; fi
done
```

If any missing, report them and create them:
```bash
mkdir -p .agent/{briefs,specs,sessions,Tasks,System,SOP}
```

## Step 3: Check Version and Updates

```bash
LOCAL_VER=$(cat .claude/skills/vibe-coding-toolkit/.version 2>/dev/null | tr -d '[:space:]' || echo "unknown")
REMOTE_VER=$(curl -fsSL --connect-timeout 3 https://raw.githubusercontent.com/Sprayer115/claude-coding-toolkit/master/VERSION 2>/dev/null | tr -d '[:space:]')
```

Report network errors, update availability, or up-to-date status.

## Step 4: Check Current Workflow State

```bash
ls -1 .agent/briefs/BRIEF-*.md 2>/dev/null | head -5
ls -1 .agent/specs/SPEC-*.md 2>/dev/null | head -5
```

## Step 5: Check Git Status

```bash
git branch --show-current 2>/dev/null || echo "(not a git repo)"
git status --short 2>/dev/null | head -5
```

## Step 6: Generate Readiness Report

Output a summary table with: Commands, Skills, .agent folders, Version, Git status.

Show workflow state: number of briefs, specs.

## Step 7: Next Steps

Based on readiness, suggest the appropriate next action. If not ready, offer to run installer or create folders. Always end with the full command reference table.

---

## Rules

1. **DO** show explicit ok/missing status for each component
2. **DO** create missing .agent folders (never silently)
3. **DO** always show the command reference at the end
