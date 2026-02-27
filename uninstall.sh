#!/bin/bash

# Claude Coding Toolkit (CCT) Uninstaller
# Removes claude-coding-toolkit from your project's .claude/ folder
# Usage: curl -fsSL https://raw.githubusercontent.com/Sprayer115/claude-coding-toolkit/master/uninstall.sh | bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║        Claude Coding Toolkit (CCT) Uninstaller            ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if claude-coding-toolkit is installed (check both old and new command names)
INSTALLED=0

if [ -d ".claude/skills/vibe-coding-toolkit" ]; then
    INSTALLED=1
fi

# Check for new vctk- prefixed commands
for cmd in vctk-feature-brief vctk-technical-spec vctk-implement-feature vctk-review-code vctk-init-session vctk-save-session; do
    if [ -f ".claude/commands/$cmd.md" ]; then
        INSTALLED=1
        break
    fi
done

# Check for old command names (for backward compatibility)
for cmd in feature-brief technical-spec implement-feature review-code; do
    if [ -f ".claude/commands/$cmd.md" ]; then
        INSTALLED=1
        break
    fi
done

if [ $INSTALLED -eq 0 ]; then
    echo -e "${YELLOW}Claude Coding Toolkit is not installed in this directory.${NC}"
    exit 0
fi

# Show what will be removed
echo -e "${BLUE}The following will be removed:${NC}"
echo ""

if [ -d ".claude/skills/vibe-coding-toolkit" ]; then
    echo -e "  ${YELLOW}Skills:${NC}"
    echo "    - .claude/skills/vibe-coding-toolkit/"
fi

echo -e "  ${YELLOW}Commands:${NC}"
# Check new vctk- commands
for cmd in vctk-feature-brief vctk-technical-spec vctk-implement-feature vctk-review-code vctk-init-session vctk-save-session; do
    if [ -f ".claude/commands/$cmd.md" ]; then
        echo "    - .claude/commands/$cmd.md"
    fi
done
# Check old commands (backward compatibility)
for cmd in feature-brief technical-spec implement-feature review-code; do
    if [ -f ".claude/commands/$cmd.md" ]; then
        echo "    - .claude/commands/$cmd.md"
    fi
done

echo ""

# Check for workflow documents
BRIEFS_COUNT=0
SPECS_COUNT=0

if [ -d ".agent/briefs" ]; then
    BRIEFS_COUNT=$(find .agent/briefs -name "BRIEF-*.md" 2>/dev/null | wc -l | tr -d ' ')
fi

if [ -d ".agent/specs" ]; then
    SPECS_COUNT=$(find .agent/specs -name "SPEC-*.md" 2>/dev/null | wc -l | tr -d ' ')
fi

if [ "$BRIEFS_COUNT" -gt 0 ] || [ "$SPECS_COUNT" -gt 0 ]; then
    echo -e "${YELLOW}Note: Your workflow documents will NOT be removed:${NC}"
    [ "$BRIEFS_COUNT" -gt 0 ] && echo "  - $BRIEFS_COUNT feature brief(s) in .agent/briefs/"
    [ "$SPECS_COUNT" -gt 0 ] && echo "  - $SPECS_COUNT technical spec(s) in .agent/specs/"
    echo ""
fi

# Confirm uninstallation
read -p "Remove Claude Coding Toolkit from this project? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled."
    exit 0
fi

# Remove skills
if [ -d ".claude/skills/vibe-coding-toolkit" ]; then
    echo -e "${BLUE}Removing skills...${NC}"
    rm -rf .claude/skills/vibe-coding-toolkit
    echo -e "  ${GREEN}✓${NC} Skills removed"
fi

# Remove commands (new vctk- prefix)
echo -e "${BLUE}Removing commands...${NC}"
for cmd in vctk-feature-brief vctk-technical-spec vctk-implement-feature vctk-review-code vctk-init-session vctk-save-session; do
    if [ -f ".claude/commands/$cmd.md" ]; then
        rm ".claude/commands/$cmd.md"
        echo -e "  ${GREEN}✓${NC} Removed $cmd"
    fi
done

# Remove old commands (backward compatibility)
for cmd in feature-brief technical-spec implement-feature review-code; do
    if [ -f ".claude/commands/$cmd.md" ]; then
        rm ".claude/commands/$cmd.md"
        echo -e "  ${GREEN}✓${NC} Removed $cmd (legacy)"
    fi
done

# Ask about .agent directories
echo ""
if [ -d ".agent/briefs" ] || [ -d ".agent/specs" ] || [ -d ".agent/sessions" ]; then
    echo -e "${YELLOW}The .agent/ directory contains your workflow documents and session history.${NC}"
    read -p "Remove empty .agent subdirectories? (keeps any documents) (y/n) " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Only remove if empty
        rmdir .agent/briefs 2>/dev/null && echo -e "  ${GREEN}✓${NC} Removed .agent/briefs/" || echo -e "  ${YELLOW}⊘${NC} .agent/briefs/ not empty, keeping"
        rmdir .agent/specs 2>/dev/null && echo -e "  ${GREEN}✓${NC} Removed .agent/specs/" || echo -e "  ${YELLOW}⊘${NC} .agent/specs/ not empty, keeping"
        rmdir .agent/sessions 2>/dev/null && echo -e "  ${GREEN}✓${NC} Removed .agent/sessions/" || echo -e "  ${YELLOW}⊘${NC} .agent/sessions/ not empty, keeping"
        rmdir .agent/Tasks 2>/dev/null || true
        rmdir .agent/System 2>/dev/null || true
        rmdir .agent/SOP 2>/dev/null || true
        rmdir .agent 2>/dev/null || true
    fi
fi

# Clean up empty directories
rmdir .claude/skills 2>/dev/null || true
rmdir .claude/commands 2>/dev/null || true
rmdir .claude 2>/dev/null || true

echo ""
echo -e "${GREEN}Claude Coding Toolkit has been removed.${NC}"
echo ""
echo -e "${YELLOW}Your workflow documents (briefs/specs/sessions) were preserved.${NC}"
echo "To reinstall: curl -fsSL https://raw.githubusercontent.com/Sprayer115/claude-coding-toolkit/master/install.sh | bash"
echo ""
