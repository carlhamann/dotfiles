-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    -- 'leoluz/nvim-dap-go',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F11>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F10>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<S-F11>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<F9>',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<S-F9>',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F1>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- require('mason-nvim-dap').setup {
    --   -- Makes a best effort to setup the various debuggers with
    --   -- reasonable debug configurations
    --   automatic_installation = true,
    --
    --   -- You can provide additional configuration to the handlers,
    --   -- see mason-nvim-dap README for more information
    --   handlers = {},
    --
    --   -- You'll need to check that you have the required things installed
    --   -- online, please don't ask me how to install them :)
    --   ensure_installed = {
    --     'cppdbg',
    --   },
    -- }

    -- Instructions on how to set up cppvsdbg handshake:
    --https://github.com/mfussenegger/nvim-dap/discussions/869#discussioncomment-8121995
    -- You apparently really can't use vsdbg outside of vscode normally:
    -- https://www.reddit.com/r/neovim/comments/1ds4l2a/comment/lb96u5x/
    -- vsdbg/bin/vsdbg.exe'), ['--interpreter=vscode', '--extConfigDir=%USERPROFILE%\\.cppvsdbg\\extensions']);
    -- Note: DAP supports running without debugging via 'noDebug':
    -- https://microsoft.github.io/debug-adapter-protocol/specification#Requests
    -- nvim.dap can be customized via the LISTENERS EXTENSIONS API to specify this (I think!)
    -- https://github.com/mfussenegger/nvim-dap/blob/master/doc/dap.txt#L1231
    -- The original Github discusstion also mentions modifying the plugin source and settings "startFrame = 0".
    -- Maybe this can also be achieved with he listeneners extensions API for the "StackTrace Request" event?
    dap.adapters.cppvsdbg = {
      id = 'cppvsdbg',
      type = 'executable',
      command = vim.fn.stdpath 'data' .. '/mason/packages/cpptools/extension//debugAdapters/vsdbg/bin/vsdbg.exe',
      args = {
        '--interpreter=vscode',
      },
      -- command = 'C:\\Users/Admin\\AppData\\Local\\nvim-data\\mason\\packages\\cpptools\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe',
      -- command = 'C:/Users/Admin/.vscode/extensions/ms-vscode.cpptools-1.23.6-win32-x64/debugAdapters/bin/OpenDebugAD7.exe',
      options = {
        detached = false,
      },
    }

    dap.configurations.cpp = {
      {
        name = 'Launch file',
        type = 'cppvsdbg',
        request = 'launch',
        -- MIDebuggerPath = 'C:\\Users/Admin\\AppData\\Local\\nvim-data\\mason\\packages\\cpptools\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtEntry = true,
      },
    }

    -- Adding this through the nvim-mason-dap handler is not working
    -- dap.configurations.cpp = {
    --   {
    --     name = 'Launch Game',
    --     type = 'cppdbg',
    --     request = 'launch',
    --     program = function()
    --       return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    --     end,
    --     args = {
    --       'test',
    --       'my_mode',
    --     },
    --     stopAtEntry = false,
    --     cwd = '${workspaceFolder}/build',
    --     envFile = '${workspaceFolder}/build/debug.env',
    --     console = 'integratedTerminal',
    --   },
    -- }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
  end,
}
