alias rb := rebuild
alias up := update
alias gc := clean

# List all available recipes.
@default:
    just --list

# Build this configuration, and then switch this machine to the new generation.
@rebuild:
    @# Rebuilding system...
    nh os switch -- --impure
    
    @# Rebuild complete!

# Back up and then update the configuration flake's lock file.
@update:
    @# Backing up lock file...
    cp flake.lock flake.lock.old
    
    @# Updating lock file...
    nix flake update
    
    @# Lock file updated!
    @# Rebuild this system to perform the upgrade.

# Clean this system by calling Nix's garbage collector; the last five generations will be kept.
@clean:
    @# Calling garbage collector...
    nh clean all --keep 5
    
    @# System cleaned!
