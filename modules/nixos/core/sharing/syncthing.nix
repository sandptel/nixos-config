{ username, ... }:
{
  services.syncthing = {
    enable = true;
    user = username;
    dataDir = "/home/${username}";
    configDir = "/home/${username}/.config/syncthing";
    openDefaultPorts = true; # 22000 tcp/udp + 21027 udp
  };

  # Syncthing + samba both serve out of $HOME -> needs traversable perms.
  users.users.${username}.homeMode = "755";
}
