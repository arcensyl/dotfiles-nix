{ lib, config, pkgs, home-manager, vars, ... }:

let
  cfg = config.theming;
in {
  options.theming.enable =
    lib.mkEnableOption "system-wide theming powered by Stylix";

  config = lib.mkIf cfg.enable { 
    programs.dconf.enable = true;
    stylix.enable = true;

    home-manager.users."${vars.master.name}" = {
      stylix.enable = true;
      stylix.image = vars.theme.wallpaper;

      stylix.targets.hyprland.enable = false;
      stylix.targets.neovim.enable = false;
      stylix.targets.emacs.enable = false;
    };

    stylix.image = vars.theme.wallpaper;
    
    stylix.polarity = vars.theme.polarity;
    stylix.base16Scheme = lib.mkIf (vars.theme.colorScheme != null) vars.theme.colorScheme;

    stylix.cursor = {
      package = vars.cursor.package;
      name = vars.cursor.name;
      size = vars.cursor.size;
    };
    
    stylix.fonts = {
      serif = {
        package = vars.fonts.serif.package;
        name = vars.fonts.serif.name;
      };

      sansSerif = {
        package = vars.fonts.sansSerif.package;
        name = vars.fonts.sansSerif.name;
      };

      monospace = {
        package = vars.fonts.monospace.package;
        name = vars.fonts.monospace.name;
      };

      emoji = {
        package = vars.fonts.emoji.package;
        name = vars.fonts.emoji.name;
      };
    };

    environment.systemPackages = vars.fonts.extras;
  };
}
