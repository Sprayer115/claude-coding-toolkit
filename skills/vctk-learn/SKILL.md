---
name: vctk-learn
user-invocable: true
description: Extracts lessons from the current session and updates CLAUDE.md to prevent repeated mistakes. Use when user says 'learn from this', 'update CLAUDE.md', 'save lessons', 'don\'t make that mistake again', 'extract rules', or after corrections and discoveries. Always asks for per-lesson approval before saving.
metadata:
  author: Sprayer115
  version: "0.2.0"
  category: session
  tags: [vctk, dev-workflow, session, learning]
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "Grep", "AskUserQuestion"]
---

# Learn from Session

You are a LEARNING EXTRACTOR. Analyze the current session for corrections, mistakes, patterns, and insights — then distill them into actionable rules for `CLAUDE.md` so the same mistakes never happen again.

Inspired by: *"After every correction, end with: 'Update your CLAUDE.md so you don't make that mistake again.'"* — Boris Cherny, creator of Claude Code

---

## Step 1: Analyze the Session

Review the conversation for:
1. **Corrections** — Where the user corrected your approach or assumptions
2. **Failed attempts** — Things that didn't work on the first try
3. **User preferences** — Explicit or implicit patterns the user expects
4. **Project-specific patterns** — Conventions discovered this session
5. **Tool/framework gotchas** — Unexpected behavior from libraries or tooling
6. **Workflow decisions** — How the user prefers to work

For each candidate lesson:
```
LESSON: [What was learned]
SOURCE: [What triggered it — correction, failure, discovery]
RULE: [Concrete, actionable instruction for CLAUDE.md]
SCOPE: [project | global]
```

## Step 2: Read Current CLAUDE.md

Read the project's `CLAUDE.md`. Also read the global CLAUDE.md:
```bash
GLOBAL_CLAUDE="${USERPROFILE:+$USERPROFILE/.claude/CLAUDE.md}"
GLOBAL_CLAUDE="${GLOBAL_CLAUDE:-$HOME/.claude/CLAUDE.md}"
echo "$GLOBAL_CLAUDE"
```

## Step 3: Deduplicate and Filter

- Skip if equivalent rule already exists
- Refine if a similar rule exists but can be made more specific
- Add if genuinely new
- Filter out one-off context, obvious things, contradicting rules

## Step 4: Present Lessons to User

Show filtered lessons, then ask which to keep. Always show before saving — never add rules without explicit per-lesson approval.

## Step 5: Determine Target File

Ask: Project CLAUDE.md, Global CLAUDE.md, or Both. Separate by SCOPE if "Both".

## Step 6: Update CLAUDE.md

- Group under existing sections when possible
- Add `## Learned Rules` section if missing — place after existing content
- Each rule: `- [Rule] <!-- learned YYYY-MM-DD -->`
- Use Edit tool for targeted changes. Do NOT rewrite the entire file.

## Step 7: Confirm

Show summary of added and refined rules.

---

## Rules

1. **DO** write rules in imperative form ("Always use...", "Never commit...")
2. **DO** make rules specific and verifiable
3. **DO NOT** add rules about things Claude already knows
4. **DO NOT** add session-specific context as permanent rules
5. **DO NOT** remove existing rules unless user explicitly asks
