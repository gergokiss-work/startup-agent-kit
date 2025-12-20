#!/usr/bin/env bash
# Project Initializer - Auto-detects project info and generates CLAUDE.md
# Usage: .claude/scripts/init-project.sh [--force]

set -euo pipefail

FORCE="${1:-}"
CLAUDE_MD="CLAUDE.md"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() { echo -e "${GREEN}[init]${NC} $1"; }
warn() { echo -e "${YELLOW}[warn]${NC} $1"; }
info() { echo -e "${BLUE}[info]${NC} $1"; }

# Check if CLAUDE.md already exists
if [[ -f "$CLAUDE_MD" && "$FORCE" != "--force" ]]; then
    warn "CLAUDE.md already exists. Use --force to overwrite."
    exit 1
fi

log "Analyzing project..."

# ============================================
# Detect Project Name
# ============================================
PROJECT_NAME=""
if [[ -f "package.json" ]]; then
    PROJECT_NAME=$(grep -m1 '"name"' package.json | sed 's/.*: *"\([^"]*\)".*/\1/' || echo "")
elif [[ -f "go.mod" ]]; then
    PROJECT_NAME=$(head -1 go.mod | sed 's/module //' | xargs basename || echo "")
elif [[ -f "Cargo.toml" ]]; then
    PROJECT_NAME=$(grep -m1 '^name' Cargo.toml | sed 's/.*= *"\([^"]*\)".*/\1/' || echo "")
elif [[ -f "setup.py" ]] || [[ -f "pyproject.toml" ]]; then
    if [[ -f "pyproject.toml" ]]; then
        PROJECT_NAME=$(grep -m1 '^name' pyproject.toml | sed 's/.*= *"\([^"]*\)".*/\1/' || echo "")
    fi
fi
# Fallback to directory name
PROJECT_NAME="${PROJECT_NAME:-$(basename "$(pwd)")}"
info "Project name: $PROJECT_NAME"

# ============================================
# Detect Primary Language
# ============================================
detect_language() {
    local ts_count=$(find . -name "*.ts" -o -name "*.tsx" 2>/dev/null | head -100 | wc -l | tr -d ' ')
    local js_count=$(find . -name "*.js" -o -name "*.jsx" 2>/dev/null | head -100 | wc -l | tr -d ' ')
    local py_count=$(find . -name "*.py" 2>/dev/null | head -100 | wc -l | tr -d ' ')
    local go_count=$(find . -name "*.go" 2>/dev/null | head -100 | wc -l | tr -d ' ')
    local java_count=$(find . -name "*.java" 2>/dev/null | head -100 | wc -l | tr -d ' ')
    local rs_count=$(find . -name "*.rs" 2>/dev/null | head -100 | wc -l | tr -d ' ')

    local max=0
    local lang="Unknown"

    if (( ts_count > max )); then max=$ts_count; lang="TypeScript"; fi
    if (( js_count > max )); then max=$js_count; lang="JavaScript"; fi
    if (( py_count > max )); then max=$py_count; lang="Python"; fi
    if (( go_count > max )); then max=$go_count; lang="Go"; fi
    if (( java_count > max )); then max=$java_count; lang="Java"; fi
    if (( rs_count > max )); then max=$rs_count; lang="Rust"; fi

    echo "$lang"
}
PRIMARY_LANGUAGE=$(detect_language)
info "Primary language: $PRIMARY_LANGUAGE"

# ============================================
# Detect Framework
# ============================================
FRAMEWORK="None detected"
if [[ -f "package.json" ]]; then
    if grep -q '"next"' package.json 2>/dev/null; then FRAMEWORK="Next.js"
    elif grep -q '"react"' package.json 2>/dev/null; then FRAMEWORK="React"
    elif grep -q '"vue"' package.json 2>/dev/null; then FRAMEWORK="Vue.js"
    elif grep -q '"express"' package.json 2>/dev/null; then FRAMEWORK="Express"
    elif grep -q '"fastify"' package.json 2>/dev/null; then FRAMEWORK="Fastify"
    elif grep -q '"nest"' package.json 2>/dev/null; then FRAMEWORK="NestJS"
    fi
elif [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]]; then
    if grep -qi "django" requirements.txt pyproject.toml 2>/dev/null; then FRAMEWORK="Django"
    elif grep -qi "flask" requirements.txt pyproject.toml 2>/dev/null; then FRAMEWORK="Flask"
    elif grep -qi "fastapi" requirements.txt pyproject.toml 2>/dev/null; then FRAMEWORK="FastAPI"
    fi
elif [[ -f "go.mod" ]]; then
    if grep -q "gin-gonic" go.mod 2>/dev/null; then FRAMEWORK="Gin"
    elif grep -q "echo" go.mod 2>/dev/null; then FRAMEWORK="Echo"
    elif grep -q "fiber" go.mod 2>/dev/null; then FRAMEWORK="Fiber"
    fi
elif [[ -f "pom.xml" ]]; then
    if grep -q "spring-boot" pom.xml 2>/dev/null; then FRAMEWORK="Spring Boot"
    elif grep -q "quarkus" pom.xml 2>/dev/null; then FRAMEWORK="Quarkus"
    fi
fi
info "Framework: $FRAMEWORK"

# ============================================
# Detect Package Manager & Commands
# ============================================
INSTALL_CMD=""
DEV_CMD=""
TEST_CMD=""
LINT_CMD=""
BUILD_CMD=""

if [[ -f "package.json" ]]; then
    # Detect package manager
    if [[ -f "bun.lockb" ]]; then
        PM="bun"
    elif [[ -f "pnpm-lock.yaml" ]]; then
        PM="pnpm"
    elif [[ -f "yarn.lock" ]]; then
        PM="yarn"
    else
        PM="npm"
    fi

    INSTALL_CMD="$PM install"

    # Detect scripts from package.json
    if grep -q '"dev"' package.json 2>/dev/null; then DEV_CMD="$PM run dev"; fi
    if grep -q '"start"' package.json 2>/dev/null; then DEV_CMD="${DEV_CMD:-$PM start}"; fi
    if grep -q '"test"' package.json 2>/dev/null; then TEST_CMD="$PM test"; fi
    if grep -q '"lint"' package.json 2>/dev/null; then LINT_CMD="$PM run lint"; fi
    if grep -q '"build"' package.json 2>/dev/null; then BUILD_CMD="$PM run build"; fi

elif [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]]; then
    INSTALL_CMD="pip install -r requirements.txt"
    if [[ -f "pyproject.toml" ]]; then INSTALL_CMD="pip install -e ."; fi
    TEST_CMD="pytest"
    LINT_CMD="ruff check . && ruff format --check ."

elif [[ -f "go.mod" ]]; then
    INSTALL_CMD="go mod download"
    TEST_CMD="go test ./..."
    LINT_CMD="golangci-lint run"
    BUILD_CMD="go build ./..."

elif [[ -f "Cargo.toml" ]]; then
    INSTALL_CMD="cargo build"
    TEST_CMD="cargo test"
    LINT_CMD="cargo clippy"
    BUILD_CMD="cargo build --release"

elif [[ -f "pom.xml" ]]; then
    INSTALL_CMD="mvn install"
    TEST_CMD="mvn test"
    BUILD_CMD="mvn package"
fi

# ============================================
# Detect Project Structure
# ============================================
STRUCTURE=""
if [[ -d "src" ]]; then STRUCTURE="src/"; fi
if [[ -d "lib" ]]; then STRUCTURE="${STRUCTURE}lib/, "; fi
if [[ -d "app" ]]; then STRUCTURE="${STRUCTURE}app/, "; fi
if [[ -d "tests" ]] || [[ -d "test" ]] || [[ -d "__tests__" ]]; then STRUCTURE="${STRUCTURE}tests/, "; fi
if [[ -d "docs" ]]; then STRUCTURE="${STRUCTURE}docs/, "; fi
STRUCTURE="${STRUCTURE%, }"
STRUCTURE="${STRUCTURE:-Standard layout}"

# ============================================
# Detect Git Info
# ============================================
GIT_REMOTE=""
if git rev-parse --is-inside-work-tree &>/dev/null; then
    GIT_REMOTE=$(git remote get-url origin 2>/dev/null | sed 's/.*github.com[:/]\(.*\)\.git/https:\/\/github.com\/\1/' || echo "")
fi

# ============================================
# Generate CLAUDE.md
# ============================================
log "Generating CLAUDE.md..."

cat > "$CLAUDE_MD" << EOF
# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Repository Overview

**Project Name**: $PROJECT_NAME
**Primary Language**: $PRIMARY_LANGUAGE
**Framework**: $FRAMEWORK

## Project Structure

\`\`\`
$PROJECT_NAME/
├── ${STRUCTURE//,/
├──}
\`\`\`

## Development Commands

\`\`\`bash
# Install dependencies
${INSTALL_CMD:-# Add install command}

# Run development server
${DEV_CMD:-# Add dev command}

# Run tests
${TEST_CMD:-# Add test command}

# Run linting
${LINT_CMD:-# Add lint command}

# Build for production
${BUILD_CMD:-# Add build command}
\`\`\`

## Available Tools

### Scripts (run via Bash)

| Script | Purpose | Usage |
|--------|---------|-------|
| \`.claude/scripts/context-collector.sh\` | Get current date, time, git status, system info | \`bash .claude/scripts/context-collector.sh\` |
| \`.claude/scripts/init-project.sh\` | Regenerate this CLAUDE.md | \`bash .claude/scripts/init-project.sh --force\` |

### Commands (invoke with /)

| Command | Purpose |
|---------|---------|
| \`/create_requirement\` | Create or discover requirements from codebase |
| \`/create_plan\` | Create detailed implementation plans |
| \`/implement_plan\` | Execute plans phase by phase |
| \`/research_codebase\` | Deep codebase research |
| \`/commit\` | Structured git commits |
| \`/describe_pr\` | Generate PR descriptions |
| \`/debug\` | Investigation-only debugging |
| \`/context\` | Display current system context |

### Agents (spawned automatically)

| Agent | Purpose |
|-------|---------|
| \`codebase-locator\` | Find files by topic |
| \`codebase-analyzer\` | Understand implementations |
| \`codebase-pattern-finder\` | Find similar patterns |
| \`quality-gate\` | Run verification checks |
| \`test-writer\` | Write tests |
| \`research-agent\` | Research objectively |
| \`status-reporter\` | Generate reports with timestamps |

## Context Collection

Before generating reports or timestamps, run:
\`\`\`bash
bash .claude/scripts/context-collector.sh
\`\`\`

## Thoughts Directory

Store persistent metadata in \`thoughts/\`:
- \`thoughts/shared/requirements/\` - Feature specs, tickets, user stories
- \`thoughts/shared/plans/\` - Implementation plans (created from requirements)
- \`thoughts/shared/research/\` - Codebase research documents

### Workflow

1. **Requirements** → User creates or you help create specs in \`requirements/\`
2. **Planning** → \`/create_plan requirements/ENG-1234.md\` creates plan in \`plans/\`
3. **Research** → \`/research_codebase topic\` saves findings in \`research/\`
4. **Implementation** → \`/implement_plan plans/2025-12-20-feature.md\` executes plan

### File Naming

| Directory | Format | Example |
|-----------|--------|---------|
| requirements/ | \`[ticket]-description.md\` | \`ENG-1234-auth-feature.md\` |
| plans/ | \`YYYY-MM-DD-description.md\` | \`2025-12-20-auth-feature.md\` |
| research/ | \`YYYY-MM-DD-topic.md\` | \`2025-12-20-api-patterns.md\` |

## Code Quality Standards

### Formatting
- Follow project conventions
- Always leave empty line at end of file
- Trim trailing whitespace

### Testing
- Run tests before committing
- Add tests for new features

## Architecture Guidelines

<!-- Add your architecture patterns here -->
- Follow existing patterns in the codebase
- Check similar implementations before adding new code

## Security Considerations

- Never commit secrets, API keys, or credentials
- Use environment variables for sensitive configuration

## Working Style

- **Git Operations**: Review changes before committing
- **Code Reviews**: Follow PR template guidelines

${GIT_REMOTE:+## Repository

- **GitHub**: $GIT_REMOTE}

---

*Generated on $(date +"%Y-%m-%d") by startup-agent-kit*
*Customize this file for your project's specific needs*
EOF

log "Created CLAUDE.md successfully!"
info "Review and customize the generated file as needed."

# Show summary
echo ""
echo "============================================"
echo "  Project Analysis Summary"
echo "============================================"
echo "  Name:      $PROJECT_NAME"
echo "  Language:  $PRIMARY_LANGUAGE"
echo "  Framework: $FRAMEWORK"
echo "  Structure: $STRUCTURE"
echo "============================================"
