{ config, pkgs, ... }:

# hardware.graphics (incl. enable32Bit) is configured in hosts/bushido/graphics.nix.
{
  # Steam Configuration
  programs.steam = {
    enable = true;
    # Open required firewall ports for local streaming and multiplayer
    remotePlay.openFirewall = true; 
    dedicatedServer.openFirewall = true; 
    localNetworkGameTransfers.openFirewall = true; 
    
    # Allows Steam to utilize Gamescope easily 
    gamescopeSession.enable = true; 
  };

  # 3. Feral GameMode
  # Automatically optimizes CPU scheduler, I/O priority, and GPU states when games launch.
  # (Launch games in Steam using: gamemoderun %command%)
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        # Specifically targets your AMD architecture to maximize clock speeds
        amd_performance_level = "high";
      };
      custom = {
        # Sends a notification to your desktop when GameMode turns on/off
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations activated'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations deactivated'";
      };
    };
  };

  # 4. Essential Gaming Packages
  environment.systemPackages = with pkgs; [
    
    mangohud      # System performance overlay (FPS, GPU/CPU temps)

    gamescope     # Valve's micro-compositor (sandbox games, force FSR scaling on Hyprland)

    protonup-qt   # GUI to easily install custom GE-Proton versions

    # lutris is currently unable to compile
    lutris-unwrapped        
  ];

  # 5. Environment Variables
  # Tells ProtonUp-Qt exactly where to drop custom Proton versions so Steam finds them
  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  };
}