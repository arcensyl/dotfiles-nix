{
  description = "This flake exposes custom packages as part of Arc's NixOS configuration.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: let
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    packages = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      # Packages go here.
      mypkgs-test = pkgs.callPackage ./mypkgs-test/package.nix {};

      rider2emacs = pkgs.callPackage ./rider2emacs/package.nix {};
    });

    # This flake exposes an overlay over Nixpkgs.
    # All custom packages are stored under the 'my' prefix.
    overlays.default = final: prev: {
      my = self.packages.${prev.system};
    };
  };
}
