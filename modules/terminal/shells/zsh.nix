{ lib, config, pkgs, vars, ... }:

let
  cfg = config.terminal.shells.zsh;
in {
  options.terminal.shells.zsh  = {
    enable =
      lib.mkEnableOption "ZSH, a POSIX-compatible shell";

    default = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Determines if ZSH should be the default log-in shell.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh.enable = true;

    # To solve a bug slowing down ZSH, we need to disable completions from the system side.
    programs.zsh.enableCompletion = false;
    
    environment.pathsToLink = [ "/share/zsh" ];

    users.users."${vars.master.name}".shell = lib.mkIf cfg.default pkgs.zsh;
    
    home-manager.users."${vars.master.name}" = {
      programs.zsh = {
        enable = true;
        dotDir = ".config/zsh";

        history.path = "${vars.master.homeDir}/.local/share/zsh/history";
      };

      programs.zsh.antidote = {
        enable = true;

        plugins = [
          #"zsh-users/zsh-syntax-highlighting"
          "zdharma-continuum/fast-syntax-highlighting kind:defer"
          "zsh-users/zsh-autosuggestions kind:defer"
        ];
      };
    };
  };
}
