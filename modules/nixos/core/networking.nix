{ pkgs, ... }:
{
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;

    # Open ports in the firewall.
    allowedTCPPorts = [
      5555
      8081
      4000
      53317
    ];
    allowedUDPPortRanges = [ { from = 50000; to = 50100; } ];
    allowedUDPPorts = [ 53317 ];
  };

  # Cloudflare WARP VPN client + daemon.
  services.cloudflare-warp.enable = true;
  environment.systemPackages = [ pkgs.cloudflare-warp ];
}
