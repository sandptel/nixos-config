{ inputs,pkgs, lib,username, ... }:

let
  inherit (import ./variables.nix) gitUsername;
in
{
services.tftpd.enable = true;
services.tftpd.path = "/srv/tftp";
 nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
  ];
#   services.fprintd.elanmoc2.enable=true;
  imports=[
./starship.nix
];
  users = { 
    users."${username}" = {
      homeMode = "755";
      isNormalUser = true;
      description = "${gitUsername}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "libvirtd"
        "scanner"
        "lp"
        "video" 
        "input" 
        "audio"
      ];

  #   # define user packages here
  #    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #   "slack"
  # ];
    packages = with pkgs; [
      # inputs.nix-init.packages."${system}".default
      #  inputs.hellwal.packages."${system}".default
      # gitbutler
    #   inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin
kando
kcl
wl-clipboard
code-cursor
# spotify
slack
obsidian
grim
slurp
blueman
rofi-bluetooth
networkmanagerapplet  
flameshot
bun
eza
pulseaudio
brightnessctl
playerctl
neofetch
# firefox
# obs-studio	
gcc
gdb
rustup
gcc
glib     
google-chrome
vlc
telegram-desktop
discord
gnomeExtensions.pano
libnotify
# qutebrowser
krabby
      ];
    };
    
    defaultUserShell = pkgs.fish;
  }; 
  
  environment.shells = with pkgs; [ fish ];
  environment.systemPackages = with pkgs; [ fzf ]; 
  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    #fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc
        #pokemon colorscripts 
        krabby random --no-mega --no-gmax --no-regional --no-title -s;
        wal --preview | sed '/Current colorscheme:/d'
  '';
  
   programs = {
  #   spicetify = {
  #       enable = true;
  #      theme = "catppuccin";
  #      colorscheme = "mocha";
  #   };
  # Zsh configuration
	  zsh = {
    	enable = true;
	  	enableCompletion = true;
      ohMyZsh = {
        enable = true;
        plugins = ["git"];
        theme = "xiong-chiamiov-plus"; 
      	};
      
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      
      promptInit = ''
        fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc
        
        #pokemon colorscripts like. Make sure to install krabby package
        #krabby random --no-mega --no-gmax --no-regional --no-title -s; 
        
        source <(fzf --zsh);
        HISTFILE=~/.zsh_history;
        HISTSIZE=10000;
        SAVEHIST=10000;
        setopt appendhistory;
        '';
      };
   };
}
