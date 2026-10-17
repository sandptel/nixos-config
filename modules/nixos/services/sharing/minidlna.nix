{ username, ... }:
{
  services.minidlna = {
    enable = true;
    openFirewall = true;
    settings = {
      media_dir = [ "V,/home/${username}/Videos/Sharing" ];
      friendly_name = "nixos-media";
      inotify = "yes";
      # No network_interface pin -> a hardcoded `wlp97s0` breaks on NIC rename
      # and on ethernet. SSDP on docker0 is inert; the firewall gates real access.
    };
  };
}
