{ username, ... }:
{
  imports = [
    # ./syncthing.nix
    # ./samba.nix
    ./minidlna.nix
  ];

  # Every sharing daemon here serves out of $HOME and runs as its own user, so
  # /home/<user> must be traversable. Lives here, not in one submodule, or it
  # disappears the moment that submodule is commented out above.
  users.users.${username}.homeMode = "755";
}
