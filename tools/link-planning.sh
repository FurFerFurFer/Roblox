#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLANNING_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
TARGET_DIR="${1:-$PWD}"
LINK_NAME="${2:-_brain_brawl_planning}"
LINK_PATH="$TARGET_DIR/$LINK_NAME"

if [ ! -d "$TARGET_DIR" ]; then
	printf 'Target directory does not exist: %s\n' "$TARGET_DIR" >&2
	exit 1
fi

if [ -L "$LINK_PATH" ]; then
	EXISTING_TARGET="$(readlink "$LINK_PATH")"
	if [ "$EXISTING_TARGET" = "$PLANNING_DIR" ]; then
		printf 'Planning bridge already exists: %s -> %s\n' "$LINK_PATH" "$PLANNING_DIR"
	else
		printf 'A different symlink already exists at %s -> %s\n' "$LINK_PATH" "$EXISTING_TARGET" >&2
		exit 1
	fi
elif [ -e "$LINK_PATH" ]; then
	printf 'Cannot create planning bridge because this path already exists: %s\n' "$LINK_PATH" >&2
	exit 1
else
	ln -s "$PLANNING_DIR" "$LINK_PATH"
	printf 'Created planning bridge: %s -> %s\n' "$LINK_PATH" "$PLANNING_DIR"
fi

GIT_EXCLUDE="$TARGET_DIR/.git/info/exclude"
if [ -f "$GIT_EXCLUDE" ]; then
	if ! grep -qxF "$LINK_NAME/" "$GIT_EXCLUDE"; then
		printf '\n%s/\n' "$LINK_NAME" >> "$GIT_EXCLUDE"
		printf 'Added %s/ to %s\n' "$LINK_NAME" "$GIT_EXCLUDE"
	fi
fi

printf '\nAgent path to use from the target project:\n'
printf '  %s/AGENTS.md\n' "$LINK_NAME"
printf '  %s/README.md\n' "$LINK_NAME"
printf '  %s/bro.md\n' "$LINK_NAME"
printf '  %s/To-Do.md\n' "$LINK_NAME"
printf '  %s/bro.luau\n' "$LINK_NAME"
