{ config,lib,inputs,pkgs, ... }:
{
  imports=[
    ../../nixos-dots.nix
    # ./hypr.nix
    # ./firefox-webapp.nix
    ./pywal16.nix
    inputs.hyprland.homeManagerModules.default
    ./matugen.nix
    ./spicetify.nix
    # ./tmux.nix
    # ./nixvim.nix
    # inputs.hellwal.homeManagerModules.default
    # inputs.matugen.homeManagerModules.default
];

# programs.hellwal.enable=true;
nixos-dots.enable = true;
# home.configFile."<path>".source = "${config.programs.matugen.theme.files}/<template_output_path>";

# home.file.".config/gtk-4.0/gtk.css".source = "${config.programs.matugen.theme.files}/.config/gtk-4.0/gtk.css";

# home.file.".config/gtk-3.0/gtk.css".source = "${config.programs.matugen.theme.files}/.config/gtk-3.0/gtk.css";

  home.username = "roronoa";
  home.homeDirectory = "/home/roronoa";
  home.enableNixpkgsReleaseCheck = false;
 
# module.phcontrol.enable=true;

programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
};


  home.stateVersion = "23.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

    # programs.firefox.webapps.notion ={
    # enable = true;
    # name = "Notion";
    # extraSettings = config.programs.firefox.profiles."default".settings;
    # # mimeTypes = ["video/*"];
    # genericName = "Notion";
    # comment = "Notion is a new tool that blends your everyday work apps into one. It's the all-in-one workspace for you and your team.";
    # categories = ["Network"];
    # # icon = "";
    # # prefersNonDefaultGPU = false;
    # url = "https://www.notion.so/";
    # id = 1;
    # backgroundColor = "#202225";
    # };

}  
