#!/bin/bash
set -e

HOOKS_VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$(git rev-parse --git-dir)/hooks"

# Function to install hooks for a specific template
install_hooks() {
  local template=$1
  echo "📦 Installing $template hooks..."
  
  if [ ! -d "$SCRIPT_DIR/templates/$template" ]; then
    echo "❌ Template '$template' not found in $SCRIPT_DIR/templates/"
    echo "Available templates:"
    ls -1 "$SCRIPT_DIR/templates/"
    exit 1
  fi
  
  cp "$SCRIPT_DIR/templates/$template/pre-commit" "$TARGET_DIR/pre-commit"
  cp "$SCRIPT_DIR/templates/$template/pre-push" "$TARGET_DIR/pre-push"
  chmod +x "$TARGET_DIR/pre-commit" "$TARGET_DIR/pre-push"
  
  # Write version file for tracking
  echo "HOOKS_VERSION=${HOOKS_VERSION}" > "$TARGET_DIR/.hooks-version"
  echo "HOOKS_TEMPLATE=${template}" >> "$TARGET_DIR/.hooks-version"
  
  echo "✅ ${template} hooks installed (v${HOOKS_VERSION})"
  echo "💡 Use SKIP_HOOKS=1 or --no-verify to bypass during commits/pushes"
}

# Function to prompt user for template selection
select_template() {
  echo "🔍 Available hook templates:"
  templates=($(ls -1 "$SCRIPT_DIR/templates/"))
  
  for i in "${!templates[@]}"; do
    echo "  $((i+1)). ${templates[$i]}"
  done
  
  echo ""
  read -p "Select a template (1-${#templates[@]}): " choice
  
  if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#templates[@]}" ]; then
    selected_template="${templates[$((choice-1))]}"
    echo ""
    install_hooks "$selected_template"
  else
    echo "❌ Invalid selection"
    exit 1
  fi
}

echo "🔧 Installing shared git hooks (v${HOOKS_VERSION})..."

# Check if template was provided as argument
if [ -n "$1" ]; then
  install_hooks "$1"
  
# Auto-detect project type
elif [ -f "Gemfile" ]; then
  echo "📦 Detected Ruby project (found Gemfile)"
  install_hooks "ruby"
  
elif [ -f "package.json" ]; then
  echo "📦 Detected Node.js project (found package.json)"
  install_hooks "node"
  
# No detection possible - prompt user
else
  echo "⚠️  Could not auto-detect project type (no Gemfile or package.json found)"
  echo ""
  select_template
fi

echo "🎉 Done! Hooks are now active."