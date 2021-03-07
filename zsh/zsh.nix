{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "colored-man-pages"
        "tmux"
      ];
    };
    shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      "c" = "clear";
      "down" = "cd ~/Downloads";
      "cat" = "${pkgs.bat}/bin/bat";
      "ls" = "${pkgs.exa}/bin/exa";
      "l" = "${pkgs.exa}/bin/exa -l -g --git";
      "gl" = "git checkout";
      "please" = "sudo !!";
      "cpwd" = "pwd | xsel -b";
      "dmenu" = "dmenu -b -nb '#2f343f' -sb '#2f343f'";
      "untar" = "tar -xvzf $x";
      "ta" = "tmux attach";
      "v" = "nvim";
      "topdf" = "pandoc -f markdown -t pdf -o doc.pdf -V mainfont=\"[source code pro]\" $x --pdf-engine wkhtmltopdf";
      "sudov" = "sudo -E nvim";

      # Push to keybase
      "push-wikis" = "push-work && push-diary";
      "push-work" = "cd ~/wikis/work && pushall";
      "push-diary" ="cd ~/wikis/personal && keybase login -s dghaehre_ && pushall";

      # todo.sh
      "t" = "todo.sh -d ~/Dropbox/todotxt/nixos-config";
      "today" ="t lsp B";
      "work" = "t ls @work";
      # TODO: add now()

    };
    initExtra = (builtins.readFile ./.zshrc);
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      character = {
        symbol = "➜";
        vicmd_symbol = "λ";
      };
      time = {
        disabled = false;
        style = "white dimmed";
        time_format = "%T";
        utc_time_offset = "+1";
      };
      status = {
        disabled = false;
        style = "bg:blue";
        symbol = "💣 ";
      };
      cmd_duration.disabled = true;
      haskell.disabled = true;
    };
  };

}
