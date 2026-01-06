# Session Memory Protocol Template

> **Optional feature** - Enable this for projects that need state persistence across sessions.

## Overview

The Session Memory Protocol helps maintain continuity between Claude sessions by using structured state files. This is useful for:

- Long-running projects with complex state
- Feature development spanning multiple sessions
- Team handoffs where context needs preservation

## Setup

### 1. Create Memory Files

Create these files in your project root or `.claude/` directory:

```
.claude/
├── state/
│   ├── features.json      # Feature backlog with status
│   ├── progress.md        # Session history and progress
│   └── context.json       # Current working context
```

### 2. Add to CLAUDE.md

Add this section to your project's CLAUDE.md:

```markdown
## Session Protocol

### Memory Files
| File | Purpose |
|------|---------|
| `.claude/state/features.json` | Feature backlog with status |
| `.claude/state/progress.md` | Session history |
| `.claude/state/context.json` | Current working context |

### Session Workflow
- **START**: Read all state files to restore context
- **DURING**: Work on one task at a time, update progress
- **END**: Update all state files before ending session
```

## File Templates

### features.json

```json
{
  "version": "1.0",
  "lastUpdated": "2025-01-06T10:00:00Z",
  "features": [
    {
      "id": "FEAT-001",
      "title": "Feature Title",
      "status": "in_progress",
      "priority": "high",
      "description": "Brief description",
      "tasks": [
        { "task": "Task 1", "done": true },
        { "task": "Task 2", "done": false }
      ],
      "notes": "Additional context"
    }
  ]
}
```

### progress.md

```markdown
# Progress Log

## Session: 2025-01-06

### Completed
- [x] Task 1 description

### In Progress
- [ ] Task 2 description

### Blockers
- Blocker description

### Notes
Session notes and context for next session

---

## Session: 2025-01-05
[Previous session log...]
```

### context.json

```json
{
  "currentFeature": "FEAT-001",
  "currentTask": "Task 2",
  "workingFiles": [
    "src/feature.js",
    "tests/feature.test.js"
  ],
  "openQuestions": [
    "Question that needs resolution"
  ],
  "lastAction": "Completed Task 1, starting Task 2"
}
```

## Session Workflow

### At Session Start

1. Read `.claude/state/features.json` to understand backlog
2. Read `.claude/state/progress.md` for recent history
3. Read `.claude/state/context.json` for current focus
4. Announce current state to user

### During Session

1. Work on **one task at a time**
2. Update progress.md as tasks complete
3. Note any blockers or questions
4. Keep context.json current

### At Session End

1. Update all state files
2. Write clear handoff notes
3. Document any unfinished work
4. Note next steps

## Best Practices

1. **Atomic Updates**: Update state files after each meaningful change
2. **Clear Notes**: Write notes as if explaining to a new team member
3. **Track Blockers**: Document what's blocking progress
4. **Version State**: Include version/timestamp in state files
5. **Clean Up**: Remove completed items periodically

## When to Use

✅ **Good for:**
- Multi-session feature development
- Complex refactoring projects
- Team collaboration with handoffs
- Projects requiring audit trails

❌ **Skip for:**
- One-off tasks
- Simple bug fixes
- Exploratory work
- Projects without continuity needs
