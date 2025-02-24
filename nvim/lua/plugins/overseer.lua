return {
  'stevearc/overseer.nvim',
  config = function()
    require('overseer').setup {
      task_list = {
        bindings = {
          -- Unbind bindings I use for window naviagtion
          ['<C-l>'] = false,
          ['<C-h>'] = false,
          ['<C-j>'] = false,
          ['<C-k>'] = false,
        },
      },

      vim.keymap.set('n', '<leader>rt', ':OverseerRun<CR>', { desc = 'Run task' }), -- close current split window
    }
  end,
}
