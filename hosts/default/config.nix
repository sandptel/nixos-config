# Main default config
{
  nixos-dots,
  config,
  pkgs,
  host,
  username,
  options,
  inputs,
  modulesPath,
  ...
}:
let
  inherit (import ./variables.nix) keyboardLayout;
  python-packages = pkgs.python3.withPackages (
    ps: with ps; [
      requests
      pyquery # needed for hyprland-dots Weather script
    ]
  );
in
{
  regolith = {
    enable = true;
    #    extraSwayConfig= "#testing";
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "BACKUP";
    users = {
      roronoa = {
        imports = [

          ./home.nix
        ];
      };
    };
  };

  nixpkgs.config.allowUnsupportedSystem = true;
  imports = [
    # inputs.matugen.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    # inputs.nixvim.nixosModules.nixvim
    (modulesPath + "/installer/scan/not-detected.nix")
    ./code.nix
    ./gaming.nix
    ./starship.nix
    ./hardware.nix
    ./users.nix
    # ./power.nix
    ./kernel.nix
    # ./nixvim.nix
    # ../../modules/amd-drivers.nix
    # ../../modules/nvidia-drivers.nix
    # ../../modules/nvidia-prime-drivers.nix
    ../../modules/intel-drivers.nix
    ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
    #../../modules/core/user.nix
    #../../modules/stylix.nix
    #../../modules/sddm.nix
  ];
  # nixos-boot = {
  #      enable = true;
  #   };
  # BOOT related stuff
  boot = {

    # Needed For Some Steam Games
    #kernel.sysctl = {
    #  "vm.max_map_count" = 2147483642;
    #};

    ## BOOT LOADERS: NOT USE ONLY 1. either systemd or grub
    # Bootloader SystemD
    loader.systemd-boot.enable = true;

    loader.efi = {
      #efiSysMountPoint = "/efi"; #this is if you have separate /efi partition
      canTouchEfiVariables = true;
    };

    loader.timeout = 1;
    loader.systemd-boot.graceful = true;

    # Bootloader GRUB
    # loader.grub = {
    #   enable = true;
    #   devices = [ "nodev" ];
    #   efiSupport = true;
    #   memtest86.enable = true;
    #   extraGrubInstallArgs = [ "--bootloader-id=${host}" ];
    #   configurationName = "${host}";
    # };

    # Bootloader GRUB theme, configure below
    #stylix.enable = true;
    #theme = inputs.nixos-grub-themes.packages.${pkgs.system}.nixos;
    ## -end of BOOTLOADERS----- ##

    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };

    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = true;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };

    #stylix.enable = true;
    # plymouth.enable = true;
    # plymouth.themePackages = [
    #     pkgs.catppuccin-plymouth
    # ];
    # plymouth.theme = "catppuccin-macchiato";
    #plymouth.theme = "catppuccin";
    # plymouth = {
    #  enable = true;
    #  theme = "connect";
    #  themePackages = with pkgs; [
    # By default we would install all themes
    #    (adi1090x-plymouth-themes.override {
    #      selected_themes = [ "connect" ];
    #    })
    #  ];
    #};

  };

  #stylix = {
  #  enable = true;
  #   polarity = "dark";
  #  opacity.terminal = 0.8;

  #};
  #stylix.enable = true;
  # GRUB Bootloader theme. Of course you need to enable GRUB above.. duh!
  #distro-grub-themes = {
  #  enable = true;
  #  theme = "nixos";
  #};
  # boot.loader.grub2-theme = {
  #       enable = true;
  #       theme = "tela";
  #       footer = true;
  #       customResolution = "2160x1440";

  # };

  # Extra Module Options
  # drivers.amdgpu.enable = false;
  drivers.intel.enable = true;
  # drivers.nvidia.enable = true;
  # drivers.nvidia-prime = {
  #   enable = true;
  #   intelBusID = "PCI:0:2:0";
  #   nvidiaBusID = "PCI:1:0:0";
  # };
  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;

  # networking
  networking.networkmanager.enable = true;
  networking.hostName = "${host}";
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  nixpkgs.config.allowUnfree = true;

  services.seatd.enable = true;

  programs = {
    hyprland = {
      enable = true;
      #     package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; #hyprland-git
      #   #   plugins = [
      #   #     inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
      #   #             #  inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprbars
      #   #  ];
      #  portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland; # xdphls
      #    xwayland.enable = true;
      #  opengl.enable = true;
    };

    nix-ld.enable = true;
    waybar.enable = true;
    hyprlock.enable = true;
    firefox.enable = true;
    git.enable = true;
    nm-applet.indicator = true;
    # neovim.enable = true;
    # neovim = {
    # enable = true;
    # plugins = with pkgs.vimPlugins; [ nvim-lspconfig pywal-nvim nvim-treesitter nvim-tree-sitter nvim-lsp-installer ];
    # extraPackages = with pkgs; [ rust-analyzer rustc cargo rustfmt clippy ];
    # };
    #stylix.enable = true;
    thunar.enable = true;
    thunar.plugins = with pkgs.xfce; [
      exo
      mousepad
      thunar-archive-plugin
      thunar-volman
      tumbler
    ];

    virt-manager.enable = false;

    #steam = {
    #  enable = true;
    #  gamescopeSession.enable = true;
    #  remotePlay.openFirewall = true;
    #  dedicatedServer.openFirewall = true;
    #};

    xwayland.enable = true;

    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.fish;
  };

  environment.systemPackages =
    (with pkgs; [
      # System Packages
      home-manager
      #  albert
      gedit
      timer
      gjs
      baobab
      btrfs-progs
      clang
      curl
      cpufrequtils
      duf
      eza
      ffmpeg
      glib # for gsettings to work
      gsettings-qt
      git
      killall
      libappindicator
      libnotify
      pciutils
      vim
      wget
      xdg-user-dirs
      xdg-utils
      fastfetch
      (mpv.override { scripts = [ mpvScripts.mpris ]; }) # with tray
      # Hyprland Stuff
      hyprpanel
      #   ags
      anyrun
      btop
      brightnessctl # for brightness control
      # cava
      cliphist
      eog
      gnome-system-monitor
      file-roller
      grim
      gtk-engine-murrine # for gtk themes
      hyprcursor # requires unstable channel
      hypridle # requires unstable channel
      imagemagick
      inxi
      jq
      # kitty
      libsForQt5.qtstyleplugin-kvantum # kvantum
      networkmanagerapplet
      nwg-look # requires unstable channel
      #   nvtopPackages.full
      pamixer
      pavucontrol
      playerctl
      polkit_gnome
      pyprland
      libsForQt5.qt5ct
      qt6ct
      qt6.qtwayland
      qt6Packages.qtstyleplugin-kvantum # kvantum
      rofi-wayland
      slurp
      swappy
      swaynotificationcenter
      inputs.swww.packages.${pkgs.system}.swww
      unzip
      wallust
      wl-clipboard
      wlogout
      yad
      yt-dlp
      nitch
      wezterm
      # inputs.wezterm.packages.${pkgs.system}.default
      inputs.zen-browser.packages."${system}".default
      # zen-browser
      # hyprgui
      dialog
      # neovide
      lshw
      # sddm
      catppuccin-sddm-corners
      sddm-sugar-dark
      sddm-astronaut
      where-is-my-sddm-theme
      bun
      # nodejs
      dart-sass
      vesktop
      yazi
      fish
      libgtop
      mise
      atuin
      sass
      sassc
      gtop
      vscodium
      komikku
      mangal
      mangareader
      oh-my-posh
      telegram-desktop
      neofetch
      python312Packages.gpustat
      power-profiles-daemon
      ani-cli
      zathura
      pango
      gdk-pixbuf
      cairo
      dbus-glib
      nwg-dock-hyprland
      waypaper
      #qcomicbook
      #libsForQt5.qt5.qtquickcontrols
      #libsForQt5.qt5.qtgraphicaleffects
      cava
      hyprpicker
      #hyprlandPlugins.borders-plus-plus
      egl-wayland
      v2ray
      v2raya
      # spotify
      lunarvim
      #xarchive
      nvidia-vaapi-driver
      libsForQt5.ark
      #waybar  # if wanted experimental next line
      #(pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];}))
    ])
    ++ [
      # python-packages #no python should be stated here
    ];

  # FONTS
  fonts.packages = with pkgs; [
    noto-fonts
    fira-code
    noto-fonts-cjk-sans
    jetbrains-mono
    font-awesome
    material-icons
    terminus_font
    nerd-fonts.droid-sans-mono
    # nerd-fonts._0xproto
    #(nerdfonts.override { fonts = [ "0xproto" "JetBrainsMono" ]; })
  ];

  #chaotic.mesa-git.enable = true;
  #catppuccin.enable = true;
  # Extra Portal Configuration
  xdg.portal = {
    enable = true;
    # wlr.enable = false;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
  };

  # Enable sddm login manager

  # Services to start
  services = {
    # displayManager.ly.enable=true; //so slow and buggy
    # greetd={
    #   enable =true;
    #   package=pkgs.greetd.tuigreet;
    # }; #imported as a module above
    displayManager.gdm = {
      enable = false;
    };
    xserver = {

      enable = true;
      xkb = {
        layout = "${keyboardLayout}";
        variant = "";
      };

    };
    smartd = {
      enable = false;
      autodetect = true;
    };

    gvfs.enable = true;
    tumbler.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    udev.enable = true;
    envfs.enable = true;
    dbus.enable = true;

    fstrim = {
      enable = true;
      interval = "weekly";
    };

    libinput.enable = true;

    rpcbind.enable = false;
    nfs.server.enable = false;

    openssh.enable = true;
    flatpak.enable = true;

    blueman.enable = true;

    #hardware.openrgb.enable = true;
    #hardware.openrgb.motherboard = "amd";

    fwupd.enable = true;

    upower.enable = true;

    # desktopManager.gnome.enable = true;

    # gnome.gnome-keyring.enable = true;

    #printing = {
    #  enable = false;
    #  drivers = [
    # pkgs.hplipWithPlugin
    #  ];
    #};

    #avahi = {
    #  enable = true;
    #  nssmdns4 = true;
    #  openFirewall = true;
    #};

    #ipp-usb.enable = true;

    #syncthing = {
    #  enable = false;
    #  user = "${username}";
    #  dataDir = "/home/${username}";
    #  configDir = "/home/${username}/.config/syncthing";
    #};
  };

  systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };

  # zram
  zramSwap = {
    enable = true;
    priority = 100;
    memoryPercent = 30;
    swapDevices = 1;
    algorithm = "zstd";
  };

  # hardware.opengl.enable = true;
  #hardware.sane = {
  #  enable = true;
  #  extraBackends = [ pkgs.sane-airscan ];
  #  disabledDefaultBackends = [ "escl" ];
  #};

  # Extra Logitech Support
  hardware.logitech.wireless.enable = false;
  hardware.logitech.wireless.enableGraphical = false;

  # Bluetooth
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;

  # Security / Polkit
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';
  # security.pam.services."config.services.fprintd.enable".fprintAuth = true;
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # Cachix, Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://hyprland.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = false;
      #   dates = "weekly";
      #   options = "--delete-older-than 7d";
    };
  };

  # Virtualization / Containers
  virtualisation.libvirtd.enable = false;
  virtualisation.podman = {
    enable = false;
    dockerCompat = false;
    defaultNetwork.settings.dns_enabled = false;
  };

  console.keyMap = "${keyboardLayout}";

  # For Electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "kitty";
    VISUAL = "vscodium";
    GSK_RENDERER = "gl";
  };

  # Open ports in the firewall.
  programs.kdeconnect.enable = true;
  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
