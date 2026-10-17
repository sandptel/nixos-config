{ pkgs, ... }:
{
  # Core system baseline tools, not tied to any single module.
  environment.systemPackages = with pkgs; [
    curl
    wget
    zip
    unzip
    blueman
  ];
}
