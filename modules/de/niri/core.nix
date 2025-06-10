{ lib, config, pkgs, home-manager, niri, inputs, vars, ... }:

let
  cfg = config.de.niri;
in {
  options.de.niri = {
    enable =
      lib.mkEnableOption "Niri, as this machine's WM,";
  };
  
  config = lib.mkIf cfg.enable {
    de.hasEnvironment = true;

    programs.niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };

    environment.systemPackages = [
      pkgs.swaybg
    ];

    home-manager.users."${vars.master.name}" = {
      programs.niri.settings.binds = {
        "Mod+q".action.spawn = "foot";
      };

      programs.niri.settings.spawn-at-startup = [
        { command = [ "swaybg" "-i" "~/.dotfiles/nix/gen/current_wallpaper" ]; }
      ];

    };
    
    systemd.user.services.niri-flake-polkit.enable = false;
  };
}
