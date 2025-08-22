{pkgs, ...}: {
  programs = {
    nvf = {
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
          # extraPackages = [pkgs.deno];
          formatter.conform-nvim = {
            enable = true;
            setupOpts.formatters_by_ft = {
              javascript = ["prettier"];
              jsonc = ["prettier"];
            };
          };

          lsp = {
            enable = true;
            formatOnSave = true;
          };
          languages = {
            enableTreesitter = true;
            enableFormat = true;
            css = {
              enable = true;
              format.package = pkgs.prettier;
            };
            nix.enable = true;
          };
          treesitter.grammars = with pkgs; [
            vimPlugins.nvim-treesitter.builtGrammars.hyprlang
          ];
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
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
