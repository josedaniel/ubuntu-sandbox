#!/usr/bin/env bash
#
# Installer: links the `ubuntu` command into your PATH and checks OrbStack.
# No sudo required if ~/.local/bin is on your PATH.
#
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${BIN_DIR:-$HOME/.local/bin}"

if ! command -v orb >/dev/null 2>&1; then
  echo "OrbStack not detected. Install it first:"
  echo "    brew install --cask orbstack"
  echo "(linking the command anyway)"
fi

mkdir -p "$TARGET_DIR"
ln -sf "$REPO_DIR/bin/ubuntu" "$TARGET_DIR/ubuntu"
chmod +x "$REPO_DIR/bin/ubuntu" "$REPO_DIR/provision/setup.sh"

# Seed a personal config.sh from the example if missing.
if [ ! -f "$REPO_DIR/config.sh" ]; then
  cp "$REPO_DIR/config.example.sh" "$REPO_DIR/config.sh"
  echo "Created config.sh — edit it to set UBUNTU_SANDBOX_HOME (the Mac folder for the home)."
fi

echo "Linked:  $TARGET_DIR/ubuntu -> $REPO_DIR/bin/ubuntu"
case ":$PATH:" in
  *":$TARGET_DIR:"*) echo "PATH OK. You can now run:  ubuntu" ;;
  *) echo "Add this to your ~/.zshrc:"; echo "    export PATH=\"$TARGET_DIR:\$PATH\"" ;;
esac
