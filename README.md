# VCTK — Vibe Coding Toolkit v0.2.1

A skills-first workflow toolkit for Claude Code. Structures feature development into four gated phases with supporting quality tools, session management, and project templates.

## Architecture

VCTK uses a **skills-first architecture**: every tool is a Claude skill that auto-triggers on natural language, with optional `/command` shortcuts for direct invocation.

```
skills/                  ← Auto-triggerable Claude skills (primary)
commands/                ← Thin /slash-command stubs (backward compat)
project-templates/       ← Parameterized templates for project-specific skills
memory/                  ← Memory scaffolding templates
```

> **Important**: Claude Code discovers project-local skills at `.claude/skills/<skill-name>/SKILL.md` (depth 1 only). Skills must be installed flat — not nested under a subdirectory. The installer handles this correctly.

## Core Workflow

| Phase | Skill | Trigger |
|-------|-------|---------|
| 1. Discovery | `feature-brief` | "I want to build X", "new feature", "requirements for" |
| 2. Design | `technical-spec` | "design this feature", "create a spec", "how should we build" |
| 3. Build | `implement-feature` | "build this", "implement the spec", "start coding" |
| 4. Verify | `review-code` | "review this", "check the code", "audit my changes" |

Each phase is **gated** — Phase N requires output from Phase N-1.

## Quality Tools

| Skill | Trigger | What It Does |
|-------|---------|-------------|
| `vctk-challenge` | "challenge me", "grill me on this" | Adversarial review — interrogates the developer on their decisions |
| `vctk-techdebt` | "scan for tech debt", "find duplicated code" | Codebase health scan with prioritized P0-P4 report |

## Session Management

| Skill | Trigger | What It Does |
|-------|---------|-------------|
| `vctk-init-session` | "init session", "load context" | Loads developer context, shows workflow reference |
| `vctk-save-session` | "save session", "end of session" | Saves session summary, optionally updates CLAUDE.md |
| `vctk-learn` | "learn from this", "update CLAUDE.md" | Extracts rules from session, requires per-lesson approval |

## Maintenance

| Skill | Trigger | What It Does |
|-------|---------|-------------|
| `toolkit-install` | "install toolkit", "setup toolkit", "update vctk" | Installs or updates VCTK into the current project's `.claude/` directory |
| `vctk-init` | "check vctk setup", "preflight check" | Verifies installation and project readiness |
| `vctk-update` | "update vctk", "upgrade toolkit" | Updates to latest version from remote |
| `vctk-sync-docs` | "sync docs", "document the codebase" | Generates/updates .agent documentation |

## Installation

### Quick Install (latest)
```bash
curl -fsSL https://raw.githubusercontent.com/Sprayer115/claude-coding-toolkit/master/install.sh | bash
```

### Interactive Install (choose components)
```bash
curl -fsSL https://raw.githubusercontent.com/Sprayer115/claude-coding-toolkit/master/install.sh -o install.sh
chmod +x install.sh
./install.sh
```

### From Source
```bash
git clone https://github.com/Sprayer115/claude-coding-toolkit
cd claude-coding-toolkit
./install.sh
```

The installer copies all skills flat into `.claude/skills/<skill-name>/` so Claude Code can discover them correctly.

### Project-local install via `toolkit-install` skill

Once `toolkit-install` is installed as a global skill (`~/.claude/skills/toolkit-install/`), you can install VCTK into any project by opening Claude Code in that project directory and saying:

> "install toolkit" or "setup vctk"

The skill detects the current working directory and installs all VCTK skills into `<project>/.claude/skills/`.

## Project Templates

Copy and customize these for project-specific skills:

```
project-templates/
├── context-skill/     # Auto-inject domain context when working in specific areas
├── explore-skill/     # Guided codebase exploration for large/legacy projects
└── agent-profiles/    # Specialist persona templates (backend expert, frontend architect)
```

See each template's README.md for customization instructions.

## Memory Scaffolding

VCTK includes memory templates for Claude's persistent memory system:

```
memory/
├── MEMORY.md                     # Index template
└── templates/
    ├── project_overview.md       # Project context memory
    └── stack_conventions.md      # Coding conventions + learned rules
```

Installed to `~/.claude/projects/{project-name}/memory/` by the installer.

## .agent Directory

VCTK creates a `.agent/` directory for workflow artifacts:

```
.agent/
├── briefs/     # Feature briefs (Phase 1 output)
├── specs/      # Technical specs (Phase 2 output)
├── sessions/   # Developer session summaries
├── Tasks/      # Implementation plans
├── System/     # Architecture documentation
└── SOP/        # Standard operating procedures
```

## Slash Commands (Backward Compatibility)

All skills are also available as `/commands`:

```
/vctk-feature-brief     /vctk-technical-spec    /vctk-implement-feature
/vctk-review-code       /vctk-challenge         /vctk-techdebt
/vctk-init-session      /vctk-save-session      /vctk-learn
/vctk-init              /vctk-update            /vctk-sync-docs
```

## Contributing

Issues and PRs welcome at https://github.com/Sprayer115/claude-coding-toolkit

## License

MIT
