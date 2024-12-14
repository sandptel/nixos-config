{ inputs,pkgs, lib,username, ... }:

let
  inherit (import ./variables.nix) gitUsername;
in
{


  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
  ];
  services.fprintd.elanmoc2.enable=true;
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

    # define user packages here
    packages = with pkgs; [
      # inputs.nix-init.packages."${system}".default
      #  inputs.hellwal.packages."${system}".default
      # gitbutler
      gitkraken
wl-clipboard
# spotify
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
firefox
vim
git
#vscode
# obs-studio	
rustup
gcc
glib     
google-chrome
vlc
telegram-desktop
discord
gnomeExtensions.pano
libnotify
github-desktop
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
