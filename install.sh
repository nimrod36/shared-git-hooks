#!/bin/bash
set -e

HOOKS_VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$(git rev-parse --git-dir)/hooks"

echo "🔧 Installing shared git hooks (v${HOOKS_VERSION})..."

# Detect project type and install appropriate hooks
if [ -f "Gemfile" ]; then
  echo "📦 Detected Ruby project"
  cp "$SCRIPT_DIR/templates/ruby/pre-commit" "$TARGET_DIR/pre-commit"
  cp "$SCRIPT_DIR/templates/ruby/pre-push" "$TARGET_DIR/pre-push"
  echo "✅ Ruby hooks installed"
  
elif [ -f "package.json" ]; then
  echo "📦 Detected Node.js project"
  cp "$SCRIPT_DIR/templates/node/pre-commit" "$TARGET_DIR/pre-commit"
  cp "$SCRIPT_DIR/templates/node/pre-push" "$TARGET_DIR/pre-push"
  echo "✅ Node.js hooks installed"
  
else
  echo "⚠️  Could not detect project type (no Gemfile or package.json)"
  echo "Please specify: ./install.sh ruby|node"
  exit 1
fi

chmod +x "$TARGET_DIR/pre-commit" "$TARGET_DIR/pre-push"

# Write version file for tracking
echo "HOOKS_VERSION=${HOOKS_VERSION}" > "$TARGET_DIR/.hooks-version"

echo "🎉 Done! Hooks v${HOOKS_VERSION} are active."
echo "💡 Use SKIP_HOOKS=1 or --no-verify to bypass during commits/pushes"