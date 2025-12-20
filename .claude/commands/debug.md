---
description: Investigation-only debugging with parallel analysis (read-only mode)
---

# Debug

Investigate issues using parallel analysis tasks. This is a READ-ONLY mode - no file editing allowed.

## Important Constraint

**⚠️ NO FILE EDITING ALLOWED**

This command is for investigation only. All findings should be reported so the user can decide how to fix issues.

## Process

When this command is invoked:

### Step 1: Understand the Issue

Ask for context if not provided:
```
I'll help debug this issue. Please provide:
1. What error/behavior are you seeing?
2. When does it occur?
3. What did you expect to happen?
4. Any relevant logs or error messages?
```

### Step 2: Spawn Investigation Tasks

Launch parallel analysis:

1. **Log Analysis**
   - Search for error patterns in logs
   - Find relevant stack traces
   - Identify timing of issues

2. **Code Analysis**
   - Find the code paths involved
   - Trace the execution flow
   - Identify potential failure points

3. **State Inspection**
   - Check configuration files
   - Examine environment variables
   - Review database state if relevant

4. **History Check**
   - `git log` - Recent changes
   - `git blame` - Who changed what
   - Related issues or PRs

### Step 3: Synthesize Findings

Present structured analysis:

```
## Debug Analysis: [Issue Description]

### Error Summary
- **What**: [Error/behavior observed]
- **Where**: [File:line or component]
- **When**: [Conditions that trigger it]

### Root Cause Analysis

#### Evidence Found:
1. `file.js:45` - [What we found]
2. Log shows: [Relevant log entry]
3. Config: [Configuration issue if any]

#### Most Likely Cause:
[Explanation of what's probably wrong]

#### Other Possibilities:
- [Alternative cause 1]
- [Alternative cause 2]

### Affected Code Paths
1. `entry.js:10` → `handler.js:25` → `service.js:45`
2. [Any other affected paths]

### Recommended Investigation
1. [Next step to confirm cause]
2. [Additional data to gather]

### Suggested Fixes
1. **[Fix Option 1]**
   - Change `file.js:45` to [suggestion]
   - Reason: [why this would help]

2. **[Fix Option 2]**
   - Alternative approach
   - Reason: [tradeoffs]

### Files to Examine
- `path/to/file.js:45` - [why]
- `path/to/config.json` - [why]
```

## Output Guidelines

1. **Don't make changes** - only report findings
2. **Include file:line references** for all claims
3. **Provide evidence** for conclusions
4. **Suggest fixes** but let user implement
5. **Note uncertainties** - be clear about confidence levels

## Example Invocations

- `/debug` - Interactive debugging
- `/debug "TypeError in user service"` - Specific error
- `/debug check authentication flow` - Investigate flow
