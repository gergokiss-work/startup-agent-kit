#!/bin/bash
# TTS Reader for Claude Code
# Reads summary from .claude/tts/summary.txt if TTS is enabled
#
# Toggle: touch .claude/tts/enabled   (enable)
#         rm .claude/tts/enabled      (disable)
#
# Voice options (uncomment preferred):
# VOICE="Samantha"    # Default US female
# VOICE="Daniel"      # UK male
# VOICE="Moira"       # Irish female
# VOICE="Tessa"       # South African female

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
TTS_DIR="$PROJECT_DIR/.claude/tts"
SUMMARY_FILE="$TTS_DIR/summary.txt"
ENABLED_FILE="$TTS_DIR/enabled"

# Default voice (change as preferred)
VOICE="${CLAUDE_TTS_VOICE:-Samantha}"

# Rate: 150-250 words per minute (default ~175)
RATE="${CLAUDE_TTS_RATE:-200}"

# Check if TTS is enabled
if [[ ! -f "$ENABLED_FILE" ]]; then
    exit 0
fi

# Check if summary file exists and has content
if [[ ! -f "$SUMMARY_FILE" ]] || [[ ! -s "$SUMMARY_FILE" ]]; then
    exit 0
fi

# Read and speak the summary
say -v "$VOICE" -r "$RATE" -f "$SUMMARY_FILE" &

# Clear the summary file after reading (optional - comment out to keep)
# > "$SUMMARY_FILE"
