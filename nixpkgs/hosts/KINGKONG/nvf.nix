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

          clipboard = {
            enable = true;
            registers = "unnamedplus";
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
            bash.enable = true;
            nix.enable = true;
          };
          treesitter.grammars = with pkgs; [
            vimPlugins.nvim-treesitter.builtGrammars.hyprlang
            vimPlugins.nvim-treesitter.builtGrammars.tmux
            vimPlugins.nvim-treesitter.builtGrammars.ini
          ];
          diagnostics = {
            enable = true;
            config = {
              # Configure virtual text, signs, underlines
              virtual_text = true;
              signs = true;
              underline = true;
              update_in_insert = false;
              severity_sort = true;
            };
          };
          globals.mapleader = " ";
          keymaps = [
            {
              mode = "n";
              key = "<leader>cd";
              action = ":Ex<CR>";
            }
            {
              mode = "n";
              key = "<leader>dp";
              action = ":lua vim.diagnostic.goto_prev()<CR>";
            }
            {
              mode = "n";
              key = "<leader>dn";
              action = ":lua vim.diagnostic.goto_next()<CR>";
            }
            {
              mode = "n";
              key = "<leader>q";
              action = ":lua vim.diagnostic.setloclist()<CR>";
            }
          ];
          options = {
            shiftwidth = 4;
            updatetime = 250;
          };
          autocmds = [
            {
              event = ["CursorHold"];
              desc = "Show diagnostics in floating window on cursor hold";
              callback =
                pkgs.lib.generators.mkLuaInline
                /*
                lua
                */
                ''
                  function()
                    vim.diagnostic.open_float(nil, { focus = false })
                  end
                '';
            }
          ];
        };
      };
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
