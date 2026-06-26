{ pkgs, ... }:
{
  imports = [
    ./wayland.nix
    ./hyprland.nix
    ./gnome.nix
    ./niri.nix
  ];

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    pavucontrol
    nwg-look
    btop-rocm
    libappindicator

    libnotify     # Required to send notifications (via notify-send)

    # --- Screen Capture & Recording ---
    grim          # Screenshot grabber
    slurp         # Region selector for grim
    swappy        # Quick annotation tool for your grim screenshots
    gpu-screen-recorder

    # --- Clipboard Management ---
    wl-clipboard
    cliphist

    # --- System & Hardware Control ---
    brightnessctl # Backlight control (bind to your brightness keys)
    pavucontrol   # GUI audio mixer
    pamixer       # CLI audio mixer (bind to your volume keys)
    playerctl     # CLI media player controller (play/pause/next)

    swaylock      # Screen locker
    swayidle      # Idle daemon (locks screen after inactivity)

  ];

  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      fira-code
      fira-code-symbols
      rubik
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.ubuntu
      nerd-fonts.blex-mono
    ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [
        "hyprland"
        "gtk"
      ];
      gnome.default = [
        "gnome"
        "gtk"
      ];
    };
  };

}
