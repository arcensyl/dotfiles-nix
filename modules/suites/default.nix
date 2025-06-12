{ ... }:

{
  imports = [
    ./nix-extras.nix
	./flatpak.nix
	./commands.nix
    ./secrets.nix
	./git.nix
    ./media.nix
    ./gaming.nix
    ./vr.nix
	./ai.nix
    ./containerization.nix
  ];
}
