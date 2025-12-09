return {
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  ft = { 'org' },
  config = function()
    -- 1. Setup the plugin
    require('orgmode').setup({
      org_agenda_files = '~/org/**/*',
      org_default_notes_file = '~/org/refile.org',
      mappings = {
        global = {
          org_agenda = '<Leader>oa',
          org_capture = '<Leader>oc',
        },
      },
    })

    -- 2. THE BRUTE FORCE OVERRIDE (Updated)
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'org',
      callback = function()
        local org = require('orgmode')
        local map = vim.keymap.set
        local opts = { buffer = true, silent = true }

        -- === TASK MANAGEMENT ===
        -- Force Deadline (<Leader>od)
        map('n', '<Leader>od', function() org.action('org_mappings.org_deadline') end, opts)
        -- Force Schedule (<Leader>os)
        map('n', '<Leader>os', function() org.action('org_mappings.org_schedule') end, opts)
        -- Force Todo Cycle (cit)
        map('n', 'cit', function() org.action('org_mappings.org_todo') end, opts)

        -- === EDITING / HEADLINES ===
        -- Force Insert Link (<Leader>li)
        map('n', '<Leader>li', function() org.action('org_mappings.insert_link') end, opts)
        
        -- NEW HEADLINE (Standard Emacs Binding: Alt + Enter)
        -- Try this one first!
        map('i', '<M-CR>', function() org.action('org_mappings.meta_return') end, opts)
        
        -- NEW HEADLINE (Your requested Control + Enter)
        -- Note: If this acts like a normal Enter, your terminal is eating the key.
        map('i', '<C-CR>', function() org.action('org_mappings.meta_return') end, opts)
      end,
    })
  end,
}
