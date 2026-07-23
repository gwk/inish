
# List all recipes; the default.
list-recipes:
  @just --list --unsorted

# Development.

agent-perms:
  agent-allow-r .git .gitignore .vscode .zed _build agent.md claude.md justfile mypy.ini pyproject.toml readme.md
  agent-allow-rw common doc inish_ linux mac
  agent-deny _misc

# Check the codebase.
check: isort lint typecheck test

# Set all local dependency symlinks to worktrees of the given branch.
deps branch='main':
  sh/deps.sh pithy {{branch}}

# Set local dependency symlinks, then sync the venv.
develop: deps
  uv sync

# Sort python imports.
isort:
  uv run isort inish_/inish

link-claude-md:
  find . -name 'AGENTS.md' -print0 | xargs -0 -I {} sh -c 'ln -sf "$(basename {})" "$(dirname {})/CLAUDE.md"'

# Lint python code.
lint:
  uv run pyflakes inish_/inish

# Run all tests.
test:
  uv run python3 -m utest inish_/inish

# Typecheck the project.
typecheck:
  uv run mypy inish_/inish

# Clear the typechecker cache.
typecheck-clear-cache:
  rm -rf _build/mypy_cache


# Packaging.

build:
  cd inish_ && flit build
