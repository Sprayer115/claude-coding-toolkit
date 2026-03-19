---
name: stack_conventions
description: Project-specific coding conventions, patterns, and standards that Claude should follow
type: feedback
---

# Stack Conventions

Rules and patterns specific to this project that Claude should follow consistently.

## Naming Conventions

- [e.g., "Use camelCase for JavaScript variables, PascalCase for components"]
- [e.g., "Database columns use snake_case"]
- [e.g., "Feature flags use SCREAMING_SNAKE_CASE"]

## File Organization

- [e.g., "New API endpoints go in /src/api/routes/ as separate files"]
- [e.g., "Shared utilities go in /src/utils/, not inline"]

## Code Patterns

- [e.g., "Use our internal `ApiClient` class, never raw `fetch` calls"]
- [e.g., "All database queries go through the Repository pattern — never raw SQL in controllers"]
- [e.g., "Use `Result<T, E>` for error handling, never throw exceptions in service layer"]

## Testing Standards

- [e.g., "Every new public method needs a unit test"]
- [e.g., "Integration tests use the real database — no mocking the DB"]
- [e.g., "Test file naming: `{feature}.test.ts` co-located with source"]

## Git Conventions

- [e.g., "Branch naming: `feature/TICKET-123-short-description`"]
- [e.g., "Commit messages: conventional commits format (feat:, fix:, chore:)"]
- [e.g., "Squash commits before merging to main"]

## Tools to Use / Avoid

| Task | Use | Avoid |
|------|-----|-------|
| HTTP requests | [e.g., our ApiClient] | [e.g., raw fetch] |
| State management | [e.g., Pinia] | [e.g., Vuex] |
| Validation | [e.g., Zod] | [e.g., manual checks] |

## Learned Rules

Rules extracted from development sessions to prevent repeated mistakes.

<!-- Rules will be appended here by /vctk-learn and /vctk-save-session -->

---

> **How to use**: Fill in the sections relevant to your project. Claude will use these conventions when writing code. Run `/vctk-learn` to automatically add new rules discovered during development sessions.
