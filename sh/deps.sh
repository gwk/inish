#!/usr/bin/env bash
# Dedicated to the public domain under CC0: https://creativecommons.org/publicdomain/zero/1.0/.

# Set the symlink for one locally developed dependency repo: deps/${repo} -> ../../${repo}/${branch}.
# deps/ is gitignored; uv resolves packages inside the linked worktrees via the workspace members in pyproject.toml.
# Usage: sh/deps.sh ${repo} ${branch}. `just deps` sets all dependency symlinks to the same branch.

set -euo pipefail

fail() { echo "error: $*" 1>&2; exit 1; }

[[ $# -eq 2 ]] || fail 'usage: sh/deps.sh ${repo} ${branch}'
repo="$1"
branch="$2"

case "$repo" in
  pithy) ;;
  *) fail "unknown dependency repo '$repo'; expected 'pithy'."
esac

repo_root="$(cd "$(dirname "$0")/.." && pwd -P)"
work_root="$(dirname "$(dirname "$repo_root")")"
target="$work_root/$repo/$branch"
[[ -d "$target" ]] || fail "$repo has no worktree for branch '$branch': $target"
[[ -e "$target/.git" ]] || fail "not a git worktree: $target"

mkdir -p "$repo_root/deps"
ln -sfn "$target" "$repo_root/deps/$repo"
echo "deps/$repo -> $target"
