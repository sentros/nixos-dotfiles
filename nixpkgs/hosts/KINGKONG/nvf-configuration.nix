{ pkgs, lib, ... }:

{
  vim  = {
    theme = {
      enable= true;
      name = "gruvbox";
      style = "dark";
    };

    status.line.lualine.enable = true;
    telescope.enable = true;
    navigation.harpoon.enable = true;
    git.vim-fugitive.enable = true;
    autocomplete.nvim-cpm.enable = true;

    languages = {
      enableLSP = true;
      enableTreesitter = true;

      nix.enable = true;
      ts.enable = true;
      yaml.enable = true;
      hcl.enable = true;
      bash.enable = true;
      markdown.enable = true;
      python.enable = true;
    };
  };
}
