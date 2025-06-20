{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # https://github.com/pop-os/cosmic-epoch?tab=readme-ov-file#installing-on-nixos

  imports = [
    # inputs.nixos-cosmic.nixosModules.default
  ];
  nix.settings = {
    substituters = [ "https://cosmic.cachix.org/" ];
    trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
  };
  services.desktopManager.cosmic.enable = true;
  services.desktopManager.cosmic.xwayland.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  xdg.portal = {
    # enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-cosmic
      pkgs.xdg-desktop-portal-wlr
    ];
    xdgOpenUsePortal = true;
    # config = {
    #   common = {
    #     default = [
    #       "cosmic"
    #       "gtk"
    #     ];
    #   };
    #   cosmic = {
    #     default = [
    #       "cosmic"
    #       "gtk"
    #     ];
    #     "org.freedesktop.impl.portal.Screenshot" = [
    #       "cosmic"
    #     ];
    #   };
    # };
  };
  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-cosmic
    cosmic-ext-ctl
    cosmic-ext-tweaks
    cosmic-design-demo
    cosmic-ext-calculator
    #examine
    #quick-webapps
    #comsic-protocols
    cosmic-randr
  ];

}
