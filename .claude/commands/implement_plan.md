---
description: Execute an approved technical plan phase by phase with verification
---

# Implement Plan

You are tasked with implementing a technical plan. You will execute each phase systematically, running verification after each phase, and pausing for manual verification when needed.

## Initial Steps

When this command is invoked:

1. **Read the plan file completely**
   - If a path was provided, read that file
   - If no path provided, ask which plan to implement

2. **Check for existing progress**
   - Look for checkmarks on completed phases
   - Identify the next phase to implement

3. **Present status**:
```
Implementing plan: [Plan Name]

Progress:
- [x] Phase 1: [Name] - Completed
- [ ] Phase 2: [Name] - Starting now
- [ ] Phase 3: [Name] - Pending

I'll begin implementing Phase 2 now.
```

## Implementation Process

### For Each Phase:

1. **Read the phase requirements completely**
   - Understand all changes required
   - Note the success criteria

2. **Implement changes**
   - Make each change as specified
   - Follow the file:line references
   - Use existing patterns from the codebase

3. **Run automated verification**
   - Execute each command in "Automated Verification"
   - Report results clearly

4. **Update plan progress**
   - Check off completed items in the plan file
   - Update status markers

5. **Pause for manual verification**
   - If phase has manual verification items, STOP
   - Present the manual verification checklist
   - Wait for user confirmation before proceeding

## Status Reporting

After each phase, report:

```
## Phase [N] Complete

### Changes Made:
- Modified `file.js:45-60` - [what was changed]
- Created `new-file.js` - [purpose]

### Automated Verification:
✅ Tests pass: `npm test`
✅ Linting passes: `npm run lint`
❌ Type check failed: [error details]

### Blocking Issues:
[If any automated checks failed]

### Ready for Manual Verification:
- [ ] Feature works in UI
- [ ] Performance acceptable

Please verify the manual items and confirm before I proceed to Phase [N+1].
```

## Error Handling

### If Automated Checks Fail:
1. Report the failure clearly
2. Attempt to fix the issue
3. Re-run verification
4. If still failing, pause and ask for guidance

### If Implementation Differs from Plan:
1. Note the deviation
2. Explain why the change was necessary
3. Confirm with user before continuing

## Important Guidelines

1. **Follow the plan exactly** - don't add unrequested features
2. **Verify after each phase** - don't skip verification
3. **Stop for manual verification** - always wait for user confirmation
4. **Report progress clearly** - use the todo list and status updates
5. **Handle errors gracefully** - report and ask for guidance when stuck

## Completion

When all phases are complete:

```
## Implementation Complete

All phases have been implemented:
- [x] Phase 1: [Name]
- [x] Phase 2: [Name]
- [x] Phase 3: [Name]

### Final Verification Status:
- Automated: All checks passing
- Manual: Confirmed by user

### Files Modified:
- `path/to/file1.js`
- `path/to/file2.js`

### Next Steps:
- [Any follow-up tasks from the plan]
- Consider creating a PR with `/describe_pr`
```
