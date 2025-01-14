{pkgs, ...}: {
programs.neovim = {
  enable = true;
  plugins = [{
plugin = pkgs.vimPlugins.pywal-nvim;
type = "lua";
    }];
}
};
