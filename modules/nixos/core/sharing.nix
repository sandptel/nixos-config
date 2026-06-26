{ ... }:
{
  services.syncthing = {
    enable = true;
    user = "bushido"; # Replace with your actual Linux username
    dataDir = "/home/bushido"; # Default directory for new folders
    configDir = "/home/bushido/.config/syncthing"; # Where settings and keys are stored

    # This is the magic line. It automatically opens ports 22000 (TCP/UDP)
    # and 21027 (UDP) in your NixOS firewall.
    openDefaultPorts = true;
  };
}
