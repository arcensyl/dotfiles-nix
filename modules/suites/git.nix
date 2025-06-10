{ lib, config, pkgs, inputs, vars, ... }:

let
  cfg = config.suites.git;
in {
  options.suites.git = {
    enable =
      lib.mkEnableOption "Git, the most popular version control system";

	name = lib.mkOption {
	  type = lib.types.str;
	  default = "Developer";
	  description = "The name that Git will use for this machine's master user.";
	};
	
    email = lib.mkOption {
      type = lib.types.str;
      default = "dev@example.com";
      description = "The email that Git will use for this machine's master user.";
    };

	defaultBranch = lib.mkOption {
	  type = lib.types.str;
	  default = "main";
	  description = "The name Git will use for the initial branch of a new repository.";
	};
  };

  config.home-manager.users."${vars.master.name}" = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = cfg.name;
      userEmail = cfg.email;

	  extraConfig = {
		init.defaultBranch = cfg.defaultBranch;
	  };
    };
  };
}
