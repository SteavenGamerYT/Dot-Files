if status is-interactive
    # Commands to run in interactive sessions can go here.
### ADDING TO THE PATH
# First line removes the path; second line sets it.  Without the first line,
# your path gets massive and fish becomes very slow.
set -e fish_user_paths
set -U fish_user_paths $HOME/.bin  $HOME/.local/bin $HOME/Applications /var/lib/flatpak/exports/bin/ $fish_user_paths
    eval "$(starship init fish)"
end