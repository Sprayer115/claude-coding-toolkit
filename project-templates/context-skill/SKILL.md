---
name: PROJECT_NAME-context
user-invocable: false
description: Automatically injects PROJECT_NAME domain context when working on PROJECT_DOMAIN tasks. Use when user asks about PROJECT_DOMAIN features, mentions PROJECT_KEY_TERMS, or starts working on PROJECT_AREA. Loads PROJECT_SYSTEM_DOCS and provides relevant architectural context without being asked. Replace all PROJECT_* placeholders with project-specific values.
metadata:
  author: Sprayer115
  version: "0.2.0"
  category: context
  tags: [project-specific, context-injection]
---

# PROJECT_NAME Context Injector

> **Template Instructions:** Replace all `PROJECT_*` placeholders with your project-specific values.
> Delete this instructions block before deploying.

You are a context-aware assistant for PROJECT_NAME. When the user's request involves PROJECT_DOMAIN work, automatically load and surface the relevant context from the project's documentation.

## Trigger Conditions

Activate this skill when the user's request mentions:
- PROJECT_KEY_TERM_1
- PROJECT_KEY_TERM_2
- PROJECT_KEY_TERM_3
- Any reference to PROJECT_SUBSYSTEM

## Context to Load

When triggered, read the following documentation (do not announce this — just use it):

```
Read: .agent/System/PROJECT_ARCHITECTURE_DOC.md
```

Also check for relevant SOPs:
```
Glob: pattern=".agent/SOP/PROJECT_DOMAIN-*.md"
```

## Key Domain Context

Provide the following context inline when relevant:

### Architecture Overview
[PROJECT_ARCHITECTURE_SUMMARY — describe the main systems, how they interact, key constraints]

### Key Patterns
- [PROJECT_PATTERN_1]: [description]
- [PROJECT_PATTERN_2]: [description]

### Important Files
| Purpose | Location |
|---------|----------|
| [Main entry] | `PROJECT_ENTRY_FILE` |
| [Config] | `PROJECT_CONFIG_FILE` |
| [Tests] | `PROJECT_TEST_DIR` |

### Common Gotchas
- [PROJECT_GOTCHA_1]
- [PROJECT_GOTCHA_2]

## Behavior

- Load context silently — don't announce "I'm loading context"
- Reference specific file paths when giving guidance
- When you see `PROJECT_ANTI_PATTERN`, suggest `PROJECT_CORRECT_PATTERN` instead
- Always check `PROJECT_CONFIG_FILE` before suggesting configuration changes

## Customization Checklist

Before deploying this template:
- [ ] Replace PROJECT_NAME with your project name
- [ ] Replace PROJECT_DOMAIN with the domain this covers (e.g., "authentication", "billing")
- [ ] Replace PROJECT_KEY_TERM_* with actual terms that trigger this context
- [ ] Fill in Architecture Overview with real content
- [ ] Add Key Patterns specific to this codebase
- [ ] Add Important Files with real paths
- [ ] Add Common Gotchas discovered during development
- [ ] Set `user-invocable: true` if users should also be able to invoke it manually
- [ ] Remove this checklist
