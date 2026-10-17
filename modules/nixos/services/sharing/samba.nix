{ username, ... }:
{
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "nixos-media";
        "security" = "user";
        "smb encrypt" = "desired"; # opportunistic SMB3, no client breakage
        # LAN-scoped by subnet, not by `interfaces = wlp97s0` -> survives NIC
        # renames and works over ethernet; still keeps docker0 (172.17/16) out.
        "hosts allow" = "192.168.0.0/16 10.0.0.0/8 127.0.0.1";
        "hosts deny" = "0.0.0.0/0";
      };
      "Shared" = {
        path = "/home/${username}/Videos/Sharing";
        browseable = "yes";
        "read only" = "yes";
        "valid users" = username;
      };
    };
  };

  services.samba.winbindd.enable = false; # AD/domain joins only
  services.samba-wsdd.enable = true; # WS-Discovery -> visible on Windows/Android
  # nmbd is legacy NetBIOS, made redundant by wsdd above, and spams the journal
  # with "send_udp ... Network is unreachable" on every link change.
  services.samba.nmbd.enable = false;
}
