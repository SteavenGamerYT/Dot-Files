case $- in
    *i*) ;;
      *) return;;
esac

# Sourcing custom settings with error handling
source_custom() {
  # Check if the file is readable
  if [[ -r "$1" ]]; then
    # If the file is readable, source it
    source "$1"
  else
    # If the file is not found, output an error message
    echo "Error: Can't find the script $1"
  fi
}

# Source the default bash settings and a custom script
source_custom ~/.bash-default
source_custom ~/.steavengameryt

# History settings
HISTFILE=~/.bash-history  # Set the file where history is stored
HISTSIZE=10000            # Set the number of commands to remember in the history
SAVEHIST=10000            # Set the number of commands to save in the history file


if [ -e /etc/os-release ]; then
    linux_distro=$(awk -F= '/^ID=/{gsub(/"/, "", $2); print tolower($2)}' /etc/os-release)
else
    # fallback to your previous method if /etc/os-release is not available
    linux_distro=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
fi

#case $linux_distro in
#  arch)
#    export STARSHIP_CONFIG=~/.config/starship/starship-arch.toml
#    ;;
#  fedora)
#    export STARSHIP_CONFIG=~/.config/starship/starship-fedora.toml
#    ;;
#  debian)
#    export STARSHIP_CONFIG=~/.config/starship/starship-debian.toml
#    ;;
#  ubuntu)
#    export STARSHIP_CONFIG=~/.config/starship/starship-ubuntu.toml
#    ;;
#  opensuse-tumbleweed)
#    export STARSHIP_CONFIG=~/.config/starship/starship-opensuse.toml
#    ;;
#  *)
#    export STARSHIP_CONFIG=~/.config/starship/starship.toml
#    ;;
#esac
export STARSHIP_CONFIG=~/.config/starship/starship.toml

# Check if Starship configuration is readable before initializing
if [[ -r "$STARSHIP_CONFIG" ]]; then
    eval "$(starship init bash)"
else
    echo "Error: The configuration file $STARSHIP_CONFIG is not readable!"
fi

# Additional utilities initialization
eval "$(zoxide init bash)"  # Initialize zoxide for smarter directory navigation
colorscript -r  # Run a random color script for terminal aesthetics

# Check for fastfetch in multiple locations
if [ -f "/usr/bin/fastfetch" ]; then
  FASTFETCH_BIN="/usr/bin/fastfetch"
elif [ -f "/home/linuxbrew/.linuxbrew/bin/fastfetch" ]; then
  FASTFETCH_BIN="/home/linuxbrew/.linuxbrew/bin/fastfetch"
elif [ -f "/run/current-system/sw/bin/fastfetch" ]; then
  FASTFETCH_BIN="/run/current-system/sw/bin/fastfetch"
else
  echo 'fastfetch not found'
  return  # Exit if fastfetch is not found
fi


# Terminal-specific commands
case "$TERM" in
  "xterm-kitty")
    $FASTFETCH_BIN --config ~/.config/fastfetch/config-kitty.jsonc
    ;;
  "xterm-256color")
    $FASTFETCH_BIN --config ~/.config/fastfetch/config.jsonc
    ;;
  *)
    echo "Unsupported terminal: $TERM"
    ;;
esac


# Try to source bash-preexec from common locations
bash_preexec_loaded=false

if [[ -f /usr/share/bash-preexec/bash-preexec.sh ]]; then
  source /usr/share/bash-preexec/bash-preexec.sh && bash_preexec_loaded=true
elif [[ -f /home/linuxbrew/.linuxbrew/etc/profile.d/bash-preexec.sh ]]; then
  source /home/linuxbrew/.linuxbrew/etc/profile.d/bash-preexec.sh && bash_preexec_loaded=true
else
#  nix build nixpkgs#bash-preexec
  bash_preexec_pkg=$(nix eval --offline --raw nixpkgs#bash-preexec 2>/dev/null)
  if [[ -f "$bash_preexec_pkg/share/bash/bash-preexec.sh" ]]; then
    source "$bash_preexec_pkg/share/bash/bash-preexec.sh" && bash_preexec_loaded=true
  fi
fi

# Check if bash-preexec was successfully loaded
if [[ "$bash_preexec_loaded" = true ]]; then
  eval "$(atuin init bash)"
else
  echo "Error: bash-preexec could not be found or sourced." >&2
fi