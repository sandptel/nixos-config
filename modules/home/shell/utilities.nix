{ ... }:
{
  # 2. Modern Shell Tools (The \"Does it for me\" section)
  
  # A better 'cd'
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true; # Autoloads in Fish
  };

  # A better 'ls'
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    icons = "auto";
    git = true;
  };

  # A better 'cat'
  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
    };
  };

  # Fuzzy Finder
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # Fast file searching
  programs.ripgrep.enable = true;

  # 3. Git & TUI
  programs.lazygit.enable = true; # The best TUI for Git
  
  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  # 5. Env Management (Crucial for Nix users)
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # 6. Nix-Index (Command-not-found replacement)
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableFishIntegration = true;
  };
  
}
