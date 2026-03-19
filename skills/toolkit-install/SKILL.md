---
name: toolkit-install
user-invocable: true
description: Installs or updates the Vibe Coding Toolkit (VCTK) on this system from the local repository. Use when user says 'install toolkit', 'install vctk', 'setup toolkit', 'update toolkit', 'reinstall vctk', or 'toolkit setup'. Runs install.sh from the local clone and reports installation status.
metadata:
  author: iLux1
  version: "0.2.1"
  category: maintenance
  tags: [vctk, dev-workflow, maintenance, global]
allowed-tools: ["Bash", "AskUserQuestion"]
---

# Toolkit Install / Update

Local repo path: `C:/Users/iLux1/entwicklung/claude-toolkit/claude-vibe-coding-toolkit-main`

## Step 1: Check current installation status

```bash
INSTALL_DIR="$HOME/.claude/skills/vibe-coding-toolkit"
INSTALLED_VER=$(cat "$INSTALL_DIR/.version" 2>/dev/null | tr -d '[:space:]' || echo "")
REPO_DIR="/c/Users/iLux1/entwicklung/claude-toolkit/claude-vibe-coding-toolkit-main"
REPO_VER=$(cat "$REPO_DIR/VERSION" 2>/dev/null | tr -d '[:space:]' || echo "unknown")

echo "Repo version : $REPO_VER"
if [[ -n "$INSTALLED_VER" ]]; then
  echo "Installed    : $INSTALLED_VER"
  echo "MODE=update"
else
  echo "Installed    : not found"
  echo "MODE=fresh"
fi
```

Show the user:
- Current installed version (or "not installed")
- Repo version available

## Step 2: Confirm action

- **Fresh install**: Ask user to confirm: "VCTK is not installed. Install v{REPO_VER} now? (all default components)"
- **Same version**: Inform user "VCTK {INSTALLED_VER} is already up to date. Reinstall anyway?" and wait for confirmation.
- **Newer version available**: Ask "Update VCTK from {INSTALLED_VER} → {REPO_VER}?"

If user declines, stop.

## Step 3: Run installer from local repo

```bash
REPO_DIR="/c/Users/iLux1/entwicklung/claude-toolkit/claude-vibe-coding-toolkit-main"

if [[ ! -f "$REPO_DIR/install.sh" ]]; then
  echo "ERROR: install.sh not found at $REPO_DIR"
  echo "Check that the local repo exists at the expected path."
  exit 1
fi

# Run installer in non-interactive mode with all defaults
cd "$HOME" && VCTK_NON_INTERACTIVE=true bash "$REPO_DIR/install.sh"
```

## Step 4: Verify installation

```bash
NEW_VER=$(cat "$HOME/.claude/skills/vibe-coding-toolkit/.version" 2>/dev/null | tr -d '[:space:]' || echo "unknown")
SKILL_COUNT=$(ls "$HOME/.claude/skills/vibe-coding-toolkit/" 2>/dev/null | wc -l | tr -d ' ')
echo "Installed version : $NEW_VER"
echo "Skill directories : $SKILL_COUNT"
```

Report the outcome:
- If MODE was `update`: `VCTK updated: {INSTALLED_VER} → {NEW_VER}`
- If MODE was `fresh`: `VCTK {NEW_VER} installed successfully`
- List what was installed (skills + commands)

---

## Rules

1. **DO** show version comparison before running the installer
2. **DO NOT** run the installer without user confirmation
3. **DO** use `VCTK_NON_INTERACTIVE=true` to avoid blocking on the interactive menu
4. **DO NOT** modify the local repo files — read-only access
5. **DO** report the final installed version after completion
6. If `install.sh` is not found at the expected repo path, report the error clearly and stop
