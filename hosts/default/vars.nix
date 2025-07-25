{ inputs, props }:

let
  pkgs = inputs.nixpkgs.legacyPackages.${props.system.platform};
in rec {
  master = {
    name = "master";
    fullName = "Master";
    email = "master@example.com";

    homeDir = "/home/${master.name}";
    dotDir = "${master.homeDir}/.dotfiles";
    flakeDir = "path:${master.dotDir}/nix";
  };

  theme = {
    wallpaper = ../../gen/temp_wallpaper.png;
    polarity = "dark";
    colorScheme = "${pkgs.base16-schemes}/share/themes/chalk.yaml";
  };

  cursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 20;
  };

  fonts = {
    serif = {
      package = pkgs.libre-baskerville;
      name = "Libre Baskerville";
    };

    sansSerif = {
      package = pkgs.inter;
      name = "Inter";
    };

    monospace = {
      package = pkgs.nerd-fonts.fira-mono;
      name = "FiraMono Nerd Font Mono";
    };

    emoji = {
      package = pkgs.noto-fonts-color-emoji;
      name = "Noto Color Emoji";
    };

    extras = [ pkgs.noto-fonts-cjk ];
  };
}
