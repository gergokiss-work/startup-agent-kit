---
description: Deep codebase research using parallel agents for comprehensive understanding
---

# Research Codebase

You are tasked with conducting deep research into the codebase. You will spawn parallel agents to investigate different aspects and synthesize the findings.

## Initial Steps

When this command is invoked:

1. **Parse the research topic**
   - Extract the main topic/question from the command
   - Identify specific areas to investigate

2. **Plan the research**
   - Break down into specific research questions
   - Identify which agents to use

3. **Confirm scope**:
```
I'll research: [Topic]

Research questions:
1. [Question 1]
2. [Question 2]
3. [Question 3]

I'll spawn parallel agents to investigate these areas.
```

## Research Process

### Step 1: Spawn Research Agents

Launch multiple agents in parallel:

1. **codebase-locator**: Find all relevant files
   - "Find all files related to [topic]"

2. **codebase-analyzer**: Understand implementations
   - "Analyze how [feature] is implemented"

3. **codebase-pattern-finder**: Find similar patterns
   - "Find patterns similar to [topic]"

4. **research-agent**: Gather external context if needed
   - "Research [external topic] and best practices"

### Step 2: Wait for All Results

Do not proceed until all agents have returned.

### Step 3: Synthesize Findings

Combine all findings into a comprehensive report:

```
## Codebase Research: [Topic]

### File Locations
[From codebase-locator]

### Implementation Details
[From codebase-analyzer]

### Existing Patterns
[From codebase-pattern-finder]

### External Context
[From research-agent if used]

### Summary

**How it works:**
[High-level explanation with file:line references]

**Key files:**
- `path/to/file.js` - [purpose]
- `path/to/another.js` - [purpose]

**Patterns to follow:**
- [Pattern 1]
- [Pattern 2]

**Considerations:**
- [Important finding 1]
- [Important finding 2]
```

## Output Guidelines

1. **Include file:line references** for all claims
2. **Organize by topic** for easy navigation
3. **Note confidence levels** for uncertain findings
4. **Identify gaps** in the research
5. **Stay objective** - report facts, not opinions

## Save Research

After synthesizing findings, save to `thoughts/shared/research/`:

```bash
# Get current date for filename
DATE=$(date +"%Y-%m-%d")
```

Save as: `thoughts/shared/research/YYYY-MM-DD-topic.md`

Example: `thoughts/shared/research/2025-12-20-authentication-flow.md`

## Example Invocations

- `/research_codebase authentication flow`
- `/research_codebase database models`
- `/research_codebase error handling patterns`
- `/research_codebase API endpoint structure`
