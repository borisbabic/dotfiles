return {
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  config = function()
    require('orgmode').setup({
      org_agenda_files = '~/orgfiles/**/*.org',
      org_default_notes_file = '~/orgfiles/notes.org',
    })
   -- Experimental LSP support
   vim.lsp.enable('org')
  end,
}
