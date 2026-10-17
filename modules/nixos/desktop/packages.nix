{ pkgs, ... }:
# Shared desktop support packages and integrations not tied to one compositor.
{
  # Desktop integration enables.
  programs.nm-applet.enable = true;
  programs.seahorse.enable = true; # keyring GUI
  programs.dconf.enable = true; # GTK / settings backend

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    pavucontrol
    nwg-look
    btop-rocm
    libappindicator

    libnotify # send notifications (notify-send)

    # rice engine (~/.config/rice/rice): runs from noctalia hooks, needs these on PATH
    python3
    imagemagick # wallpaper classification

    # --- Screen Capture & Recording ---
    grim
    slurp
    swappy
    gpu-screen-recorder

    # --- Clipboard Management ---
    wl-clipboard
    cliphist

    # --- System & Hardware Control ---
    brightnessctl
    pamixer
    playerctl

    swaylock
    swayidle
  ];
}
