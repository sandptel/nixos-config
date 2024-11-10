{ inputs, pkgs, ... }:
let
  themes = {
    catppuccin-mocha = "catppuccin-mocha";
    mountain = "mountain";
    oxocarbon-dark = "oxocarbon-dark";
    jabuti = {
      scheme = "Jabuti";
      author = "Notusknot";
      base00 = "292a37";
      base01 = "343545";
      base02 = "3c3e51";
      base03 = "45475d";
      base04 = "50526b";
      base05 = "c0cbe3";
      base06 = "d9e0ee";
      base07 = "ffffff";
      base08 = "ec6a88";
      base09 = "efb993";
      base0A = "e1c697";
      base0B = "3fdaa4";
      base0C = "ff7eb6";
      base0D = "3fc6de";
      base0E = "be95ff";
      base0F = "8b8da9";
    };
  };
in
{
  stylix = {
    enable = true;
   # autoEnable = true;
    #image = ../hosts/redyf/9ovcXG0Wo4P7FQPe.jpg;
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    # base16Scheme = themes.jabuti;
   # cursor = {
   #   name = "Banana";
   #   package = pkgs.banana-cursor;
   #   size = 36;
   # };
    };
}
