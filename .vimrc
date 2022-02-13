call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdcommenter'
Plug 'mhinz/vim-startify'
Plug 'morhetz/gruvbox'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'drmingdrmer/vim-toggle-quickfix'
Plug 'airblade/vim-gitgutter'
Plug 'editorconfig/editorconfig-vim'
Plug 'mhinz/vim-janah'
Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-tscompletejob.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'runoshun/tscompletejob'
Plug 'ryanoasis/vim-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'jacoborus/tender.vim'
Plug 'doums/darcula'
Plug 'nvim-telescope/telescope-project.nvim'
Plug 'akinsho/toggleterm.nvim'
Plug 'joshdick/onedark.vim'
Plug 'sheerun/vim-polyglot'
Plug 'liuchengxu/vista.vim'


call plug#end()

set encoding=UTF-8
syntax on
set ignorecase
set smartcase
set hidden
set number
set nobackup
set nospell
set nowritebackup
set smarttab
set nocompatible
set cindent
set tabstop=2
set softtabstop=2
set noswapfile
set shiftwidth=2
set expandtab
set cursorline
au FocusLost * silent! wa
let mapleader=" "


imap jj <Esc>
map <leader>xx <plug>NERDCommenterToggle
nmap gd :LspDefinition <cr>
nmap gu :LspReferences <cr>
imap <c-space> <Plug>(asyncomplete_force_refresh)
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
highlight lspReference ctermfg=white guifg=white ctermbg=black guibg=black


function HandleOpen()
  if exists("g:NERDTree") && g:NERDTree.IsOpen()
    execute 'NERDTreeClose'
  else 
    execute 'NERDTreeFind'
  endif
endfunction

nmap <S-Tab> :call HandleOpen() <CR>

" let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

lua << EOF

require('telescope')
  .setup{ 
    pickers = {
      find_files = {
        hidden = true
      }
    },
    defaults = { file_ignore_patterns = {"node_modules", "build", "gradle", "ios"} },
    extensions = { 
      project = {}
    }
  }

require'telescope'.load_extension('project')

local actions = require('telescope.actions')require('telescope').setup{ pickers = { buffers = { sort_lastused = true } } }

require("toggleterm").setup{ }

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    custom_captures = {

    },
    additional_vim_regex_highlighting = false,
  },
}

EOF


" colors

if (has("termguicolors"))
 set termguicolors
endif

syntax enable
colorscheme darcula
let g:lightline = { 'colorscheme': 'darculaOriginal' }


" end colors


set autowriteall

autocmd BufNewFile,BufRead .eslintrc set syntax=json
autocmd BufNewFile,BufRead *.js set syntax=typescriptreact


let g:ale_fixers = {
 \ 'typescript': ['eslint'],
 \ 'javascript': ['eslint'],
 \ 'typescriptreact': ['eslint'],
 \ 'go': ['golangci-lint']
 \ }

let g:ale_linters = {
 \ 'typescript': ['eslint'],
 \ 'javascript': ['eslint'],
 \ 'typescriptreact': ['eslint'],
 \ 'go': ['golangci-lint']
 \ }


let g:ale_disable_lsp = 1
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
let g:ale_fix_on_save = 1
let g:ale_javascript_eslint_executable = 'eslint_d'
let g:ale_javascript_eslint_use_global = 0
let g:ale_lint_on_save = 1

highlight ALEError ctermbg=none gui=underline guisp=red

" start lsp
if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ })
endif


set guifont=DroidSansMono\ Nerd\ Font:h11

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
" nnoremap <leader>ko :lua require'telescope'.extensions.project.project{}<cr>
nnoremap <leader>ko <cmd> Startify <cr>
nnoremap <Tab><Tab> <cmd>Telescope buffers<cr>
noremap <c-p> <cmd>Telescope find_files<CR>
nnoremap <silent><c-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
nmap <leader>l :ALEFix<cr>

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#ale#enabled = 1

let g:go_highlight_structs = 1 
let g:go_highlight_methods = 1
let g:go_highlight_functions = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1


let g:startify_lists = [
   \ { 'type': 'sessions',  'header': ['   Sessions']       },
   \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
   \ { 'type': 'commands',  'header': ['   Commands']       },
   \ ]

let g:startify_bookmarks = [
  \ { 'agilix': '~/projects/agilix'},
  \ { 'vim-config': '~/vim/.vimrc'},
  \ ]

let g:startify_session_persistence = 1
let g:startify_session_autoload = 1
let g:startify_session_delete_buffers = 1
let g:startify_change_to_vcs_root = 1
let g:startify_enable_special = 0
let g:startify_session_dir = '~/.config/nvim/session'


nmap <leader>o :Startify<cr>


