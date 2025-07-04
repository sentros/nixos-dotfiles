return {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    branch = 'master',
    lazy = false,
    config = function()
	local configs = require("nvim-treesitter.configs")
	configs.setup({
	    highlight = {
		enable = true,
	    },
	    indent = { enable = true },
	    autotage = { enable = true },
	    ensure_installed = {
            "lua",
            "tsx",
            "typescript",
            "nix",
            "yaml",
            "hcl",
            "dockerfile",
            "bash"
	    },
	    auto_install = false,
	})
    end
}
