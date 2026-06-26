{ pkgs, ... }:
# Dev tooling. CLI tools configured via home-manager (bat/eza/fzf/ripgrep, git,
# lazygit, delta) live in modules/home/shell; editors (helix, neovim) are
# configured + installed via modules/home/dev; baseline tools (curl/wget/zip) in core.
{
  programs.vscode.enable = true;

  environment.systemPackages = with pkgs; [
    fastfetch
    yazi
    vim # plain vim as a root/system fallback editor
    tmux
    fd
    htop
    mold
  ];
}
