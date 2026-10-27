# Function to source a plugin with error handling
source_plugin() {
    # Check if the file is readable
    if [[ -r "$1" ]]; then
        # If the file is readable, source it
        source "$1"
    else
        # If the file is not found, output an error message
        echo "Error: Unable to locate the script: $1"
    fi
}

# Sourcing plugins
#source_plugin /usr/share/zsh/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh  # Source the zsh-autocomplete plugin
source_plugin ~/.steavengameryt  # Attempt to source a file that seems to be missing its extension or path

# Starship prompt configuration based on Linux distribution
if [ -e /etc/os-release ]; then
    # If /etc/os-release exists, use awk to parse the distribution ID
    linux_distro=$(awk -F= '/^ID=/{gsub(/"/, "", $2); print tolower($2)}' /etc/os-release)
else
    # If /etc/os-release does not exist, use lsb_release as a fallback
    linux_distro=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
fi

# Set the Starship configuration file based on the detected Linux distribution
case $linux_distro in
  arch)
    export STARSHIP_CONFIG=~/.config/starship/starship-arch.toml  # Arch Linux configuration
    ;;
  fedora)
    export STARSHIP_CONFIG=~/.config/starship/starship-fedora.toml  # Fedora configuration
    ;;
  debian)
    export STARSHIP_CONFIG=~/.config/starship/starship-debian.toml  # Debian configuration
    ;;
  ubuntu)
    export STARSHIP_CONFIG=~/.config/starship/starship-ubuntu.toml  # Ubuntu configuration
    ;;
  opensuse-tumbleweed)
    export STARSHIP_CONFIG=~/.config/starship/starship-opensuse.toml  # OpenSUSE Tumbleweed configuration
    ;;
  *)
    export STARSHIP_CONFIG=~/.config/starship/starship.toml  # Default configuration for other distributions
    ;;
esac

# Validate Starship configuration readability before initialization
if ! [[ -r "$STARSHIP_CONFIG" ]]; then
    # If the configuration file is not readable, output an error message
    echo "Error: Unable to read the configuration file $STARSHIP_CONFIG!"
fi
eval "$(starship init zsh)"  # Initialize Starship prompt

# History configuration
HISTFILE=~/.zhistory  # Set the history file location
HISTSIZE=SAVEHIST=10000  # Set the history size and save history size
setopt sharehistory  # Share history across all sessions
setopt extendedhistory  # Record timestamp of command in history file

# Disable nomatch option
unsetopt nomatch  # If a pattern does not match any files, treat it as a normal string

# Home directory cleanup
autoload -U compinit  # Load the complete initialization function
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"  # Initialize completion using cache file
eval "$(atuin init zsh)"  # Initialize Atuin for enhanced shell history
eval "$(zoxide init zsh)"  # Initialize zoxide for quick directory navigation
colorscript -r  # Run a random color script for terminal aesthetics

# Check for fastfetch in the two locations
if [ -f "/usr/bin/fastfetch" ]; then
  FASTFETCH_BIN="/usr/bin/fastfetch"
elif [ -f "/home/linuxbrew/.linuxbrew/bin/fastfetch" ]; then
  FASTFETCH_BIN="/home/linuxbrew/.linuxbrew/bin/fastfetch"
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
