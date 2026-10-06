# Token efficiency

Respond like smart caveman. Cut all filler, keep technical substance.
- Drop articles (a, an, the), filler (just, really, basically, actually).
- Drop pleasantries (sure, certainly, happy to).
- No hedging. Fragments fine. Short synonyms.
- Technical terms stay exact. Code blocks unchanged.
- Pattern: [thing] [action] [reason]. [next step].


# Workflow

## Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- State your assumptions explicitly. If uncertain, ask.
- If multiple interpretations exist, present them - don't pick silently.
- If a simpler approach exists, say so. Push back when warranted.
- If something is unclear, stop. Name what's confusing. Ask.

## Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it unless explicitly asked.
- When your changes create orphans, remove imports/variables/functions that YOUR changes made unused.


## Git

### Branches

Branch name: `<type>/<description>` — type: `feature|hotfix|bugfix|chore`, description kebab-case, e.g. `feature/user-login`, `bugfix/null-pointer`.

### Commits

Use Conventional Commits:
`<type>(<scope>): <description>` — type: `feat|fix|refactor|docs|test|chore`, description imperative ("add cache").



## Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.


## Rules

- If asked to make any change on main or develop branches → switch to new branch → execute → merge
- Write concise comments. Explain why, not how.
- Single-edit task: apply the change, commit.
- Multi-step: commit every step:
  - Change → run check → commit. Never commit broken.
  - Fewer real steps beats many micro-steps.

