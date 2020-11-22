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
    vim
    tmux
    git
    alacritty

    # Social
    slack
    signal-desktop
    keybase-gui

    # Programming
    docker
    docker-compose
    rustup

    # Utils
    nnn
    zathura
    ripgrep
    rofi
    feh
  ];

  networking.networkmanager.enable = true;

  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

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
  services.xserver.displayManager.sddm.enable = true;
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

  system.stateVersion = "20.03";
}
