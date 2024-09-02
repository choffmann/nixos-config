return {
  "lewis6991/gitsigns.nvim",
  opts = {},
  config = function()
    require("gitsigns").setup({
      on_attach = function(bufnr)
        vim.keymap.set("n", "<leader>gh", ":Gitsigns preview_hunk<CR>", { desc = "[G]it [H]unk" })
        vim.keymap.set(
          "n",
          "<leader>gb",
          ":Gitsigns toggle_current_line_blame<CR>",
          { desc = "[G]it [B]lame Line (toggle)" }
        )
      end,
    })
  end,
}
