#!/usr/bin/env bash
# install.sh — installs the personal SOUL into ~/.copilot/copilot-instructions.md (macOS/Linux)
# The repo-level config (.github/, .vscode/) needs no install; it works on open in VS Code.

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source_file="$script_dir/templates/soul.copilot-instructions.md"
dest_dir="$HOME/.copilot"
dest="$dest_dir/copilot-instructions.md"

if [[ ! -f "$source_file" ]]; then
  echo "Source template not found: $source_file" >&2
  exit 1
fi

mkdir -p "$dest_dir"

if [[ -f "$dest" ]]; then
  cp "$dest" "$dest.bak"
  echo "Existing personal instructions backed up to: $dest.bak"
fi

cp "$source_file" "$dest"
echo "Installed SOUL -> $dest"
echo "Done. Reload VS Code (or restart Copilot Chat) to pick it up."
