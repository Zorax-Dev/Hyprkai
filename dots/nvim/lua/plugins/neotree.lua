return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      sources = { "filesystem" },

      filesystem = {
        hijack_netrw_behavior = "open_default",
        bind_to_cwd = true,
        follow_current_file = {
          enabled = true,
        },
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },

      window = {
        position = "left",
        width = 30,
      },

      source_selector = {
        winbar = false,
        statusline = false,
      },
    },
  },
}
