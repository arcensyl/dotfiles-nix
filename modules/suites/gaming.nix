{ lib, config, pkgs, vars, ... }:

let
  cfg = config.suites.gaming;

  packageQueue = with pkgs; [
    heroic
    bottles
    prismlauncher
	portablemc
	ferium
  ];
in {
  options.suites.gaming = {
    enable = lib.mkEnableOption "a suite of game launchers and tools";

    extraGames = lib.mkOption {
      type = with lib.types; listOf package;
      default = [];
      example = [ pkgs.superTuxKart ];
      description = "A list of standalone games to install.";
    };

    steam = {
      disable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = "Whether to disable Steam, the game storefront and launcher";
      };

      keybindCommand = lib.mkOption {
        type = lib.types.str;
        default = "steam";
        example = "steam -bigpicture";
        description = "The command used by your WM to launch Steam.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    programs.steam.enable = !cfg.steam.disable;

    hardware.xone.enable = true;

    programs.gamescope = {
      enable = true;

      args = [
        "-W 2560"
        "-H 1440"
        "-r 144"
      ];
    };

    programs.gamemode.enable = true;

    home-manager.users."${vars.master.name}" = {
      home.packages = cfg.extraGames ++ packageQueue;
      
      programs.mangohud.enable = true;

      wayland.windowManager.hyprland.settings = lib.mkIf config.de.hypr.enable {
        bind = [ "CTRL ALT, S, exec, ${cfg.steam.keybindCommand}" ];
      };
    };
  };
}
