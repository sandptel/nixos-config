{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    dejavu_fonts
    fira-code
    fira-code-symbols
    rubik
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.ubuntu
    nerd-fonts.blex-mono
  ];
}
