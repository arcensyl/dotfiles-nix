{ lib, config, pkgs, inputs, vars, ... }:

let
  cfg = config.suites.nix;
in {
  options.suites.nix = {
    enable =
      lib.mkEnableOption "various Nix-related tools and enhancements";

    configFlake = lib.mkOption {
      type = lib.types.str;
      default = "/etc/nixos";
      description = "The URI of your configuration's primary flake.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.sessionVariables = {
      NH_FLAKE = cfg.configFlake;
    };

    environment.systemPackages = with pkgs; [
      nh # A helper for various Nix commands.
      nvd # Diffs two instances of the Nix store; useful for comparing system configurations.
      nixd # A language server for Nix.
    ];

    # Nix-LD - Useful tool to allow launching unpatched binaries on NixOS.
    programs.nix-ld.enable = true;

    # Required for the Nix's LSP to behave properly.
    nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    home-manager.users."${vars.master.name}" = {
      programs.direnv  = {
        enable = true;
	nix-direnv.enable = true;
      };
    };
  };
}
