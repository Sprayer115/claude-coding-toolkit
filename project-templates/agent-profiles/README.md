# Agent Profile Templates

Agent profiles define specialist personas that Claude can adopt for focused work. Copy these to your project's `.claude/` directory (or reference them in your CLAUDE.md) to activate project-specific expertise.

## What Are Agent Profiles?

An agent profile is a markdown file that:
1. Defines a specific engineering persona (backend expert, frontend architect, security reviewer, etc.)
2. Describes how that persona approaches problems
3. Lists what it prioritizes, pushes back on, and approves quickly

When referenced in a conversation, Claude adopts this persona's perspective and communication style.

## How to Use

### Option A: Reference in CLAUDE.md
Add to your project's CLAUDE.md:
```markdown
## Agent Profiles
- Backend reviews: Use `.claude/agent-profiles/backend-expert.md`
- Frontend reviews: Use `.claude/agent-profiles/frontend-architect.md`
```

### Option B: Direct Reference
In a conversation: "Review this using the backend expert profile at `.claude/agent-profiles/backend-expert.md`"

### Option C: As Skills
Wrap the profile in a SKILL.md to make it auto-triggerable or user-invocable.

## Customization

For each profile:
1. Copy it to `.claude/agent-profiles/` in your project
2. Update the **Expertise** section with your project's specific tech stack
3. Replace generic examples in "What You Push Back On" with project-specific concerns
4. Add project-specific conventions and patterns
5. Remove the "Template Note" at the bottom

## Available Templates

| Profile | Use When |
|---------|----------|
| `backend-expert.md` | Reviewing server-side code, APIs, database queries |
| `frontend-architect.md` | Reviewing UI components, state management, accessibility |

## Creating New Profiles

Good profiles to create for your project:
- **Security Reviewer** — focused on OWASP top 10, auth/authz, input validation
- **DevOps / Platform Engineer** — focused on CI/CD, infrastructure, deployment
- **Data Engineer** — focused on pipelines, schema design, query performance
- **Mobile Developer** — focused on platform-specific patterns and performance
