{ lib, config, pkgs, inputs, vars, ... }:

let
  cfg = config.apps.browsers;
  zen-browser = inputs.zen-browser.packages."${pkgs.system}".default;
  colors = config.lib.stylix.colors.withHashtag;
in {
  options.apps.browsers.zen = {
    enable =
	  lib.mkEnableOption "Zen Browser, a fork of Firefox. Requires the Zen flake";

	default = lib.mkOption {
	  type = lib.types.bool;
	  default = false;
	  example = true;
	  description = "Determines if Zen should be the default browser.";
	};
  };

  options.apps.browsers.nyxt = {
    enable =
	  lib.mkEnableOption "the Nyxt web browser";

	default = lib.mkOption {
	  type = lib.types.bool;
	  default = false;
	  example = true;
	  description = "Determines if Nyxt should be the default browser.";
	};
  };

  options.apps.browsers.nyxt-electron = {
	enable =
	  lib.mkEnableOption "support for Nyxt's Electron version (separately downloaded as Flatpak)";

	default = lib.mkOption {
	  type = lib.types.bool;
	  default = false;
	  example = true;
	  description = "Determines if Nyxt (Electron) should be the default browser.";
	};
  };

  config.home-manager.users."${vars.master.name}" = {
    home.packages = lib.filter (v: v != null) [
      (if cfg.zen.enable then zen-browser else null)
	  (if cfg.nyxt.enable then pkgs.nyxt else null)
    ];

    wayland.windowManager.hyprland.settings.bind = lib.filter (v: v != null) [
      (if (cfg.zen.enable && cfg.zen.default) then "CTRL ALT, W, exec, zen" else null)
      (if (cfg.nyxt.enable && cfg.nyxt.default) then "CTRL ALT, W, exec, nyxt" else null)
	  (if (cfg.nyxt-electron.enable && cfg.nyxt-electron.default) then "CTRL ALT, W, exec, engineer.atlas.Nyxt-Electron" else null)
    ];

	home.shellAliases = {
	  nyxt-electron = lib.mkIf cfg.nyxt-electron.enable "engineer.atlas.Nyxt-Electron";
	};
	
	home.sessionVariables = lib.mkIf cfg.nyxt-electron.default {
	  BROWSER = "engineer.atlas.Nyxt-Electron";
	};

	home.file.nyxt-electron-desktop = lib.mkIf cfg.nyxt-electron.default {
	  target = ".local/share/applications/nyxt-electron.desktop";
	  text = ''
[Desktop Entry]
Name=Nyxt (Electron)
Comment=Be Productive
GenericName=Web Browser
Keywords=Internet;WWW;Browser;Web;Explorer
Exec=engineer.atlas.Nyxt-Electron %u
Terminal=false
X-MultipleArgs=false
Type=Application
Icon=nyxt
Categories=GTK;Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;x-scheme-handler/chrome;video/webm;application/x-xpinstall;
StartupNotify=true
StartupWMClass=nyxt
	  '';
	};

# 	home.file.nyxt-electron-default = lib.mkIf cfg.nyxt-electron.default {
# 	  target = ".local/share/applications/mineapps.list";
# 	  text = ''
# [Default Applications]
# x-scheme-handler/http=nyxt-electron.desktop;
# x-scheme-handler/https=nyxt-electron.desktop;
# 	  '';
# 	};

	xdg.mimeApps.defaultApplications = lib.mkIf cfg.nyxt-electron.default {
	  "x-scheme-handler/http" = "nyxt-electron.desktop";
	  "x-scheme-handler/https" = "nyxt-electron.desktop";
	};
	
	# TODO: Tweak the colors used for my generated Nyxt theme
	# Maybe use the mantle and surface colors?
	home.file.nyxt-stylix = lib.mkIf cfg.nyxt.enable {
	  target = ".dotfiles/nix/gen/nyxt-stylix-theme.lisp";
	  text = ''
(in-package #:nyxt-user)

(define-configuration browser
  ((theme (make-instance
           'theme:theme
           :dark-p ${(if vars.theme.polarity == "dark" then "t" else "nil")}
           :background-color "${colors.base00}"
		   :background-color+ "${colors.base01}"
		   :background-color- "${colors.base02}"
           :text-color "${colors.base05}"
           :accent-color "${colors.base0D}"
		   :highlight-color "${colors.base0E}"
		   :codeblock-color "${colors.base01}"
           :primary-color "${colors.base04}"
           :secondary-color "${colors.base03}"
           :secondary-color+ "${colors.base02}"
		   :secondary-color- "${colors.base04}"
           :tertiary-color "${colors.base01}"
           :quaternary-color "${colors.base02}"))))

(define-configuration nyxt/style-mode:dark-mode
  ((style #.(cl-css:css
             '((*
                :background-color "${colors.base00} !important"
                :background-image "none !important"
                :color "${colors.base05}")
               (a
                :background-color "${colors.base00} !important"
                :background-image "none !important"
                :color "${colors.base03} !important"))))))
	  '';
	};

	home.file.nyxt-v4-stylix = lib.mkIf cfg.nyxt-electron.enable {
	  target = ".dotfiles/nix/gen/nyxt-v4-stylix-theme.lisp";
	  text = ''
(in-package #:nyxt-user)

(define-configuration browser
  ((theme (make-instance
           'theme:theme
           :background-color "${colors.base00}"
		   :background-color+ "${colors.base01}"
		   :background-color- "${colors.base02}"
           :primary-color "${colors.base03}"
		   :primary-color+ "${colors.base04}"
		   :primary-color- "${colors.base02}"
           :secondary-color "${colors.base03}"
           :secondary-color+ "${colors.base02}"
		   :secondary-color- "${colors.base04}"

		   :highlight-color "${colors.base07}"
		   :highlight-color+ "${colors.base07}"
		   :highlight-color- "${colors.base07}"
		   :action-color "${colors.base0D}"
		   :action-color+ "${colors.base0D}"
		   :action-color- "${colors.base0D}"
		   :success-color "${colors.base0B}"
		   :success-color+ "${colors.base0B}"
		   :success-color- "${colors.base0B}"
		   :warning-color "${colors.base0A}"
		   :warning-color+ "${colors.base0A}"
		   :warning-color- "${colors.base0A}"

		   :on-background-color "${(if vars.theme.polarity == "dark" then "white" else "black")}"
		   :on-primary-color "${(if vars.theme.polarity == "dark" then "white" else "black")}"
		   :on-secondary-color "${(if vars.theme.polarity == "dark" then "white" else "black")}"
		   :on-highlight-color "${(if vars.theme.polarity == "dark" then "white" else "black")}"
		   :on-action-color "${(if vars.theme.polarity == "dark" then "white" else "black")}"
		   :on-success-color "${(if vars.theme.polarity == "dark" then "white" else "black")}"
		   :on-warning-color "${(if vars.theme.polarity == "dark" then "white" else "black")}"))))
	  '';
	};
  };
}
