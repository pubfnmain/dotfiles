#!/usr/bin/env bash
# Link dotfiles into $HOME. Idempotent; never clobbers a real file or directory.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# "<path in repo>:<path relative to $HOME>"
LINKS=(
  "nvim:.config/nvim"
  "tmux:.config/tmux"
  "fish/config.fish:.config/fish/config.fish"
  "pi/settings.json:.pi/agent/settings.json"
  "pi/AGENTS.md:.pi/agent/AGENTS.md"
  "pi/extensions:.pi/agent/extensions"
  "pi/npm/package.json:.pi/agent/npm/package.json"
  "pi/npm/package-lock.json:.pi/agent/npm/package-lock.json"
)

for entry in "${LINKS[@]}"; do
  src="$DOTFILES/${entry%%:*}"
  dst="$HOME/${entry#*:}"
  [ -e "$src" ] || { echo "SKIP    $dst (missing $src)"; continue; }
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok      $dst"
  elif [ -L "$dst" ]; then
    ln -sfn "$src" "$dst"
    echo "relinked $dst"
  elif [ -e "$dst" ]; then
    echo "SKIP    $dst (real file/dir exists)"
  else
    ln -s "$src" "$dst"
    echo "linked  $dst"
  fi
done
