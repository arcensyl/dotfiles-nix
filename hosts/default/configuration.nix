{ config, pkgs, inputs, vars, ... }:

{
  # My 'core' module provides everything a minimal system needs.
  # Disabling this will likely break your system.
  core = {
	enable = true;
	timeZone = "UTC";
  };

  # My 'theming' module provides visual customization through Stylix.
  # On non-server machines, you will likely want to enable this.
  theming.enable = false;

  # The 'audio' driver provides support for audio playback and recording.
  # On non-server machines, you will likely want to enable this.
  drivers.audio.enable = false;

  # The 'commands' suite provides various useful CLI tools.
  # These tools fill relatively common niches, so they are helpful on most systems.
  suites.commands.enable = true;

  # NeoVim is my preferred default editor for minimal systems.
  # As per NixOS defaults, the 'nano' editor is also available.
  apps.editors.nvim.enable = true;

  # The 'git' suite provides Git along with other related tools.
  # This is enabled to aid in working with my dotfiles repository.
  suites.git.enable = true;
}
