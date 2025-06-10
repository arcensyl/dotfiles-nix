{ lib, ... }:

{
  imports = [
    ./hypr
    ./niri
  ];

  options.de.hasEnvironment = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "This flag indicates this system has a desktop environment or window manager.";
  };
}
