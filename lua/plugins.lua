require("lazy").setup({
  { "EdenEast/nightfox.nvim" },
  { "matze/vim-move" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },

  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-tree").setup({
        disable_netrw = true,
        hijack_netrw = false,
      })
    end,
  },
  { "nvim-telescope/telescope.nvim", dependencies = "nvim-lua/plenary.nvim" },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown", "mdx" },
    opts = {
      file_types = { "markdown", "mdx" },
      heading = {
        sign = true,
        position = "inline",
      },
      code = {
        sign = true,
        width = "block",
        language = true,
      },
      bullet = { enabled = true },
      checkbox = { enabled = true },
      quote = { enabled = true },
      pipe_table = { enabled = true },
    },
  },
  {



    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        direction = "float",
        open_mapping = [[<c-t>]],
        float_opts = { border = "rounded" },


    })
    end
  },

  {
    "stevearc/conform.nvim",
    version = "*",
    cmd = { "ConformInfo" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          java = { "google-java-format" },
          rust = { "rustfmt" },
          lua = { "stylua" },
          python = { "black" },
        },
        format_on_save = function(buf)
          if vim.g.skip_autoformat then return false end
          if not vim.bo[buf].modifiable then return false end
          return { timeout_ms = 500, lsp_format = "fallback" }
        end,
      })

      vim.api.nvim_create_augroup("ConformBindings", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = "ConformBindings",
        callback = function(args)
          require("conform").format({ async = true, bufnr = args.buf })
        end,
      })
    end,
  },

  {
    "folke/which-key.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        preset = "helix",
        delay = 300,
        spec = {
          { "<leader>f", group = "find" },
          { "<leader>r", group = "rust / lsp" },
          { "<leader>w", group = "archivos" },
          { "<leader>g", group = "git / lsp" },
          { "<leader>j", group = "java" },
          { "<leader>l", group = "lsp / formato" },
        },
      })
    end,
  },
})
