{
  description = "This flake is the entrypoint for Arc's NixOS configuration.";

  inputs = {
    # This configuration uses the unstable channel for Nix packages.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager allows me to configure a user's environment.
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Stylix is a Nix module to automate theming your system.
    stylix.url = "github:danth/stylix";

    # Hyprland is a tiling window manager that doesn't compromise on looks.
    hyprland.url = "github:hyprwm/Hyprland";

    niri.url = "github:sodiboo/niri-flake";

    # Zen Browser is provided by a flake, as it is not in nixpkgs yet.
    # This flake is from a fork that is automatically updated for new Zen Browser versions.
    zen-browser.url = "github:omarcresp/zen-browser-flake";

    # Wezterm is provided by a flake so it can be compiled from source.
    # This will hopefully allow Wezterm to run as a proper Wayland window.
    wezterm.url = "github:wez/wezterm?dir=nix";

    # Curd is a CLI tool for streaming anime.
    curd = {
      url = "github:Wraient/curd";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    inherit (nixpkgs) lib;

    # Hosts are automatically discovered by walking through the 'hosts' directory.
    hosts = builtins.attrNames (lib.filterAttrs 
      (name: type: type == "directory") 
      (builtins.readDir ./hosts));

    # This function takes a host name, and then returns its associated configuration.
    mkHostConfig = host: 
      let
        props = import (./hosts + "/${host}/system-properties.nix") { inherit host; };
        vars = import (./hosts + "/${host}/vars.nix") { inherit inputs props; };
      in lib.nixosSystem {
        specialArgs = { inherit inputs props vars; };
        modules = [
          # Full modules:
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          inputs.niri.nixosModules.niri
          ./modules

          # Inline modules:
          { nixpkgs.overlays = [ inputs.niri.overlays.niri ]; }

          # Host-specific files:
          (./hosts + "/${host}/hardware-configuration.nix")
          (./hosts + "/${host}/configuration.nix")
        ];
      };
  in {
    nixosConfigurations = lib.genAttrs hosts mkHostConfig;
  };
}
