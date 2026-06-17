#!/usr/bin/env bash
#
# Sandbox provisioning. Runs ONCE, as root, on the machine's first boot.
# Idempotent: if it already ran, it exits without doing anything.
#
# Receives via env (set by bin/ubuntu):
#   SANDBOX_HOME   Mac folder where the Linux HOME must live
#   SANDBOX_USER   Linux user to point at that HOME
#
# Edit this file to add whatever tools your AI agent needs, then run
# `ubuntu --rebuild` to rebuild from scratch.
#
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

SENTINEL=/var/lib/ubuntu-sandbox-provisioned
if [ -f "$SENTINEL" ]; then
  echo "Already provisioned; nothing to do."
  exit 0
fi

# --- Redirect HOME to the chosen Mac folder ---------------------------------
# OrbStack exposes the Mac filesystem inside Linux at the same path, so a
# folder created on the Mac at SANDBOX_HOME is reachable here at that path.
if [ -n "${SANDBOX_HOME:-}" ] && [ -n "${SANDBOX_USER:-}" ]; then
  echo ">> Pointing HOME of '$SANDBOX_USER' at $SANDBOX_HOME …"
  mkdir -p "$SANDBOX_HOME"
  usermod -d "$SANDBOX_HOME" "$SANDBOX_USER"
fi

echo ">> Updating package indexes…"
apt-get update -y

echo ">> Installing base system utilities…"
apt-get install -y --no-install-recommends \
  ca-certificates curl git build-essential ripgrep fd-find unzip jq

echo ">> Installing Node.js LTS (required by Claude Code)…"
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt-get install -y nodejs

echo ">> Installing Claude Code…"
npm install -g @anthropic-ai/claude-code

# --- add your own tools here (python, uv, pnpm, etc.) -----------------------
# apt-get install -y python3 python3-pip
# curl -LsSf https://astral.sh/uv/install.sh | sh

apt-get clean
rm -rf /var/lib/apt/lists/*
touch "$SENTINEL"
echo ">> Provisioning complete."
