#!/usr/bin/env bash
# Context Collector - Gathers system information for precise agent reporting
# Usage: source this script or run it to get current context as JSON or Markdown

set -euo pipefail

# Output format: "json" or "markdown" (default: markdown)
OUTPUT_FORMAT="${1:-markdown}"

# Collect current date/time
CURRENT_DATE=$(date +"%Y-%m-%d")
CURRENT_TIME=$(date +"%H:%M:%S")
CURRENT_TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
TIMEZONE=$(date +"%Z")
DAY_OF_WEEK=$(date +"%A")

# Collect system info
OS_NAME=$(uname -s)
OS_VERSION=$(uname -r)
ARCH=$(uname -m)
HOSTNAME=$(hostname -s 2>/dev/null || echo "unknown")

# macOS specific
if [[ "$OS_NAME" == "Darwin" ]]; then
    OS_PRETTY=$(sw_vers -productName 2>/dev/null || echo "macOS")
    OS_VERSION_PRETTY=$(sw_vers -productVersion 2>/dev/null || echo "$OS_VERSION")
else
    OS_PRETTY="$OS_NAME"
    OS_VERSION_PRETTY="$OS_VERSION"
fi

# Git context (if in a git repo)
GIT_BRANCH="(not a git repo)"
GIT_REPO="(not a git repo)"
GIT_STATUS="0"
GIT_LAST_COMMIT="(not a git repo)"
if git rev-parse --is-inside-work-tree &>/dev/null; then
    GIT_BRANCH=$(git branch --show-current 2>/dev/null || echo "detached")
    GIT_REPO=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)" || echo "unknown")
    GIT_STATUS=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    GIT_LAST_COMMIT=$(git log -1 --format="%h - %s (%ar)" 2>/dev/null || echo "no commits")
fi

# Tool versions
NODE_VERSION=$(node --version 2>/dev/null || echo "not installed")
NPM_VERSION=$(npm --version 2>/dev/null || echo "not installed")
PYTHON_VERSION=$(python3 --version 2>/dev/null | cut -d' ' -f2 || echo "not installed")
GO_VERSION=$(go version 2>/dev/null | cut -d' ' -f3 || echo "not installed")
DOCKER_VERSION=$(docker --version 2>/dev/null | cut -d' ' -f3 | tr -d ',' || echo "not installed")

# Current directory info
CWD=$(pwd)
CWD_NAME=$(basename "$CWD")

# Output based on format
if [[ "$OUTPUT_FORMAT" == "json" ]]; then
    cat <<EOF
{
  "timestamp": {
    "date": "$CURRENT_DATE",
    "time": "$CURRENT_TIME",
    "iso": "$CURRENT_TIMESTAMP",
    "timezone": "$TIMEZONE",
    "dayOfWeek": "$DAY_OF_WEEK"
  },
  "system": {
    "os": "$OS_PRETTY",
    "version": "$OS_VERSION_PRETTY",
    "arch": "$ARCH",
    "hostname": "$HOSTNAME"
  },
  "git": {
    "repository": "$GIT_REPO",
    "branch": "$GIT_BRANCH",
    "uncommittedChanges": $GIT_STATUS,
    "lastCommit": "$GIT_LAST_COMMIT"
  },
  "tools": {
    "node": "$NODE_VERSION",
    "npm": "$NPM_VERSION",
    "python": "$PYTHON_VERSION",
    "go": "$GO_VERSION",
    "docker": "$DOCKER_VERSION"
  },
  "directory": {
    "path": "$CWD",
    "name": "$CWD_NAME"
  }
}
EOF
else
    cat <<EOF
## Current Context

**Date**: $DAY_OF_WEEK, $CURRENT_DATE
**Time**: $CURRENT_TIME $TIMEZONE
**Timestamp**: $CURRENT_TIMESTAMP

### System
- **OS**: $OS_PRETTY $OS_VERSION_PRETTY ($ARCH)
- **Host**: $HOSTNAME

### Git Repository
- **Repository**: $GIT_REPO
- **Branch**: $GIT_BRANCH
- **Uncommitted Changes**: $GIT_STATUS files
- **Last Commit**: $GIT_LAST_COMMIT

### Tool Versions
- **Node.js**: $NODE_VERSION
- **npm**: $NPM_VERSION
- **Python**: $PYTHON_VERSION
- **Go**: $GO_VERSION
- **Docker**: $DOCKER_VERSION

### Working Directory
- **Path**: $CWD
- **Name**: $CWD_NAME
EOF
fi
