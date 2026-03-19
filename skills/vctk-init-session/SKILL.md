---
name: vctk-init-session
user-invocable: true
description: Initializes developer session by loading project context, checking for VCTK updates, and displaying the workflow command reference. Use when user says 'init session', 'start my session', 'load context', 'what was I working on', 'begin session', or at the start of a new conversation. Keeps output under 80 lines.
metadata:
  author: Sprayer115
  version: "0.2.0"
  category: session
  tags: [vctk, dev-workflow, session]
allowed-tools: ["Bash", "Read", "Glob", "AskUserQuestion"]
---

# Initialize Session

## Step 1: Check for VCTK Updates

```bash
LOCAL_VER=$(cat .claude/skills/vibe-coding-toolkit/.version 2>/dev/null | tr -d '[:space:]' || echo "unknown")
REMOTE_VER=$(curl -fsSL --connect-timeout 2 https://raw.githubusercontent.com/Sprayer115/claude-coding-toolkit/master/VERSION 2>/dev/null | tr -d '[:space:]')
CURL_STATUS=$?
if [ $CURL_STATUS -ne 0 ] || [ -z "$REMOTE_VER" ]; then
  echo "NETWORK_ERROR|$LOCAL_VER"
elif [ "$LOCAL_VER" != "$REMOTE_VER" ] && [ "$LOCAL_VER" != "unknown" ]; then
  echo "UPDATE_AVAILABLE|$LOCAL_VER|$REMOTE_VER"
else
  echo "UP_TO_DATE|$LOCAL_VER"
fi
```

Show update notice at top if update available. If network error, show a brief warning. If up to date, proceed silently.

## Step 2: Identify Developer

```bash
git config user.name 2>/dev/null
```

Store as `$DEV_USERNAME`. If empty, ask the user for their name.

Sanitize: replace spaces and special characters with dashes.

## Step 3: Load Session Context

Read `.agent/sessions/{$DEV_USERNAME}/last_session.md` if it exists.

## Step 4: Display Context Index

Show this reference table — DO NOT read these files, just list them:

```
## Quick Reference (load on-demand)

| Need | Location |
|------|----------|
| Project architecture | `.agent/System/` |
| Feature briefs | `.agent/briefs/` |
| Technical specs | `.agent/specs/` |
| Implementation plans | `.agent/Tasks/` |
| How-to guides | `.agent/SOP/` |
```

## Step 5: Show Current State

```bash
git branch --show-current
git status --short | head -10
```

## Step 6: Show Workflow Commands

```
## Vibe Coding Workflow

| Phase | Command | Output |
|-------|---------|--------|
| 1. Discovery | /vctk-feature-brief | .agent/briefs/BRIEF-*.md |
| 2. Design | /vctk-technical-spec | .agent/specs/SPEC-*.md |
| 3. Build | /vctk-implement-feature | Code changes |
| 4. Verify | /vctk-review-code | Audit report |

| Utility | Command |
|---------|---------|
| Adversarial review | /vctk-challenge |
| Tech debt scan | /vctk-techdebt |
| Preflight check | /vctk-init |
| Save session | /vctk-save-session |
| Learn from session | /vctk-learn |
| Update VCTK | /vctk-update |
| Sync docs | /vctk-sync-docs |
```

## Step 7: Ready Prompt

End with: `Session initialized for **{$DEV_USERNAME}**. What would you like to work on?`

---

## Rules

1. **DO NOT** read full documentation files during init
2. **DO** keep total output under 80 lines
3. **DO** show update notice prominently if available
