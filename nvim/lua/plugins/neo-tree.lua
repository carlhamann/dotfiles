-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
    's1n7ax/nvim-window-picker', -- enables using 'w' to pick a window to open in
  },
  cmd = 'Neotree',
  keys = {
    { '<leader>e', ':Neotree reveal position=float<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- This is what you want: If you set this to `true`, all "hide" just mean "dimmed out"
        hide_dotfiles = false,
        hide_gitignored = true,
      },
      window = {
        mappings = {
          ['<leader>e'] = 'close_window',

          -- Use window picker variant of defautt bindings
          ['<CR>'] = 'open_with_window_picker',
          ['s'] = 'vsplit_with_window_picker',
          ['S'] = 'split_with_window_picker',
        },
      },
    },
  },
}
