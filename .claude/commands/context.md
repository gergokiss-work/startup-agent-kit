---
description: Display current system context for precise reporting (date, time, git status, tool versions)
---

# Context

Display current system context to ensure accurate timestamps and environment awareness in reports.

## Process

When this command is invoked:

### Step 1: Collect System Context

Run the context collector script:

```bash
.claude/scripts/context-collector.sh markdown
```

### Step 2: Display Context

Present the collected information:

```
## Current Context

**Date**: [Day], YYYY-MM-DD
**Time**: HH:MM:SS TZ
**Timestamp**: ISO-8601 UTC

### System
- **OS**: [OS Name] [Version] ([Architecture])
- **Host**: [Hostname]

### Git Repository
- **Repository**: [repo-name]
- **Branch**: [branch-name]
- **Uncommitted Changes**: [N] files
- **Last Commit**: [hash] - [message] ([time ago])

### Tool Versions
- **Node.js**: [version]
- **Python**: [version]
- **Go**: [version]
- **Docker**: [version]

### Working Directory
- **Path**: [full path]
- **Name**: [directory name]
```

## Use Cases

1. **Before creating reports** - Ensure correct date/time in documentation
2. **Before commits** - Verify git status and branch
3. **Debugging environment issues** - Check tool versions
4. **Handoff documentation** - Include precise context

## JSON Output

For programmatic use, request JSON format:

```bash
.claude/scripts/context-collector.sh json
```

## Integration with Other Commands

This context is automatically available and should be used by:
- `/create_plan` - Include date in plan filenames
- `/describe_pr` - Reference current branch/commit
- `status-reporter` agent - Generate reports with precise timestamps
