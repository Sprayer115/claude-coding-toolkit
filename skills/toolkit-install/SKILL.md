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

## Step 1: Determine install target

Determine the project install directory dynamically from the current working directory:

```bash
# Project-local install: use .claude/ in the current working directory
PROJECT_DIR="$(pwd)"
PROJECT_CLAUDE_DIR="$PROJECT_DIR/.claude"
INSTALL_DIR="$PROJECT_CLAUDE_DIR/skills/vibe-coding-toolkit"
REPO_DIR="/c/Users/iLux1/entwicklung/claude-toolkit/claude-vibe-coding-toolkit-main"

INSTALLED_VER=$(cat "$PROJECT_CLAUDE_DIR/skills/.vctk-version" 2>/dev/null | tr -d '[:space:]' || echo "")
REPO_VER=$(cat "$REPO_DIR/VERSION" 2>/dev/null | tr -d '[:space:]' || echo "unknown")

echo "Target project  : $PROJECT_DIR"
echo "Install dir     : $PROJECT_CLAUDE_DIR/skills"
echo "Repo version    : $REPO_VER"
if [[ -n "$INSTALLED_VER" ]]; then
  echo "Installed       : $INSTALLED_VER"
  echo "MODE=update"
else
  echo "Installed       : not found"
  echo "MODE=fresh"
fi
```

Show the user:
- Target project directory
- Current installed version (or "not installed")
- Repo version available

## Step 2: Confirm action

- **Fresh install**: Ask user to confirm: "VCTK is not installed in this project. Install v{REPO_VER} to `{PROJECT_DIR}/.claude/`?"
- **Same version**: Inform user "VCTK {INSTALLED_VER} is already up to date in this project. Reinstall anyway?" and wait for confirmation.
- **Newer version available**: Ask "Update VCTK from {INSTALLED_VER} → {REPO_VER} in this project?"

If user declines, stop.

## Step 3: Run installer targeting the project directory

```bash
PROJECT_DIR="$(pwd)"
REPO_DIR="/c/Users/iLux1/entwicklung/claude-toolkit/claude-vibe-coding-toolkit-main"

if [[ ! -f "$REPO_DIR/install.sh" ]]; then
  echo "ERROR: install.sh not found at $REPO_DIR"
  echo "Check that the local repo exists at the expected path."
  exit 1
fi

# Install into the current project's .claude directory
VCTK_NON_INTERACTIVE=true VCTK_INSTALL_DIR="$PROJECT_DIR/.claude" bash "$REPO_DIR/install.sh"
```

If `VCTK_INSTALL_DIR` is not supported by install.sh, fall back to manually copying the skills:

```bash
PROJECT_DIR="$(pwd)"
REPO_DIR="/c/Users/iLux1/entwicklung/claude-toolkit/claude-vibe-coding-toolkit-main"
SKILLS_DEST="$PROJECT_DIR/.claude/skills"

mkdir -p "$SKILLS_DEST"

# Copy each skill flat into .claude/skills/<skill-name>/ (not nested under vibe-coding-toolkit)
# This matches the structure Claude Code expects for project-local skills
for skill_dir in "$REPO_DIR"/skills/*/; do
  skill_name=$(basename "$skill_dir")
  cp -r "$skill_dir" "$SKILLS_DEST/$skill_name"
  echo "Installed skill: $skill_name"
done

# Copy commands if present
if [[ -d "$REPO_DIR/commands" ]]; then
  mkdir -p "$PROJECT_DIR/.claude/commands"
  cp -r "$REPO_DIR"/commands/* "$PROJECT_DIR/.claude/commands/" 2>/dev/null && echo "Commands installed"
fi

# Write version stamp at skills root level
REPO_VER=$(cat "$REPO_DIR/VERSION" 2>/dev/null | tr -d '[:space:]' || echo "unknown")
echo "$REPO_VER" > "$SKILLS_DEST/.vctk-version"

echo "Done. VCTK $REPO_VER installed to $SKILLS_DEST"
```

## Step 4: Verify installation

```bash
PROJECT_DIR="$(pwd)"
SKILLS_DIR="$PROJECT_DIR/.claude/skills"
NEW_VER=$(cat "$SKILLS_DIR/.vctk-version" 2>/dev/null | tr -d '[:space:]' || echo "unknown")
SKILL_COUNT=$(ls "$SKILLS_DIR/" 2>/dev/null | grep -v '^\.' | wc -l | tr -d ' ')
CMD_COUNT=$(ls "$PROJECT_DIR/.claude/commands/" 2>/dev/null | wc -l | tr -d ' ')
echo "Installed version : $NEW_VER"
echo "Skill directories : $SKILL_COUNT"
echo "Commands          : $CMD_COUNT"
```

Report the outcome:
- Target: `{PROJECT_DIR}/.claude/`
- If MODE was `update`: `VCTK updated: {INSTALLED_VER} → {NEW_VER}`
- If MODE was `fresh`: `VCTK {NEW_VER} installed successfully`
- List installed skills and commands

---

## Rules

1. **DO** always resolve the install target from `$(pwd)` — never hardcode `$HOME/.claude`
2. **DO** show the target project directory before running anything
3. **DO NOT** run the installer without user confirmation
4. **DO** use `VCTK_NON_INTERACTIVE=true` to avoid blocking on interactive menu
5. **DO NOT** modify the local repo files — read-only access
6. **DO** fall back to manual copy if the installer doesn't support `VCTK_INSTALL_DIR`
7. **DO** report the final installed version and target path after completion
8. If `install.sh` is not found at the expected repo path, report the error clearly and stop

## Known issue (fixed)

**Skill discovery depth**: Claude Code only discovers project-local skills at `.claude/skills/<skill-name>/SKILL.md` (depth 1). It does NOT recurse into subdirectories like `.claude/skills/vibe-coding-toolkit/<skill-name>/`. The manual copy fallback (Step 3) correctly installs flat. If `install.sh` installs into a `vibe-coding-toolkit/` subdirectory, the skills will not be discovered — the user must manually promote them one level up:

```bash
mv .claude/skills/vibe-coding-toolkit/* .claude/skills/
rmdir .claude/skills/vibe-coding-toolkit
```
