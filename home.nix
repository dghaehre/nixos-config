{ config, pkgs, lib, ... }:

let colors = import ./colors.nix; in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "dghaehre";
  home.homeDirectory = "/home/dghaehre";

  imports = [
    ./nvim/nvim.nix
    ./zsh/zsh.nix
    ./tmux/tmux.nix
    ./i3/i3.nix
    ./firefox/firefox.nix
  ];

  programs.fzf.enable = true;
  programs.feh.enable = true;
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
    };
  };

  services.clipmenu.enable = true;
  services.unclutter = {
    enable = true;
    timeout = 4;
  };

  programs.rofi = {
    enable = true;
    location = "center";
    theme = "Adapta-Nokto";
  };

  programs.git = {
    enable = true;
    aliases = {
      lg = "log --stat --decorate --graph";
      ca = "! git add . && git commit";
      b = "branch -a --sort=committerdate";
      ss = "stash show -p";
      sl = "stash list";
    };
    userEmail = "dghaehre@gmail.com";
    userName = "Daniel";
    ignores = [ "*.swp" ];
    extraConfig = {
      core = {
        editor = "nvim";
        excludesfile = ".gitignore.local";
      };
      pull = {
        rebase = false;
      };
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        size = 8;
        normal = {
          family = "Source Code Pro Semibold";
        };
      };
      window.decorations = "none";
      window.padding = {
        x = 5;
        y = 5;
      };

      colors.primary = colors.primary;
      colors.normal = colors.normal;
      colors.bright = colors.bright;
    };
  };
  
  # Read up before changing
  home.stateVersion = "20.09";
}
