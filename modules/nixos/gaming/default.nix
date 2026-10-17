{ config, pkgs, ... }:

# hardware.graphics (incl. enable32Bit) is configured in hosts/bushido/graphics.nix.
{
  imports = [ ./controller.nix ];

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

    # Wrapped lutris = FHS env, which is what umu/pressure-vessel needs: a real
    # /usr/bin (bwrap: execvp true) and a valid ld.so.cache (pressure-vessel's
    # "Unable to determine architecture of provider / ldconfig").
    # Launch it as plain `lutris` -- NOT `steam-run lutris`: steam-run's older glib
    # breaks every gio module (undefined symbol: g_task_set_name) and the portal.
    (lutris.override {
      extraPkgs = p: with p; [
        coreutils # /usr/bin/true, which pressure-vessel execs to probe the container
        umu-launcher
        winetricks
        vulkan-tools # vulkaninfo, which lutris shells out to on startup
        p7zip
      ];
    })
  ];

  environment.sessionVariables = {
    # Where ProtonUp-Qt drops custom Proton builds so Steam finds them.
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";

    # gamemoderun exports LD_PRELOAD=libgamemodeauto.so.0, which pressure-vessel
    # /flatpak inherit into bwrap -- but the gamemode dbus daemon isn't reachable
    # from inside the sandbox, so libdbus aborts at _dl_fini and dumps core on
    # every launch. Downgrades that abort to a warning.
    # https://gitlab.freedesktop.org/dbus/dbus/-/issues/239
    DBUS_FATAL_WARNINGS = "0";
  };
}
