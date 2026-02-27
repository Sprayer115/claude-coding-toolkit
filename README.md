# Claude Coding Toolkit

AI-augmented development workflow for teams. Enables non-technical and technical members to use AI coding agents while maintaining code quality.

## Overview

A 4-phase workflow where AI agents behave differently at each phase:

```
Phase 1          Phase 2            Phase 3             Phase 4
DISCOVERY   →    DESIGN        →    BUILD          →    VERIFY

feature-brief    technical-spec     implement-feature   review-code

Anyone can       Tech Lead only     Anyone can          Tech Lead
initiate         decides            execute             approves

Agent:           Agent:             Agent:              Agent:
INTERVIEWER      RESEARCHER         EXECUTOR            AUDITOR
```

## Workflow Commands

### `/vctk-feature-brief` (Phase 1: Discovery)

Extract complete requirements through structured interviewing.

- Conducts multi-phase interview: problem discovery, solution walkthrough, edge cases, scope boundaries, priority
- Challenges vague answers ("users" → "which users specifically?")
- 3-attempt fallback: if a section can't be answered concretely, marks it as an open question and continues
- **Output:** `BRIEF-[name]-[YYYY-MM-DD].md` in `.agent/briefs/`

### `/vctk-technical-spec` (Phase 2: Design)

Research best practices, draft a spec, then refine through user interview.

- **Gate:** Requires a feature brief in `.agent/briefs/`
- Searches the web for industry standards and official docs before proposing anything
- Drafts a spec based on research, then compares it against your vision decision by decision
- Documents deviations from best practice with reasoning
- **Output:** `SPEC-[name]-[YYYY-MM-DD].md` in `.agent/specs/`

### `/vctk-implement-feature` (Phase 3: Build)

Execute implementation following the spec exactly — no creativity, no scope expansion.

- **Gate:** Requires a spec with `status: APPROVED FOR IMPLEMENTATION`
- Searches official documentation for current APIs before writing any code
- Acknowledges all constraints explicitly before starting
- Logs scope temptations as `SCOPE NOTE` entries without acting on them
- Stops immediately on ambiguity — never guesses
- **Output:** Code + constraint verification table + scope verification

### `/vctk-review-code` (Phase 4: Verify)

Audit implementation against spec with confidence-based scoring.

- **Gate:** Requires spec + files to review
- 5 audit passes: constraint compliance, documentation verification, security (OWASP), scope, tests
- Confidence scoring 0–100, threshold 80 — only findings ≥80 are reported as blocking
- **Output:** Audit report with `APPROVE` / `REQUEST CHANGES` / `NEEDS DISCUSSION`

---

## Quality & Review Commands

### `/vctk-challenge` (Adversarial Review)

Grills the developer on their changes before approving.

- Acts as a senior staff engineer conducting a verbal code review
- Asks tough questions about design decisions, edge cases, and trade-offs — referenced to exact lines
- Scores answers per question and produces a `READY` / `NOT READY` / `NEEDS FIXES` verdict
- Maximum 12 questions; adapts difficulty based on answer quality

### `/vctk-techdebt` (Tech Debt Scanner)

Scans the codebase for code smells and technical debt.

- 6 scans: TODOs/FIXMEs, code duplication, dead code, inconsistent patterns, dependency health, complexity hotspots
- Prioritizes findings by impact vs effort (P0–P4 matrix)
- Can fix P0s immediately, save the report, or create issues

---

## Session Management Commands

### `/vctk-init-session`

Load developer context at the start of a session.

- Checks for CCT updates silently; shows a notice only if one is available
- Reads your last session file from `.agent/sessions/{name}/last_session.md`
- Shows git branch, uncommitted changes, and a command reference table
- Lazy-loads context — does not read full docs during init

### `/vctk-save-session`

Save session context for continuity across conversations.

- Writes a structured summary to `.agent/sessions/{name}/last_session.md`
- Automatically evaluates whether the session produced lessons worth persisting to `CLAUDE.md`
- Presents lessons for approval before writing — never auto-saves rules

### `/vctk-learn` (Session Learning)

Extract lessons from the current session and persist them to `CLAUDE.md`.

- Scans for corrections, failed attempts, discovered patterns, and user preferences
- Deduplicates against existing `CLAUDE.md` rules before proposing anything
- Per-lesson approval: each rule confirmed individually before saving
- Supports both project `CLAUDE.md` and global `~/.claude/CLAUDE.md`

### `/vctk-sync-docs` (Documentation Sync)

Deep-scan the codebase and generate `.agent/` documentation.

- Three modes: Initialize (first-time full scan), Update (refresh after changes), Add SOP (document a specific procedure)
- Creates `System/project_architecture.md`, `System/database_schema.md`, `CONTEXT_INDEX.md`, and `README.md` inside `.agent/`

---

## Maintenance Commands

### `/vctk-init` (Preflight Check)

Verify CCT installation and project readiness before starting work.

- Checks all 11 commands and 4 skills are installed
- Verifies `.agent/` folder structure exists
- Reports current version and whether an update is available
- Shows current workflow state (briefs and specs on disk)

### `/vctk-update`

Update CCT to the latest version.

- Compares local version to remote before doing anything
- Warns explicitly if the installation has local customizations and requires confirmation before overwriting

---

## Installation

### Quick Install (Recommended)

Run this in your project directory:

```bash
curl -fsSL https://raw.githubusercontent.com/Sprayer115/claude-coding-toolkit/master/install.sh | bash
```

This installs commands and skills into your project's `.claude/` folder and creates the `.agent/` directory structure.

### Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/Sprayer115/claude-coding-toolkit/master/uninstall.sh | bash
```

### Alternative: Plugin Directory

For development or testing against this repo directly:

```bash
claude --plugin-dir /path/to/claude-coding-toolkit
```

---

## Usage

```bash
# 1. Verify setup
/vctk-init

# 2. Load context at session start
/vctk-init-session

# 3. Define the feature
/vctk-feature-brief

# 4. Design the implementation
/vctk-technical-spec

# 5. Build from spec
/vctk-implement-feature

# 6. Review the implementation
/vctk-review-code

# 7. Save session context
/vctk-save-session
```

---

## Document Structure

The toolkit writes all workflow documents to `.agent/` in your project:

```text
.agent/
├── README.md               # Index of all documentation
├── CONTEXT_INDEX.md        # Lightweight trigger table for /vctk-init-session
├── briefs/                 # Feature briefs (Phase 1 output)
│   └── BRIEF-[name]-[date].md
├── specs/                  # Technical specs (Phase 2 output)
│   └── SPEC-[name]-[date].md
├── sessions/               # Per-developer session history
│   └── {dev-name}/last_session.md
├── Tasks/                  # Implementation plans
├── System/                 # Architecture and schema docs
└── SOP/                    # Standard operating procedures
```

---

## Key Principles

1. **Gate enforcement** — Each phase requires the previous phase's output; gates fail loudly, never silently
2. **Role separation** — Agents stay in their lane: INTERVIEWER doesn't code, EXECUTOR doesn't decide architecture
3. **Constraint-based** — Specs generate verifiable constraints; review checks each one with evidence
4. **Human decisions** — AI presents options, humans choose; deviations from best practice are documented
5. **Continuous learning** — Sessions feed lessons back into `CLAUDE.md` for compounding improvement
6. **No git required** — Works with files in the working directory (vibe-coder friendly)

---

## License

MIT
