{ pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    # Socket-activated instead of running from boot -> no idle daemon draining
    # the battery; the first `docker` call starts it. User is in the docker
    # group via hosts/bushido/configuration.nix.
    enableOnBoot = false;
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}
