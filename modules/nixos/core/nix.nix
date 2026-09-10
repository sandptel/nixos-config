{ ... }:
{
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      max-jobs = "auto";
    };

    # Sweep old generations so /nix doesn't grow forever. Boot entries are
    # capped separately in hosts/bushido/boot.nix -- gc does not touch the ESP.
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };
}
