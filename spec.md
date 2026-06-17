# Technical Specification — Isolated Ubuntu Sandbox for AI Agents

## 1. Overview

Provide an automated mechanism that, through a single terminal command, spins up
an on-demand secondary execution environment isolated from the host operating
system. The environment confines the activity of an AI agent (e.g. Claude Code)
so that its configuration files and working directories remain accessible,
editable, and manageable directly from the host's file manager and code editors.

## 2. Functional Requirements

### RF-1 — External mapping of the user home (`$HOME`)

**Need.** View, back up, and modify the sandbox's internal configuration —
including the AI agent's credentials and state — directly from the host's GUI and
tools.

**Behavior.** The user's home directory inside the sandbox is redirected to and
physically stored in a designated folder on the host. Any file the system or the
AI agent writes to its home is immediately visible and editable on the host.

### RF-2 — Contextual activation and project mounting

**Need.** Start the environment from any project folder in the host terminal with
a single command.

**Behavior.** The mechanism detects the current path, ensures the sandbox is
running, and opens a shell positioned in the equivalent folder inside the sandbox.
Source-file changes synchronize bidirectionally and instantly.

### RF-3 — Strict isolation of identity and preferences

**Need.** Prevent the sandbox's credentials, access tokens, and AI-agent history
from interfering or mixing with the user's global host configuration.

**Behavior.** By redirecting the sandbox home to a dedicated external folder, the
AI agent's session storage is strictly encapsulated within that path, guaranteeing
a unique, independent profile exclusive to this sandbox.

### RF-4 — Automatic network and service forwarding

**Need.** Test AI-built applications in real time and attach external debugging
tools without manual network configuration.

**Behavior.** The sandbox network stack is bound to the host. When the AI agent
starts a development server or an internal port, the user can reach it directly via
the host's `localhost`.

## 3. Non-Functional Requirements

### RNF-1 — Automated provisioning

On first run, the environment automatically installs all OS dependencies, language
runtimes, and global tools required for the AI agent to operate immediately, with
no manual intervention.

### RNF-2 — Resource and hardware efficiency

The virtualization/isolation layer integrates tightly with the host hardware
architecture, ensuring minimal power and CPU consumption and fast file
read/write throughput for analyzing dense codebases.

### RNF-3 — Clean exit flow

The environment integrates with the standard terminal workflow. When finished, the
user exits with a native termination command, returning cleanly to the host
terminal.

## 4. Reference Implementation

This repository implements the specification on Apple Silicon using
[OrbStack](https://orbstack.dev) as the virtualization layer and a thin `ubuntu`
launcher command. See [README.md](README.md) for the design rationale and usage.
