---
description: "Initialize developer session with lazy-loaded project context"
allowed-tools: ["Bash", "Read", "Glob", "AskUserQuestion"]
---

# Initialize Session

## Step 1: Check for VCTK Updates

Run this check silently and store the result:

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

If output starts with `NETWORK_ERROR`, show at the TOP:

```
⚠ Could not check for VCTK updates (network unavailable).
```

If output starts with `UPDATE_AVAILABLE`, show this notice at the TOP of your response:

```
┌─────────────────────────────────────────────────────────────┐
│  ⬆️  VCTK Update Available: {LOCAL_VER} → {REMOTE_VER}       │
│  Run: curl -fsSL https://raw.githubusercontent.com/         │
│       Sprayer115/claude-coding-toolkit/master/install.sh    │
│       | bash                                                │
└─────────────────────────────────────────────────────────────┘
```

If `UP_TO_DATE`, show nothing about versions—proceed silently.

## Step 2: Identify Developer

```bash
git config user.name 2>/dev/null
```

Store the result as `$DEV_USERNAME`.

If the result is empty (not a git repo, or `user.name` not configured), do NOT silently continue with a blank username. Show:

```
⚠ Could not determine developer identity (git user.name is not set).
```

Then ask:

```
AskUserQuestion({
  questions: [{
    question: "What name should I use for your session files?",
    header: "Identity",
    options: [
      { label: "Enter in chat", description: "I'll type my name" },
      { label: "Use 'developer'", description: "Use a generic fallback name" }
    ],
    multiSelect: false
  }]
})
```

Sanitize `$DEV_USERNAME` before using it in file paths: replace spaces and special characters with dashes (e.g. "John Doe" → "John-Doe").

## Step 3: Load Session Context

Read the developer's session file:

`.agent/sessions/{$DEV_USERNAME}/last_session.md`

If file doesn't exist, that's OK—new developer. Say so briefly and continue.

## Step 4: Display Context Index

Output this reference table—DO NOT read these files, just list them:

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

Run briefly:

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

End with:

```
Session initialized for **{$DEV_USERNAME}**.

What would you like to work on?
```

---

## Rules

1. **DO NOT** read full documentation files during init
2. **DO NOT** summarize large README files
3. **DO** keep total output under 80 lines
4. **DO** let the developer request specific docs when needed
5. **DO** use Read tool later during actual work, not during init
6. **DO** show update notice prominently if available
