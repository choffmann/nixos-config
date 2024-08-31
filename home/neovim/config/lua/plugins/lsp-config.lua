return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "williamboman/mason.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },
      { "folke/neodev.nvim", opts = {} },
      { "towolf/vim-helm", ft = "helm" },
    },
    config = function()
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
          map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
          map(
            "<leader>ws",
            require("telescope.builtin").lsp_dynamic_workspace_symbols,
            "[W]orkspace [S]ymbols"
          )
          map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
          map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
          map("<C-K>", vim.lsp.buf.hover, "Hover Documentation")
          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          map("<leader>td", vim.lsp.buf.type_definition, "Type [D]efinition")
          map("<leader>cR", vim.lsp.buf.code_action, "[C]ode [R]efactor")
          map("<leader>h", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, "[H]int inlay")

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local servers = {
        lua_ls = {
          capabilities = capabilities,
        },
        tsserver = {
          capabilities = capabilities,
          settings = {
            typescript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationNameHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
          },
        },
        dockerls = {
          capabilities = capabilities,
        },
        rust_analyzer = {
          capabilities = capabilities,
        },
        elixirls = {
          cmd = { "/home/choffmann/.local/share/nvim/mason/bin/elixir-ls" },
          capabilities = capabilities,
        },
        bashls = {
          capabilities = capabilities,
        },
        gopls = {
          capabilities = capabilities,
          settings = {
            gopls = {
              completeUnimported = true,
              usePlaceholders = true,
              analyses = {
                unusedparams = true,
                shadow = true,
                fillreturns = true,
              },
            }
          }
        },
        tailwindcss = {
          capabilities = capabilities,
          init_options = {
            userLanguages = {
              elixir = "html-eex",
              eelixir = "html-eex",
              heex = "html-eex",
            },
          },
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  'class[:]\\s*"([^"]*)"',
                },
              },
            },
          },
        },
        jdtls = {
          capabilities = capabilities,
        },
        jsonls = {
          capabilities = capabilities,
        },
        yamlls = {
          capabilities = capabilities,
        },
        helm_ls = {
          cmd = {"helm_ls", "serve"},
          filetypes = {'helm'},
          capabilities = capabilities,
          valuesFiles = {
            mainValuesFile = "values.yaml",
            lintOverlayValuesFile = "values.lint.yaml",
            additionalValuesFilesGlobPattern = "values/+(develop|stage|prod).yaml",
          },
          yamlls = {
            capabilities = capabilities,
            enable = true,
            path = "/home/choffmann/.local/share/nvim/mason/bin/yaml-language-server",
            config = {
              schemas = {
                kubernetes = "templates/**",
              },
              completion = true,
              hover = true,
            }
          },
        },
        html = {
          capabilities = capabilities,
        },
        cssls = {
          capabilities = capabilities,
        },
        graphql = {
          capabilities = capabilities,
        },
        clangd = {
          capabilities = capabilities,
        },
        nil_ls = {
          capabilities = capabilities,
        },
      }

      require("mason").setup()

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
        "prettier", -- Used to format JavaScript code
        "eslint_d", -- Used to lint JavaScript code
        "beautysh", -- Used to format shell scripts
				"golangci-lint",
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
}
