alias up := update

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
