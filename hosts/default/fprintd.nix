{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.fprintd.elanmoc2;
  myOverlay = final: prev: {
    libfprint = prev.libfprint.overrideAttrs (old: {
      src = builtins.fetchGit {
        url = "https://gitlab.freedesktop.org/depau/libfprint.git";
        rev = "f4439ce96b2938fea8d4f42223d7faea05bd4048";
      };
      buildInputs = with pkgs;[
          gusb
          pixman
          glib
          cairo
          libgudev
          openssl
          nss
          cmake
        ];
    });
    fprintd = prev.fprintd.overrideAttrs (old: {
      mesonCheckFlags = [
        "--no-suite"
        "fprintd:TestPamFprintd"
        "--no-suite"
        "fprintd:FPrintdManagerPreStartTests"
      ];
    });
  };
in
{
  options.services.fprintd.elanmoc2 = {
    enable = mkEnableOption "Compile elanmoc2 to enable support for 04f3:0c00 fingerprint reader ";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ myOverlay ];
    services.fprintd.enable = true;
  };
}
