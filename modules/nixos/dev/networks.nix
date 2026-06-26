{ pkgs, username, ... }:
{
  # Wireshark: this sets up the dumpcap capability wrapper AND creates the
  # `wireshark` group. Do NOT just add wireshark to systemPackages — you'd
  # get the binary but no working capture permissions.
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;   # GUI. The option DEFAULTS to wireshark-cli (tshark only),
                                # so you must set this explicitly to get the Qt GUI.
  };

  environment.systemPackages = with pkgs; [
    termshark
    tcpdump
    etherape
    bandwhich
    iftop
    nethogs
    bmon
    nload
    trippy      # binary is `trip`
    gping
    mtr
    nmap
    sniffnet
  ];

  # Declaratively grant raw-socket capabilities to the tools that need them,
  # so you don't sudo every time. Wrappers land in /run/wrappers/bin, which is
  # early in PATH, so these names shadow the plain binaries automatically.
  security.wrappers = let
    capWrap = bin: {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw,cap_net_admin+ep";
      source = bin;
    };
  in {
    sniffnet  = capWrap "${pkgs.sniffnet}/bin/sniffnet";
    bandwhich = capWrap "${pkgs.bandwhich}/bin/bandwhich";
    etherape  = capWrap "${pkgs.etherape}/bin/etherape";
    iftop     = capWrap "${pkgs.iftop}/bin/iftop";
    nethogs   = capWrap "${pkgs.nethogs}/bin/nethogs";
    trip      = capWrap "${pkgs.trippy}/bin/trip";
  };
}