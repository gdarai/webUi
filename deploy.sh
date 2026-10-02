#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIST_DIR="$SCRIPT_DIR/dist"
TARGET_REPO_DIR="$SCRIPT_DIR/../gdarai.github.io"
TARGET_WEBUI_DIR="$TARGET_REPO_DIR"

echo "Building project..."
npm run build

if [[ ! -d "$SOURCE_DIST_DIR" ]]; then
  echo "Error: dist folder not found at $SOURCE_DIST_DIR"
  exit 1
fi

if [[ ! -d "$TARGET_REPO_DIR/.git" ]]; then
  echo "Error: target repository not found at $TARGET_REPO_DIR"
  exit 1
fi

echo "Copying dist content to $TARGET_WEBUI_DIR..."
mkdir -p "$TARGET_WEBUI_DIR"
TARGET_ASSETS_DIR="$TARGET_WEBUI_DIR/assets"
if [[ -d "$TARGET_ASSETS_DIR" ]]; then
  echo "Cleaning existing assets folder at $TARGET_ASSETS_DIR..."
  rm -rf "$TARGET_ASSETS_DIR"
fi
cp -a "$SOURCE_DIST_DIR"/. "$TARGET_WEBUI_DIR"/

cd "$TARGET_REPO_DIR"

echo "Staging and committing deployment..."
git add -A
git commit -a -m "deployment"

open_terminal() {
  local cmd="$1"
  if command -v "${cmd%% *}" >/dev/null 2>&1; then
    eval "$cmd"
    return 0
  fi
  return 1
}

echo "Opening a separate terminal for manual git push..."
if open_terminal "gnome-terminal --working-directory=\"$TARGET_REPO_DIR\" -- bash -lc 'echo Ready for manual push.; exec bash'"; then
  :
elif open_terminal "konsole --workdir \"$TARGET_REPO_DIR\" -e bash -lc 'echo Ready for manual push.; exec bash'"; then
  :
elif open_terminal "xfce4-terminal --working-directory=\"$TARGET_REPO_DIR\" -e 'bash -lc \"echo Ready for manual push.; exec bash\"'"; then
  :
elif open_terminal "x-terminal-emulator -e bash -lc 'cd \"$TARGET_REPO_DIR\"; echo Ready for manual push.; exec bash'"; then
  :
elif open_terminal "xterm -e bash -lc 'cd \"$TARGET_REPO_DIR\"; echo Ready for manual push.; exec bash'"; then
  :
elif open_terminal "alacritty --working-directory \"$TARGET_REPO_DIR\" -e bash -lc 'echo Ready for manual push.; exec bash'"; then
  :
elif open_terminal "kitty --directory \"$TARGET_REPO_DIR\" bash -lc 'echo Ready for manual push.; exec bash'"; then
  :
elif open_terminal "wezterm start --cwd \"$TARGET_REPO_DIR\" -- bash -lc 'echo Ready for manual push.; exec bash'"; then
  :
else
  echo "Could not open a terminal automatically."
  echo "Run the following command manually:"
  echo "cd \"$TARGET_REPO_DIR\" && git push"
fi
