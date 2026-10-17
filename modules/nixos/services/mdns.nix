{ ... }:
{
  # mDNS/DNS-SD. Currently pulled in transitively by GNOME -> declare it here so
  # network printer + .local host discovery survives dropping the GNOME session.
  services.avahi = {
    enable = true;
    nssmdns4 = true; # resolve *.local via NSS
    openFirewall = true;
  };
}
