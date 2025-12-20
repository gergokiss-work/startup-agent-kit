---
description: Create or discover software requirements through codebase analysis and user collaboration
---

# Create Requirement

Create software requirements by analyzing the codebase, discovering implicit requirements, and collaborating with the user.

## Modes

This command operates in two modes:

### Mode 1: New Requirement (user describes what they want)
```
/create_requirement add user authentication
```

### Mode 2: Discovery Mode (analyze codebase for implicit requirements)
```
/create_requirement discover
```

## Process for New Requirement

### Step 1: Understand the Request

If a description is provided:
1. Parse the user's description
2. Ask clarifying questions:

```
I'll help create a requirement for: [parsed topic]

Before I write this up, let me clarify:

1. **User Story**: Who is this for and what's their goal?
   - Example: "As a [user type], I want [goal] so that [benefit]"

2. **Scope**: What's included vs explicitly out of scope?

3. **Constraints**: Any technical, time, or resource constraints?

4. **Priority**: Critical / High / Medium / Low?

5. **Dependencies**: Does this depend on or block other work?
```

### Step 2: Research Context

Spawn agents to understand the codebase context:
- **codebase-locator**: Find related existing code
- **codebase-pattern-finder**: Find similar features already implemented

### Step 3: Write Requirement

Create file in `thoughts/shared/requirements/`:

```markdown
# [Feature Name]

**Created**: YYYY-MM-DD
**Status**: Draft | Ready for Planning | In Progress | Complete
**Priority**: Critical | High | Medium | Low

## User Story

As a [user type], I want [goal] so that [benefit].

## Overview

[2-3 sentence description of the requirement]

## Acceptance Criteria

- [ ] Criterion 1: [Specific, testable condition]
- [ ] Criterion 2: [Specific, testable condition]
- [ ] Criterion 3: [Specific, testable condition]

## Technical Context

### Related Existing Code
- `path/to/file.js` - [how it relates]
- `path/to/another.js` - [how it relates]

### Patterns to Follow
- [Pattern from codebase]

### Technical Constraints
- [Constraint 1]
- [Constraint 2]

## Out of Scope

- [Explicitly excluded item 1]
- [Explicitly excluded item 2]

## Dependencies

- **Blocked by**: [other requirements or external factors]
- **Blocks**: [downstream work]

## Open Questions

- [ ] [Question needing resolution before implementation]

## Notes

[Additional context, links, or references]
```

## Process for Discovery Mode

When invoked with `discover`:

### Step 1: Analyze Codebase

Spawn parallel agents:
1. **codebase-locator**: Find all TODOs, FIXMEs, and incomplete features
2. **codebase-analyzer**: Identify areas lacking tests or documentation
3. **codebase-pattern-finder**: Find inconsistent patterns that need standardization

### Step 2: Check Existing Requirements

```bash
ls thoughts/shared/requirements/
```

Compare found issues against existing requirements to avoid duplicates.

### Step 3: Present Findings

```
## Discovered Potential Requirements

### From Code Analysis

1. **[Area]**: [Issue found]
   - Location: `file.js:45`
   - Suggested requirement: [brief description]
   - Priority estimate: [High/Medium/Low]

2. **[Area]**: [Issue found]
   ...

### From TODO/FIXME Comments

1. `file.js:123` - TODO: [comment text]
2. `another.js:45` - FIXME: [comment text]

### Gaps Identified

1. **Missing tests for**: [component]
2. **No documentation for**: [feature]
3. **Inconsistent pattern in**: [area]

---

Which of these should I create as formal requirements?
```

### Step 4: Create Selected Requirements

For each approved discovery, create a requirement file using the template above.

## File Naming

Format: `[ticket-id]-description.md` or `YYYY-MM-DD-description.md`

Examples:
- `ENG-1234-user-authentication.md`
- `2025-12-20-api-rate-limiting.md`
- `BUG-456-fix-login-timeout.md`

## Integration

After creating requirements:
```
Requirement created: thoughts/shared/requirements/[filename].md

Next steps:
1. Review and refine the requirement
2. Run `/create_plan thoughts/shared/requirements/[filename].md` to create implementation plan
```

## Important Guidelines

1. **Be Specific**: Vague requirements lead to vague implementations
2. **Be Testable**: Each acceptance criterion should be verifiable
3. **Research First**: Always check existing code before writing requirements
4. **Ask Questions**: Better to clarify upfront than discover issues later
5. **Note Dependencies**: Requirements don't exist in isolation
