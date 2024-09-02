return {
  "glacambre/firenvim",
  lazy = not vim.g.started_by_firenvim,
  build = function()
    vim.fn["firenvim#install"](0)
  end,
  config = function()
    vim.g.firenvim_config = {
      localSettings = {
        [".*"] = { takeover = "never" },
      },
    }

    vim.api.nvim_create_autocmd({ "UIEnter" }, {
      callback = function(event)
        local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
        if client ~= nil and client.name == "Firenvim" then
          vim.o.laststatus = 0
          vim.cmd.colorscheme("nord")
          vim.cmd("set guifont=JetBrainsMono\\ NFM:h12")
        end
      end,
    })


    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      pattern = "github.com_*.txt",
      command = "set filetype=markdown",
    })
  end,
}
