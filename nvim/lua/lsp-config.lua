local lspconfig = require'lspconfig'
local cmp = require'cmp'
local telescope = require'telescope.builtin'
local get_dropdown = require('telescope.themes').get_dropdown

vim.api.nvim_create_autocmd('CursorHold', {
  pattern = '*',
  callback = function() vim.diagnostic.open_float(nil, { focus = false }) end,
})
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.css,*.json,*.yaml,*.html,*.rs',
  callback = function() vim.lsp.buf.format({ async = false }) end,
})

cmp.setup({
  preselect = cmp.PreselectMode.None,
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<j>'] = cmp.mapping.scroll_docs(-4),
    ['<k>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.close(),
  },
  sources = cmp.config.sources(
    { { name = 'nvim_lsp' } },
    { { name = 'nvim_lsp_signature_help' } },
    { { name = 'buffer' } },
    { { name = 'path' } }
  ),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})

cmp.setup.cmdline(':', { sources = cmp.config.sources({ { name = 'path' } }) })

-- Mappings.
local opts = { noremap=true, silent=true }
vim.keymap.set('n', 'gE', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', 'ge', vim.diagnostic.goto_next, opts)

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set('n', 'gd', function() telescope.lsp_definitions(get_dropdown({ show_line = false })) end, opts)
  vim.keymap.set('n', 'gr', function() telescope.lsp_references(get_dropdown({ show_line = false })) end, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, opts)

  if (client.name == "eslint" or client.name == "tsserver") then
    vim.keymap.set('n', '<leader>g', function() vim.cmd('EslintFixAll') end, opts)
  else
    vim.keymap.set('n', '<leader>g', function() vim.lsp.buf.format { async = true } end, opts)
  end
end

local servers = { 'bashls', 'rust_analyzer', 'tsserver', 'cssls', 'jsonls', 'eslint', 'vimls', 'yamlls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
  }
end
