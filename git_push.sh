#!/bin/bash#!/bin/bash
# Git script to push all files (tracked and untracked) to GitHub.

set -e

REPO_DIR="$(dirname "$0")"
cd "$REPO_DIR"

# Show current status before pushing
echo "📂 Current git status:"
git status

# Ask for confirmation before pushing
read -p "Are you sure you want to stage and push ALL changes (including untracked files)? [y/N]: " CONFIRM
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
    echo "❌ Push cancelled."
    exit 1
fi

# Stage all changes, including untracked files
git add -A

# Commit with default message or use argument as commit message
if [ -z "$1" ]; then
    COMMIT_MSG="Update all project files"
else
    COMMIT_MSG="$1"
fi

# Commit changes (if any)
if git diff --cached --quiet; then
    echo "⚠️ Nothing to commit."
else
    git commit -m "$COMMIT_MSG"
fi

# Push to origin main
git push origin main

echo "✅ All project files pushed to GitHub repository."


