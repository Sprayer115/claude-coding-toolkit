# Context Skill Template

Use this template to create project-specific context injection skills. These skills automatically surface domain knowledge when Claude detects relevant work, reducing context-loading friction.

## What It Does

A context skill:
1. Detects when the user is working in a specific domain (auth, billing, API, etc.)
2. Silently loads relevant documentation and architectural context
3. Provides targeted guidance based on that context without being asked

## How to Use This Template

1. Copy this `context-skill/` folder to your project's `.claude/skills/` directory
2. Rename it to match your domain: `my-project-auth-context/`
3. Open `SKILL.md` and replace all `PROJECT_*` placeholders
4. Add real architectural knowledge in the Key Domain Context section
5. Deploy: the skill will auto-trigger based on your defined trigger conditions

## Good Use Cases

- **Domain-specific codebases**: "When working on the payment system, always check the idempotency rules in SOP/payments.md"
- **Legacy system onboarding**: "When touching the legacy API layer, remind about the adapter pattern and known quirks"
- **Multi-team projects**: "When in the `infra/` directory, load the infrastructure conventions doc"

## Tips

- Keep trigger terms specific — overly broad triggers cause the skill to activate too often
- Keep the context concise — this is a reference layer, not a full tutorial
- Update the skill as you discover new gotchas during development
- One skill per domain is better than one giant context skill
