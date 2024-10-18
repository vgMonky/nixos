{ config, lib, pkgs, ... }:

{
  networking.hostName = "desk";

  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --output DVI-I-1 --off --output DP-1 --off --output DP-2 --off --output DP-3 --off --output HDMI-3 --primary --gamma 1.4:1.4:1.4 --mode 1920x1080 --pos 0x0 --rotate normal --output VGA-1-1 --mode 1024x768 --pos 1920x312 --rotate normal --output HDMI-1-1 --off --output HDMI-1-2 --off
  '';

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.interfaces.wlp0s20u4.ipv4.addresses = [{
    address = "192.168.1.19";
    prefixLength = 24;
  }];

  services.ddclient = {
    enable = true;
    protocol = "noip";
    username = "vgmonky";
    passwordFile = "/etc/wireguard/noippw";
    domains = [ "monky.ddns.net" ];
    use = "web, web=checkip.dyndns.org/, web-skip='IP Address'";
    server = "dynupdate.no-ip.com";
  };

  networking.nat = {
    enable = true;
    externalInterface = "wlp0s20u4";
    internalInterfaces = [ "wgdesk" ];
  };

  networking.firewall = {
    allowedUDPPorts = [ 51820 51821 ];
    allowedTCPPorts = [ 22 5173 ];
  };

  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.7/32" ];
      listenPort = 51820;
      privateKeyFile = "/etc/wireguard/privatekey";
      peers = [
        {
          publicKey = "gxN9aDzFhJO4Jun+5WeVLzPBr3Clc/JLbHYNKnVrD0k=";
          allowedIPs = [ "10.100.0.1/32" ];
          endpoint = "169.197.140.154:51820";
          persistentKeepalive = 25;
        }
      ];
    };
    wgdesk = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 51821;
      privateKeyFile = "/etc/wireguard/privatekey";
      peers = [
        {
          publicKey = "dkglLOUgDByMe3htPU+Ym8OqU9fx1nKczvgIFSupFVw=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
      ];
    };
  };
}
