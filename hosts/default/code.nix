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
     python-packages # says the docs required for weather but who needs weather :)
      rustup
      cargo
      # vim
      git
      # tmux
      pkg-config
      # github-desktop
      #vscode
    #   devenv
    direnv
      gitkraken
      github-cli
      openssl #required by Rainbow borders too :)
      ((vim_configurable.override {  }).customize{
      name = "vim";
      # Install plugins for example for syntax highlighting of nix files
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [ vim-nix vim-lastplace ];
        opt = [];
      };
      vimrcConfig.customRC = ''
        " your custom vimrc
        set nocompatible
        imap jj <Esc>
        set backspace=indent,eol,start
        " Turn on syntax highlighting by default
        syntax on
        " ...
      '';
    }
  )
    ]);
}