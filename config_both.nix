{ config, lib, pkgs, ... }:

let
  i3-resurrect-cmd = pkgs.callPackage (fetchTarball {
    url = "https://github.com/vgMonky/i3-resurrect-cmd/archive/42a3933de9ba5946e8d4f540c463bf648a78b0c3.tar.gz";
    sha256 = "1xxm4y0nl46siv4vjg7qcwkimm7911dyv4b2s5p8xhz0008pq3j5";
  }) {};
in
{
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "nvme_core.default_ps_max_latency_us=0"
    ];
  };

  networking.networkmanager.enable = true;

  time.timeZone = "America/Montevideo";

  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;
    xkb.layout = "us";
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
        i3status
        i3lock
        i3blocks
        i3-resurrect
        i3-resurrect-cmd
      ];
    };
  };

  services.libinput.enable = true;
  services.displayManager.defaultSession = "none+i3";

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
    permittedInsecurePackages = [ "qbittorrent-qt5-4.6.4" ];
  };

  users.users.monky = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      pyradio
      cmatrix
      python311
      xorg.xgamma
      networkmanagerapplet
      git
      nodejs
      nodePackages.firebase-tools
      vim
      htop
      tree
      neofetch
      ventoy-full
      wireguard-tools
      p7zip
      xclip
      alacritty
      scrot
      firefox
      csound-qt
      xfce.thunar
      libreoffice-qt6-still
      godot3
      arandr
      vlc
      vscode
      telegram-desktop
      element-desktop
      qbittorrent-qt5
      wesnoth
      steam-run
      atlauncher
      (writeScriptBin "godot3-soft" ''
        #!${bash}/bin/bash
        LIBGL_ALWAYS_SOFTWARE=1 ${godot3}/bin/godot3 -e
      '')

      (neovim.override {
        configure = {
          customRC = ''
            set clipboard+=unnamedplus
          '';
          packages.myVimPackage = with pkgs.vimPlugins; {
            start = [ vim-airline vim-airline-themes ];
          };
        };
      })
    ];
  };

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
      UseDns = true;
      X11Forwarding = true;
      PermitRootLogin = "prohibit-password";
    };
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  programs.steam.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common.default = "*";
  };

  system.stateVersion = "24.05";
}
