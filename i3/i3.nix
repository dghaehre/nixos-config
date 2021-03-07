{ config, lib, pkgs, ... }:

let colors = import ../colors.nix; in
{
  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {

        blocks = [
          {
            block = "keyboard_layout";
          }
          {
             block = "disk_space";
             path = "/";
             info_type = "available";
             unit = "GB";
             interval = 60;
             warning = 20.0;
             alert = 10.0;
           }
           {
             block = "memory";
             display_type = "memory";
             format_mem = "{Mup}%";
             format_swap = "{SUp}%";
           }
           {
             block = "cpu";
             interval = 1;
           }
           {
             block = "networkmanager";
             primary_only = true;
           }
           {
             block = "battery";
             interval = 10;
             format = "{percentage}%";
           }
           {
             block = "time";
             interval = 60;
             format = "%a %d/%m %R";
           }
        ];

        settings = {
          theme =  {
            name = "solarized-dark";
            overrides = {
              # separator_bg = colors.primary.background;
              # separator_fg = colors.primary.foreground;
              separator_bg = "auto";
              separator_fg = "auto";
              idle_bg      = colors.primary.background;
              idle_fg      = colors.primary.foreground;
              good_bg      = colors.primary.background;
              good_fg      = colors.normal.green;
              info_bg      = colors.normal.yellow;
              info_fg      = colors.normal.black;
            };
          };
        };

        icons = "awesome5";
        theme = "solarized-dark";
      };
    };
  };

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      terminal = "alacritty";
      fonts = [ "Sourcecodepro 8" ];
      startup = [
        {
          command = "feh --bg-scale ~/myconfig/i3/background.jpg";
          notification = false;
          always = true;
        }
        {
          command = "xset r rate 200 30";
          notification = false;
          always = true;
        }
        { # Create folders
          command = ''
            mkdir -p ~/wikis/work && \
            mkdir -p ~/wikis/personal && \
            mkdir -p ~/Downloads
            '';
          notification = false;
        }
      ];

      # Todo: make it look good
      # Use global color variables
      bars = [{
        fonts = [ "Sourcecodepro 8" ];
        statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
        colors = {
          background = colors.primary.background;

          bindingMode = {
            background = colors.normal.yellow;
            border = colors.primary.background;
            text = colors.normal.black;
          };

          inactiveWorkspace = {
            background = colors.primary.background;
            border = colors.primary.background;
            text = colors.normal.black;
          };

          focusedWorkspace = {
            background = colors.primary.background;
            border = colors.primary.background;
            text = colors.bright.white;
          };
        };
      }];

      colors = {
        focused = {
          background = colors.primary.background;
          text = colors.primary.foreground;
          border = colors.primary.foreground;
          childBorder = colors.primary.background;
          indicator = colors.primary.background;
        };
        unfocused = {
          background = colors.primary.background;
          text = colors.bright.black;
          border = colors.primary.background;
          childBorder = colors.primary.background;
          indicator = colors.primary.background;
        };
      };

      keybindings =
        let modifier = config.xsession.windowManager.i3.config.modifier;
        in lib.mkOptionDefault {
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          "${modifier}+d" = "exec rofi -show drun -show-icons";

          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          "${modifier}+b" = "split h";
          "${modifier}+v" = "split v";

          "${modifier}+Shift+space" = "floating toggle";

          "${modifier}+minus" = "scratchpad show";
          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+Shift+e" = "mode \"$lock_launcher\"";
          "${modifier}+Shift+f" = "mode \"$firefox_launcher\"";

          "${modifier}+Shift+t" = "[class=\"^Alacritty$\"] scratchpad show";

          # TODO needs styling..
          "${modifier}+c" = "exec clipmenu -i -b -nb '#2f343f' -sb '#2f343f' -fn Terminus:size=9";
      };

      window.commands = [
        { # Remove title bar for every application
          command = "border pixel 0";
          criteria = {
            class = "^.*";
          };
        }
      ];
    };

    extraConfig = ''

set $firefox_launcher Firefox (d) dghaehre, (w) work, (o) omni
mode "$firefox_launcher" {
  bindsym d exec --no-startup-id firefox --args -P dghaehre, mode "default"
  bindsym w exec --no-startup-id firefox --args -P work, mode "default"
  bindsym o exec --no-startup-id firefox --args -P omni, mode "default"

  # back to normal: Enter or Escape
  bindsym Return mode "default"
  bindsym Escape mode "default"
}

set $lock_launcher System (l) lock, (e) logout, (s) suspend, (r) reboot, (Shift+s) shutdown
mode "$lock_launcher" {
  bindsym l exec --no-startup-id i3lock -c ${colors.primary.background}, mode "default"
  bindsym e exec --no-startup-id "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -B 'Yes, exit i3' 'i3-msg exit'"
  bindsym s exec --no-startup-id "i3lock -c ${colors.primary.background} && systemctl suspend", mode "default"
  bindsym r exec --no-startup-id systemctl reboot, mode "default"
  bindsym Shift+s exec --no-startup-id systemctl poweroff, mode "default"
  # back to normal: Enter or Escape
  bindsym Return mode "default"
  bindsym Escape mode "default"
}

    '';
  };

}
