{ inputs, outputs, lib, config, pkgs, ... }:
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
}