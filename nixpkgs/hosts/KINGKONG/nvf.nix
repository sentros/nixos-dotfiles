{
  config,
  lib,
  ...
}: {
  programs.nvf = {
    enable = true;
    settings = {
      vim = {
        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
        };
        statusline.lualine.enable = true;
        telescope.enable = true;
        navigation.harpoon.enable = true;
        git.vim-fugitive.enable = true;
        autocomplete.nvim-cmp.enable = true;
        formatter.conform-nvim = {
          enable = true;
        };

        lsp = {
          enable = true;
          formatOnSave = true;
        };
        languages = {
          enableTreesitter = true;
          enableFormat = true;
          nix.enable = true;
          #	ts.enable = true;
          #	yaml.enable = true;
          #	hcl.enable = true;
          #	bash.enable = true;
          #	markdown.enable = true;
          #	python.enable = true;
        };
        globals.mapleader = " ";
        keymaps = [
          {
            mode = "n";
            key = "<leader>cd";
            action = ":Ex<CR>";
          }
        ];
        options = {
          shiftwidth = 4;
        };
      };
    };
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
