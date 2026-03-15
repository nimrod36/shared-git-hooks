#!/bin/bash
# Uninstall shared git hooks

TARGET_DIR="$(git rev-parse --git-dir)/hooks"

if [ -f "$TARGET_DIR/.hooks-version" ]; then
  VERSION=$(grep HOOKS_VERSION "$TARGET_DIR/.hooks-version" | cut -d= -f2)
  echo "🗑️  Removing shared git hooks (v${VERSION})..."
else
  echo "🗑️  Removing git hooks..."
fi

rm -f "$TARGET_DIR/pre-commit"
rm -f "$TARGET_DIR/pre-push"
rm -f "$TARGET_DIR/.hooks-version"

echo "✅ Git hooks uninstalled"
echo "💡 Run ../shared-git-hooks/install.sh to reinstall"
