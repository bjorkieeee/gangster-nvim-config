-- Set leader key 
vim.g.mapleader = " "  -- Sets <leader> to spacebar

-- SET PATH
vim.env.PATH = vim.env.PATH .. ':' .. os.getenv('HOME') .. '/.local/bin'

-- General Settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4       -- Number of spaces that a <Tab> counts for
vim.o.shiftwidth = 4    -- Number of spaces to use for each step of (auto)indent
vim.o.expandtab = true  -- Convert tabs to spaces



require('packer').startup(function(use)
    -- Plugin manager
    use 'wbthomason/packer.nvim'
    
    -- Fuzzy finder (Telescope)
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- This will give us command line completion. Give us a menu of possible bindings. Includes the ones that we set
    use {
  	"folke/which-key.nvim",
  	config = function()
  	  require("which-key").setup {}
  	end
    }

-- Syntax highlighting, language specific features.
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'  -- Automatically update parsers
    }
    require'nvim-treesitter.configs'.setup {
        ensure_installed = { "python", "javascript", "html", "css", "lua", "c", "rust" },  -- Add your preferred languages here
        highlight = {
          enable = true,  -- Enable syntax highlighting
        },
    }

    use 'neovim/nvim-lspconfig'  -- LSP configurations for Neovim
    
    -- Set up Python and other language servers
    require'lspconfig'.pylsp.setup{}  -- Python LSP
    require'lspconfig'.ts_ls.setup{}  -- TypeScript/JavaScript LSP
    require'lspconfig'.html.setup{}  -- HTML LSP
    require'lspconfig'.cssls.setup{}  -- CSS LSP
    require'lspconfig'.clangd.setup{}  -- C LSP

    -- Rust-specific tools
    use 'simrat39/rust-tools.nvim'

    -- Enable Rust support with rust-analyzer
    require'lspconfig'.rust_analyzer.setup{
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
          },
        },
      }
    }

    use 'hrsh7th/nvim-cmp'  -- Autocompletion plugin
    use 'hrsh7th/cmp-nvim-lsp'  -- LSP source for nvim-cmp

    -- Status line
    use 'nvim-lualine/lualine.nvim'

    -- Color scheme (You can pick whichever you like)
    use 'gruvbox-community/gruvbox'

end)
-- Rust tools configuration for better integration
    require('rust-tools').setup({
      server = {
        on_attach = function(_, bufnr)
          -- Keybindings for Rust actions
          local opts = { noremap=true, silent=true }
          vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>RustCodeAction<CR>', opts)
        end,
      },
    })

-- Set up completion
    local cmp = require'cmp'
    cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' }
    },
    mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
	['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
})

-- Keybindings
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true })

