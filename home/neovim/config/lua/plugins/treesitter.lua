return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local configs = require("nvim-treesitter.configs")
		configs.setup({
			auto_install = true,
			ensure_installed = { "vim", "regex", "lua", "bash", "markdown", "markdown_inline" },
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
