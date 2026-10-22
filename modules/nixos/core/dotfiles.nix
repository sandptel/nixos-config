{ lib, pkgs, username, ... }:
# Dotfiles live in their own repo (github:sandptel/dots), checked out writable at
# ~/dots and symlinked into $HOME -- not managed by Nix/home-manager.
let
  dotfiles = pkgs.writeShellApplication {
    name = "dotfiles";
    runtimeInputs = with pkgs; [
      git
      gh # credential helper for push
      coreutils
      findutils
      gnugrep
      util-linux # flock
    ];
    runtimeEnv.DOTS_REMOTE = "https://github.com/sandptel/dots.git";
    text = builtins.readFile ./dotfiles.sh;
  };
in
{
  environment.systemPackages = [ dotfiles ];

  # Every rebuild (and login) pulls the latest from origin and relinks.
  # Runs in every user's manager -> gate on the user; timeout so offline can't stall it.
  system.userActivationScripts.dotfiles.text = ''
    if [ "$(id -un)" = ${username} ]; then
      timeout 60 ${lib.getExe dotfiles} pull || true
      # First run on a machine: generate the rice's state (hypr setup.conf, noctalia
      # zz-setup.toml, gen/) so the first Hyprland login sources no missing files.
      # Only when missing -- noctalia regenerates it on every start after that.
      if [ -x "$HOME/.config/rice/rice" ] && [ ! -e "$HOME/.config/hypr/setup.conf" ]; then
        PATH=${lib.makeBinPath [ pkgs.python3 pkgs.imagemagick pkgs.coreutils ]}:$PATH \
          timeout 60 "$HOME/.config/rice/rice" resolve || true
      fi
    fi
  '';

  # Auto-commit + push. ponytail: 5 min poll, not inotify -> batches noisy
  # writers (noctalia, eyecandy toggles) into one commit.
  systemd.user.services.dotfiles-sync = {
    description = "Commit and push dotfile changes";
    unitConfig.ConditionUser = username;
    unitConfig.ConditionPathIsDirectory = "%h/dots/.git";
    serviceConfig.Type = "oneshot";
    serviceConfig.ExecStart = "${lib.getExe dotfiles} sync";
  };
  systemd.user.timers.dotfiles-sync = {
    wantedBy = [ "timers.target" ];
    unitConfig.ConditionUser = username;
    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "5min";
    };
  };
}
