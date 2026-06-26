{ username, ... }:
{
  services.syncthing = {
    enable = true;
    user = username;
    dataDir = "/home/${username}";
    configDir = "/home/${username}/.config/syncthing";

    # Automatically opens ports 22000 (TCP/UDP) and 21027 (UDP) in the firewall.
    openDefaultPorts = true;
  };
}
