---
name: vctk-sync-docs
user-invocable: true
description: Scans codebase and synchronizes .agent documentation including architecture docs, SOPs, and the context index. Use when user says 'sync docs', 'update documentation', 'document the codebase', 'generate architecture docs', 'create SOPs', or when .agent docs are stale. Supports initialize, update, and add-SOP modes.
metadata:
  author: Sprayer115
  version: "0.2.0"
  category: maintenance
  tags: [vctk, dev-workflow, documentation]
allowed-tools: ["Bash", "Read", "Write", "Glob", "Grep", "Task", "AskUserQuestion"]
---

# Sync Documentation

You are an expert code documentation specialist. Deep-scan and analyze the codebase to provide accurate, up-to-date documentation so any engineer can get full context.

## .agent Documentation Structure

```
.agent/
├── README.md           # Index of all documentation
├── CONTEXT_INDEX.md    # Lightweight trigger table for init-session
├── Tasks/              # PRD & implementation plans
├── System/             # Current state docs (architecture, schema)
├── SOP/                # Standard operating procedures
├── briefs/             # Feature briefs
├── specs/              # Technical specs
└── sessions/           # Developer session history
```

## Mode Selection

```
AskUserQuestion({
  questions: [{
    question: "What documentation task do you want to perform?",
    header: "Doc Task",
    options: [
      { label: "Initialize", description: "First-time setup: scan codebase and create all docs" },
      { label: "Update", description: "Refresh existing docs with recent changes" },
      { label: "Add SOP", description: "Document a specific procedure or workflow" }
    ],
    multiSelect: false
  }]
})
```

## Mode: Initialize Documentation

1. Deep scan: project structure, tech stack, entry points, integrations, database schema
2. Create `.agent/System/project_architecture.md` with overview, tech stack table, structure, integration points, key flows
3. Create `.agent/System/database_schema.md` if database exists
4. Create `.agent/README.md` as documentation index
5. Create `.agent/CONTEXT_INDEX.md` (under 80 lines, pointers only)

## Mode: Update Documentation

1. Read current .agent/ state
2. Ask what changed (New feature / Architecture / Database / Full refresh)
3. Update only relevant docs
4. Always update README.md and CONTEXT_INDEX.md indexes

## Mode: Add SOP

1. Ask which procedure to document
2. Scan for existing examples in the codebase
3. Create `.agent/SOP/{topic}.md` with Overview, Prerequisites, Steps, Examples, Common Issues
4. Update README.md and CONTEXT_INDEX.md

---

## Rules

1. **DO** consolidate docs — avoid overlap between files
2. **DO** keep CONTEXT_INDEX.md under 80 lines (pointers only, not content)
3. **DO NOT** duplicate information across multiple files
4. **DO** update README.md index after any documentation changes
