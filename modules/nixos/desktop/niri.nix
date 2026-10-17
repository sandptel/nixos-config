{ pkgs, ... }:
{
  # Enable the Niri Wayland compositor
  programs.niri = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    polkit_gnome  # GUI prompt for asking for passwords
  ];

  # polkit_gnome ships no service; start the agent so GUI privilege prompts
  # work under standalone niri (gnome session provides its own agent).
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}