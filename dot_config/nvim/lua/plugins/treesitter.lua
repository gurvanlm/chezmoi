return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", "python", "lua", "javascript", "typescript",
          "vue", "json", "yaml", "toml", "markdown", "markdown_inline",
          "java", "html", "css", "dockerfile", "gitcommit", "diff",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
}
