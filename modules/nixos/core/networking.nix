{ pkgs, username, ... }:
{
  networking.firewall = {
    # Enable the firewall.
    enable = true;

    # Allow ping.
    # allowedICMPTypes = [ "echo-request" ];

    # Open ports in the firewall.
    allowedTCPPorts = [
      22
      5555
      8081
      4000
      53317
    ];
    allowedUDPPortRanges = [ { from = 50000; to = 50100; } ];
    allowedUDPPorts = [ 53317 ];
  };
}
