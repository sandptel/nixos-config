{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    dejavu_fonts
    fira-code
    fira-code-symbols
    rubik
    # shell UI faces, picked per look in ~/.config/rice/parts/look
    inter
    geist-font
    plus-jakarta-sans
    figtree
    # pixel mono: numerals and labels on rice's pixel-flavoured widgets
    departure-mono
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.ubuntu
    nerd-fonts.blex-mono
  ];
}
