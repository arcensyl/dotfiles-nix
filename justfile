alias up := update
alias chw := change-wallpaper

# List all available recipes.
@default:
    just --list

# Back up and then update the configuration flake's lock file.
@update:
    @# Backing up lock file...
    cp flake.lock flake.lock.old
    
    @# Updating lock file...
    nix flake update
    
    @# Lock file updated!
    @# Rebuild this system to perform the upgrade.

# Change this system's wallpaper to PATH.
[no-cd]
@change-wallpaper path:
    @# Linking wallpaper...
    ln -sf "{{absolute_path(canonicalize(path))}}" ~/.dotfiles/nix/gen/current_wallpaper
    
    @# Reloading wallpaper...
    hyprctl hyprpaper reload ,~/.dotfiles/nix/gen/current_wallpaper
    
    @# Wallpaper changed!
