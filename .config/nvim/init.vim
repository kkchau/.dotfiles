set nocompatible
set encoding=utf-8
syntax enable

"---Plugins--------------------------------------------------------------------"
" If need to install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Begin plugins
call plug#begin()

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'

" Code actions
Plug 'kosayoda/nvim-lightbulb'

" Tree-sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" NERDTree
Plug 'preservim/nerdtree'

" Fuzzy-file-finder
Plug 'nvim-telescope/telescope.nvim'
Plug 'BurntSushi/ripgrep'

" Markdown
Plug 'ellisonleao/glow.nvim'

" Theme
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

" Statusline
Plug 'nvim-lualine/lualine.nvim'

call plug#end()

filetype indent plugin on

"---Commands-------------------------------------------------------------------"
" New leader
" let mapleader = " "
" let maplocalleader = "  "

" Yank to clipboard
set clipboard+=unnamedplus

" Better command-line completion
set wildmenu

" Show partial commands in the last line
set showcmd

" Confirmation of unsaved changes
set confirm

" Regular Expressions
set magic

"---Navigation-----------------------------------------------------------------"
" Backspace over indents, endofline, insrt
set backspace=indent,eol,start

" split screen and navigation
set splitbelow
set splitright

" split navigation
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

" Search setting
set nohlsearch
set incsearch
set ignorecase

" Case-insensitive search expt when CAP
set ignorecase
set smartcase

"---Style----------------------------------------------------------------------"
" Colorscheme
colorscheme tokyonight

" Visual bell instead of audible bell
set visualbell

" Guides
set cursorline
set cursorcolumn
set colorcolumn=80

set scl=yes

" Numbering
set number relativenumber
autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber

" Use soft tabs
set expandtab
set smarttab
set shiftwidth=4
set softtabstop=4

" Copy indentation from previous line
set smartindent

" Don't wrap text
set nowrap

" Persistent ruler
set ruler

"---NERDTree-------------------------------------------------------------------"
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1
    \ && winnr('$') == 1
    \ && exists('b:NERDTree')
    \ && b:NERDTree.isTabTree() | quit | endif

let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let NERDTreeMinimalUI = 1
let NERDTreeShowHidden = 1

" Remap
map <C-n> :NERDTreeToggle<CR>

"---lightbulb------------------------------------------------------------------"
autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()

"---Telescope------------------------------------------------------------------"
" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

"---LuaCode--------------------------------------------------------------------"

lua << LSP
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<C-e>', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  if client.resolved_capabilities.document_formatting then
    vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
  end

end

require("null-ls").setup({
  sources = {
    require("null-ls").builtins.formatting.black,
    require("null-ls").builtins.formatting.isort.with({
        args={"--profile", "black", "-"}
    }),
    require("null-ls").builtins.diagnostics.pylint.with({
        extra_args={"--init-hook=sys.path.append('src')"}
    }),
  },
  on_attach = on_attach
})
local servers = { 'pyright' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
LSP

lua << LUALINE
require'lualine'.setup({
  options = {
    icons_enabled = false,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    lualine_a = {'buffers'},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {'tabs'}
  },
  extensions = {}
})
LUALINE

lua << TREESITTER
require'nvim-treesitter.configs'.setup({
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = false,
    disable = {},
  },
  ensure_installed = {
    "bash",
    "toml",
    "json",
    "yaml",
    "python"
  },
})
TREESITTER
