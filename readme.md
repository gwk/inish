# Inish

Inish is a set of tools for setting up computers. It currently focuses on macOS developer machines and Fedora Linux servers.

This project is a work in progress and should be considered unstable.


# Development

The `inish` package lives in `inish_/` under a virtual workspace root, following pithy's layout (see pithy's `doc/git-worktrees.md`).
This allows dependent repos to consume `deps/inish/inish_` as a workspace member of their own workspace, since uv does not support nested workspaces.

Inish depends on locally developed packages from the `pithy` repository, which are not published to PyPI.
Sibling repos use the bare-git worktree layout described in pithy's `doc/git-worktrees.md`.
`sh/deps.sh` symlinks a dependency repo worktree into `deps/`, which is gitignored; uv resolves the packages through those links via the workspace members in `pyproject.toml`.
Run `just develop` once per worktree checkout to set the symlinks and sync the `.venv`.
`just deps` re-points all symlinks at the worktrees of a given branch, defaulting to `main`.
`just check` runs isort, pyflakes, mypy, and the test suite through the venv via `uv run`.
