---
description: "Update VCTK to the latest version"
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

Compare versions:

- If `LOCAL_VER` equals `REMOTE_VER`: Report "Already up to date" and stop
- If `REMOTE_VER` is "unknown": Report "Could not check remote version" and stop
- Otherwise: Proceed to Step 3a

## Step 3a: Check for Local Customizations

```bash
if [ -f ".claude/skills/vibe-coding-toolkit/.customized" ]; then
  echo "CUSTOMIZED"
else
  echo "STOCK"
fi
```

If `CUSTOMIZED`:

```
AskUserQuestion({
  questions: [{
    question: "⚠ This is a customized installation. Running the upstream update WILL overwrite your changes. How do you want to proceed?",
    header: "Customized",
    options: [
      { label: "Cancel", description: "Stop here — I'll update manually to preserve my changes" },
      { label: "Update anyway", description: "I understand my customizations will be overwritten" }
    ],
    multiSelect: false
  }]
})
```

If "Cancel" → Stop immediately. Show:

```
Update cancelled. Your customized commands are unchanged.
To update manually: download individual files from https://github.com/Sprayer115/claude-coding-toolkit
```

If "Update anyway" → Proceed to Step 4.

If `STOCK` → Proceed to Step 4 directly.

## Step 4: Run Update

Execute the install script:

```bash
curl -fsSL https://raw.githubusercontent.com/Sprayer115/claude-coding-toolkit/master/install.sh | bash
```

## Step 5: Confirm Update

```bash
NEW_VER=$(cat .claude/skills/vibe-coding-toolkit/.version 2>/dev/null | tr -d '[:space:]')
echo "Updated to version: $NEW_VER"
```

Report completion:

```
✓ VCTK updated: {LOCAL_VER} → {NEW_VER}

Changelog: https://github.com/Sprayer115/claude-coding-toolkit/releases
```

---

## Rules

1. **DO** show version comparison before updating
2. **DO** report if already up to date
3. **DO NOT** update if versions match
4. **DO NOT** overwrite a customized installation without explicit user confirmation
5. **DO** provide link to changelog after update
