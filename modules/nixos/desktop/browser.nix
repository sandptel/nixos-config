{ ... }:
# Default browser: install firefox, set env + MIME associations.
{
  programs.firefox.enable = true;

  environment.sessionVariables = {
    BROWSER = "firefox";
  };

  # XDG MIME default applications (used by GUI apps).
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
