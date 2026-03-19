---
name: vctk-save-session
user-invocable: true
description: Saves session context and optionally extracts lessons to CLAUDE.md for continuity across conversations. Use when user says 'save session', 'end of session', 'save my work context', 'wrap up', 'commit learnings', or at the end of a coding session. Creates a session summary and optionally updates CLAUDE.md with learned rules.
metadata:
  author: Sprayer115
  version: "0.2.0"
  category: session
  tags: [vctk, dev-workflow, session]
allowed-tools: ["Bash", "Read", "Write", "Edit", "Glob", "Grep", "AskUserQuestion"]
---

# Save Session

You are an expert session documenter. Create comprehensive session summaries that capture all changes and context, ensuring any engineer or LLM can understand exactly what was accomplished.

## Step 1: Get Developer Identity

```bash
git config user.name 2>/dev/null
```

Store as `$DEV_USERNAME`. If empty, ask the user. Sanitize: replace spaces/special chars with dashes.

## Step 2: Create Developer Folder

```bash
mkdir -p .agent/sessions/{$DEV_USERNAME}
```

## Step 3: Analyze Session

1. Check git status for modified/added files
2. Check recent commits if any were made
3. Review conversation context for what was discussed/built
4. Check .agent/briefs/ and .agent/specs/ for new files

## Step 4: Generate Session Summary

Write to `.agent/sessions/{$DEV_USERNAME}/last_session.md` with sections:
- Session Objective
- Files Modified (Created/Modified/Deleted)
- Implementation Details (Main Changes, Technical Decisions)
- Workflow Progress table
- Testing & Validation
- Current State
- Blockers/Issues
- Next Steps

## Step 5: Evaluate CLAUDE.md Lessons

Scan the session for:
1. Corrections received from the user
2. Repeated failures before getting it right
3. Project conventions discovered
4. User preferences expressed
5. Framework/tool gotchas

**Propose CLAUDE.md updates when:**
- User corrected your approach and it applies to future work
- A project convention not already in CLAUDE.md was discovered
- A tool behaved unexpectedly and the workaround should be remembered
- User explicitly stated a preference that should persist

If lessons found, ask for approval before saving. Never add rules without explicit per-lesson approval.

When adding to CLAUDE.md:
- Look for existing `## Learned Rules` section; if missing, add at end
- Each rule: `- [Imperative instruction] <!-- learned YYYY-MM-DD -->`
- Use Edit tool for targeted changes — do NOT rewrite the entire file

## Step 6: Confirm Save

After writing, confirm save location and show 1-2 sentence session summary with primary next step.

---

## Guidelines

- Include enough detail to resume work after time away
- Capture the "why" behind decisions, not just the "what"
- Only propose rules that genuinely help future sessions — not forced
