#!/bin/bash

# Claude Coding Toolkit (CCT) Installer
# Installs skills and commands into your project's .claude/ folder
# Usage: curl -fsSL https://raw.githubusercontent.com/Sprayer115/claude-coding-toolkit/master/install.sh | bash

set -e

REPO_URL="https://github.com/Sprayer115/claude-coding-toolkit"
REPO_RAW="https://raw.githubusercontent.com/Sprayer115/claude-coding-toolkit/master"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║         Claude Coding Toolkit (CCT) Installer             ║"
echo "║      AI-Augmented Development Workflow (4 Phases)         ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if we're in a git repo or project directory
if [ ! -d ".git" ] && [ ! -f "package.json" ] && [ ! -f "Cargo.toml" ] && [ ! -f "pyproject.toml" ] && [ ! -f "go.mod" ]; then
    echo -e "${YELLOW}Warning: Not in a typical project directory.${NC}"
    read -p "Install here anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 1
    fi
fi

# Function to download a file
download_file() {
    local url="$1"
    local dest="$2"

    if command -v curl &> /dev/null; then
        curl -fsSL "$url" -o "$dest"
    elif command -v wget &> /dev/null; then
        wget -q "$url" -O "$dest"
    else
        echo -e "${RED}Error: curl or wget required${NC}"
        exit 1
    fi
}

# Create .claude directory structure
echo -e "${BLUE}Creating .claude directory structure...${NC}"
mkdir -p .claude/commands
mkdir -p .claude/skills/vibe-coding-toolkit/{feature-brief/references,technical-spec/references,implement-feature/references,review-code/references}

# Clean up old unprefixed commands (v1 → v2 migration)
OLD_COMMANDS=("feature-brief" "technical-spec" "implement-feature" "review-code")
CLEANED=0

for old_cmd in "${OLD_COMMANDS[@]}"; do
    if [ -f ".claude/commands/$old_cmd.md" ]; then
        rm ".claude/commands/$old_cmd.md"
        CLEANED=1
    fi
done

if [ $CLEANED -eq 1 ]; then
    echo -e "${YELLOW}Cleaned up old command names (migrating to cct- prefix)${NC}"
fi

# Download commands (with vctk- prefix)
echo -e "${BLUE}Downloading commands...${NC}"

COMMANDS=(
    "vctk-feature-brief"
    "vctk-technical-spec"
    "vctk-implement-feature"
    "vctk-review-code"
    "vctk-challenge"
    "vctk-techdebt"
    "vctk-init-session"
    "vctk-save-session"
    "vctk-learn"
    "vctk-update"
    "vctk-init"
)

for cmd in "${COMMANDS[@]}"; do
    echo -e "  ${GREEN}✓${NC} $cmd"
    download_file "$REPO_RAW/commands/$cmd.md" ".claude/commands/$cmd.md"
done

# Download skills and their references
echo -e "${BLUE}Downloading skills...${NC}"

# Feature Brief
echo -e "  ${GREEN}✓${NC} feature-brief skill"
download_file "$REPO_RAW/skills/feature-brief/SKILL.md" ".claude/skills/vibe-coding-toolkit/feature-brief/SKILL.md"
download_file "$REPO_RAW/skills/feature-brief/references/interview-guide.md" ".claude/skills/vibe-coding-toolkit/feature-brief/references/interview-guide.md"
download_file "$REPO_RAW/skills/feature-brief/references/brief-template.md" ".claude/skills/vibe-coding-toolkit/feature-brief/references/brief-template.md"

# Technical Spec
echo -e "  ${GREEN}✓${NC} technical-spec skill"
download_file "$REPO_RAW/skills/technical-spec/SKILL.md" ".claude/skills/vibe-coding-toolkit/technical-spec/SKILL.md"
download_file "$REPO_RAW/skills/technical-spec/references/research-checklist.md" ".claude/skills/vibe-coding-toolkit/technical-spec/references/research-checklist.md"
download_file "$REPO_RAW/skills/technical-spec/references/option-format.md" ".claude/skills/vibe-coding-toolkit/technical-spec/references/option-format.md"
download_file "$REPO_RAW/skills/technical-spec/references/spec-template.md" ".claude/skills/vibe-coding-toolkit/technical-spec/references/spec-template.md"

# Implement Feature
echo -e "  ${GREEN}✓${NC} implement-feature skill"
download_file "$REPO_RAW/skills/implement-feature/SKILL.md" ".claude/skills/vibe-coding-toolkit/implement-feature/SKILL.md"
download_file "$REPO_RAW/skills/implement-feature/references/execution-protocols.md" ".claude/skills/vibe-coding-toolkit/implement-feature/references/execution-protocols.md"
download_file "$REPO_RAW/skills/implement-feature/references/completion-checklist.md" ".claude/skills/vibe-coding-toolkit/implement-feature/references/completion-checklist.md"

# Review Code
echo -e "  ${GREEN}✓${NC} review-code skill"
download_file "$REPO_RAW/skills/review-code/SKILL.md" ".claude/skills/vibe-coding-toolkit/review-code/SKILL.md"
download_file "$REPO_RAW/skills/review-code/references/confidence-scoring.md" ".claude/skills/vibe-coding-toolkit/review-code/references/confidence-scoring.md"
download_file "$REPO_RAW/skills/review-code/references/security-checklist.md" ".claude/skills/vibe-coding-toolkit/review-code/references/security-checklist.md"
download_file "$REPO_RAW/skills/review-code/references/audit-report-template.md" ".claude/skills/vibe-coding-toolkit/review-code/references/audit-report-template.md"

# Create .agent directory for briefs, specs, and sessions
echo -e "${BLUE}Creating .agent directory for workflow documents...${NC}"
mkdir -p .agent/briefs
mkdir -p .agent/specs
mkdir -p .agent/sessions
mkdir -p .agent/Tasks
mkdir -p .agent/System
mkdir -p .agent/SOP

# Download and save version for update checking
echo -e "${BLUE}Saving version info...${NC}"
download_file "$REPO_RAW/VERSION" ".claude/skills/vibe-coding-toolkit/.version"
INSTALLED_VERSION=$(cat .claude/skills/vibe-coding-toolkit/.version | tr -d '[:space:]')
echo -e "  ${GREEN}✓${NC} Version $INSTALLED_VERSION installed"

# Write customized marker so vctk-update can detect local changes
echo -e "${BLUE}Marking installation as customized...${NC}"
touch .claude/skills/vibe-coding-toolkit/.customized
echo -e "  ${GREEN}✓${NC} Customization marker written (.customized)"

# Success message
echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║            Installation Complete!                         ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Commands installed to: ${BLUE}.claude/commands/${NC}"
echo -e "Skills installed to:   ${BLUE}.claude/skills/vibe-coding-toolkit/${NC}"
echo -e "Workflow folders:      ${BLUE}.agent/{briefs,specs,sessions}/${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo -e "${YELLOW}                    CCT Commands                            ${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "  ${CYAN}Development Workflow${NC}"
echo -e "    /vctk-feature-brief      Phase 1: Extract requirements"
echo -e "    /vctk-technical-spec     Phase 2: Research & design"
echo -e "    /vctk-implement-feature  Phase 3: Build from spec"
echo -e "    /vctk-review-code        Phase 4: Audit implementation"
echo ""
echo -e "  ${CYAN}Quality & Review${NC}"
echo -e "    /vctk-challenge          Adversarial review — grill me on changes"
echo -e "    /vctk-techdebt           Scan codebase for tech debt"
echo ""
echo -e "  ${CYAN}Session Management${NC}"
echo -e "    /vctk-init-session       Load context at session start"
echo -e "    /vctk-save-session       Save context at session end"
echo -e "    /vctk-learn              Extract lessons → update CLAUDE.md"
echo ""
echo -e "  ${CYAN}Maintenance${NC}"
echo -e "    /vctk-init               Preflight check (verify setup)"
echo -e "    /vctk-update             Update CCT to latest version"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Quick start:${NC}"
echo "  1. Preflight:   /vctk-init"
echo "  2. Session:     /vctk-init-session"
echo "  3. New feature: /vctk-feature-brief"
echo "  4. Design:      /vctk-technical-spec"
echo "  5. Build:       /vctk-implement-feature"
echo "  6. Review:      /vctk-review-code"
echo "  7. Save:        /vctk-save-session"
echo "  8. Learn:       /vctk-learn (or auto via save-session)"
echo ""
echo -e "Documentation: ${BLUE}$REPO_URL${NC}"
echo ""
