{ config,inputs, pkgs, ... }:
let 
python-packages = pkgs.python3.withPackages (
    ps:
      with ps; [
        requests
        pyquery # needed for hyprland-dots Weather script
      ]
  );
  in
{

nix.extraOptions = ''
        trusted-users = root roronoa
        extra-substituters = https://devenv.cachix.org
        extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    '';

environment.systemPackages =
    (with pkgs; [ 
     # System Packages
    #  python-packages # say the docs required for weather but who needs weather :)
      rustup
      cargo
      vim
      git
      tmux
      pkg-config
      # github-desktop
      #vscode
      devenv
      gitkraken
      github-cli
      openssl #required by Rainbow borders too :)
    ]);
}