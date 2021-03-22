# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, lib, pkgs, ... }:

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "4cc1b77c3fc4f4b3bc61921dda72663eea962fa3";
    ref = "master";
  };
in
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "slack"
    "dropbox"
    "firefox-bin"
    "firefox-release-bin"
    "firefox-release-bin-unwrapped"
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "nixos"; # Define your hostname.

  networking.useDHCP = false;
  networking.interfaces.enp0s25.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;
  networking.interfaces.wwp0s20u4i6.useDHCP = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    source-code-pro
    font-awesome
    powerline-fonts
  ];

  environment.systemPackages = with pkgs; [
    # Core
    wget
    neovim
    tmux
    git
    alacritty

    # Social
    slack
    signal-desktop
    keybase-gui

    # Programming
    rustup
    go

    # Utils
    nnn
    zathura
    ripgrep
    rofi
    feh
    todo-txt-cli
    translate-shell

  ];

  environment.variables = {
    GOROOT = [ "${pkgs.go.out}/share/go" ];
  };

  networking.networkmanager.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "mac";
  services.xserver.xkbOptions = "eurosign:e";

  # Use capslock as Ctrl and Escape
  services.interception-tools.enable = true;

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the Desktop Environment.
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.gtk = {
      enable = true;
      theme = {
        name = "Nordic";
        package = pkgs.nordic;
      };
      cursorTheme = {
        name = "Numix-cursor-theme";
        package = pkgs.numix-cursor-theme;
      };
      iconTheme = {
        name = "Numix-icon-heme";
        package = pkgs.numix-icon-theme;
      };
    };
  };
  services.xserver.windowManager.i3.enable = true;

  services.keybase.enable = true;
  services.kbfs.enable = true;
  virtualisation.docker.enable = true;

  # Copy desired files from https://nordvpn.com/opvn
  # to /root/nixos/openvpn
  services.openvpn.servers =
    if builtins.pathExists "/root/nixos/openvpn"
    then
      let
        files = builtins.attrNames (builtins.readDir "/root/nixos/openvpn");
        createSet = file: {
          name = builtins.substring 0 5 file;# TODO: make better
          value = { config = '' config /root/nixos/openvpn/${file} ''; };
        };
      in builtins.listToAttrs (builtins.map createSet files)
    else builtins.trace "No openvpn files found" {};

  users.users.dghaehre = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.zsh;
  };

  home-manager.users.dghaehre = {
    imports = [
      ./home.nix
    ];
  };

  # Dropbox
  # used for todo.txt
  networking.firewall = {
    allowedTCPPorts = [ 17500 ];
    allowedUDPPorts = [ 17500 ];
  };
  systemd.user.services.dropbox = {
    description = "Dropbox";
    after = [ "xembedsniproxy.service" ];
    wants = [ "xembedsniproxy.service" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.dropbox.out}/bin/dropbox";
      ExecReload = "${pkgs.coreutils.out}/bin/kill -HUP $MAINPID";
      KillMode = "control-group"; # upstream recommends process
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };

  system.stateVersion = "20.03";
}
