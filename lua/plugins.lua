require("lazy").setup({
  { "EdenEast/nightfox.nvim" },
  { "matze/vim-move" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },

  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  { "nvim-tree/nvim-tree.lua", dependencies = "nvim-tree/nvim-web-devicons", config = true },
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
})
