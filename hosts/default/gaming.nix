{ pkgs, config, ... }:
{
  imports = [
  ];

  options = {
  };

  config = {
    # programs.gamemode.enable = true; # for performance mode

    programs.steam = {
      enable = true; # install steam
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      protontricks.enable = true; # install protontricks
    
    };

    hardware.graphics.enable32Bit = true; # enable 32-bit graphics support

    environment.systemPackages = with pkgs; [
      wineWowPackages.waylandFull # install wine with wayland support
      heroic # install heroic launcher
      lutris # install lutris launcher
      mumble # install voice-chat
      protonup-qt # GUI for installing custom Proton versions like GE_Proton
      # (retroarch.override {
      #   cores = with libretro; [ # decide what emulators you want to include
      #     puae # Amiga 500
      #     scummvm
      #     dosbox
      #   ];
      # })
      # teamspeak_client # install voice-chat
    ];
  };
}
