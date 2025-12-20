---
description: Generate comprehensive PR descriptions from changes
---

# Describe PR

Generate a comprehensive pull request description from the current branch changes.

## Process

When this command is invoked:

### Step 1: Gather Information

Run in parallel:
- `git log main..HEAD --oneline` - All commits in this branch
- `git diff main...HEAD --stat` - File change summary
- `git diff main...HEAD` - Full diff

### Step 2: Analyze Changes

For each changed file:
1. Categorize the change type
2. Summarize what changed
3. Note any significant logic changes

### Step 3: Generate PR Description

Create description using this template:

```markdown
## Summary

[2-3 bullet points summarizing the changes]

## Changes

### [Category 1: e.g., New Features]
- [Change description]
- [Change description]

### [Category 2: e.g., Bug Fixes]
- [Change description]

### [Category 3: e.g., Refactoring]
- [Change description]

## Technical Details

[Any important technical context or decisions made]

## Testing

- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Checklist

- [ ] Code follows project conventions
- [ ] Self-review completed
- [ ] Documentation updated (if needed)
- [ ] No breaking changes (or documented if any)
```

### Step 4: Verification Checks

Run available checks:
- `npm run lint` or equivalent
- `npm run test` or equivalent
- `npm run typecheck` or equivalent

Report results:
```
## Pre-PR Checks

✅ Linting: Passed
✅ Tests: 42 passed
✅ Type Check: No errors
```

## Output Options

After generating:
```
PR description generated.

Options:
1. Copy to clipboard
2. Create PR now: `gh pr create`
3. Save to file: `thoughts/shared/prs/[branch]-description.md`
4. Modify and regenerate
```

## Important Guidelines

1. **Be comprehensive** - include all significant changes
2. **Group logically** - organize changes by type/area
3. **Include context** - explain "why" for non-obvious changes
4. **Run checks first** - verify code passes before PR
5. **Link issues** - reference related tickets/issues
