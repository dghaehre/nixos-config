{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    keyMode = "vi";
    shortcut = "a";
    terminal = "screen-256color";
    escapeTime = 0;
    extraConfig = (builtins.readFile ./.tmux.conf);
  };
}
