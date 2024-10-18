{ config, lib, pkgs, ... }:

{
  networking.hostName = "laptop";

  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --primary --mode 2048x1152 --pos 0x0 --rotate normal --output DP-1 --off --output DP-2 --off --output DP-3 --off --output DP-4 --off --output DP-1-5 --off --output HDMI-1-1 --off --output eDP-1-2 --off
  '';

  swapDevices = [
    { device = "/swapfile"; size = 16192; }
  ];

  networking.firewall = {
    allowedUDPPorts = [ 51820 51821 ];
  };

  networking.wireguard.interfaces = {
    wgdesk = {
      ips = [ "10.100.0.2/24" ];
      listenPort = 51821;
      privateKeyFile = "/etc/wireguard/private";
      peers = [
        {
          publicKey = "qX/xjWNGWCdbAxOdAFrVBSUJhxyCIpzUoc4/yYgzgTo=";
          allowedIPs = [ "10.100.0.0/24" ];
          endpoint = "monky.ddns.net:51821";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
