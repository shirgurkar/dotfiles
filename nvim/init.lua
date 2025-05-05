-- Basic Settings
vim.opt.number = true           -- Enable line numbers
vim.opt.relativenumber = true   -- Enable relative line numbers
vim.opt.mouse = 'a'             -- Enable mouse support
vim.opt.ignorecase = true       -- Case-insensitive search
vim.opt.smartcase = true        -- Smart case sensitivity
vim.opt.hlsearch = true         -- Highlight search results
vim.opt.wrap = true             -- Enable line wrapping
vim.opt.breakindent = true      -- Preserve indentation in wrapped lines
vim.opt.tabstop = 2             -- Tab width
vim.opt.shiftwidth = 2          -- Indent width
vim.opt.expandtab = true        -- Use spaces instead of tabs
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.termguicolors = true    -- True color support
vim.opt.updatetime = 300        -- Faster update time
vim.opt.signcolumn = 'yes'      -- Always show the sign column

-- Dictionary for txt files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "text",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
  end
})

-- Install Packer if not installed
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path
  })
  vim.cmd [[packadd packer.nvim]]
end

-- Packer configuration
require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Auto pairs for brackets, quotes, etc.
  use {
    'jiangmiao/auto-pairs',
    config = function()
      -- Default configuration is usually sufficient
      -- You can add custom settings if needed:
      vim.g.AutoPairsMapCR = 1       -- Map <CR> to insert new indented line between pairs
      vim.g.AutoPairsMapSpace = 1    -- Map Space to insert space between pairs
      vim.g.AutoPairsMapBS = 1       -- Map Backspace to delete pairs
    end
  }

  -- Catppuccin color scheme
  use {
    'catppuccin/nvim',
    as = 'catppuccin',
    config = function()
      vim.cmd('colorscheme catppuccin-macchiato')
    end
  }

  -- Lualine status line with Catppuccin theme
  use {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          theme = 'catppuccin',
          section_separators = '',
          component_separators = ''
        }
      }
    end
  }

-- Gruvbox color scheme (commented out - uncomment to use)
-- use {
--   'morhetz/gruvbox',
--   config = function()
--     vim.o.background = 'dark'                -- Ensure dark background
--     vim.g.gruvbox_contrast_dark = 'hard'     -- Use "hard" contrast
--     vim.cmd('colorscheme gruvbox')
--   end
-- }
-- -- Lualine with Gruvbox theme (uncomment if using Gruvbox)
-- use {
--   'nvim-lualine/lualine.nvim',
--   config = function()
--     require('lualine').setup {
--       options = {
--         theme = 'gruvbox',
--         section_separators = '',
--         component_separators = ''
--       }
--     }
--   end
-- }
  -- LSP Configuration
  use {
    'neovim/nvim-lspconfig',
    requires = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    }
  }

  -- Autocompletion
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'onsails/lspkind-nvim',
    }
  }

  -- Commenting plugin
  use {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  }

  -- Git integration
  use {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end
  }

  use 'tpope/vim-fugitive'  -- Git commands

  -- Treesitter for better syntax highlighting
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- File explorer
  use {
    'kyazdani42/nvim-tree.lua',
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      require('nvim-tree').setup{}
    end
  }

  -- Fuzzy finder
  use {
    'nvim-telescope/telescope.nvim',
    requires = 'nvim-lua/plenary.nvim'
  }

  -- Automatically set up configuration after cloning packer.nvim
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- LSP and completion setup
local lspconfig = require('lspconfig')
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }

  -- LSP keybindings
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end

-- Setup Mason and Mason-lspconfig
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'clangd',           -- C/C++
    'pyright',          -- Python
    'jdtls',            -- Java
    'ts_ls',            -- JavaScript/TypeScript
    'rust_analyzer',    -- Rust
    'bashls',           -- Bash
    'html',             -- HTML
    'cssls',            -- CSS
    'eslint',           -- JavaScript linting
  }
})

-- Setup nvim-cmp
local cmp = require('cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'path' },
  }),
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 50,
    })
  }
})

-- Setup individual LSP servers
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- C/C++
lspconfig.clangd.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Python
lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Java
lspconfig.jdtls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- JavaScript/TypeScript (including React, Node, Express)
lspconfig.ts_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
}

-- Rust
lspconfig.rust_analyzer.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Bash
lspconfig.bashls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- HTML
lspconfig.html.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- CSS
lspconfig.cssls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- ESLint
lspconfig.eslint.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Setup Treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "c", "cpp", "python", "java", "javascript", "typescript",
    "tsx", "rust", "bash", "html", "css", "json", "lua"
  },
  highlight = {
    enable = true,
  },
}

-- Key mappings for common operations
vim.g.mapleader = ' '  -- Set leader key to space
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', ':Telescope help_tags<CR>', { noremap = true, silent = true })

-- Enhanced hover diagnostics - show the full error message
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Configure the hover behavior
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = "rounded",
    width = 60,
    focusable = false,
  }
)

-- Ensure diagnostic popups are more informative
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = {
      spacing = 4,
      prefix = '●'
    },
    signs = true,
    update_in_insert = false,
  }
)
