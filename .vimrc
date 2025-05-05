" Basic Settings
set number                " Enable line numbers
set relativenumber        " Enable relative line numbers
set mouse=a               " Enable mouse support
set ignorecase            " Case-insensitive search
set smartcase             " Smart case sensitivity
set hlsearch              " Highlight search results
set wrap                  " Enable line wrapping
set breakindent           " Preserve indentation in wrapped lines
set tabstop=2             " Tab width
set shiftwidth=2          " Indent width
set expandtab             " Use spaces instead of tabs
set clipboard=unnamedplus " Use system clipboard
set termguicolors         " True color support
set updatetime=300        " Faster update time
set signcolumn=yes        " Always show the sign column

" Fix screen redrawing issues
set ttyfast               " Indicate fast terminal connection
set lazyredraw            " Don't redraw while executing macros
set nolazyredraw          " Force redraw when needed (counteracts ghost effect)
set redrawtime=10000      " Allow more time for redrawing
set ttyscroll=3           " Faster scrolling

" Force Vim to re-scan the entire screen
autocmd VimEnter,BufEnter,FocusGained * redraw!

" If using tmux, try to fix redraw issues
if exists('$TMUX')
  set ttymouse=xterm2
  set notimeout
  set ttimeout
  set ttimeoutlen=100
endif

" Dictionary for txt files
autocmd FileType text setlocal spell spelllang=en_us

" Install Vim-Plug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Vim-Plug configuration
call plug#begin('~/.vim/plugged')

" Auto pairs for brackets, quotes, etc.
Plug 'jiangmiao/auto-pairs'
let g:AutoPairsMapCR = 1       " Map <CR> to insert new indented line between pairs
let g:AutoPairsMapSpace = 1    " Map Space to insert space between pairs
let g:AutoPairsMapBS = 1       " Map Backspace to delete pairs

" " Color scheme - Catppuccin instead of Gruvbox
" Plug 'catppuccin/vim', { 'as': 'catppuccin' }
"
" " Status line
" Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
" " Enable Powerline fonts (make sure you have them installed)
" let g:airline_powerline_fonts = 0
" " If you have issues with symbols, uncomment the line below
" " let g:airline_symbols_ascii = 1
" let g:airline_theme = 'catppuccin_macchiato'

" Color scheme - Gruvbox instead of Catppuccin
Plug 'morhetz/gruvbox'

" Status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Enable Powerline fonts (make sure you have them installed)
let g:airline_powerline_fonts = 0
" If you have issues with symbols, uncomment the line below
" let g:airline_symbols_ascii = 1
let g:gruvbox_contrast_dark = 'hard'
let g:airline_theme = 'gruvbox'

" Language Server Protocol - using CoC instead of native LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Commenting plugin
Plug 'tpope/vim-commentary'

" Git integration
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'  " Git commands

" Better syntax highlighting - using vim-polyglot instead of treesitter
Plug 'sheerun/vim-polyglot'

" File explorer - NERDTree instead of nvim-tree
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'  " For file icons

" Fuzzy finder - using CtrlP instead of telescope
Plug 'ctrlpvim/ctrlp.vim'

" Initialize plugin system
call plug#end()

" Set colorscheme
syntax enable
set background=dark
colorscheme gruvbox

" CoC extensions to install (similar to the LSP servers in Neovim config)
let g:coc_global_extensions = [
      \ 'coc-clangd',
      \ 'coc-pyright',
      \ 'coc-java',
      \ 'coc-tsserver',
      \ 'coc-rust-analyzer',
      \ 'coc-sh',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-eslint'
      \ ]

" CoC configuration
" Use tab for trigger completion with characters ahead and navigate
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
inoremap <silent><expr> <c-space> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
      \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Apply code actions
nmap <leader>ca <Plug>(coc-codeaction)
nmap <leader>qf <Plug>(coc-fix-current)

" Navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Format code
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

" Key mappings for common operations
let mapleader = ' '  " Set leader key to space
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>ff :CtrlP<CR>
nnoremap <leader>fg :CtrlPLine<CR>
nnoremap <leader>fb :CtrlPBuffer<CR>
nnoremap <leader>fh :help

" Enhanced hover diagnostics - show the full error message
" This is mostly handled by CoC settings

" Add CoC status to airline
let g:airline#extensions#coc#enabled = 1
