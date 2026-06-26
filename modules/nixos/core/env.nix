{ pkgs, ... }:
# to be used to setup environment variables and MIME associations for the desktop environment
{
  environment.systemPackages = with pkgs; [
    
  ];

  environment.sessionVariables = {
    BROWSER = "firefox"; 
  };

  # 2. Set XDG MIME default applications (used by GUI apps)
  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
}