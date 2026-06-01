{ ... }:
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
      53317
    ];
    allowedUDPPorts = [ 53317 ];
  };
}
