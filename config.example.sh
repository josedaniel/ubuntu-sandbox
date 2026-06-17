# Copy this file to `config.sh` and edit. `config.sh` is gitignored, so your
# personal paths stay out of the shared repo.
#
#   cp config.example.sh config.sh

# Machine name in OrbStack.
UBUNTU_SANDBOX_MACHINE=devbox

# Ubuntu version. e.g. ubuntu:noble (24.04 LTS), ubuntu:jammy (22.04).
UBUNTU_SANDBOX_DISTRO=ubuntu:noble

# Mac folder where the Ubuntu HOME is physically stored. It will be created if
# it doesn't exist, and is fully visible/editable from Finder and your editor.
# Examples:
#   UBUNTU_SANDBOX_HOME="$HOME/UbuntuSandbox/home"
#   UBUNTU_SANDBOX_HOME="$HOME/Projects/_sandbox-home"
UBUNTU_SANDBOX_HOME="$HOME/UbuntuSandbox/home"
