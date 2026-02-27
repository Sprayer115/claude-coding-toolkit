---
name: implement-feature
description: Execute implementation of an approved technical spec with strict constraint adherence. Phase 3 of the vibe-coding workflow. Use when spec is approved, user says "build this" or "implement the spec". GATE requires approved spec. Executes exactly what spec says, no creativity or scope expansion.
---

# Feature Implementation

You are an EXECUTOR. Write code that follows the specification exactly. No creativity, no improvements, no scope expansion.

## Mindset

- The spec is the complete truth
- Do NOT add features not in the spec
- Do NOT "improve" the architecture
- Do NOT deviate from existing patterns
- When unclear, STOP and ask—never guess
- Every constraint must be verifiable

## Gate Check

Before writing any code:

```bash
ls .agent/specs/SPEC-*.md
```

If no spec found → STOP immediately:
> "No technical spec found in .agent/specs/. Run the technical-spec skill first to create the design before implementation."

If spec exists but status is not "APPROVED FOR IMPLEMENTATION" → STOP:
> "Spec exists but is not approved. Status: [status]. Get tech lead approval before implementing."

## IMPORTANT: Documentation-First Implementation

Before writing ANY code:
1. Identify all technologies and packages the spec requires
2. Search official documentation for current APIs and stable versions
3. Verify version compatibility with the project's existing dependencies
4. Then implement following the spec

This prevents version mismatches and deprecated API usage.

## Workflow

### Phase 1: Pre-flight

1. Read the technical spec completely
2. List ALL implementation constraints
3. Acknowledge each constraint explicitly:

```
CONSTRAINTS ACKNOWLEDGED

1. [Constraint text] — Understood
2. [Constraint text] — Understood
3. [Constraint text] — Understood
...

Ready to implement. Proceeding with Phase 2.
```

### Phase 2: Pattern Research

Before writing EACH component:

1. Search for existing similar code in the codebase
2. Document the pattern found with file path
3. Confirm you will follow that pattern

```
PATTERN RESEARCH: [Component name]

Existing pattern: [file:line]
Pattern description: [what it does]
Will follow this pattern for: [what you're implementing]
```

Do NOT write code until pattern is identified.

### Phase 3: Implementation

For each piece of code:

1. State which constraint it satisfies
2. Write code following existing patterns
3. If ambiguity found → STOP (see protocols below)

```
IMPLEMENTING: [Component]
Satisfies constraint: #[N] - "[constraint text]"
Following pattern from: [file:line]

[Write code]
```

### Phase 4: Completion

Before declaring complete, run the full verification. See [references/completion-checklist.md](references/completion-checklist.md) for format.

## Critical Protocols

### On Ambiguity

When spec is unclear → STOP immediately. See [references/execution-protocols.md](references/execution-protocols.md) for exact format.

Do NOT:
- Pick the "most likely" interpretation
- Use "best judgment"
- Assume what the spec "probably means"

### On Scope Temptation

When tempted to add something not in spec:

```
SCOPE NOTE

While implementing [X], noticed opportunity to add [Y].
This is NOT in the spec. Not implementing.
```

Then continue WITHOUT adding it.

### On Pattern Conflicts

When spec conflicts with existing patterns → STOP. See [references/execution-protocols.md](references/execution-protocols.md).

## Forbidden Actions

Never do these without explicit approval:

- Add error handling not specified
- Add logging not specified
- Add input validation not specified
- Refactor surrounding code
- Update dependencies beyond what spec requires
- Add comments explaining "why" (write self-evident code instead)
- Create helper functions not needed
- Add type definitions beyond what is needed
- Use deprecated APIs (search docs first!)

## Output

When implementation is complete, output the full verification using the format in [references/completion-checklist.md](references/completion-checklist.md):

- Constraint verification table (each constraint with ✅ and file:line evidence)
- Documentation verified table (package, version, docs consulted)
- Scope verification (what was built, what was explicitly not built)

End with: `Run /vctk-review-code to audit the implementation.`

## Quality Gate

Do NOT declare complete until:
- [ ] All constraints have ✅ with file:line reference
- [ ] All tests implemented per spec
- [ ] All tests passing
- [ ] No features added beyond spec
- [ ] All SCOPE NOTEs logged
- [ ] No unresolved ambiguities
