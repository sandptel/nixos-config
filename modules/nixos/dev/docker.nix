{ pkgs,username, ... }: {

  # Enable the Docker daemon
  virtualisation.docker.enable = true;

  # Add your user account to the docker group
  # users.users.username.extraGroups = [ "docker" ];

  # (Optional) Install docker-compose along with your system packages
  environment.systemPackages = with pkgs; [
    docker-compose
  ];
}