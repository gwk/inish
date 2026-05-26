# Inish

Inish is a toolkit for developing and managing linux web servers.

The following is the context for `pithy`, our main library dependency. We use the same style and guidelines throughout this project.
@../pithy/main/AGENTS.md

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


# Pithy

Pithy is a python utility library that we rely on heavily. The pithy repository contains several python source trees,
including the `pithy` package as well as `utest` (unit testing library) `tolkien` (token data type) and others.
The source code for those packages should be accessible from this repo root via:
* `../pithy/main/pithy_/pithy`
* `../pithy/main/iotest_/iotest`
* `../pithy/main/utest_/utest`
* `../ptihy/main/tolkien_/tolkien`

## Pithy Guidelines
The following is the agents prompt for `pithy`. We use the same style and guidelines throughout this project.
@../pithy/main/AGENTS.md
