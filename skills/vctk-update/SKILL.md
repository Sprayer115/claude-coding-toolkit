---
name: vctk-update
user-invocable: true
description: Updates VCTK to the latest version from the remote repository. Use when user says 'update vctk', 'upgrade toolkit', 'get latest version', 'update the toolkit', or when a version update notification appears. Checks for customizations before overwriting.
metadata:
  author: Sprayer115
  version: "0.2.0"
  category: maintenance
  tags: [vctk, dev-workflow, maintenance]
allowed-tools: ["Bash", "AskUserQuestion"]
---

# Update VCTK

## Step 1: Check Current Version

```bash
LOCAL_VER=$(cat .claude/skills/vibe-coding-toolkit/.version 2>/dev/null | tr -d '[:space:]' || echo "not installed")
echo "Current version: $LOCAL_VER"
```

## Step 2: Check Remote Version

```bash
REMOTE_VER=$(curl -fsSL --connect-timeout 5 https://raw.githubusercontent.com/Sprayer115/claude-coding-toolkit/master/VERSION 2>/dev/null | tr -d '[:space:]' || echo "unknown")
echo "Latest version: $REMOTE_VER"
```

## Step 3: Determine Action

- If versions match: Report "Already up to date" and stop
- If remote unknown: Report "Could not check remote version" and stop
- Otherwise: Check for local customizations

```bash
if [ -f ".claude/skills/vibe-coding-toolkit/.customized" ]; then echo "CUSTOMIZED"; else echo "STOCK"; fi
```

If CUSTOMIZED: warn user that update will overwrite changes and ask to confirm. If they cancel, stop and show manual update instructions.

## Step 4: Run Update

```bash
curl -fsSL https://raw.githubusercontent.com/Sprayer115/claude-coding-toolkit/master/install.sh | bash
```

## Step 5: Confirm Update

```bash
NEW_VER=$(cat .claude/skills/vibe-coding-toolkit/.version 2>/dev/null | tr -d '[:space:]')
echo "Updated to version: $NEW_VER"
```

Report: `VCTK updated: {LOCAL_VER} → {NEW_VER}`

---

## Rules

1. **DO** show version comparison before updating
2. **DO NOT** update if versions match
3. **DO NOT** overwrite customized installation without explicit user confirmation
4. **DO** provide link to changelog after update
