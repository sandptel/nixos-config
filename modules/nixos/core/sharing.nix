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

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "nixos-media";
        "security" = "user";
        "smb encrypt" = "desired"; # opportunistic SMB3 encryption, no client breakage
        interfaces = "lo wlp97s0"; # LAN only, keep off docker0
        "bind interfaces only" = "yes";
      };
      "Shared" = {
        path = "/home/${username}/Videos/Sharing";
        browseable = "yes";
        "read only" = "yes";
        "valid users" = username;
      };
    };
  };
  services.samba.winbindd.enable = false; # only needed for AD/domain joins, not local file sharing
  services.samba-wsdd.enable = true; # network discovery, lets it show up on Windows/Android

  services.minidlna = {
    enable = true;
    openFirewall = true;
    settings = {
      media_dir = [ "V,/home/${username}/Videos/Sharing" ];
      friendly_name = "nixos-media";
      inotify = "yes";
      network_interface = "wlp97s0"; # LAN only, keep off docker0
    };
  };

  users.users.${username}.homeMode = "755";
}
