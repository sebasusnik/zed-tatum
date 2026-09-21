#!/usr/bin/env bash
#
# Pull the queries over from the grammar repo and pin extension.toml to its
# current commit. Zed caches a grammar build per revision, so forgetting the
# pin is what makes a grammar change look like it did nothing.
set -euo pipefail

GRAMMAR_DIR="${1:-$(cd "$(dirname "$0")/../tree-sitter-tatum" && pwd)}"
HERE="$(cd "$(dirname "$0")" && pwd)"

if [[ ! -d "$GRAMMAR_DIR/.git" ]]; then
    echo "not a git repo: $GRAMMAR_DIR" >&2
    exit 1
fi

if [[ -n "$(git -C "$GRAMMAR_DIR" status --porcelain)" ]]; then
    echo "$GRAMMAR_DIR has uncommitted changes; commit them first so there is" >&2
    echo "a revision to pin." >&2
    exit 1
fi

REV="$(git -C "$GRAMMAR_DIR" rev-parse HEAD)"

cp "$GRAMMAR_DIR"/queries/*.scm "$HERE/languages/tatum/"
/usr/bin/sed -i '' -E "s|^rev = \".*\"|rev = \"$REV\"|" "$HERE/extension.toml"

echo "queries synced, grammar pinned at $REV"
echo "now run 'zed: reload extensions' in Zed"
