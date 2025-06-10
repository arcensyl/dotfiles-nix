{ lib, config, pkgs, inputs, vars, ... }:

let
  cfg = config.suites.ai;
in {
  options.suites.ai = {
	enable = lib.mkEnableOption "the suite for locally-hosted AI tools";

	backend = lib.mkOption {
	  type = lib.types.string;
	  default = "cpu";
	  example = "rocm";
	  description = "The device backend that Ollama will use.";
	};
  };

  config = lib.mkIf cfg.enable {
	services.ollama = {
	  enable = true;
	  acceleration = "rocm"; # TODO: Make this use the 'backend' option.
	  rocmOverrideGfx = "11.0.0"; # May need to change this for different systems.
	};
  };
}
