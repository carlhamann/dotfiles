-- Based on:
-- https://github.com/tjdevries/config.nvim/blob/006889bbfb6ff655e2d8e33b26453fa4d614b99b/lua/custom/plugins/oil.lua
return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      CustomOilBar = function()
        local path = vim.fn.expand '%'
        path = path:gsub('oil://', '')

        return '  ' .. vim.fn.fnamemodify(path, ':.')
      end

      require('oil').setup {
        columns = { 'icon' },
        keymaps = {
          ['<C-h>'] = false,
          ['<C-l>'] = false,
          ['<C-k>'] = false,
          ['<C-j>'] = false,
          ['<A-s>'] = 'actions.select_vsplit',
        },
        -- win_options = {
        --   winbar = '%{v:lua.CustomOilBar()}',
        -- },
        view_options = {
          show_hidden = true,
        },
        delete_to_trash = true,
      }

      -- Open parent directory in current window
      -- vim.keymap.set('n', '<leader>-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

      -- Open parent directory in floating window
      vim.keymap.set('n', '<leader>-', require('oil').toggle_float)
    end,
  },
}
