# ubuntu-sandbox

> One command. An isolated Ubuntu, in your current folder, with its own home —
> stored on your Mac and editable from your editor.

`ubuntu-sandbox` gives you a disposable, on-demand Linux environment for running
AI coding agents (Claude Code, etc.) on Apple Silicon. Run `ubuntu` from any
project folder and you land in an Ubuntu shell at the same path, ready to work —
then `exit` back to your Mac. It's built on [OrbStack](https://orbstack.dev) with
a thin launcher on top.

## Why you'd want this

Running an AI agent directly on your Mac mixes its credentials, tokens, npm
globals, and shell history into your personal `~`. That's risky and messy: the
agent can read your real SSH keys, scribble into your dotfiles, and its login
session lives next to your own.

This project draws a clean line:

- **Isolated identity.** The agent's `$HOME` is a *separate* folder, so its
  credentials and state never touch your Mac's `~/.claude`, `~/.ssh`, or shell
  config.
- **Still fully visible.** That home lives in a Mac folder *you choose*, so you
  can open, inspect, back up, or edit everything from Finder and your editor — no
  `docker cp`, no guessing where files went.
- **Your code stays put.** Project files remain on your Mac and appear inside
  Linux at the same path. Edit in your normal editor; the agent sees changes
  instantly, and vice versa.
- **Zero network setup.** A dev server the agent starts on `:3000` is reachable at
  `localhost:3000` on your Mac, automatically.
- **Fast and cheap.** OrbStack's microVM (Apple's Virtualization.framework) boots
  in seconds and sips resources — far lighter than a traditional VM.
- **Disposable.** Broke something? `ubuntu --rebuild` and you're back to a clean,
  fully-provisioned box in a couple of minutes.

In short: the agent gets a real, throwaway Linux machine; you keep full host-side
visibility and control without the two ever bleeding into each other.

## Requirements

- Apple Silicon Mac (M-series)
- [OrbStack](https://orbstack.dev): `brew install --cask orbstack`

## Install

```bash
git clone <this-repo> ubuntu-sandbox && cd ubuntu-sandbox
./install.sh
# if install.sh asks, add ~/.local/bin to your PATH and reload your shell:
#   export PATH="$HOME/.local/bin:$PATH"
```

`install.sh` links the `ubuntu` command into `~/.local/bin` and creates a personal
`config.sh` (gitignored) you can edit.

## Configure

Edit `config.sh` to choose the machine, the Ubuntu version, and — most usefully —
**which Mac folder holds the sandbox home**:

```sh
UBUNTU_SANDBOX_MACHINE=devbox                    # OrbStack machine name
UBUNTU_SANDBOX_DISTRO=ubuntu:noble               # 24.04 LTS (or ubuntu:jammy, ...)
UBUNTU_SANDBOX_HOME="$HOME/UbuntuSandbox/home"    # the Mac folder for the home
```

Settings resolve as: environment variable › `config.sh` › built-in default.
Changing `UBUNTU_SANDBOX_HOME` after the machine exists requires a
`ubuntu --rebuild`.

## Usage

```bash
cd ~/Projects/my-project

ubuntu              # open an Ubuntu shell, already in my-project
ubuntu claude       # run Claude Code here, inside the sandbox
exit                # return to your Mac terminal (Ctrl-D also works)

ubuntu --home       # open the sandbox home in Finder
ubuntu --rebuild    # destroy + recreate the machine (re-provision from scratch)
```

The **first** `ubuntu` run creates the machine and provisions it (Node.js, Claude
Code, common CLI tools) — about 1–2 minutes. Every run after that is instant.

## How it works

OrbStack runs each Linux machine as a lightweight microVM and mirrors the Mac
filesystem inside it at identical paths. The launcher leans on three facts:

1. **Same-path mapping** means running `orb` from a Mac folder drops you into the
   equivalent folder in Linux — that's `ubuntu`'s contextual launch (RF-2).
2. **Redirecting `$HOME`** to a Mac path (`usermod -d` during provisioning) makes
   the agent's home physically live on your Mac, isolated yet visible (RF-1, RF-3).
3. **Automatic port forwarding** exposes any port the sandbox listens on at the
   Mac's `localhost` (RF-4).

| File | Role |
|------|------|
| `bin/ubuntu` | The launcher command |
| `provision/setup.sh` | First-boot provisioning (edit to add your tools) |
| `config.example.sh` | Template copied to `config.sh` on install |
| `install.sh` | Links the command, seeds config |
| `spec.md` | The original requirements this implements |

## Customize the toolchain

Add whatever your agent needs to `provision/setup.sh` (Python, `uv`, `pnpm`,
language servers, …), then rebuild:

```bash
ubuntu --rebuild
```

## A note on isolation

OrbStack exposes your whole Mac filesystem inside Linux so you can edit project
code normally. This means your Mac `~` is technically *readable* from inside the
sandbox. The guarantee here is about **writes and identity**: the agent's `$HOME`
is your dedicated folder, so it stores its credentials and state there and never
modifies your real `~/.claude`, `~/.ssh`, or dotfiles. If you need stricter
read isolation (e.g. mount only `~/Projects`), that's a small change — open an
issue or ask.

## License

MIT
