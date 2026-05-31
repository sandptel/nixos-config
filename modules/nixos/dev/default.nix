{ pkgs, ... }: {
  imports = [ ./rust.nix ./nix-tools.nix ];

  programs.vscode.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  environment.systemPackages = with pkgs; [
    fastfetch
    yazi
    helix
    neovim
    vim
    ripgrep
    # git
    curl
    wget
    tmux
    fzf
    fd
    bat
    eza
    htop
    zip
    unzip
    git-lfs
  ];
}
