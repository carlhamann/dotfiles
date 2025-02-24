return {
  'rmagatti/auto-session',
  lazy = false,
  keys = {

    { '<leader>wr', '<cmd>SessionRestore<CR>', desc = 'Restore session for cwd' }, -- restore last workspace session for current directory
    { '<leader>ws', '<cmd>SessionSave<CR>', desc = 'Save session for auto session root dir' }, -- save workspace session for current working directory
  },

  ---enables autocomplete for opts
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    auto_restore = false,
    -- suppressed_dirs = { '~/', '~/Dev/', '~/Downloads', '~/Documents', '~/Desktop/' },
  },
}
