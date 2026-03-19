#!/usr/bin/env bash
# VCTK v0.2.0 Installer — Interactive Component Selection
set -euo pipefail

# ─── Config ──────────────────────────────────────────────────────────────────
REPO_RAW="https://raw.githubusercontent.com/Sprayer115/claude-coding-toolkit/master"
VERSION="0.2.0"
INSTALL_DIR=".claude/skills/vibe-coding-toolkit"
COMMANDS_DIR=".claude/commands"

# ─── Colors ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; BOLD='\033[1m'; RESET='\033[0m'

info()    { echo -e "${BLUE}[info]${RESET} $*"; }
success() { echo -e "${GREEN}[ok]${RESET}   $*"; }
warn()    { echo -e "${YELLOW}[warn]${RESET} $*"; }
error()   { echo -e "${RED}[err]${RESET}  $*" >&2; }

# ─── Detection ───────────────────────────────────────────────────────────────
detect_local_install() {
  # Running from a local clone?
  if [[ -f "$(dirname "$0")/skills/feature-brief/SKILL.md" ]]; then
    echo "local"
  else
    echo "remote"
  fi
}

# ─── Component Definitions ────────────────────────────────────────────────────
declare -A COMPONENT_LABELS=(
  [feature-brief]="Phase 1: Requirements extraction"
  [technical-spec]="Phase 2: Research & design"
  [implement-feature]="Phase 3: Implementation"
  [review-code]="Phase 4: Audit"
  [vctk-challenge]="Adversarial code review"
  [vctk-techdebt]="Tech debt scanner"
  [vctk-sync-docs]="Architecture doc generation"
  [vctk-init-session]="Load context at session start"
  [vctk-save-session]="Save session + learnings"
  [vctk-learn]="Extract lessons to CLAUDE.md"
  [vctk-init]="Preflight check"
  [vctk-update]="Self-update command"
  [context-skill]="Domain context auto-injection template"
  [explore-skill]="Legacy system discovery template"
  [agent-profiles]="Specialist agent profile templates"
  [memory-scaffold]="Create memory directory + MEMORY.md template"
)

# Default selections (true = selected by default)
declare -A DEFAULTS=(
  [feature-brief]=true
  [technical-spec]=true
  [implement-feature]=true
  [review-code]=true
  [vctk-challenge]=true
  [vctk-techdebt]=true
  [vctk-sync-docs]=false
  [vctk-init-session]=true
  [vctk-save-session]=true
  [vctk-learn]=false
  [vctk-init]=false
  [vctk-update]=false
  [context-skill]=false
  [explore-skill]=false
  [agent-profiles]=false
  [memory-scaffold]=true
)

# ─── Interactive Menu ─────────────────────────────────────────────────────────
show_menu() {
  echo ""
  echo -e "${BOLD}=== VCTK v${VERSION} Installer ===${RESET}"
  echo ""
  echo "Select components to install (space to toggle, enter to confirm):"
  echo ""

  echo -e "${BOLD}[Core Workflow]${RESET}"
  for c in feature-brief technical-spec implement-feature review-code; do
    local mark="${SELECTED[$c]:-${DEFAULTS[$c]}}"
    [[ "$mark" == "true" ]] && echo -e "  ${GREEN}[x]${RESET} $c — ${COMPONENT_LABELS[$c]}" \
                             || echo -e "  [ ] $c — ${COMPONENT_LABELS[$c]}"
  done

  echo ""
  echo -e "${BOLD}[Quality Tools]${RESET}"
  for c in vctk-challenge vctk-techdebt vctk-sync-docs; do
    local mark="${SELECTED[$c]:-${DEFAULTS[$c]}}"
    [[ "$mark" == "true" ]] && echo -e "  ${GREEN}[x]${RESET} $c — ${COMPONENT_LABELS[$c]}" \
                             || echo -e "  [ ] $c — ${COMPONENT_LABELS[$c]}"
  done

  echo ""
  echo -e "${BOLD}[Session Management]${RESET}"
  for c in vctk-init-session vctk-save-session vctk-learn; do
    local mark="${SELECTED[$c]:-${DEFAULTS[$c]}}"
    [[ "$mark" == "true" ]] && echo -e "  ${GREEN}[x]${RESET} $c — ${COMPONENT_LABELS[$c]}" \
                             || echo -e "  [ ] $c — ${COMPONENT_LABELS[$c]}"
  done

  echo ""
  echo -e "${BOLD}[Maintenance]${RESET}"
  for c in vctk-init vctk-update; do
    local mark="${SELECTED[$c]:-${DEFAULTS[$c]}}"
    [[ "$mark" == "true" ]] && echo -e "  ${GREEN}[x]${RESET} $c — ${COMPONENT_LABELS[$c]}" \
                             || echo -e "  [ ] $c — ${COMPONENT_LABELS[$c]}"
  done

  echo ""
  echo -e "${BOLD}[Project Templates]${RESET} (copy to .claude/skills/ and customize)"
  for c in context-skill explore-skill agent-profiles; do
    local mark="${SELECTED[$c]:-${DEFAULTS[$c]}}"
    [[ "$mark" == "true" ]] && echo -e "  ${GREEN}[x]${RESET} $c — ${COMPONENT_LABELS[$c]}" \
                             || echo -e "  [ ] $c — ${COMPONENT_LABELS[$c]}"
  done

  echo ""
  echo -e "${BOLD}[Memory Setup]${RESET}"
  local mark="${SELECTED[memory-scaffold]:-${DEFAULTS[memory-scaffold]}}"
  [[ "$mark" == "true" ]] && echo -e "  ${GREEN}[x]${RESET} memory-scaffold — ${COMPONENT_LABELS[memory-scaffold]}" \
                           || echo -e "  [ ] memory-scaffold — ${COMPONENT_LABELS[memory-scaffold]}"
  echo ""
}

interactive_select() {
  # Initialize selections from defaults
  declare -gA SELECTED
  for c in "${!DEFAULTS[@]}"; do
    SELECTED[$c]="${DEFAULTS[$c]}"
  done

  local all_components=(feature-brief technical-spec implement-feature review-code \
    vctk-challenge vctk-techdebt vctk-sync-docs \
    vctk-init-session vctk-save-session vctk-learn \
    vctk-init vctk-update \
    context-skill explore-skill agent-profiles \
    memory-scaffold)

  # Non-interactive mode: use defaults
  if [[ ! -t 0 ]] || [[ "${VCTK_NON_INTERACTIVE:-false}" == "true" ]]; then
    info "Non-interactive mode: using default selections"
    return
  fi

  show_menu

  echo "Toggle components (type component name to toggle) or press enter to install:"
  echo -e "  ${BOLD}all${RESET} — select all  |  ${BOLD}none${RESET} — deselect all  |  ${BOLD}enter${RESET} — confirm"
  echo ""

  while true; do
    echo -n "> "
    read -r input
    input="${input,,}" # lowercase

    case "$input" in
      "")
        break
        ;;
      "all")
        for c in "${all_components[@]}"; do SELECTED[$c]=true; done
        show_menu
        ;;
      "none")
        for c in "${all_components[@]}"; do SELECTED[$c]=false; done
        show_menu
        ;;
      *)
        if [[ -v "SELECTED[$input]" ]]; then
          [[ "${SELECTED[$input]}" == "true" ]] && SELECTED[$input]=false || SELECTED[$input]=true
          show_menu
        else
          warn "Unknown component: '$input'. Valid names: ${all_components[*]}"
        fi
        ;;
    esac
  done
}

# ─── Installation Functions ───────────────────────────────────────────────────
install_mode=""

install_skill() {
  local name="$1"
  local dest="$INSTALL_DIR/$name"
  mkdir -p "$dest"

  if [[ "$install_mode" == "local" ]]; then
    local src_dir
    # Regular skills vs project-templates
    if [[ "$name" == context-skill || "$name" == explore-skill || "$name" == agent-profiles ]]; then
      src_dir="$(dirname "$0")/project-templates/$name"
    else
      src_dir="$(dirname "$0")/skills/$name"
    fi
    if [[ -d "$src_dir" ]]; then
      cp -r "$src_dir/." "$dest/"
      success "Installed skill: $name"
    else
      warn "Source directory not found: $src_dir"
    fi
  else
    # Remote install via curl
    local skill_base_url
    if [[ "$name" == context-skill || "$name" == explore-skill || "$name" == agent-profiles ]]; then
      skill_base_url="$REPO_RAW/project-templates/$name"
    else
      skill_base_url="$REPO_RAW/skills/$name"
    fi
    if curl -fsSL "$skill_base_url/SKILL.md" -o "$dest/SKILL.md" 2>/dev/null; then
      success "Installed skill: $name"
      # Download references/ if available
      curl -fsSL "$skill_base_url/references/" -o /dev/null 2>/dev/null || true
    else
      warn "Could not download skill: $name"
    fi
  fi
}

install_command() {
  local name="$1"
  mkdir -p "$COMMANDS_DIR"

  if [[ "$install_mode" == "local" ]]; then
    local src="$(dirname "$0")/commands/${name}.md"
    if [[ -f "$src" ]]; then
      cp "$src" "$COMMANDS_DIR/${name}.md"
      success "Installed command: /$name"
    else
      warn "Command source not found: $src"
    fi
  else
    if curl -fsSL "$REPO_RAW/commands/${name}.md" -o "$COMMANDS_DIR/${name}.md" 2>/dev/null; then
      success "Installed command: /$name"
    else
      warn "Could not download command: $name"
    fi
  fi
}

install_memory_scaffold() {
  local memory_dir
  # Detect global claude dir
  if [[ -n "${USERPROFILE:-}" ]]; then
    memory_dir="$USERPROFILE/.claude/projects/$(basename "$(pwd)")/memory"
  else
    memory_dir="$HOME/.claude/projects/$(basename "$(pwd)")/memory"
  fi

  mkdir -p "$memory_dir/templates"

  if [[ "$install_mode" == "local" ]]; then
    local src_dir="$(dirname "$0")/memory"
    if [[ -d "$src_dir" ]]; then
      cp "$src_dir/MEMORY.md" "$memory_dir/MEMORY.md" 2>/dev/null || true
      cp -r "$src_dir/templates/." "$memory_dir/templates/" 2>/dev/null || true
      success "Memory scaffolding created at: $memory_dir"
    fi
  else
    curl -fsSL "$REPO_RAW/memory/MEMORY.md" -o "$memory_dir/MEMORY.md" 2>/dev/null && \
      success "Memory scaffolding created at: $memory_dir" || \
      warn "Could not download memory scaffold"
  fi
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  install_mode=$(detect_local_install)
  info "Install mode: $install_mode"

  interactive_select

  echo ""
  info "Installing selected components..."
  echo ""

  # Skill components (also install as commands for backward compat)
  local skill_components=(feature-brief technical-spec implement-feature review-code \
    vctk-challenge vctk-techdebt vctk-sync-docs \
    vctk-init-session vctk-save-session vctk-learn \
    vctk-init vctk-update)

  for c in "${skill_components[@]}"; do
    if [[ "${SELECTED[$c]:-false}" == "true" ]]; then
      install_skill "$c"
      # Also install the command stub
      install_command "$c"
    fi
  done

  # Project templates (skills only, no commands)
  for c in context-skill explore-skill agent-profiles; do
    if [[ "${SELECTED[$c]:-false}" == "true" ]]; then
      install_skill "$c"
    fi
  done

  # Memory scaffold
  if [[ "${SELECTED[memory-scaffold]:-false}" == "true" ]]; then
    install_memory_scaffold
  fi

  # Write version file
  mkdir -p "$INSTALL_DIR"
  echo "$VERSION" > "$INSTALL_DIR/.version"

  # Create .agent folder structure
  mkdir -p .agent/{briefs,specs,sessions,Tasks,System,SOP}
  success "Created .agent folder structure"

  echo ""
  echo -e "${GREEN}${BOLD}✓ VCTK v${VERSION} installation complete${RESET}"
  echo ""
  echo "Quick start:"
  echo "  /vctk-init-session   — Initialize your session"
  echo "  /vctk-feature-brief  — Start a new feature"
  echo ""
}

main "$@"
