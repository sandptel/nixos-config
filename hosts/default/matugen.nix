{config,inputs, ...}: {
  imports = [
    inputs.matugen.nixosModules.default
  ];



# home.configFile."<path>".source = "${config.programs.matugen.theme.files}/<template_output_path>";

home.file."gtk-4.0/gtk.css".source = "${config.programs.matugen.theme.files}/.config/gtk-4.0/gtk.css";
home.file."gtk-3.0/gtk.css".source = "${config.programs.matugen.theme.files}/.config/gtk-3.0/gtk.css";


  # programs.matugen = {
  #   enable = true;
  #   variant = "dark";
  #   jsonFormat = "hex";
  #   palette = "default";

  #   templates = {
  #     # ags = {
  #     #   input_path = "./templates/ags.scss";
  #     #   output_path = "~/.config/ags/scss/colors.scss";
  #     # };

  #     # kittty = {
  #     #   input_path = "./templates/kitty.conf";
  #     #   output_path = "~/.config/kitty/colors.conf";
  #     # };

  #     gtk = {
  #       input_path = "./templates/gtk.css";
  #       output_path = "~/.config/gtk-4.0/gtk.css";
  #     };

  #     # hypr = {
  #     #   input_path = "./templates/hypr.conf";
  #     #   output_path = "~/.config/hypr/colors.conf";
  #     # };

  #     # yazi = {
  #     #   input_path = "./templates/yazi.toml";
  #     #   output_path = "~/.config/yazi/theme.toml";
  #     # };
  #   };
  # };
}