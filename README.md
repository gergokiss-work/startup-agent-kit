# Startup Agent Kit

A ready-to-use AI development toolkit for Claude Code. Drop this into any repository to enable AI-assisted development with best practices built in.

## Quick Start

1. Copy the kit to your repository
2. Run `bash setup.sh`
3. Start using Claude Code

```bash
# Copy everything to your project
cp -r startup-agent-kit/.claude /path/to/your/project/
cp -r startup-agent-kit/.github /path/to/your/project/
cp -r startup-agent-kit/thoughts /path/to/your/project/
cp startup-agent-kit/setup.sh /path/to/your/project/

# Run setup (makes scripts executable, generates CLAUDE.md)
cd /path/to/your/project
bash setup.sh
```

The `setup.sh` script:
- Makes all scripts executable (`chmod +x`)
- Creates `thoughts/` directories
- Auto-generates `CLAUDE.md` from your project
- Verifies the installation

## Project Initialization

The `init-project.sh` script auto-detects and populates `CLAUDE.md`:

```bash
.claude/scripts/init-project.sh          # Generate CLAUDE.md
.claude/scripts/init-project.sh --force  # Overwrite existing
```

**Auto-detects:**
- Project name (from package.json, go.mod, Cargo.toml, etc.)
- Primary language (TypeScript, Python, Go, Java, Rust)
- Framework (Next.js, React, Django, FastAPI, Spring Boot, etc.)
- Package manager (npm, yarn, pnpm, bun, pip, cargo, maven)
- Development commands (install, dev, test, lint, build)
- Git remote URL

## What's Included

```
startup-agent-kit/
├── .claude/
│   ├── agents/              # Specialized sub-agents
│   │   ├── codebase-locator.md      # Find files by topic
│   │   ├── codebase-analyzer.md     # Understand implementations
│   │   ├── codebase-pattern-finder.md # Find similar patterns
│   │   ├── quality-gate.md          # Run verification checks
│   │   ├── test-writer.md           # Write tests
│   │   ├── research-agent.md        # Research topics
│   │   └── status-reporter.md       # Generate status reports
│   ├── commands/            # Workflow commands
│   │   ├── create_requirement.md    # /create_requirement
│   │   ├── create_plan.md           # /create_plan
│   │   ├── implement_plan.md        # /implement_plan
│   │   ├── research_codebase.md     # /research_codebase
│   │   ├── commit.md                # /commit
│   │   ├── describe_pr.md           # /describe_pr
│   │   ├── debug.md                 # /debug
│   │   └── context.md               # /context
│   ├── scripts/             # Utility scripts
│   │   ├── context-collector.sh     # System context gatherer
│   │   └── init-project.sh          # Auto-generate CLAUDE.md
│   └── settings.json        # Claude Code permissions config
├── .github/
│   ├── PULL_REQUEST_TEMPLATE.md     # PR template
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug-report.md            # Bug report template
│   │   └── feature-request.md       # Feature request template
│   └── workflows/
│       └── ci.yml.example           # Sample CI workflow
├── thoughts/
│   └── shared/
│       ├── requirements/            # Feature specs, tickets, user stories
│       ├── plans/                   # Implementation plans
│       └── research/                # Research documents
├── CLAUDE.md                        # Project configuration template
├── setup.sh                         # One-command setup script
└── README.md                        # This file
```

## Available Commands

| Command | Description |
|---------|-------------|
| `/create_requirement` | Create or discover requirements from codebase analysis |
| `/create_plan` | Create detailed implementation plans interactively |
| `/implement_plan` | Execute a plan phase by phase with verification |
| `/research_codebase` | Deep codebase research with parallel agents |
| `/commit` | Structured git commit workflow |
| `/describe_pr` | Generate comprehensive PR descriptions |
| `/debug` | Investigation-only debugging (read-only) |
| `/context` | Display current system context (date, time, git, versions) |

## Agents

| Agent | Purpose |
|-------|---------|
| `codebase-locator` | Find files by topic/feature ("super grep/glob") |
| `codebase-analyzer` | Understand how code works with file:line references |
| `codebase-pattern-finder` | Find similar implementations to use as templates |
| `quality-gate` | Run verification checks and report results |
| `test-writer` | Write tests matching codebase patterns |
| `research-agent` | Research topics objectively (documents, doesn't critique) |
| `status-reporter` | Generate status reports with precise timestamps |

## Key Concepts

### Planning Workflow

1. **Create Plan**: `/create_plan` - Interactive plan creation
2. **Review**: User reviews and approves the plan
3. **Implement**: `/implement_plan` - Execute phase by phase
4. **Verify**: Automated + manual verification at each phase

### Success Criteria

All plans separate success criteria into:

- **Automated Verification**: Commands that can be run (`npm test`, `npm run lint`)
- **Manual Verification**: Human testing required (UI, performance, edge cases)

### Thoughts Directory

The `thoughts/` directory stores metadata outside the main codebase:
- `thoughts/shared/requirements/` - Feature specs, tickets, user stories
- `thoughts/shared/plans/` - Implementation plans (created from requirements)
- `thoughts/shared/research/` - Codebase research documents

### Agent Principle

**"Agents Document, Don't Critique"**

Research and analysis agents report findings objectively. They don't make judgments or recommendations - they provide information for humans to make decisions.

### Context Collector

The `.claude/scripts/context-collector.sh` script gathers system information for precise reporting:

```bash
# Markdown output (default)
.claude/scripts/context-collector.sh

# JSON output for programmatic use
.claude/scripts/context-collector.sh json
```

Collects:
- Current date/time with timezone
- OS and architecture
- Git repository, branch, uncommitted changes
- Tool versions (Node, Python, Go, Docker)
- Working directory

Use `/context` command or have agents call this script before generating reports.

## Customization

### CLAUDE.md

The `CLAUDE.md` file is your project's configuration for Claude Code. Customize:
- Project overview and stack
- Development commands
- Code quality standards
- Architecture guidelines
- Security considerations

### Adding Custom Agents

Create new agents in `.claude/agents/`:

```markdown
---
name: my-agent
description: What this agent does
tools: Read, Grep, Glob
---

# Agent Instructions

[Agent-specific instructions here]
```

### Adding Custom Commands

Create new commands in `.claude/commands/`:

```markdown
---
description: What this command does
---

# Command Name

[Command workflow instructions here]
```

## Best Practices

### Context Engineering

- Keep context focused and relevant
- Use sub-agents for deep research
- Let agents handle file exploration

### Planning

- Create plans for non-trivial changes
- Break work into testable phases
- Include clear success criteria

### Verification

- Run automated checks after each phase
- Pause for manual verification when needed
- Don't skip quality gates

### Git Workflow

- Use `/commit` for structured commits
- Use `/describe_pr` for PR descriptions
- Group related changes logically

## For Existing Projects

When dropped into an existing project, the kit will:

1. **Detect project type** - Analyzes package.json, go.mod, etc.
2. **Scan for TODOs/FIXMEs** - Discovers implicit requirements
3. **Check for existing requirements** - Looks in `thoughts/shared/requirements/`
4. **Offer to generate requirements** - From codebase analysis

Use `/create_requirement discover` to analyze the codebase and generate requirements.

## Git Integration

### Recommended .gitignore additions

```gitignore
# If you want to keep thoughts private (not recommended for teams)
# thoughts/

# If you want to share thoughts (recommended for teams)
# Commit the thoughts/ directory
```

**Recommendation**: Commit `thoughts/` to share context across team and sessions.

## License

MIT - Feel free to use and modify for your projects.

---

*Part of the AI Best Practices documentation*
