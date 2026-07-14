# Inish

Inish is a toolkit for developing and managing linux web servers.

The following is the context for `pithy`, our main library dependency. We use the same style and guidelines throughout this project.
@deps/pithy/AGENTS.md

## Build Commands
* `just check`: Run isort, lint, typecheck, and tests.
* `just isort`: Sort imports.
* `just lint`: Run pyflakes linter.
* `just typecheck`: Run mypy type checker.
* `just test`: Run all tests.
* `python3 -m utest inish/path/to/test.ut.py`: Run specific test file.

## Development Flow
- Always run `just check` before declaring done or committing.
- Verify file changes with `git status` and `git diff`.
- New modules should follow existing patterns in similar files.

## Code Style
Same as pithy.

## Unit Tests
Same as pithy.


# Local Dependencies

Locally developed dependency repos are symlinked into `deps/`, which is gitignored.
`sh/deps.sh` sets the symlink for one repo; `just deps` sets all of them to the same branch, defaulting to `main`.

# Pithy

Pithy is a python utility library that we rely on heavily. The pithy repository contains several python source trees,
including the `pithy` package as well as `utest` (unit testing library) `tolkien` (token data type) and others.
The source code for those packages should be accessible from this repo root via:
* `deps/pithy/pithy_/pithy`
* `deps/pithy/iotest_/iotest`
* `deps/pithy/utest_/utest`
* `deps/pithy/tolkien_/tolkien`

## Pithy Guidelines
The following is the agents prompt for `pithy`. We use the same style and guidelines throughout this project.
@deps/pithy/AGENTS.md
