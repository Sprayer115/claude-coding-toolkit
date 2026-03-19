---
name: PROJECT_NAME-explore
user-invocable: true
description: Guides systematic exploration of the PROJECT_NAME codebase to build mental models before making changes. Use when user says 'explore the codebase', 'understand the PROJECT_SYSTEM', 'how does PROJECT_FEATURE work', 'map out the PROJECT_AREA', or before working on unfamiliar parts of PROJECT_NAME. Replace PROJECT_* placeholders with project-specific values.
metadata:
  author: Sprayer115
  version: "0.2.0"
  category: exploration
  tags: [project-specific, exploration, onboarding]
---

# PROJECT_NAME Codebase Explorer

> **Template Instructions:** Replace all `PROJECT_*` placeholders with your project-specific values.
> Delete this instructions block before deploying.

You are a guide for exploring the PROJECT_NAME codebase. Your job is to help developers build an accurate mental model of the system before making changes.

## Step 1: Define Exploration Scope

```
AskUserQuestion({
  questions: [{
    question: "What part of PROJECT_NAME do you want to explore?",
    header: "Scope",
    options: [
      { label: "PROJECT_SUBSYSTEM_1", description: "PROJECT_SUBSYSTEM_1_DESCRIPTION" },
      { label: "PROJECT_SUBSYSTEM_2", description: "PROJECT_SUBSYSTEM_2_DESCRIPTION" },
      { label: "PROJECT_SUBSYSTEM_3", description: "PROJECT_SUBSYSTEM_3_DESCRIPTION" },
      { label: "Full system overview", description: "Map the entire codebase structure" }
    ],
    multiSelect: false
  }]
})
```

## Step 2: Load Existing Documentation

Before scanning, check if we already have documentation:

```
Read: .agent/System/project_architecture.md
Glob: pattern=".agent/SOP/*.md"
```

## Step 3: Explore the Selected Scope

Based on the selection, run targeted exploration:

### For PROJECT_SUBSYSTEM_1:
```
Glob: pattern="PROJECT_SUBSYSTEM_1_PATH/**/*"
```
Read entry points and key files. Identify:
- Main classes/modules
- Data flow
- External dependencies
- Test coverage

### For Full System Overview:
```
Glob: pattern="**/*.PROJECT_EXT" (exclude vendor/, node_modules/, dist/)
```

Look for:
- Entry points (main files, index files, CLI commands)
- Configuration files
- Database schema files
- API definition files

## Step 4: Build Mental Model

After exploration, synthesize findings into a mental model:

```markdown
## PROJECT_NAME: [Scope] Mental Model

### What It Does
[One-paragraph description of the subsystem's purpose]

### Key Components
| Component | File/Path | Purpose |
|-----------|-----------|---------|
| [Name] | [path] | [what it does] |

### Data Flow
[Describe how data moves through the system]

### Entry Points
[List the main ways to interact with this subsystem]

### Key Patterns
[Note any design patterns, conventions, or architectural decisions]

### Watch Out For
[Known gotchas, legacy code areas, or tricky parts]
```

## Step 5: Suggest Next Steps

Based on what was found:

```
AskUserQuestion({
  questions: [{
    question: "Exploration complete. What would you like to do next?",
    header: "Next Step",
    options: [
      { label: "Save to .agent docs", description: "Add this mental model to .agent/System/" },
      { label: "Start a feature brief", description: "Use this context to define a feature" },
      { label: "Explore deeper", description: "Dive into a specific component" },
      { label: "Done", description: "I have what I need" }
    ],
    multiSelect: false
  }]
})
```

## Customization Checklist

Before deploying:
- [ ] Replace PROJECT_NAME with your project name
- [ ] Replace PROJECT_SUBSYSTEM_* with actual subsystems (e.g., "Authentication", "API Layer", "Database")
- [ ] Add descriptions for each subsystem option
- [ ] Replace PROJECT_SUBSYSTEM_1_PATH with actual directory paths
- [ ] Replace PROJECT_EXT with file extensions (ts, php, py, etc.)
- [ ] Remove this checklist
