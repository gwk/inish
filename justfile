
# List all recipes; the default.
list-recipes:
  @just --list --unsorted

# Development.

agent-perms:
  agent-allow-r .git .gitignore .vscode .zed _build agent.md claude.md justfile mypy.ini pyproject.toml readme.md
  agent-allow-rw common doc inish linux mac
  agent-deny _misc

# Check the codebase.
check: isort lint typecheck test

# Sort python imports.
isort:
  isort inish

link-claude-md:
  find . -name 'AGENTS.md' -print0 | xargs -0 -I {} sh -c 'ln -sf "$(basename {})" "$(dirname {})/CLAUDE.md"'

# Lint python code.
lint:
  pyflakes inish

# Run all tests.
test:
  python3 -m utest inish

# Typecheck the project.
typecheck:
  mypy inish

# Clear the typechecker cache.
typecheck-clear-cache:
  rm -rf _build/mypy_cache
