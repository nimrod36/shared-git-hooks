# Shared Git Hooks

Reusable git hooks for Ruby and Node.js projects with automatic quality enforcement.

## Features

- **Ruby Projects**: RuboCop linting (if configured), RSpec unit tests (pre-commit), Cucumber BDD tests (pre-push)
- **Node.js Projects**: ESLint/linting (if configured), unit tests (pre-commit), full test suite including BDD (pre-push)
- **Auto-detection**: Automatically detects project type based on `Gemfile` or `package.json`
- **Cucumber profile support**: Respects `cucumber.yml` profiles when available
- **Skip mechanism**: Use `SKIP_HOOKS=1` or `--no-verify` to bypass when needed
- **Version tracking**: Tracks installed hook versions for easier updates

## Installation

### Option 1: Install from Parent Directory

If `shared-git-hooks` is adjacent to your project:

```bash
# In your project directory (e.g., cajiva/, monday-band/)
../shared-git-hooks/install.sh
```

### Option 2: Install from Anywhere

```bash
# Clone once to a shared location
git clone https://github.com/YOUR_USERNAME/shared-git-hooks.git ~/shared-git-hooks

# Then in any project:
~/shared-git-hooks/install.sh
```

### Option 3: Add as Git Submodule

```bash
# In your project directory
git submodule add https://github.com/YOUR_USERNAME/shared-git-hooks.git .githooks
.githooks/install.sh

# Team members need to run:
git submodule update --init
.githooks/install.sh
```

## Usage

### Normal Workflow
```bash
git add .
git commit -m "Add feature"  # Runs pre-commit checks
git push                      # Runs pre-push checks
```

### Skip Hooks When Needed
```bash
# Skip all hooks
SKIP_HOOKS=1 git commit -m "WIP: experimenting"
SKIP_HOOKS=1 git push

# Or use git's built-in flag
git commit --no-verify -m "Emergency fix"
git push --no-verify
```

## What Gets Checked

### Ruby Projects (Pre-Commit)
- **RuboCop linting** on staged `.rb` files (only if `.rubocop.yml` or `.rubocop_todo.yml` exists)
- **RSpec unit tests** (only if `spec/` directory exists and has content)

### Ruby Projects (Pre-Push)
- **Full Cucumber BDD suite** (checks `specs/` first, then `features/`)
- **Respects cucumber.yml profiles** when present (uses `--profile default`)
- **Skips `@wip` tagged scenarios** (when no cucumber.yml)

### Node.js Projects (Pre-Commit)
- **Linter** on staged `.js`/`.jsx`/`.ts`/`.tsx` files (only if `lint` script exists)
- **Unit tests** (prefers `test:unit` script, falls back to `npm test`)

### Node.js Projects (Pre-Push)
- **Full test suite** including BDD
- **Runs `test:bdd`** if available, otherwise falls back to `npm test`

## Uninstalling

```bash
# From your project directory
../shared-git-hooks/uninstall.sh

# Or manually
rm .git/hooks/pre-commit .git/hooks/pre-push .git/hooks/.hooks-version
```

## Updating Hooks

```bash
# Pull latest changes
cd ~/shared-git-hooks  # or wherever you cloned it
git pull

# Re-install in your project
cd /path/to/your/project
~/shared-git-hooks/install.sh
```

Version tracking helps you know which version is installed:
```bash
cat .git/hooks/.hooks-version
```

## Project-Specific Behavior

The hooks intelligently adapt to your project structure:

### Ruby
- Only runs RuboCop if you have `.rubocop.yml` configured
- Only runs RSpec if you have a `spec/` directory
- Prefers `specs/` over `features/` for BDD (workspace convention)
- Respects `cucumber.yml` profiles for custom test configurations

### Node.js
- Only runs linter if `lint` script is defined in `package.json`
- Checks for both `test:unit` and `test:bdd` scripts
- Falls back gracefully if scripts are missing
- Supports `.js`, `.jsx`, `.ts`, `.tsx` file extensions

## CI/CD Integration

These hooks run the same commands as your CI pipeline:

**Ruby projects**: Matches commands in `.github/workflows/ci.yml`  
**Node projects**: Matches `package.json` test scripts  

If hooks pass locally, CI should pass too.

## Team Onboarding

Add to your project's README:

```markdown
### Developer Setup

1. Clone the repository
2. Install dependencies: `bundle install` or `npm install`
3. Install quality enforcement hooks:
   ```bash
   ../shared-git-hooks/install.sh
   ```
```

## Troubleshooting

**Hooks not running?**
- Verify they're executable: `ls -la .git/hooks/`
- Check they were copied: `cat .git/hooks/pre-commit`

**Tests failing in hooks but passing manually?**
- Hooks run from repository root
- Ensure all dependencies are installed
- Check that `cucumber.yml` profiles work

**Need to commit without running tests?**
- Emergency: `git commit --no-verify`
- Preferred: `SKIP_HOOKS=1 git commit`

## Contributing

To modify hook behavior:

1. Edit templates in `templates/ruby/` or `templates/node/`
2. Update version in `install.sh`
3. Test in a sample project
4. Commit and push
5. Re-run `install.sh` in affected projects

## Version History

- **v1.0.0**: Initial release with Ruby and Node.js support, cucumber profile support, version tracking
