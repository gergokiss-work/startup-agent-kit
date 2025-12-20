#!/usr/bin/env bash
# Startup Agent Kit - Setup Script
# Works for both new and existing projects
# Usage: bash setup.sh

set -euo pipefail

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() { echo -e "${GREEN}[setup]${NC} $1"; }
info() { echo -e "${BLUE}[info]${NC} $1"; }
warn() { echo -e "${YELLOW}[warn]${NC} $1"; }

echo "========================================"
echo "  Startup Agent Kit - Setup"
echo "========================================"
echo ""

# ============================================
# Detect Project Type (New vs Existing)
# ============================================
PROJECT_TYPE="new"
HAS_CODE=false
HAS_REQUIREMENTS=false
TODO_COUNT=0

# Check for existing code
if [[ -f "package.json" ]] || [[ -f "go.mod" ]] || [[ -f "Cargo.toml" ]] || \
   [[ -f "requirements.txt" ]] || [[ -f "pyproject.toml" ]] || [[ -f "pom.xml" ]] || \
   [[ -d "src" ]] || [[ -d "lib" ]] || [[ -d "app" ]]; then
    PROJECT_TYPE="existing"
    HAS_CODE=true
fi

# Check for existing requirements
if [[ -d "thoughts/shared/requirements" ]] && [[ -n "$(ls -A thoughts/shared/requirements 2>/dev/null | grep -v .gitkeep)" ]]; then
    HAS_REQUIREMENTS=true
fi

# Count TODOs/FIXMEs in codebase
if $HAS_CODE; then
    TODO_COUNT=$(grep -r -E "TODO|FIXME|HACK|XXX" --include="*.js" --include="*.ts" --include="*.py" --include="*.go" --include="*.java" --include="*.rs" . 2>/dev/null | wc -l | tr -d ' ' || echo "0")
fi

if [[ "$PROJECT_TYPE" == "existing" ]]; then
    log "Detected existing project"
    info "  Has source code: $HAS_CODE"
    info "  Has requirements: $HAS_REQUIREMENTS"
    info "  TODO/FIXME count: $TODO_COUNT"
else
    log "Setting up new project"
fi
echo ""

# ============================================
# Make Scripts Executable
# ============================================
log "Making scripts executable..."
if [[ -d ".claude/scripts" ]]; then
    chmod +x .claude/scripts/*.sh 2>/dev/null || true
    info "Made .claude/scripts/*.sh executable"
fi

# ============================================
# Create Thoughts Directories
# ============================================
log "Creating thoughts directories..."
mkdir -p thoughts/shared/requirements thoughts/shared/plans thoughts/shared/research
info "Created thoughts/shared/{requirements,plans,research}"

# ============================================
# Generate CLAUDE.md
# ============================================
if [[ ! -f "CLAUDE.md" ]]; then
    log "No CLAUDE.md found. Generating from project analysis..."
    if [[ -f ".claude/scripts/init-project.sh" ]]; then
        bash .claude/scripts/init-project.sh
    else
        warn "init-project.sh not found. Please create CLAUDE.md manually."
    fi
else
    info "CLAUDE.md already exists. Skipping generation."
    info "Run 'bash .claude/scripts/init-project.sh --force' to regenerate."
fi

# ============================================
# Existing Project Analysis
# ============================================
if [[ "$PROJECT_TYPE" == "existing" ]]; then
    echo ""
    log "Existing project analysis..."

    # Check for TODOs
    if [[ $TODO_COUNT -gt 0 ]]; then
        info "Found $TODO_COUNT TODO/FIXME comments in codebase"
        info "Run '/create_requirement discover' to convert these to requirements"
    fi

    # Check existing requirements
    if $HAS_REQUIREMENTS; then
        REQ_COUNT=$(ls -1 thoughts/shared/requirements 2>/dev/null | grep -v .gitkeep | wc -l | tr -d ' ')
        info "Found $REQ_COUNT existing requirements in thoughts/shared/requirements/"
    else
        info "No existing requirements found"
        info "Run '/create_requirement' to create your first requirement"
    fi

    # Check for existing plans
    if [[ -d "thoughts/shared/plans" ]] && [[ -n "$(ls -A thoughts/shared/plans 2>/dev/null | grep -v .gitkeep)" ]]; then
        PLAN_COUNT=$(ls -1 thoughts/shared/plans 2>/dev/null | grep -v .gitkeep | wc -l | tr -d ' ')
        info "Found $PLAN_COUNT existing plans in thoughts/shared/plans/"
    fi
fi

# ============================================
# Verify Setup
# ============================================
echo ""
log "Verifying setup..."

CHECKS_PASSED=0
CHECKS_TOTAL=5

if [[ -x ".claude/scripts/context-collector.sh" ]]; then
    ((CHECKS_PASSED++))
    info "✓ context-collector.sh is executable"
else
    warn "✗ context-collector.sh not executable"
fi

if [[ -x ".claude/scripts/init-project.sh" ]]; then
    ((CHECKS_PASSED++))
    info "✓ init-project.sh is executable"
else
    warn "✗ init-project.sh not executable"
fi

if [[ -f "CLAUDE.md" ]]; then
    ((CHECKS_PASSED++))
    info "✓ CLAUDE.md exists"
else
    warn "✗ CLAUDE.md missing"
fi

if [[ -d ".claude/agents" ]] && [[ -d ".claude/commands" ]]; then
    ((CHECKS_PASSED++))
    info "✓ .claude/agents and .claude/commands exist"
else
    warn "✗ .claude folders incomplete"
fi

if [[ -f ".claude/settings.json" ]]; then
    ((CHECKS_PASSED++))
    info "✓ .claude/settings.json exists"
else
    warn "✗ .claude/settings.json missing"
fi

# ============================================
# Summary
# ============================================
echo ""
echo "========================================"
echo "  Setup Complete: $CHECKS_PASSED/$CHECKS_TOTAL checks passed"
echo "========================================"
echo ""

if [[ "$PROJECT_TYPE" == "existing" ]]; then
    echo "Existing project detected. Recommended next steps:"
    echo ""
    echo "  1. Review CLAUDE.md and customize if needed"
    echo "  2. Run '/create_requirement discover' to find implicit requirements"
    echo "  3. Create plans with '/create_plan requirements/[file].md'"
    echo ""
    if [[ $TODO_COUNT -gt 10 ]]; then
        echo "  Note: Found $TODO_COUNT TODOs in your codebase."
        echo "  Consider running '/create_requirement discover' to triage them."
        echo ""
    fi
else
    echo "New project setup complete. Next steps:"
    echo ""
    echo "  1. Review and customize CLAUDE.md"
    echo "  2. Create your first requirement with '/create_requirement'"
    echo "  3. Start Claude Code: claude"
    echo ""
fi
